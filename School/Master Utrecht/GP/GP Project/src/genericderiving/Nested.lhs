> module Nested where

> import PerfectDatatype
> import PerfectReps
> import Generics.Deriving.Eq
 
Perfect Binary Trees (Nested)

> instance (GEq a) => GEq (Perfect a)
> instance (GEq a) => GEq (Fork a)
> equalPerfect :: Perfect Int -> Perfect Int -> Bool
> equalPerfect = geq