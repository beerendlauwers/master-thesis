> module CompanyReps where

> import CompanyDatatypes
> import Control.Applicative
> import Data.Generics.Multiplate
> import Data.Functor.Constant
> import Data.Traversable

data Company  = C [Dept]               deriving Show
data Dept     = D Name Manager [Unit]  deriving Show
data Unit     = PU Employee | DU Dept  deriving Show
data Employee = E Person Salary        deriving Show
data Person   = P Name Address         deriving Show
data Salary   = S Float                deriving Show
type Manager  = Employee
type Name     = String
type Address  = String


> data CompanyPlate f = CompanyPlate 
>                       { company :: Company -> f Company
>                       , dept :: Dept -> f Dept
>                       , unit :: Unit -> f Unit
>                       , emp :: Employee -> f Employee
>                       , per :: Person -> f Person
>                       , sal :: Salary -> f Salary
>                       }

> instance Multiplate CompanyPlate where
>   multiplate child = CompanyPlate c d u e p s
>    where
>      c (C xs) = C <$> traverse (dept child) xs
>      d (D n m xs) = D <$> pure n <*> emp child m <*> traverse (unit child) xs
>      u (PU e) = PU <$> emp child e
>      u (DU dp) = DU <$> dept child dp
>      e (E pr s) = E <$> per child pr <*> sal child s
>      p (P n a) = P <$> pure n <*> pure a
>      s (S s) = S <$> pure s
>   mkPlate build = CompanyPlate (build company) (build dept) (build unit) (build emp) (build per) (build sal)