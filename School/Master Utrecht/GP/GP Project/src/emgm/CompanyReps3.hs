{-# LANGUAGE TypeOperators, FlexibleInstances, MultiParamTypeClasses #-}
{-

To make ad-hoc cases available for every data type within the
compound data type `Company', ONE subclass is declared. All
data types are added as methods to that subclass and a default
implementation is added. This default implementation uses the
isomorphism (view/datatype) method. If one needs to add an
ad-hoc case to the generic function, the default implementation
can be overidden. If the compound data type is change, for
instance when the Employee data type is extended with a room number,
the ONE subclass has to be extended with a method and a default
implementation, but the generic functions do not have to be
adapted.


If a subclass is given for every data type, a generic function
would have to make an instance declaration per data type subclass.
In this case, changing a data type would mean that every function
has to add an instance declaration.

-}


module CompanyReps3 where

import CompanyDatatypes
import Generics.EMGM hiding (Unit)
import GL3

-- The type representation of the company data type.

class Generic3 g => GenericCompany g where
  company  :: g Company Company Company
  company  =  rtype3 isoCompany isoCompany isoCompany (rcon3 (ConDescr "C" 1 False Prefix) (rList3 dept))
  dept     :: g Dept Dept Dept
  dept     =  rtype3 isoDept isoDept isoDept
                   (rcon3 (ConDescr "D" 3 False Prefix) (rList3 rchar3 <*> employee <*> rList3 unit'))
  unit'    :: g Unit Unit Unit
  unit'    =  rtype3 isoUnit isoUnit isoUnit
                   (rcon3 (ConDescr "PU" 1 False Prefix) employee <|> rcon3 (ConDescr "DU" 1 False Prefix) dept)
  employee :: g Employee Employee Employee
  employee =  rtype3 isoEmployee isoEmployee isoEmployee
                   (rcon3 (ConDescr "E" 2 False Prefix) (person <*> salary))
  person   :: g Person Person Person
  person   =  rtype3 isoPerson isoPerson isoPerson
                   (rcon3 (ConDescr "P" 2 False Prefix) (rList3 rchar3 <*> rList3 rchar3))
  salary   :: g Salary Salary Salary
  salary   =  rtype3 isoSalary isoSalary isoSalary (rcon3 (ConDescr "S" 1 False Prefix) rfloat3)

instance GenericCompany g => GRep3 g Company where
  over3 = company

-- Company --
isoCompany = EP fromCompany toCompany
fromCompany :: Company -> [Dept]
fromCompany (C x) = x
toCompany :: [Dept] -> Company
toCompany x = C x

-- Dept --
isoDept = EP fromDept toDept
fromDept :: Dept -> Name :*: (Manager :*: [Unit])
fromDept (D n m us) = n :*: (m :*: us)
toDept :: Name :*: (Manager :*: [Unit]) -> Dept
toDept (n :*: (m :*: us)) = D n m us

-- Unit --
isoUnit = EP fromUnit toUnit
fromUnit :: Unit -> Employee :+: Dept
fromUnit (PU e) = L e
fromUnit (DU d) = R d
toUnit :: Employee :+: Dept -> Unit
toUnit (L e) = PU e
toUnit (R d) = DU d

-- Employee --
isoEmployee = EP fromEmployee toEmployee
fromEmployee :: Employee -> Person :*: Salary
fromEmployee (E p s) = p :*: s
toEmployee :: Person :*: Salary -> Employee
toEmployee (p :*: s) = E p s

-- Person --
isoPerson = EP fromPerson toPerson
fromPerson :: Person -> Name :*: Address
fromPerson (P n a) = n :*: a
toPerson :: Name :*: Address -> Person
toPerson (n :*: a) = P n a

-- Salary --
isoSalary = EP fromSalary toSalary
fromSalary (S f) = f
toSalary f = (S f)
