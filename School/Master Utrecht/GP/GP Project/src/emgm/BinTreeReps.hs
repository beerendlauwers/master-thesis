{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses #-}
module BinTreeReps where

import GL
import BinTreeDatatype
import Generics.EMGM

bintree a =  rtype isoBinTree (rcon (ConDescr "Leaf" 1 False Prefix) a <|> 
                              rcon (ConDescr "Bin" 2 False Prefix) (bintree a <*> bintree a))

isoBinTree = EP fromBinTree toBinTree

fromBinTree (Leaf x)              =  L x
fromBinTree (Bin l r)             =  R (l :*: r)

toBinTree (L x)                 =  Leaf x
toBinTree (R (l :*: r))         =  Bin l r

instance FunctorRep BinTree where
   functorRep   =  bintree

instance (Generic g, GRep g a) => GRep g (BinTree a) where
  over = bintree over
