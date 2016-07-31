> {-# LANGUAGE FlexibleContexts #-}
> module FullTree where

> import GL
> import BinTreeDatatype
> import BinTreeReps
> import TreeDatatype
> import TreeReps
> import Generics.EMGM hiding (map)

Implementation of gfulltree

> newtype FullTree a =  FullTree { fulltree' :: Int -> [a]  }

> instance Generic FullTree where
>   runit            =  FullTree (const [Unit])
>   rchar            =  FullTree (consumeDepth ['0'])
>   rint             =  FullTree (consumeDepth [0])
>   rfloat           =  FullTree (consumeDepth [0.0])
>   rsum a b         =  FullTree (\ d -> map L (fulltree' a d) ++
>                                        map R (fulltree' b d))
>   rprod a b        =  FullTree (\ d -> [ l :*: r
>                                       | l <-  fulltree' a d
>                                       , r <-  fulltree' b d])
>   rcon _ a         =  FullTree (\ d -> case d of
>                                       0 -> []
>                                       _ -> fulltree' a (d-1) )
>   rtype ep a       =  FullTree (\ d -> map (to ep) (fulltree' a d))
>   rinteger         =  error "Not implemented"
>   rdouble          =  error "Not implemented"


Primitive types consume one depth unit
This hack would not be needed with a list-like view.

> consumeDepth ls 0 = []
> consumeDepth ls _ = ls


> instance GenericList  FullTree
> instance GenericWTree FullTree

> fulltree :: (GRep FullTree a) => Int -> [a]
> fulltree = fulltree' over

> genBinTree :: Int -> [BinTree Char]
> genBinTree = fulltree

> genList :: Int -> [[Char]]
> genList = fulltree

> genWTree :: Int -> [WTree Int Int]
> genWTree = fulltree
