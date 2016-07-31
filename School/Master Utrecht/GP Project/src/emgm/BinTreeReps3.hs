module BinTreeReps3 where

import BinTreeDatatype
import Generics.EMGM

bintree :: Generic3 g => g t t1 t2 -> g (BinTree t) (BinTree t1) (BinTree t2)
bintree a =  rtype3 isoBinTree isoBinTree isoBinTree (a <|> bintree a <*> bintree a)

isoBinTree :: EP (BinTree t) (t :+: (BinTree t :*: BinTree t))
isoBinTree = EP fromBinTree toBinTree

fromBinTree (Leaf x)              =  L x
fromBinTree (Bin l r)             =  R (l :*: r)

toBinTree (L x)                 =  Leaf x
toBinTree (R (l :*: r))         =  Bin l r

instance Generic g => FunctorRep g BinTree where
   functorRep   =  bintree


