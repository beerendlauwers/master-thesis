> {-# LANGUAGE TypeOperators #-}
> {-# LANGUAGE DefaultSignatures #-}
> {-# LANGUAGE FlexibleContexts #-}

> module FullTree where

> import Generics.Deriving
> import Generics.Deriving.Enum

> import BinTreeDatatype
> import BinTreeReps

> instance GEnum Char where
>   genum = ['0']

> instance (GEnum a) => GEnum (BinTree a)

> genBinTree :: Int -> [BinTree Char]
> genBinTree x = take (x+1) genum::[BinTree Char]

> genList :: Int -> [[Char]]
> genList x = take x genum::[[Char]]