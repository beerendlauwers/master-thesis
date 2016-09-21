{-# LANGUAGE GADTs
           , KindSignatures
           , MultiParamTypeClasses
           , TypeFamilies
           , TypeOperators
           , FlexibleInstances
           , EmptyDataDecls
           , TemplateHaskell
           #-}
module CompanyReps where

import Generics.MultiRec hiding (C)
import qualified Generics.MultiRec as MR
import Generics.MultiRec.TH
import CompanyDatatypes

data CompanyU :: * -> * where
    Company  :: CompanyU Company
    DeptList :: CompanyU [Dept]
    Dept     :: CompanyU Dept
    UnitList :: CompanyU [Unit]
    Unit     :: CompanyU Unit
    Employee :: CompanyU Employee
    Person   :: CompanyU Person
    Salary   :: CompanyU Salary

$(deriveConstructors [''Company, ''Dept, ''Unit, ''Employee, ''Person, ''Salary])
$(deriveFamily ''CompanyU [''Company, ''Dept, ''Unit, ''Employee, ''Person, ''Salary] "PF_CompanyU")

type instance PF CompanyU = PF_CompanyU

instance Eq Employee where
    (==) = eq Employee
