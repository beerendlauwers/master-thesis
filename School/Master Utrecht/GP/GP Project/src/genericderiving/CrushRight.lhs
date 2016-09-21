> {-# LANGUAGE TypeOperators #-}
> {-# LANGUAGE DeriveGeneric #-}
> {-# LANGUAGE TypeFamilies #-}
> {-# LANGUAGE DefaultSignatures #-}
> {-# LANGUAGE FlexibleContexts #-}
> {-# LANGUAGE ScopedTypeVariables #-}

> module CrushRight where

> import Data.Traversable

> import Generics.Deriving

> import BinTreeDatatype hiding (sizeBTree)
> import BinTreeReps

> import TreeDatatype

> import PerfectDatatype
> import PerfectReps

> import GMap

> class Crush f where
>   crush :: (a -> b -> b) -> b -> f a -> b

> instance Crush U1 where
>   crush op e U1 = e

> instance Crush (K1 i c) where
>   crush op e (K1 a) = e

> instance Crush Par1 where
>   crush op e (Par1 a) = a `op` e

> instance (CrushRight f) => Crush (Rec1 f) where
>   crush op e (Rec1 a) = crushr op e a

> instance (Crush f, Crush g) => Crush (f :+: g) where
>   crush op e (L1 a) = crush op e a
>   crush op e (R1 a) = crush op e a

> instance (Crush f, Crush g) => Crush (f :*: g) where
>   crush op e (x :*: y) = crush op (crush op e y) x

 --Only works if you define crush as crush :: (a -> a -> a) -> a -> f a -> a, like PolyP
 --But this implies you can only do a subuniverse of crushes (namely, those where the type does not change)
 --José Pedro Magalhães suggests to have a signature in the style of (a -> b -> b) -> b -> f (g a) -> b,
 --then use gmap to crush f (g a) to f b, and then use another function of type (b -> b -> b) to crush that to a b.
 --One possibility would be to use foldable.fold1 for the left side of a composition (could also make that a generic function)
 instance (Crush f, Crush g, GFunctor f) => Crush (f :.: g) where
   crush op e (Comp1 x) = crush op e . gmap (crush op e) $ x

> instance Crush f => Crush (M1 i c f) where
>   crush op e (M1 a) = crush op e a

> crushDefault :: (Generic1 f, Crush (Rep1 f)) => (a -> b -> b) -> b -> f a -> b
> crushDefault op e = crush op e . from1

> class CrushRight f where
>   crushr :: (a -> b -> b) -> b -> f a -> b
>   default crushr :: (Generic1 f, Crush (Rep1 f)) => (a -> b -> b) -> b -> f a -> b
>   crushr = crushDefault

Some generic crush functions

> gSize :: (Num a, Generic1 f, CrushRight f) => f a -> a
> gSize = crushr ((+).const 1) 0

Binary Trees

> instance CrushRight BinTree

> sizeBTree :: (Num a) => BinTree a -> a
> sizeBTree = gSize

> sizeListBTree :: (Num a) => [BinTree a] -> a
> sizeListBTree xs = sum $ gmap gSize xs
 
Nested Perfect Trees

> test :: (Num a) => Perfect a -> a
> test = error "Does not terminate"

Weighted Trees

> treeError = error "generic-deriving only abstracts over a single parameter, so it can't implement CrushRight for WTree a w"

> sizeListTree :: [WTree Int w] -> Int
> sizeListTree = treeError

> flattenListTree :: [WTree a b] -> [a]
> flattenListTree = treeError

> sumListTree :: [WTree Int w] -> Int
> sumListTree = treeError

Lists

> instance CrushRight []

> sizeList :: (Num a) => [a] -> a
> sizeList = gSize