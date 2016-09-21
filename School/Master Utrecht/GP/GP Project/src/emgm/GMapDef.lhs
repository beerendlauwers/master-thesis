> {-# LANGUAGE RankNTypes, KindSignatures #-}
> module GMapDef where

> import GL2
> import GL hiding (FunctorRep, functorRep)
> import Generics.EMGM

> newtype Gmap a b    =  Gmap { applyGmap :: a -> b }

> instance Generic2 Gmap where
>   runit2              =  Gmap (\ x -> x)
>   rsum2 a b           =  Gmap (\ x -> case x of
>                                       L l -> L (applyGmap a l)
>                                       R r -> R (applyGmap b r))
>   rprod2 a b          =  Gmap (\ x -> (applyGmap a (outl x)) :*: 
>                                     (applyGmap b (outr x)))
>   rtype2 ep1 ep2 a    =  Gmap (\ x -> to ep2 (applyGmap a (from ep1 x)))
>   rchar2              =  Gmap (\ x -> x)
>   rint2               =  Gmap (\ x -> x)
>   rfloat2             =  Gmap (\ x -> x)
>   rinteger2           =  error "Not implemented"
>   rdouble2            =  error "Not implemented"

Easy to call version:

> gmap :: forall aT bT (fT :: * -> *). (FunctorRep fT) => (aT -> bT) -> fT aT -> fT bT
> gmap f = applyGmap (functorRep (Gmap f))

