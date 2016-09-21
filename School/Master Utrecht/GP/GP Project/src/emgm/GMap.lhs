> module GMap where

> import GL2
> import BinTreeDatatype
> import BinTreeReps2
> import GMapDef(Gmap(Gmap,applyGmap))

> mapList            :: (a -> b) -> [a] -> [b]
> mapList f          = applyGmap (functorRep (Gmap f))

> mapListBTree       :: (a -> b) -> [BinTree a] -> [BinTree b]
> mapListBTree f     = applyGmap (rList2 (bintree (Gmap f)))

> mapListBTreeList   :: (a -> b) -> [BinTree [a]] -> [BinTree [b]] 
> mapListBTreeList f = applyGmap (rList2 (bintree (rList2 (Gmap f))))
