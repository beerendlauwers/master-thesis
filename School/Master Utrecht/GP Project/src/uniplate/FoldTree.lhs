%----------------------------------------------------------------------------
%
%  Title       :  FoldTree.lhs
%  Author(s)   :  Patrik Jansson, Alex Gerdes
%  License     :  BSD
%  Created     :  6 March 2008
%
%  Remarks     :  -
%
%----------------------------------------------------------------------------

> {-# OPTIONS_GHC -fglasgow-exts #-}

> module FoldTree where

> import Data.Generics.Uniplate.Data

> import TreeDatatype
> import TreeReps
> import CompanyDatatypes
> import CompanyReps
> import PerfectDatatype
> import PerfectReps
> import BinTreeDatatype
> import BinTreeReps
> import GRoseDatatype
> import GRoseReps

> selectIntWTree :: WTree Int Int -> [Int]
> selectIntWTree = universeBi

The following method, testing to select a Int in a Perfect structure, doesn't terminate or results in memory out of bounds exception. 
We suspect this to be a memory leakage problem in Uniplate. 

> selectIntPerfect :: Perfect Int -> [Int]
> selectIntPerfect = error "Uniplate won't terminate after selectIntPerfect call; suspected to be problem in Uniplate." --universeBi

> selectIntBinTree :: BinTree Int -> [Int]
> selectIntBinTree = universeBi

> selectIntGRose :: GRose [] Int -> [Int]
> selectIntGRose = universeBi

> selectSalary :: Company -> [Salary]
> selectSalary = universeBi

> gapplySelectCompanies :: [Company] -> [[Salary]]
> gapplySelectCompanies = error "Uniplate can't implement gmapQ"
