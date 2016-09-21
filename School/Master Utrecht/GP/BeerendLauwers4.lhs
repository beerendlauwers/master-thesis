> {-# LANGUAGE DeriveDataTypeable, FlexibleContexts, TypeOperators, FlexibleInstances, UndecidableInstances, GADTs #-}
> {-# OPTIONS_GHC -fth #-}

> module BeerendLauwers4 where

> import Control.Applicative
> import Data.Functor.Constant
> import Data.Generics.Multiplate
> import Data.Typeable
> import Data.Comp
> import Data.Comp.Derive
> import Data.Comp.Ops
> import Language.Haskell.TH hiding (Cxt, match)

Exercise 2.1

sigma . foldF phi . inF = sigma . phi . mapF (foldF phi)

=> evaluation rule (foldF phi . inF = phi . mapF (foldF phi))

sigma . phi . mapF (foldF phi) = sigma . phi . mapF (foldF phi)

=> Remove phi and mapF

sigma . (foldF phi) = sigma . (foldF phi)

=> With conditions and assumptions:
        (COND. 1) sigma x = y
        (COND. 2) forall x,y: sigma . (g x y) = h x (sigma y)
        Source: (http://users.aims.ac.za/~frederic/funprog_extra04.pdf)
        
        (ASSU. 1) h b = psi
        (ASSU. 2) phi = g a
        
sigma . (foldF phi) = foldF psi

Exercise 2.2.1 (Multiplate)

a)

> data ZigZag a b = Stop a | Cons a (ZigZag b a) deriving (Show,Typeable)

> data ZigZagPlate a b f = ZigZagPlate {
>                               zigStopA :: a -> f (ZigZag a b),
>                               zagStopB :: b -> f (ZigZag b a),
>                               zigAB :: a -> ZigZag b a -> f (ZigZag a b),
>                               zagBA :: b -> ZigZag a b -> f (ZigZag b a)
>                                       }

> toZig :: ZigZagPlate a b f -> ZigZag a b -> f (ZigZag a b)
> toZig plate (Stop a) = zigStopA plate a
> toZig plate (Cons a xs) = zigAB plate a xs
> toZag :: ZigZagPlate a b f -> ZigZag b a -> f (ZigZag b a)
> toZag plate (Stop b) = zagStopB plate b
> toZag plate (Cons b xs) = zagBA plate b xs

> instance Multiplate (ZigZagPlate a b) where
>   multiplate child = ZigZagPlate (\a -> Stop <$> pure a) (\b -> Stop <$> pure b) (\a xs -> Cons <$> pure a <*> toZag child xs) (\b xs -> Cons <$>  pure b <*> toZig child xs)
>   mkPlate build = ZigZagPlate (\a -> build toZig (Stop a)) (\b -> build toZag (Stop b)) (\a xs -> build toZig (Cons a xs)) (\b xs -> build toZag (Cons b xs))

b)

> collectDataPlate :: ZigZagPlate a b (Constant ([a],[b]))
> collectDataPlate = ZigZagPlate { zigStopA = collectA, zagStopB = collectB, zigAB = collectAB, zagBA = collectBA }
>   where
>    collectA a = Constant ([a],[])
>    collectB b = Constant ([],[b])
>    collectAB a xs = Constant ([a],[])
>    collectBA b xs = Constant ([],[b])

> collect :: ZigZag a b -> ([a],[b])
> collect = foldFor toZig $ preorderFold collectDataPlate

> testzigzag :: ZigZag Char Int
> testzigzag = Cons 'a' (Cons 12 (Cons 'b' (Cons 25 (Stop 'c'))))

c) 

> simply :: Maybe [a] -> [a]
> simply (Just x) = x
> simply Nothing = []

> collectChars :: (Typeable a, Typeable b) => ZigZag a b -> [Char]
> collectChars = (\(xs,ys) -> getChars xs ++ getChars ys).collect

> getChars :: (Typeable a) => [a] -> [Char]
> getChars = simply.cast

> testzigzag2 = Cons 'a' (Cons 'd' (Cons 'b' (Cons 'e' (Stop 'c'))))

Exercise 2.2.2 (Compositional Data Types)

a) 

> data Nat e = Zero | Succ e

> $(derive [makeFunctor, makeShowF, makeFoldable] [''Nat])

> z :: (Nat :<: f) => Cxt h f a
> z = inject $ Zero

> s :: (Nat :<: f) => Cxt h f a -> Cxt h f a
> s x = inject $ Succ x 

> evalNat :: Term Nat -> Int
> evalNat x = (query (const 1) (+) x) - 1

b)

> data Add e = Add e e

> $(derive [makeFunctor, makeShowF] [''Add])

> (.+.) :: (Add :<: f) => Cxt h f a -> Cxt h f a -> Cxt h f a
> x .+. y = inject $ Add x y

> infixl 6 .+.
> type AddNat = Nat :+: Add

c)

> class RedAdd f where
>    redAddAlg :: Alg f (Term Nat)

> instance RedAdd Nat where
>   redAddAlg Zero = z
>   redAddAlg (Succ x) = s x

> instance (Add :<: Nat) => RedAdd Add where
>   redAddAlg (Add (Term Zero) b) = b
>   redAddAlg (Add (Term (Succ n)) b) = redAddAlg (Succ b)

> instance (RedAdd f, RedAdd g) => RedAdd (f :+: g) where
>   redAddAlg (Inl f) = redAddAlg f
>   redAddAlg (Inr g) = redAddAlg g

> redAdd :: (Add :<: Nat) => Term AddNat -> Term Nat
> redAdd = cata redAddAlg

d)

> data Mul e = Mul e e

> $(derive [makeFunctor, makeShowF] [''Mul])

> (.*.) :: (Mul :<: f) => Cxt h f a -> Cxt h f a -> Cxt h f a
> x .*. y = inject $ Mul x y

> type MulNat = Mul:+: AddNat
> infixl 7 .*.

> distMul1 :: (Add :<: f, Mul:<: f) => Cxt h f a -> Cxt h f a -> Maybe (Cxt h f a)
> distMul1 a b = do Add c d <- match b
>                   return (a .*. c .+. a .*. d)
> match :: (g :<: f) => Cxt h f a -> Maybe (g (Cxt h f a))
> match (Term t) = proj t
> match (Hole a) = Nothing

> class ReduceMul f where
>   redMulAlg :: Alg f (Term AddNat)

> instance ReduceMul Nat where
>   redMulAlg Zero = z
>   redMulAlg (Succ x) = s x

> instance (Add :<: Nat) => ReduceMul Add where
>   redMulAlg (Add f g) = f .+. g

> instance (Mul :<: Add) => ReduceMul Mul where
>   redMulAlg (Mul f g) = f .*. g

> instance (ReduceMul f, ReduceMul g) => ReduceMul (f :+: g) where
>   redMulAlg (Inl f) = redMulAlg f
>   redMulAlg (Inr g) = redMulAlg g

> redMul:: (Add :<: Nat, Mul :<: Add) => Term MulNat -> Term AddNat
> redMul = cata redMulAlg

e) (Skipped)
