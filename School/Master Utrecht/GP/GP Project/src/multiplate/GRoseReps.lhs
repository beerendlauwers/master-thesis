> module GRoseReps where

> import GRoseDatatype
> import Data.Generics.Multiplate
> import Control.Applicative

data GRose f' a = GRose a (f' (GRose f' a))

> data GRosePlate f' a f = GRosePlate { grose :: a -> f' (GRose f' a) -> f (GRose f' a) }

> gRosePlate :: GRosePlate f' a f -> GRose f' a -> f (GRose f' a)
> gRosePlate plate (GRose x xs) = grose plate x xs

> -- This plate doesn't properly recurse.
> instance Multiplate (GRosePlate f' a) where
>   multiplate child = GRosePlate (\a rose -> GRose <$> pure a <*> pure rose) -- gRosePlate child rose)
>   mkPlate build = GRosePlate (\x xs -> build gRosePlate (GRose x xs))