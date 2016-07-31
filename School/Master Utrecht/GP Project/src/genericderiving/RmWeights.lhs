> {-# LANGUAGE TypeOperators #-}
> {-# LANGUAGE DefaultSignatures #-}
> {-# LANGUAGE FlexibleContexts #-}

> module RmWeights where

> import Generics.Deriving

> import TreeDatatype

-- default definition

> removeWeightsDef :: (Generic a, RmWeights1 (Rep a)) => a -> a
> removeWeightsDef = to . rmWeights1 . from

-- RmWeights class

> class RmWeights a where
>   rmWeights' :: a -> a
>   default rmWeights' :: (Generic a, RmWeights1 (Rep a)) => a -> a
>   rmWeights' = removeWeightsDef

-- RmWeights class

> class RmWeights1 f where
>   rmWeights1 :: f x -> f x

> instance RmWeights1 U1 where
>   rmWeights1 U1 = U1

> instance (RmWeights1 f) => RmWeights1 (M1 i c f) where
>   rmWeights1 (M1 x) = M1 (rmWeights1 x)

> instance (RmWeights1 f, RmWeights1 g) => RmWeights1 (f :+: g) where
>   rmWeights1 (L1 x) = L1 (rmWeights1 x)
>   rmWeights1 (R1 x) = R1 (rmWeights1 x)

> instance (RmWeights1 f, RmWeights1 g) => RmWeights1 (f :*: g) where
>   rmWeights1 (a :*: b) = (rmWeights1 a) :*: (rmWeights1 b)

> instance (RmWeights a) => RmWeights1 (K1 i a) where
>   rmWeights1 (K1 a) = K1 (rmWeights' a)

-- Primtive instances

> instance RmWeights Int where rmWeights' x = x

-- Instance for WTree

> instance (RmWeights a, RmWeights w) => RmWeights (WTree a w) where
>   rmWeights' (WithWeight t w) = rmWeights' t
>   rmWeights' x = removeWeightsDef x

> rmWeights :: (RmWeights a) => a -> a
> rmWeights = rmWeights'

> rmWeightsWTree :: (RmWeights a, RmWeights w) => WTree a w -> WTree a w
> rmWeightsWTree = rmWeights