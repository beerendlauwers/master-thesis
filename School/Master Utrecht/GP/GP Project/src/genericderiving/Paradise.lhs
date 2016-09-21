> module Paradise(increase) where
> import Generics.Deriving
> import UpdateSalaryDef
> import CompanyDatatypes

> -- Increase salary by percentage
> increase :: Float -> Company -> Company
> increase = updateSalary