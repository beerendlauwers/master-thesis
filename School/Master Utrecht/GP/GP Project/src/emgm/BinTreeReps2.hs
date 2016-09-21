{-# LANGUAGE TypeOperators #-}
module BinTreeReps2 where

import GL2
import Generics.EMGM
import BinTreeDatatype

bintree :: Generic2 g => g t t1 -> g (BinTree t) (BinTree t1)
bintree a =  rtype2 isoBinTree isoBinTree (a <|> bintree a <*> bintree a)

isoBinTree :: EP (BinTree t) (t :+: (BinTree t :*: BinTree t))
isoBinTree = EP fromBinTree toBinTree

fromBinTree (Leaf x)              =  L x
fromBinTree (Bin l r)             =  R (l :*: r)

toBinTree (L x)                 =  Leaf x
toBinTree (R (l :*: r))         =  Bin l r

instance FunctorRep BinTree where
   functorRep   =  bintree

