> module GShowExt where

> import CompanyDatatypes
> import Generics.Deriving

> instance GShow Company
> instance GShow Dept
> instance GShow Unit
> instance GShow Employee
> instance GShow Person
> instance GShow Salary

> gshowsCompany :: Company -> String
> gshowsCompany = gshow