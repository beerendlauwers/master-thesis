> {-# LANGUAGE TypeOperators #-}
> {-# LANGUAGE TypeFamilies #-} 

> module PerfectReps where

> import Generics.Deriving
> import PerfectDatatype

> data Perfect__
> data Zero__
> data Succ__

> data Fork__
> data PerfectFork__

> instance Datatype Perfect__ where
>   datatypeName _ = "Perfect"
>   moduleName   _ = "PerfectDatatype"

> instance Datatype PerfectFork__ where
>   datatypeName _ = "Fork"
>   moduleName   _ = "PerfectDatatype"

> instance Constructor Zero__  where conName _ = "Zero"
> instance Constructor Succ__  where conName _ = "Succ"
> instance Constructor Fork__  where conName _ = "Fork"

> instance Functor Perfect where fmap = fmap

> type Rep1Perfect = D1 Perfect__ ( (C1 Zero__ Par1) :+: (C1 Succ__ (Perfect :.: Rec1 Fork)) )
> instance Generic1 Perfect where
>  type Rep1 Perfect = Rep1Perfect
>  from1 (Zero x)    = M1 (L1 (M1 $ Par1 x))
>  from1 (Succ x)    = M1 (R1 (M1 (Comp1 (fmap Rec1 x))))
>  to1 (M1 (L1 (M1 (Par1 x))))   = (Zero x)
>  to1 (M1 (R1 (M1 (Comp1 x))))  = (Succ (fmap unRec1 x))

> type Rep1Fork = D1 PerfectFork__ ( C1 Fork__ (Par1 :*: Par1) )
> instance Generic1 Fork where
>  type Rep1 Fork = Rep1Fork
>  from1 (Fork x y) = M1 (M1 (Par1 x :*: Par1 y))
>  to1 (M1 (M1 (Par1 x :*: Par1 y))) = (Fork x y)