> module FoldTree where

> import Data.Generics.Multiplate
> import Data.Functor.Constant
> import Data.Functor.Identity

> import TreeDatatype as T
> import TreeReps as TR

> import CompanyDatatypes
> import CompanyReps

> import PerfectDatatype
> --import PerfectReps

> import BinTreeDatatype as B
> import BinTreeReps as BR

> import GRoseDatatype
> import GRoseReps
 
> collectionFunction a = Constant [a]
 
> selectIntWTree :: WTree Int Int -> [Int]
> selectIntWTree = foldFor treePlateAW $ preorderFold $ purePlate { TR.leaf = collectionFunction, TR.weight = const collectionFunction }

> selectIntBinTree :: BinTree Int -> [Int]
> selectIntBinTree = foldFor treePlateA $ preorderFold $ purePlate { BR.leaf = collectionFunction }

> selectSalary :: Company -> [Salary]
> selectSalary = foldFor company $ preorderFold $ purePlate { sal = collectionFunction }

> -- Doesn't work properly because multiplate instance is incorrect
> selectIntGRose :: GRose [] Int -> [Int]
> selectIntGRose = foldFor gRosePlate $ preorderFold $ GRosePlate { grose = \a f -> Constant [a] }

> gRoseExample :: GRose [] Int
> gRoseExample = GRose 1 [GRose 3 []]

 collectRose :: GRosePlate [] Int Identity -> Constant [Int] Int
 collectRose a f = Constant [a]

> gapplySelectCompanies :: [Company] -> [[Salary]]
> gapplySelectCompanies = map selectSalary

> selectIntPerfect :: Perfect Int -> [Int]
> selectIntPerfect = error "It was unclear as to how to implement Nested in Multiplate"