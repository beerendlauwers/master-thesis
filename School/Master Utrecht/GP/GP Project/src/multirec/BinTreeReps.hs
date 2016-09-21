{-# LANGUAGE GADTs
           , KindSignatures
           , MultiParamTypeClasses
           , TypeFamilies
           , TypeOperators
           #-}
module BinTreeReps where

import Generics.MultiRec
import BinTreeDatatype

data BinTreeU :: * -> * -> * where
    BinTree :: BinTreeU a (BinTree a)

type instance PF (BinTreeU a) = K a :>: BinTree a :+:
                                (I (BinTree a) :*: I (BinTree a)) :>: (BinTree a)

instance Fam (BinTreeU a) where
    from BinTree (Leaf x)  = L (Tag (K x))
    from BinTree (Bin l r) = R (Tag (I (I0 l) :*: I (I0 r)))
    to BinTree (L (Tag (K x))) = Leaf x
    to BinTree (R (Tag (I (I0 l) :*: I (I0 r)))) = Bin l r
    
instance El (BinTreeU a)(BinTree a) where
    proof = BinTree

instance EqS (BinTreeU a) where
    eqS BinTree BinTree = Just Refl
