> {-# LANGUAGE TypeOperators #-}
> {-# LANGUAGE MultiParamTypeClasses #-}
> {-# LANGUAGE FlexibleInstances #-}
> {-# LANGUAGE FlexibleContexts #-}
> {-# LANGUAGE TypeFamilies #-}
> {-# LANGUAGE GADTs #-}

> import qualified Generics.Regular as R
> import qualified Generics.MultiRec as M
> import qualified Generics.Deriving as D
> import Generics.Regular.Functions.Eq
> import qualified Generics.MultiRec.FoldK as RK
> import Data.Traversable (Traversable(..))

Beerend Lauwers
3720942

Exercise 1a)

Grade: 1.25 / 1.25

> type Result = (Int,Char,[String])
> noResult = (0, minBound, [])

> class TypeInfo a where
>     typeinfo :: a -> Result
> instance TypeInfo Int where
>   typeinfo x = (x, minBound, [])
> instance TypeInfo Char where
>   typeinfo x = (0, x, [])
> instance TypeInfo Float where
>   typeinfo x = noResult
> instance (TypeInfo a) => TypeInfo [a] where
>  typeinfo = typeinfodefault
> instance (TypeInfo a) => TypeInfo (Maybe a) where
>  typeinfo = typeinfodefault

> class GTypeInfo f where
>     gtypeinfo :: f a -> Result
    
> instance GTypeInfo D.U1 where
>     gtypeinfo D.U1 = noResult

> instance (GTypeInfo a, GTypeInfo b) => GTypeInfo (a D.:+: b) where
>     gtypeinfo (D.L1 x) = gtypeinfo x
>     gtypeinfo (D.R1 x) = gtypeinfo x

> combine :: Result -> Result -> Result
> combine (i1, c1, s1) (i2, c2, s2) = (i1+i2, c1 `max` c2, s1++s2)
    
> instance (GTypeInfo a, GTypeInfo b) => GTypeInfo (a D.:*: b) where
>     gtypeinfo (x D.:*: y) = combine (gtypeinfo x) (gtypeinfo y)

> instance (TypeInfo a) => GTypeInfo (D.K1 i a) where
>     gtypeinfo (D.K1 x) = typeinfo x

> instance GTypeInfo D.Par1 where
>     gtypeinfo (D.Par1 x) = noResult

> instance (GTypeInfo a) => GTypeInfo (D.Rec1 a) where
>     gtypeinfo (D.Rec1 x) = gtypeinfo x

> instance (GTypeInfo a, D.Constructor c) => GTypeInfo (D.M1 D.C c a) where
>     gtypeinfo c@(D.M1 x) = combine (0, minBound,[D.conName c]) (gtypeinfo x)

> instance (GTypeInfo a, D.Selector s) => GTypeInfo (D.M1 D.S s a) where
>    gtypeinfo (D.M1 x) = gtypeinfo x

> instance (GTypeInfo a, D.Datatype d) => GTypeInfo (D.M1 D.D d a) where
>    gtypeinfo (D.M1 x) = gtypeinfo x

> instance (GTypeInfo a, GTypeInfo b) => GTypeInfo (a D.:.: b) where
>    gtypeinfo (D.Comp1 x) = gtypeinfo x
    
> typeinfodefault :: (D.Generic a, GTypeInfo (D.Rep a)) => a -> Result
> typeinfodefault = gtypeinfo . D.from

> ex1aTest = typeinfodefault (Just ["a","b","c"])

Exercise 1b)

Grade: 1.25 / 1.25

Some instances to test stuff

> instance R.Regular Int where
>   from x = R.K x
>   to (R.K x) = x
> type instance R.PF Int = R.K Int

> instance R.Regular (Maybe a) where
>   from (Just x) = R.R (R.K x)
>   from Nothing = R.L R.U
>   to (R.L R.U) = Nothing
>   to (R.R (R.K x)) = Just x
> type instance R.PF (Maybe a) = R.U R.:+: R.K a

> data Just__
> data Nothing__
> instance R.Constructor Just__ where
>   conName _ = "Just"
> instance R.Constructor Nothing__ where
>   conName _ = "Nothing"

> class TypeInfoR a where
>     typeinfoR :: a -> Result
> instance TypeInfoR Int where
>   typeinfoR x = (x, minBound, [])
> instance TypeInfoR Char where
>   typeinfoR x = (0, x, [])
> instance TypeInfoR Float where
>   typeinfoR x = noResult

> class GTypeInfoR f where
>   gtypeinfoR :: ( r -> Result ) -> f r -> Result 

> instance GTypeInfoR R.U where
>    gtypeinfoR _ _ = noResult

> instance (GTypeInfoR f, GTypeInfoR g) => GTypeInfoR (f R.:+: g) where
>   gtypeinfoR f (R.L x) = gtypeinfoR f x
>   gtypeinfoR f (R.R x) = gtypeinfoR f x
    
> instance (GTypeInfoR f, GTypeInfoR g) => GTypeInfoR (f R.:*: g) where
>   gtypeinfoR f (x R.:*: y) = combine (gtypeinfoR f x) (gtypeinfoR f y) 

> instance (TypeInfoR a) => GTypeInfoR (R.K a) where
>   gtypeinfoR f (R.K x) = typeinfoR x

> instance GTypeInfoR R.I where
>   gtypeinfoR f (R.I x) = f x

> instance (GTypeInfoR f, R.Constructor c) => GTypeInfoR (R.C c f) where
>   gtypeinfoR f cx@(R.C x) = combine (0,minBound,[R.conName cx]) (gtypeinfoR f x)

> instance (GTypeInfoR f, R.Selector s) => GTypeInfoR (R.S s f) where
>   gtypeinfoR f sx@(R.S x) = gtypeinfoR f x

> regulartypeinfo :: (R.Regular a, GTypeInfoR (R.PF a)) => a -> Result
> regulartypeinfo x = gtypeinfoR regulartypeinfo (R.from x)

> ex1bTest = regulartypeinfo (Just (5::Int)) -- TODO: Try to get constructor name of Maybe a working to test, code should correct though

Exercise 1c)

Grade: 1.5 / 1.5

> class (M.HFunctor phi f) => HTypeInfo phi f where
>   hTypeInfo :: RK.Algebra' phi f Result

> instance (M.El phi xi) => HTypeInfo phi (M.I xi) where
>   hTypeInfo _ (M.I (M.K0 x)) = x

> instance (TypeInfoR a) => HTypeInfo phi (M.K a) where
>   hTypeInfo _ (M.K x) = typeinfoR x

> instance HTypeInfo phi M.U where
>   hTypeInfo _ M.U = noResult

> instance (HTypeInfo phi f, HTypeInfo phi g) => HTypeInfo phi (f M.:+: g) where
>   hTypeInfo ix (M.L x) = hTypeInfo ix x
>   hTypeInfo ix (M.R y) = hTypeInfo ix y

> instance (HTypeInfo phi f, HTypeInfo phi g) => HTypeInfo phi (f M.:*: g) where
>   hTypeInfo ix (x M.:*: y) = combine (hTypeInfo ix x) (hTypeInfo ix y)

> instance (HTypeInfo phi f) => HTypeInfo phi (f M.:>: ix) where
>   hTypeInfo ix (M.Tag x) = hTypeInfo ix x

> instance (TypeInfo1 f, Traversable f, HTypeInfo phi g) => HTypeInfo phi (f M.:.: g) where
>   hTypeInfo ix (M.D x) = typeinfo1 (fmap (hTypeInfo ix) x)

> class TypeInfo1 f where
>   typeinfo1 :: f Result -> Result
> instance TypeInfo1 Maybe where
>   typeinfo1 (Just x) = x
>   typeinfo1 Nothing = noResult

> instance (M.Constructor c, HTypeInfo phi f) => HTypeInfo phi (M.C c f) where
>   hTypeInfo ix cx@(M.C x) = (0,minBound,[M.conName cx])

> typeinfoM :: (M.Fam phi, HTypeInfo phi (M.PF phi)) => phi ix -> ix -> Result
> typeinfoM p x = RK.fold hTypeInfo p x

Exercise 2

> data U          p r = U deriving Show
> data K a        p r = K a deriving Show
> data (:+:) f g  p r = L (f p r) | R (g p r) deriving Show
> data (:*:) f g  p r = f p r :*: g p r deriving Show
> newtype P       p r = P p deriving Show
> newtype I       p r = I r deriving Show
> infixr 5 :+:
> infixr 6 :*:

> class G f where
>   type R f :: * -> * -> *
>   from :: f a -> R f a (f a)
>   to   :: R f a (f a) -> f a

Exercise 2a)

Grade: 0.5 / 0.5

> instance G Maybe where
>   type R Maybe = U :+: P
>   from Nothing = L U
>   from (Just x) = R (P x)
>   to (L u) = Nothing
>   to (R (P x)) = Just x

> data List a = Nil | Cons a (List a) deriving Show
> instance G List where
>   type R List = U :+: (P :*: I)
>   from Nil = L U
>   from (Cons x r) = R (P x :*: I r)
>   to (R (P x :*: I r)) = Cons x r
>   to (L U) = Nil

Exercise 2b)

Grade: 0.5 / 1.5

> class PMap f where
>    pmap :: (a -> b) -> f a r -> f b r

> instance PMap (K a) where
>   pmap f (K x) = (K x)

> instance PMap U where
>   pmap f U = U

> instance (PMap f, PMap g) => PMap (f :+: g) where
>   pmap f (L x) = L (pmap f x)
>   pmap f (R x) = R (pmap f x)

> instance (PMap f, PMap g) => PMap (f :*: g) where
>   pmap f (x :*: y) = pmap f x :*: pmap f y

> instance PMap I where
>   pmap f (I x) = (I x)

> instance PMap P where
>   pmap f (P p) = P (f p)

Exercise 2c)

Grade: 1 / 1

> instance Functor (U p) where
>   fmap _ U = U

> instance Functor (K x p) where
>   fmap _ (K x) = K x
   
> instance (Functor (f p), Functor (g p)) => Functor ((f :+: g) p) where
>  fmap func (L f) = L (fmap func f)
>  fmap func (R g) = R (fmap func g)
  
> instance (Functor (f p), Functor (g p)) => Functor ((f :*: g) p) where
>   fmap func (f :*: g) = fmap func f :*: fmap func g

> instance Functor (I p) where
>   fmap func (I r) = I (func r)

> instance Functor (P p) where
>   fmap func (P p) = P p
   
Exercise 2d)

Grade: 2 / 2

> type family Alg (f :: * -> * -> *) p r
> class Apply f where
>     apply :: Alg f p r -> f p r -> r

> type instance Alg U p r = r
> instance Apply U where
>   apply f U = f

> type instance Alg (K a) p r = a -> r
> instance Apply (K x) where
>   apply f (K x) = f x

> type instance Alg (f :+: g) p r = (Alg f p r, Alg g p r)
> instance (Apply f, Apply g) => Apply (f :+: g) where
>   apply (f,_) (L x) = apply f x
>   apply (_,g) (R x) = apply g x

> type instance Alg (K a :*: g) p r = a -> Alg g p r
> instance (Apply g) => Apply (K a :*: g) where
>   apply f (K x :*: y) = apply (f x) y

> type instance Alg (I :*: g) p r = r -> Alg g p r
> instance (Apply g) => Apply (I :*: g) where
>   apply f (I x :*: y) = apply (f x) y

> type instance Alg (P :*: g) p r = p -> Alg g p r
> instance (Apply g) => Apply (P :*: g) where
>   apply f (P x :*: y) = apply (f x) y

> type instance Alg I p r = r -> r
> instance Apply I where
>   apply f (I x) = f x

> type instance Alg P p r = p -> r
> instance Apply P where
>   apply f (P x) = f x

Exercise 2e)

i)

 instance Functor List where
   fmap f = doRecursion (pmap f)
 doRecursion f x = to (fmap (doRecursion f) (from x))

    fmap f x = to (fmap (fmap (to.(pmap f).from)) (from x)) -- to ( fmap (fmap (to.(pmap f).from)) (from x))

 fmap f x = to.fmap.fmap.(pmap f).(from x)  
 
 map (fmap (pmap f)) (from x))

  fmap f x = to ( fmap (fmap (pmap f) (from x) ))
  

ii)

 fold :: (Apply f) => Alg f p r -> f p r -> r
 fold alg = apply alg . fmap (fold alg) . from
 
 FINAL GRADE: 8 / 10