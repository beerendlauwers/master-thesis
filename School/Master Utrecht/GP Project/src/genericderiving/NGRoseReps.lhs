> {-# LANGUAGE TypeOperators #-}

> module NGRoseReps where

> import Generics.Deriving
> import NGRoseDatatype

data NGRose f a = NGRose a (f (NGRose (Comp f f) a)) deriving Generic

newtype Comp f g a = Comp (f (g a))


> data NGRose__
> data NGRoseCons__
> data Comp__

> instance Datatype NGRose__ where
>   datatypeName _ = "NGRose"
>   moduleName   _ = "NGRoseDatatype"

> instance Constructor NGRoseCons__  where conName _ = "NGRose"
> instance Constructor Comp__ where conName   _ = "Comp"

ngrose f a =  rtype isoNGRose (a <*> f (ngrose (comp f f) a))
fromComp (Comp x) = x
toComp x = Comp x

comp f g a = rtype (EP fromComp toComp) (f (g a))

> type Rep1Comp = D1 Comp__ Par1
> instance Generic1 Comp where
>  type Rep1 Comp = Rep1Comp
>  from1 (Comp x)    = M1 Par1 x
>  to1 (M1 Par1 x)   = Comp x

> type Rep1NGRose = D1 NGRose__ (C1 NGRoseCons__ (Par1 :*: (Rec1 (NGRose (Comp Par1 Par1)) :*: Par1)))  -- (C1 BinLeaf__ Par1) :*: (C1 Bin__ (Rec1 BinTree :*: Rec1 BinTree)))
> instance Generic1 NGRose where
>  type Rep1 NGRose = Rep1NGRose
>  from1 (NGRose x xs)    = M1 (Par1 x :*: Rec1 xs) --M1 (L1 (M1 (Par1 x)))
>  to1 M1 (Par1 x :*: Rec1 xs)             = (NGRose x xs)