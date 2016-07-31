> module RmWeights where
> import TreeDatatype
> import TreeReps
> import Data.Generics.Multiplate
> import Control.Applicative

> rmWeightsWTree :: WTree a a -> WTree a a
> rmWeightsWTree = traverseFor treePlateAW $ mapFamily purePlate { weight = (\ t x -> pure t) }