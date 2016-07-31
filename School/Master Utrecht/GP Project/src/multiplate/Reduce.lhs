> module Reduce where

> import Data.Generics.Multiplate
> import TreeDatatype
> import Data.Functor.Constant
> import TreeReps

> collectListTree :: [WTree a w] -> [a]
> collectListTree = concat . map (foldFor treePlateAW $ preorderFold $ purePlate { leaf = \a -> Constant [a] })

> sizeListTree :: [WTree Int w] -> Int
> sizeListTree = length . collectListTree

> sumListTree :: [WTree Int w] -> Int
> sumListTree = sum . collectListTree
