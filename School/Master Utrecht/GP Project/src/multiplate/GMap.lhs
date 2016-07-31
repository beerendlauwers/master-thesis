> module GMap where

> import BinTreeDatatype

> errorNotSupported  = error "Multiplate.GMap: gmap not supported in Multiplate"

> mapList            :: (a -> b) -> [a] -> [b]
> mapList f          = errorNotSupported

> mapListBTree       :: (a -> b) -> [BinTree a] -> [BinTree b]
> mapListBTree f     = errorNotSupported

> mapListBTreeList   :: (a -> b) -> [BinTree [a]] -> [BinTree [b]] 
> mapListBTreeList f = errorNotSupported
