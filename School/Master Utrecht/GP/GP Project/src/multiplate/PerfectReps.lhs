> module PerfectReps where

> import PerfectDatatype
> import Data.Generics.Multiplate
> import Control.Applicative
> import Prelude hiding (succ)

data Perfect a = Zero a | Succ (Perfect (Fork a)) deriving Show
data Fork a = Fork a a deriving Show

> data PerfectPlate a f = PerfectPlate
>                      { zero :: a -> f (Perfect a)
>                      , succ :: (Perfect (Fork a)) -> f (Perfect a)
>                      , fork :: a -> a -> f (Fork a)
>                      }


> perfectPlateA :: PerfectPlate a f -> Perfect a -> f (Perfect a)
> perfectPlateA plate (Zero x) = zero plate x
> perfectPlateA plate (Succ nest) = succ plate nest
> forkPlateA :: PerfectPlate a f -> Fork a -> f (Fork a)
> forkPlateA plate (Fork a1 a2) = fork plate a1 a2

 -- Can't get this to work here, it expects PerfectPlate a to be PerfectPlate (Fork a) in the second field (succ)
 instance Multiplate (PerfectPlate a) where
   multiplate child = PerfectPlate (\a -> Zero <$> pure a) (\s -> Succ <$> perfectPlateA child s) (\a1 a2 -> Fork <$> pure a1 <*> pure a2)
   mkPlate build = PerfectPlate (\a -> build perfectPlateA (Zero a)) (\s -> build perfectPlateA (Succ s)) (\a1 a2 -> build forkPlateA (Fork a1 a2))
