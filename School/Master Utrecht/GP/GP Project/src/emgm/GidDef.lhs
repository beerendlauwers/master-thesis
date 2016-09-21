> {-# LANGUAGE FlexibleContexts #-}
> module GidDef where
> import GL
> import Generics.EMGM

> newtype Gid a   =  Gid { gid :: a -> a }

> instance Generic Gid where
>   runit        =  Gid (\ x -> x)
>   rsum a b     =  Gid (\ x -> case x of
>                                 L l -> L (gid a l)
>                                 R r -> R (gid b r))
>   rprod a b    =  Gid (\ x -> (gid a (outl x)) :*: (gid b (outr x)))
>   rtype ep a   =  Gid (\ x -> to ep (gid a (from ep x)))
>   rchar        =  Gid (\ x -> x)
>   rint         =  Gid (\ x -> x)
>   rfloat       =  Gid (\ x -> x)
>   rinteger     =  error "Not implemented"
>   rdouble      =  error "Not implemented"

