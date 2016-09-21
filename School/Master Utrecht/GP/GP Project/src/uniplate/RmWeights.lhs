> module RmWeights where
> import TreeDatatype
> -- import TreeReps
> -- import Data.Generics.PlateData
> import Data.Generics.Uniplate.Direct

> rmWeightsWTree :: WTree Int Int -> WTree Int Int
> rmWeightsWTree = transform f
>   where
>   f (WithWeight t w) = t
>   f x                = x

> {-
> rmWeightsListWTree :: [WTree Int Int] -> [WTree Int Int] 
> rmWeightsListWTree = transformBi f
> f :: WTree Int Int -> WTree Int Int
> f (WithWeight t w) = t
> f x                = x
> -}

> instance Uniplate (WTree a w) where
>     uniplate (WithWeight t w) = plate WithWeight |* t |- w
>     uniplate (Leaf x        ) = plate Leaf       |- x
>     uniplate (Fork l r      ) = plate Fork       |* l |* r
