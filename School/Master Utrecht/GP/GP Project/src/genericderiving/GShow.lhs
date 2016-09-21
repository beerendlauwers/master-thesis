> {-# LANGUAGE DefaultSignatures #-}

> module GShow where

> import Generics.Deriving

> import BinTreeDatatype
> import CompanyDatatypes

> instance (GShow a) => GShow (BinTree a)

> instance GShow Company
> instance GShow Dept
> instance GShow Unit
> instance GShow Employee
> instance GShow Person
> instance GShow Salary

> gShowBinTree :: BinTree Int -> String
> gShowBinTree = gshow

> gshowsCompany :: Company -> String
> gshowsCompany =  gshow

> gapplyShowList :: [Int] -> [String]
> gapplyShowList = gmap gshow