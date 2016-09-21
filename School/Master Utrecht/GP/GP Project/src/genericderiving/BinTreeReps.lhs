> {-# LANGUAGE TypeOperators #-}
> {-# LANGUAGE TypeFamilies #-} 

> module BinTreeReps where

> import Generics.Deriving.Base
> import BinTreeDatatype

> data BinTree__
> data BinLeaf__
> data Bin__

> instance Datatype BinTree__ where
>   datatypeName _ = "BinTree"
>   moduleName   _ = "BinTreeDatatype"

> instance Constructor BinLeaf__  where conName _ = "Leaf"
> instance Constructor Bin__ where conName   _ = "Bin"

> type Rep1BinTree = D1 BinTree__ ((C1 BinLeaf__ Par1) :+: (C1 Bin__ (Rec1 BinTree :*: Rec1 BinTree)))
> instance Generic1 BinTree where
>  type Rep1 BinTree = Rep1BinTree
>  from1 (Leaf x)    = M1 (L1 (M1 (Par1 x)))
>  from1 (Bin l r) = M1 (R1 (M1 (Rec1 l :*: Rec1 r)))
>  to1 (M1 (L1 (M1 (Par1 x))))             = (Leaf x)
>  to1 (M1 (R1 (M1 (Rec1 l :*: Rec1 r))))  = (Bin l r)