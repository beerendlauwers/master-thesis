{-# LANGUAGE GADTs
           , KindSignatures
           , MultiParamTypeClasses
           , TypeFamilies
           , TypeOperators
           #-}
module BinTreeRepsF where

import Generics.MultiRec.BaseF
import BinTreeDatatype

data BinTreeU :: (* -> *) -> * where
    BinTree :: BinTreeU BinTree

type instance PF BinTreeU = E :>: BinTree :+:
                            (I BinTree :*: I BinTree) :>: BinTree

instance Fam BinTreeU BinTree where
    from (Leaf x)  = L (Tag (E x))
    from (Bin l r) = R (Tag (I (I0F l) :*: I (I0F r)))
    to (L (Tag (E x))) = Leaf x
    to (R (Tag (I (I0F l) :*: I (I0F r)))) = Bin l r
    index = BinTree
