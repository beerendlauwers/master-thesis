> module TreeReps where

> import TreeDatatype
> import Control.Applicative
> import Data.Generics.Multiplate
> import Data.Functor.Constant

-- Based on code by Sjoerd Visscher (https://gist.github.com/1256281)

-- A parameterised datatype for binary trees with data at the leafs
--   and possible "weight" labels
data WTree a w = Leaf a
               | Fork (WTree a w) (WTree a w)
               | WithWeight (WTree a w) w
       deriving Show
       
> data WTreePlate a w f = WTreePlate 
>                       { leaf :: a -> f (WTree a w)
>                       , fork :: WTree a w -> WTree a w -> f (WTree a w)
>                       , weight :: WTree a w -> w -> f (WTree a w)
>                       }

> treePlateAW :: WTreePlate a w f -> WTree a w -> f (WTree a w)
> treePlateAW plate (Leaf x) = leaf plate x
> treePlateAW plate (Fork t1 t2) = fork plate t1 t2
> treePlateAW plate (WithWeight t w) = weight plate t w

> instance Multiplate (WTreePlate a w) where
>   multiplate child = WTreePlate (\a -> Leaf <$> pure a) (\t1 t2 -> Fork <$> treePlateAW child t1 <*> treePlateAW child t2) (\t w -> WithWeight <$> treePlateAW child t <*> pure w)
>   mkPlate build = WTreePlate (\a -> build treePlateAW (Leaf a)) (\t1 t2 -> build treePlateAW (Fork t1 t2)) (\ t w -> build treePlateAW (WithWeight t w))

-- Example functions

> listWeights :: WTree a w -> [w]
> listWeights = foldFor treePlateAW $ preorderFold $ purePlate { weight = \_ w -> Constant [w] }