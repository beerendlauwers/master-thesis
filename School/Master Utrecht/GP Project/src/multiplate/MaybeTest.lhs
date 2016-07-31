> module MaybeTest where

> import Data.Generics.Multiplate
> import Data.Functor.Constant
> import Data.Functor.Identity
> import Control.Applicative

> data Perhaps a = Simply a | Nope

> data PerhapsPlate a f = PerhapsPlate { nopeA :: f (Perhaps a), simplyA :: a -> f (Perhaps a) }

> -- Plates
> perhapsA :: PerhapsPlate a f -> Perhaps a -> f (Perhaps a)
> perhapsA plate Nope = nopeA plate
> perhapsA plate (Simply x) = simplyA plate x

> instance Multiplate (PerhapsPlate a) where
>   multiplate child = PerhapsPlate (pure Nope) (\a -> Simply <$> pure a)
>   mkPlate build = PerhapsPlate (build perhapsA Nope) (\a -> build perhapsA (Simply a))

> data MaybePlate a f = MaybePlate { nothing :: f (Maybe a), just :: a -> f (Maybe a) }

> maybeA :: MaybePlate a f -> Maybe a -> f (Maybe a)
> maybeA plate Nothing = nothing plate
> maybeA plate (Just x) = just plate x

> instance Multiplate (MaybePlate a) where
>   multiplate child = MaybePlate (pure Nothing) (\a -> Just <$> pure a)
>   mkPlate build = MaybePlate (build maybeA Nothing) (\a -> build maybeA (Just a))