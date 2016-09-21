> {-# LANGUAGE TypeOperators #-}
> {-# LANGUAGE TypeFamilies #-} 

NOTE: Dreixel said this wouldn't work because the library only abstracts over a single type parameter, and this implementation tries to equate a with w
      because I use Par1 on both a and w.

> module TreeReps where

> import Generics.Deriving.Base
> import TreeDatatype

> import Rep2

> data WTree__
> data TreeLeaf__
> data Fork__
> data Weight__

> instance Datatype WTree__ where
>   datatypeName _ = "WTree"
>   moduleName   _ = "TreeDatatype"

> instance Constructor TreeLeaf__  where conName _ = "Leaf"
> instance Constructor Fork__ where conName   _ = "Fork"
> instance Constructor Weight__ where conName   _ = "Weight"

-- A parameterised datatype for binary trees with data at the leafs
--   and possible "weight" labels
data WTree a w = Leaf a
               | Fork (WTree a w) (WTree a w)
               | WithWeight (WTree a w) w
       deriving (Show, Generic)

> type Rep1WTree a = D1 WTree__ ( ((C1 TreeLeaf__ Par1) :+: (C1 Fork__ (Rec1 (WTree a) :*: Rec1 (WTree a)))) :+: (C1 Weight__ (Rec1 (WTree a) :*: Par1)) )
> instance Generic1 (WTree a) where
>  type Rep1 (WTree a) = Rep1WTree a
>  from1 (Leaf x)    = M1 (L1 (L1 (M1 (Par1 x))))
>  from1 (Fork l r)  = M1 (L1 (R1 (M1 (Rec1 l :*: Rec1 r))))
>  from1 (WithWeight t w) = M1 (R1 (M1 (Rec1 t :*: Par1 w)))
>  to1 (M1 (L1 (L1 (M1 (Par1 x)))))             = (Leaf x)
>  to1 (M1 (L1 (R1 (M1 (Rec1 l :*: Rec1 r)))))  = (Fork l r)
>  to1 ( M1 (R1 (M1 (Rec1 t :*: Par1 w))))      = (WithWeight t w)