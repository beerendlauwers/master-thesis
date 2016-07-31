> {-# LANGUAGE DefaultSignatures #-}
> {-# LANGUAGE DeriveGeneric #-}

> module GMap where

> import BinTreeDatatype
> import BinTreeReps
> import Generics.Deriving

> instance GFunctor BinTree

> mapList :: (a -> b) -> [a] -> [b]
> mapList f = gmap f

> mapListBTree :: (a -> b) -> [BinTree a] -> [BinTree b]
> mapListBTree f = gmap (gmap f)

> mapListBTreeList :: (a -> b) -> [BinTree [a]] -> [BinTree [b]]
> mapListBTreeList f = gmap (gmap (gmap f))