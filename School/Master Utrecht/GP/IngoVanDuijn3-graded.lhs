> {-#LANGUAGE GADTs                 #-}
> {-#LANGUAGE TypeOperators         #-}
> {-#LANGUAGE RankNTypes            #-}
> {-#LANGUAGE KindSignatures        #-}
> {-#LANGUAGE TypeFamilies          #-}
> {-#LANGUAGE FlexibleContexts      #-}
> {-#LANGUAGE FlexibleInstances     #-}
> {-#LANGUAGE MultiParamTypeClasses #-}
> {-#LANGUAGE UndecidableInstances  #-}
> {-#LANGUAGE TypeSynonymInstances  #-}


> import qualified Generics.Deriving as D
> import qualified Generics.Regular as R
> import qualified Generics.MultiRec as M
> import qualified Generics.MultiRec.FoldK as K
> import qualified Data.Foldable as DF
> import qualified Data.Traversable as DT

1.

First we handle all our primitives cases, these will be used in a, b and c:

> class TypeInfo a where 
>   typeInfo :: a -> (Int, Char, [String])
> instance TypeInfo Int where
>   typeInfo i = (i, minBound, [])
> instance TypeInfo Char where
>   typeInfo c = (0, c, [])

1a. 

Grade: 1.25 / 1.25

We make all the structure elements instances of TypeInfo', which takes
an argument of kind *->*.

> class TypeInfo' f where
>   typeInfo' :: f a -> (Int, Char, [String])

> instance TypeInfo' D.U1 where
>   typeInfo' _ = (0, minBound, [])

> instance (TypeInfo' a, TypeInfo' b) => TypeInfo' (a D.:+: b) where
>   typeInfo' (D.L1 a) = typeInfo' a
>   typeInfo' (D.R1 a) = typeInfo' a

> instance (TypeInfo' a, TypeInfo' b) => TypeInfo' (a D.:*: b) where
>   typeInfo' (a D.:*: b) = k (typeInfo' a) (typeInfo' b) where
>       k (i1, c1, l1) (i2, c2, l2) = (i1 + i2, max c1 c2, l1 ++ l2)

> instance (TypeInfo' a, D.Constructor c) => TypeInfo' (D.M1 D.C c a) where
>   typeInfo' c@(D.M1 a) = k (D.conName c) (typeInfo' a)
>       where k s (i, c, l) = (i, c, s:l)

> instance (TypeInfo' a, D.Datatype d) => TypeInfo' (D.M1 D.D d a) where
>   typeInfo' (D.M1 a) = typeInfo' a

> instance (TypeInfo c) => TypeInfo' (D.K1 i c) where
>   typeInfo' (D.K1 a) = typeInfo a

Now we can define a default typeInfo function (w

> typeInfodefault :: (D.Generic f, TypeInfo' (D.Rep f))
>                   => f -> (Int, Char, [String])
> typeInfodefault l = typeInfo' $ (D.from l)

And finally make lists an instance of TypeInfo

> instance (TypeInfo a) => TypeInfo [a] where
>   typeInfo = typeInfodefault

> test1 = [1000::Int, 330, 7]

It works!
*Main> typeInfo test1
(1337,'\NUL',[":",":",":","[]"])

1b.

Grade: 1.25 / 1.25

Very similar to 1a, we make every structural element an instance of TypeInfoR',
again with argument of kind *->*.

> class TypeInfoR' f where
>   typeInfoR' :: (a -> (Int, Char, [String])) -> f a -> (Int, Char, [String])

> instance TypeInfoR' R.U where
>   typeInfoR' f _ = (0, minBound, [])

> instance (TypeInfoR' a, TypeInfoR' b) => TypeInfoR' (a R.:+: b) where
>   typeInfoR' f (R.L a) = typeInfoR' f a
>   typeInfoR' f (R.R b) = typeInfoR' f b

> instance (TypeInfoR' a, TypeInfoR' b) => TypeInfoR' (a R.:*: b) where
>   typeInfoR' f (a R.:*: b) = k (typeInfoR' f a) (typeInfoR' f b) where
>       k (i1, c1, l1) (i2, c2, l2) = (i1 + i2, max c1 c2, l1 ++ l2)

> instance (TypeInfoR' a, R.Constructor c) => TypeInfoR' (R.C c a) where
>   typeInfoR' f cx@(R.C a) = k (R.conName cx) (typeInfoR' f a)
>       where k s (i, c, l) = (i, c, s:l)

> instance (TypeInfo a) => TypeInfoR' (R.K a) where
>   typeInfoR' f (R.K a) = typeInfo a

> instance TypeInfoR' R.I where
>   typeInfoR' f (R.I a) = f a

Here we define the generic function which can be applied to instances of Regular.

> typeInfoR :: (R.Regular a, TypeInfoR' (R.PF a)) => a -> (Int, Char, [String])
> typeInfoR a = typeInfoR' typeInfoR (R.from a)

We make List an instance of regular so we can test.

> data List a = Nil | Cons a (List a) deriving Show
> type instance R.PF (List a) = R.U R.:+: R.K a R.:*: R.I
> instance R.Regular (List a) where
>   from Nil = R.L R.U
>   from (Cons x xs) = R.R $ (R.K x) R.:*: (R.I xs)
>   to (R.L R.U) = Nil
>   to (R.R ((R.K x) R.:*: (R.I xs))) = Cons x xs

> test2 = (Cons (1000::Int) (Cons 330 (Cons 7 Nil)))

Great success! (I didn't define constructor names in my custom List so they don't show)
*Main> typeInfoR test2
(1337,'\NUL',[])

2c.

Grade: 1.5 / 1.5

We define an algebra for all structure elements.

> class (M.HFunctor fi f) => TypeInfoM' fi f where
>   typeInfoM' :: K.Algebra' fi f (Int, Char, [String])

> instance (M.El fi xi) => TypeInfoM' fi (M.I xi) where
>   typeInfoM' g (M.I (M.K0 x)) = x

> instance (TypeInfo a) => TypeInfoM' fi (M.K a) where
>   typeInfoM' g (M.K a) = typeInfo a 

> instance TypeInfoM' fi M.U where
>   typeInfoM' g M.U = (0, minBound, [])

> instance (TypeInfoM' fi f, TypeInfoM' fi g) => TypeInfoM' fi (f M.:+: g) where
>   typeInfoM' ix (M.L x) = typeInfoM' ix x
>   typeInfoM' ix (M.R y) = typeInfoM' ix y

> instance (TypeInfoM' fi f, TypeInfoM' fi g) => TypeInfoM' fi (f M.:*: g) where
>   typeInfoM' ix (x M.:*: y) = k (typeInfoM' ix x) (typeInfoM' ix y) where
>        k (i1, c1, l1) (i2, c2, l2) = (i1 + i2, max c1 c2, l1 ++ l2)

> instance (TypeInfoM' fi f) => TypeInfoM' fi (f M.:>: ix) where
>   typeInfoM' ix (M.Tag x) = typeInfoM' ix x

> instance (DT.Traversable f, TypeInfoM' fi g) => TypeInfoM' fi (f M.:.: g) where
>   typeInfoM' ix (M.D x) = DF.foldr k (0, minBound, []) (fmap (typeInfoM' ix) x) where
>    k (i1, c1, l1) (i2, c2, l2) = (i1 + i2, max c1 c2, l1 ++ l2)

> instance (M.Constructor c, TypeInfoM' fi f) => TypeInfoM' fi (M.C c f) where
>   typeInfoM' ix cx@(M.C x) = k (M.conName cx) (typeInfoM' ix x)
>        where k s (i, c, l) = (i, c, s:l)

Fold the algebra over the data.

> typeInfoM :: (M.Fam fi, TypeInfoM' fi (M.PF fi)) => fi ix -> ix -> (Int, Char, [String])
> typeInfoM = K.fold typeInfoM'



2.

Define our structure elements.

> data U p r = U deriving Show
> data K a p r = K a deriving Show
> data (:+:) f g p r = L (f p r) | R (g p r) deriving Show
> data (:*:) f g p r = f p r :*: g p r deriving Show
> newtype P p r = P p deriving Show
> newtype I p r = I r deriving Show
> infixr 5 :+:
> infixr 6 :*:

Our "generic" class.

> class G f where
>   type R f :: * -> * -> *
>   from :: f a -> R f a (f a)
>   to :: R f a (f a) -> f a

2a.

Grade: 0.5 / 0.5

Define the obvious instance for List, pretty straightforward.

> instance G List where
>   type R List = U :+: P :*: I
>   from Nil = L U
>   from (Cons x xs) = R $ P x :*: I xs
>   to (L U) = Nil
>   to (R (P x :*: I xs)) = Cons x xs

2b.

Grade: 1.0 / 1.5

Comment: Not exactly as in the solution, but the correction's definition
         of pmapdefault is virtually the same as this solution's definition for
         2e i. (The difference being a double fmap to get the needed recursion)

Make all the structure elements instances of PMap.
PMap maps on the parameter is not recursive.

> class PMap f where
>   pmap :: (a -> b) -> f a r -> f b r

> instance PMap U where
>   pmap g U = U

> instance PMap (K a) where
>   pmap g (K a) = K a

> instance (PMap f, PMap h) => PMap (f :+: h) where
>   pmap g (L f) = L $ pmap g f
>   pmap g (R h) = R $ pmap g h

> instance (PMap f, PMap h) => PMap (f :*: h) where
>   pmap g (f :*: h) = (pmap g f) :*: (pmap g h)

> instance PMap P where
>   pmap g (P p) = P $ g p

> instance PMap I where
>   pmap g (I r) = I r

2c.

Grade: 1 / 1

Make all the structure elements with fixed parameter a Functor.
Functor maps on the recursive element, so it is recursive.

> instance Functor (U p) where
>   fmap f U = U

> instance Functor (K a p) where
>   fmap f (K a) = K a

> instance (Functor (g p), Functor (h p)) => Functor ((g :+: h) p) where
>   fmap f (L g) = L $ fmap f g
>   fmap f (R h) = R $ fmap f h

> instance (Functor (g p), Functor (h p)) => Functor ((g :*: h) p) where
>   fmap f (g :*: h) = (fmap f g) :*: (fmap f h)

> instance Functor (P p) where
>   fmap f (P p) = P p

> instance Functor (I p) where
>   fmap f (I r) = I $ f r

2d.

Grade: 2 / 2

Define the Apply and Alg instances for every structure element.

> type family Alg (f :: * -> * -> *) p r

> class Apply f where
>   apply :: Alg f p r -> f p r -> r

> type instance Alg U p r = r
> instance Apply U where
>   apply f U = f

> type instance Alg (K a) p r = a -> r
> instance Apply (K a) where
>   apply f (K x) = f x

> type instance Alg (f :+: g) p r = (Alg f p r, Alg g p r)
> instance (Apply f, Apply g) => Apply (f :+: g) where
>   apply (f , _) (L x) = apply f x
>   apply (_ , g) (R y) = apply g y

> type instance Alg (K a :*: g) p r = a -> Alg g p r
> instance (Apply g) => Apply (K a :*: g) where
>   apply f (K a :*: y) = apply (f a) y

> type instance Alg (I :*: g) p r = r -> Alg g p r
> instance (Apply g) => Apply (I :*: g) where
>   apply f (I x :*: y) = apply (f x) y

> type instance Alg (P :*: g) p r = p -> Alg g p r
> instance (Apply g) => Apply (P :*: g) where
>   apply f (P x :*: y) = apply (f x) y

> type instance Alg P p r = p -> r
> instance Apply P where
>   apply f (P p) = f p

> type instance Alg I p r = r -> r
> instance Apply I where
>   apply f (I x) = f x

2e.
i

Grade: 0.25 / 0.25

Use fmap and pmap to genericaly make List a functor.

> instance Functor List where
>   fmap f = to . (pmap f) . (fmap (fmap f)) . from

ii
Pretty much the same as in the slides.

Grade: 0.25 / 0.25

> fold :: (G f, Apply (R f), Functor (R f a)) => Alg (R f) a r -> f a -> r
> fold alg = apply alg . fmap (fold alg) . from

iii

Nil algebra is the constant 0 and Cons algebra is addition.

Grade: 0.25 / 0.25

> listSumAlg :: Alg (R List) Int Int
> listSumAlg = (0, (+))

> sumList :: List Int -> Int
> sumList = fold listSumAlg

iv
Nil algebra is again 0 and Cons algebra ignores the element and
adds 1 to a counter.

Grade: 0.25 / 0.25

> consCountAlg :: Alg (R List) a Int
> consCountAlg = (0, const succ)

> countConsList :: List a -> Int
> countConsList = fold consCountAlg

Here we don't ignore the elements, but apply countConsList to it
and then add 1 to the result.

> countConsListList :: List (List a) -> Int
> countConsListList = fold (0, (+) . succ . countConsList)

FINAL GRADE: 9.5 / 10