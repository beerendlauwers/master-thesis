module TreeReps2 where

import GL2
import TreeDatatype
import Generics.EMGM

-- Representation for the tree

tree a w = rtype2 isoTree
                 isoTree
                 (a <|>
                  (tree a w <*> tree a w) <|>
                  (tree a w <*> w))

isoTree = EP fromTree toTree

fromTree (Leaf x)              =  L x
fromTree (Fork l r)            =  R (L (l :*: r))
fromTree (WithWeight a b)      =  R (R (a :*: b))

toTree (L x)                 =  Leaf x
toTree (R (L (l :*: r)))   =  Fork l r
toTree (R (R (a :*: b)))   =  WithWeight a b
