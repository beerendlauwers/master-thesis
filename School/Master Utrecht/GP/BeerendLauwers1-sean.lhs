Grade Total: 6.64

Comment: The LANGUAGE pragmas also need '>'

> {-# OPTIONS_GHC -XGADTs #-}
> {-# LANGUAGE TypeOperators #-}
> {-# LANGUAGE TypeFamilies #-}
> {-# LANGUAGE RankNTypes      #-}
> {-# LANGUAGE KindSignatures #-}
> {-# LANGUAGE GADTs #-}

> module BeerendLauwers1 where

> import Generics.LIGD.Base
> import Data.Char
> import Data.Either

Beerend Lauwers
3720942

Exercise 1

a, b, c) 

data Tree a b	:	Regular					[ * -> * -> * ]				a :+: ((Tree a b) :*: b :*: (Tree a b))
data Glist f a	:	Regular, Higher-Order	[ ( * -> * ) -> * -> * ]	Unit :+: a :*: (f a)
data Bush a		:	Nested					[ * -> * ]					a :*: (GList :*: Bush (Bush a))
data HFix f a	:	Higher-Order	        [ ( * -> * ) -> * -> * ]	
data Exists b	:	Regular, Higher-Order	[ * -> * ]	                Exists
data Exp		:	Regular					[*]                         Bool :+: Int :+: Exp :+: Exp :+: Exp

Comment 1(a): Missing existential for Exists: -0.083
Grade 1(a): 0.417

Comment 1(b): Kind of HFix is incorrect: -0.083
Grade 1(b): 0.417

Comment 1(c): Incorrect Bush type. Missing HFix and explanation for Exists.
              Incorrect Exp type. Missing everything else. +0.01
Grade 1(c): 0.01

Grade 1: 0.844

Exercice 2

a)

> data Exp where
>   Bool :: Bool -> Exp
>   Int ::Int -> Exp
>   IsZero :: Exp -> Exp
>   Add :: Exp -> Exp -> Exp
>   If :: Exp -> Exp -> Exp -> Exp

(This makes type signatures a bit more sane)

> type Result =  Maybe (Either Int Bool)

> eval :: Exp -> Result
> eval (Bool x) = Just (Right x)
> eval (Int x) = Just (Left x)
> eval (IsZero exp) = case (eval exp) of
>                       (Just (Left x)) -> if x == 0 then Just (Right True) else Just (Right False)
>                       otherwise -> error "Invalid expression: isZero expects an expression that evaluates to an Int!"
> eval (Add e1 e2) = case (eval e1) of
>                      (Just (Left x)) -> case (eval e2) of
>                                           (Just (Left y)) -> (Just (Left (x+y)))
>                                           otherwise -> error "Invalid expression: 'Add' expects two integer expressions (second one is not)!"
>                      otherwise -> error "Invalid expression: 'Add' expects two integer expressions (first one is not)!"
> eval (If pred tru fals) = case (eval pred) of
>                             (Just (Right x)) -> if x == True then (eval tru) else (eval fals)
>                             otherwise -> error "Invalid expression: 'If' expects a boolean expression as its first argument!"

Test cases:

> works = eval $ If (IsZero (Int 0)) (Add (Int 5) (Int 5)) (Add (Int 5) (Int 0))
> fails1 = eval $  If (IsZero (Bool False)) (Add (Int 5) (Int 5)) (Add (Int 5) (Int 0))
> fails2 = eval $  If (Int 5) (Add (Int 5) (Int 5)) (Add (Int 5) (Int 0))
> fails3 = eval $  If (IsZero (Int 0)) (Add (Int 5) (Bool False)) (Add (Int 5) (Int 0))
> fails4 = eval $  If (IsZero (Int 0)) (Add (Bool False) (Int 5)) (Add (Int 5) (Int 0))

Comment 2(a): Why use error when you have Nothing? -0.2
Grade 2(a): 0.3

b)

> data ExpF r where
>   BoolF :: Bool -> ExpF r
>   IntF :: Int -> ExpF r
>   IsZeroF :: r -> ExpF r
>   AddF :: r -> r -> ExpF r
>   IfF :: r -> r -> r -> ExpF r

> newtype Fix f = In { out :: f (Fix f) }
> type Exp' = Fix ExpF

Grade 2(b): 0.5

c)

> instance Functor ExpF where
>   fmap f (BoolF b) = BoolF b
>   fmap f (IntF i) = IntF i
>   fmap f (IsZeroF z) = IsZeroF (f z)
>   fmap f (AddF r1 r2) = AddF (f r1) (f r2)
>   fmap f (IfF p r1 r2) = IfF (f p) (f r1) (f r2)

> evalAlg :: ExpF Result -> Result
> evalAlg (BoolF b) = Just (Right b)
> evalAlg (IntF i) = Just (Left i)
> evalAlg (IsZeroF (Just (Left a))) = Just (Right (a == 0))
> evalAlg (AddF (Just (Left r1)) (Just (Left r2))) = Just (Left (r1+r2))
> evalAlg (IfF (Just (Right p)) r1 r2) = if p then r1 else r2
> evalAlg _ = Nothing

Comment 2(c): The last case is unnecessary. Again, you are not using the Maybe
to determine when things don't evaluate: -0.2

> fold :: (Functor f) => (f a -> a) -> Fix f -> a
> fold f = f . fmap (fold f) . out
> eval' :: Exp' -> Result
> eval' = fold evalAlg

Grade 2(c): 0.8

d)

r (kind * -> *) is partially applied type (HFix f) (note: f = ExpTF)
Only when another type is given (for example, Bool),
does it become a complete type and can it be used to typecheck


> data ExpTF :: (* -> *) -> * -> * where
>    BoolTF :: Bool -> ExpTF r Bool
>    IntTF :: Int -> ExpTF r Int
>    IsZeroTF :: (r Int) -> ExpTF r Bool
>    AddTF :: (r Int) -> (r Int) -> ExpTF r Int
>    IfTF :: (r Bool) -> (r s) -> (r s) -> ExpTF r s

> data HFix f a = HIn { hout :: f (HFix f) a }
> type ExpT' = HFix ExpTF

Comment 2(d): Missing Int, Bool in IntTF, BoolTF: -0.1. Missing expression that
              cannot be defined in ExpT': -0.2

Grade 2(d): 0.7

e)

I seem to be getting a very odd kind error here.

g = HFix f bit


> {-
> class HFunctor f where
>   hfmap :: (forall b . g b -> h b) -> f g a -> f h a
> hfold :: (HFunctor f) => (forall b . f r b -> r b) -> HFix f a -> r a
> hfold f = f . hfmap (hfold f) . hout
> newtype Id a = Id { unId :: a }
> evalT' ::ExpT' a -> a
> evalT' = unId . hfold evalAlgT

> instance HFunctor ExpTF where
>   hfmap f (IntTF x) = IntTF x
>   hfmap f (BoolTF x) = BoolTF x
>   hfmap f (IsZeroTF x) = IsZeroTF (f x)
>   hfmap f (AddTF x y) = AddTF (f x) (f y)
>   hfmap f (IfTF p x y) = IfTF (f p) (f x) (f y)

> evalAlgT ::ExpTF Id a -> Id a
> evalAlgT exp = case exp of
>                  (IntTF x) -> Id x
>                  (BoolTF x) -> Id x
>                  (IsZeroTF x) -> Id (x == 0)
>                  (AddTF x y) -> let (Id resx) = x
>                                     (Id resy) = y
>                                 in Id ( resx + resy )
>                  (IfTF (p) x y) -> if unId p then unId x else unId y
> -}

Comment 2(e): Too many small problems to fix.
Grade 2(e): 0

Grade 2: 2.3

Exercise 3

> type InfoResult = (Int, Maybe Char, [String])

> typeinfo' :: Rep t -> t -> InfoResult -> InfoResult
> typeinfo' RInt t res = (t, Nothing, [])
> typeinfo' RChar t res = (0, Just t, [])
> typeinfo' RUnit t res = (0, Nothing, [])
> typeinfo' RString t res = (0, Nothing, [])
> typeinfo' (RSum ra _) (L a) res = combine res (typeinfo' ra a res)
> typeinfo' (RSum _ rb) (R b) res = combine res (typeinfo' rb b res)
> typeinfo' (RProd ra rb) (a :*: b) res = combine res (combine (typeinfo' ra a res) (typeinfo' rb b res))
> typeinfo' (RType ep ra) t res = combine res (typeinfo' ra (from ep t) res)
> typeinfo' (RCon s RUnit) t res = combine res (0, Nothing, [s])
> typeinfo' (RCon s ra) t res = combine res (combine (0, Nothing, [s]) (typeinfo' ra t res))
 
> combine :: InfoResult -> InfoResult -> InfoResult
> combine (i1, c1, l1) (i2, c2, l2) = (i1+i2, getMaxChar c1 c2, l1 ++ l2)
 
> getMaxChar :: Maybe Char -> Maybe Char -> Maybe Char
> getMaxChar (Just x) (Just y) = Just $ max x y
> getMaxChar (Just x) _ = Just x
> getMaxChar _ (Just x) = Just x
> getMaxChar _  _ = Nothing

> typeinfo rep t = typeinfo' rep t (0, Nothing, [])

> typeinfoTest = typeinfo (RCon "Testing" (RCon "Test2" RChar)) 'd'
> typeinfoTest2 = typeinfo (RCon "Testing" (RCon "Test2" (RProd RInt (RCon "Test4" RChar)) )) (50 :*: 'c')

> typeinfoTest3 = typeinfo (RCon "Testing" (RCon "Test2" (RProd RInt (RCon "Test4" (RProd RInt RChar))))) (50 :*: (150 :*: 'n'))

Comment 3: No need to do ord/chr. Why Maybe Char and not also Maybe Int? Extra
           res parameter not needed because you have recursion: -0.5
Grade 3: 1.5

Exercise 4

> class Desum a where
>   type Desummed a
>   desum :: a -> Desummed a

> instance Desum () where
>   type Desummed () = ()
>   desum () = ()

> instance Desum Int where
>   type Desummed Int = Int
>   desum x = x

> instance (Desum a, Desum b) => Desum (a,b) where
>   type Desummed (a,b) = (a,b)
>   desum (a,b) = (a,b)

 instance (Desum a, Desum b) => Desummed (Either a b) where
   type Desummed (Either a b) = (Maybe a, Maybe b)
   desum (Left a) = (Just a, Nothing)
   desum (Right b) = (Nothing, Just b)

Comment 4: Missing recursion in (a,b) and Either a b: -1
Grade 4: 2
