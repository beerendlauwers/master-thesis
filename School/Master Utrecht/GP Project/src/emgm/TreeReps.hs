{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses #-}
module TreeReps where

import GL hiding (Tree, fromTree, toTree, Fork, tree, isoTree, GenericTree(..))
import TreeDatatype
import Generics.EMGM

-- Representation for the tree

-- This instance allows the definition of ad-hoc cases
class Generic g => GenericWTree g where
  wtree :: g a -> g w -> g (WTree a w)
  wtree a w = rwtree a w

instance (GenericWTree g, GRep g a, GRep g w) => GRep g (WTree a w) where
    over = wtree over over

-- note that the representation must use "wtree" rather than "rwtree"
-- so that the children of the represented constructor uses the ad-hoc
-- case on them. In this way we can write a constructor ad-hoc case,
-- see RmWeights.lhs
rwtree :: GenericWTree g => g a -> g w -> g (WTree a w)
rwtree a w = rtype isoTree (rcon (ConDescr "Leaf" 1 False Prefix) a <|>
                           rcon (ConDescr "Fork" 2 False Prefix) (wtree a w <*> wtree a w) <|>
                           rcon (ConDescr "WithWeight" 2 False Prefix) (wtree a w <*> w))

isoTree = EP fromTree toTree

fromTree (Leaf x)              =  L x
fromTree (Fork l r)            =  R (L (l :*: r))
fromTree (WithWeight a b)      =  R (R (a :*: b))

toTree (L x)                 =  Leaf x
toTree (R (L (l :*: r)))   =  Fork l r
toTree (R (R (a :*: b)))   =  WithWeight a b
