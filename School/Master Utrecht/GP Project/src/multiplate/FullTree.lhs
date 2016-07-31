> module FullTree where

> import BinTreeDatatype

> errorMsg = error "Multiplate can't handle generic producer functions."

> genBinTree :: Int -> BinTree Char
> genBinTree = errorMsg

> genList :: Int -> [Char]
> genList = errorMsg