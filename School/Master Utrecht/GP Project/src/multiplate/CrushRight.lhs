> module CrushRight where

> import Data.Generics.Multiplate
> import Data.Functor.Constant
> import Control.Applicative

> import TreeDatatype
> import TreeReps as TR

> import BinTreeDatatype as B
> import BinTreeReps as BR

> flattenListTree :: [WTree a w] -> [a]
> flattenListTree = concat . map (foldFor treePlateAW $ preorderFold $ purePlate { TR.leaf = \a -> Constant [a] })

> binTreeTraverse x = foldFor treePlateA $ preorderFold $ x

> sizeBTree :: BinTree a -> Int
> sizeBTree = length . (binTreeTraverse purePlate { BR.leaf = \a -> Constant [1] })
> --sizeBTree = sum . (binTreeTraverse BinTreePlate { BR.leaf = \a -> Constant [1], BR.bin = \t1 t2 -> Constant [] <*> pure t1 <*> pure t2 })

> sizeListTree :: [WTree a w] -> Int
> sizeListTree = length . flattenListTree

> sumListTree :: [WTree Int w] -> Int
> sumListTree = sum . flattenListTree