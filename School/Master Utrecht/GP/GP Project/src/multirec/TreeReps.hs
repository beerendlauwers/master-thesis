{-# LANGUAGE GADTs
           , KindSignatures
           , MultiParamTypeClasses
           , TypeFamilies
           , TypeOperators
           #-}
module TreeReps where

import Generics.MultiRec
import TreeDatatype

data WTreeU :: * -> * -> * -> * where
    WTree :: WTreeU a w (WTree a w)

type instance PF (WTreeU a w) = K a :>: WTree a w
                            :+: (I (WTree a w) :*: I (WTree a w)) :>: WTree a w
                            :+: (I (WTree a w) :*: K w) :>: WTree a w

instance Fam (WTreeU a w) where
    from WTree (Leaf x) = L (Tag (K x))
    from WTree (Fork l r) = R (L (Tag (I (I0 l) :*: I (I0 r))))
    from WTree (WithWeight t w) = R (R (Tag (I (I0 t) :*: K w)))
    to WTree (L (Tag (K x))) = Leaf x
    to WTree (R (L (Tag (I (I0 l) :*: I (I0 r))))) = Fork l r
    to WTree (R (R (Tag (I (I0 t) :*: K w)))) = WithWeight t w
    
instance El (WTreeU a w)(WTree a w) where
    proof = WTree
