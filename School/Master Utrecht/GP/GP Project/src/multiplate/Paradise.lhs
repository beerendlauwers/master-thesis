> module Paradise(increase) where
> import Data.Generics.Multiplate
> import CompanyDatatypes
> import CompanyReps
> import Data.Functor.Identity

> -- Increase salary by percentage
> increase :: Float -> Company -> Company
> increase k = traverseFor company $ mapFamily $ purePlate { sal = (\(S s) -> return (S (s * (1+k)))) }