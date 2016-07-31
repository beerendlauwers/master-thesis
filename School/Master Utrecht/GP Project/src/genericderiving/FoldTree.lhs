> {-# LANGUAGE TypeOperators #-}
> {-# LANGUAGE FlexibleContexts #-}
> {-# LANGUAGE DefaultSignatures #-}

> module FoldTree where

> import Generics.Deriving

> import PerfectDatatype
> import PerfectReps

> import BinTreeDatatype as B
> import BinTreeReps as BR

> import CompanyDatatypes

> import CrushRight

> import TreeDatatype as T

-- Generic toList function

> gToList :: (Generic1 f, CrushRight f) => f a -> [a]
> gToList = crushr (:) []

> selectIntBinTree :: BinTree Int -> [Int]
> selectIntBinTree = gToList

> selectIntWTree :: WTree Int Int -> [Int]
> selectIntWTree = error "generic-deriving only abstracts over a single parameter, so it can't implement selectIntWTree"

> selectIntPerfect :: Perfect Int -> [Int]
> selectIntPerfect = error "it was quite unclear as to how to define :.: in crushRight, so selectIntPerfect could not be implemented"

-- selectSalary implementation

-- default definition

> selectSaldef :: (Generic a, SelectSal1 (Rep a)) => a -> [Salary]
> selectSaldef = selectSal1 . from

-- SelectSal class

> class SelectSal a where
>   selectSal :: a -> [Salary]
>   default selectSal :: (Generic a, SelectSal1 (Rep a)) => a -> [Salary]
>   selectSal = selectSaldef

-- SelectSal1 class

> class SelectSal1 f where
>   selectSal1 :: f x -> [Salary]

> instance SelectSal1 U1 where
>   selectSal1 _ = []

> instance (SelectSal1 f) => SelectSal1 (M1 i c f) where
>   selectSal1 (M1 x) = selectSal1 x

> instance (SelectSal1 f, SelectSal1 g) => SelectSal1 (f :+: g) where
>   selectSal1 (L1 x) = selectSal1 x
>   selectSal1 (R1 x) = selectSal1 x

> instance (SelectSal1 f, SelectSal1 g) => SelectSal1 (f :*: g) where
>   selectSal1 (a :*: b) = selectSal1 a ++ selectSal1 b

> instance (SelectSal a) => SelectSal1 (K1 i a) where
>   selectSal1 (K1 a) = selectSal a


-- Primitive instances

> instance SelectSal Int where
>   selectSal x = []

> instance SelectSal Char where
>   selectSal x = []

-- List instance

> instance (SelectSal a) => SelectSal [a]

-- BinTree instance

> instance (SelectSal a) => SelectSal (BinTree a)

-- Company instance

> instance SelectSal Company
> instance SelectSal Dept
> instance SelectSal Unit
> instance SelectSal Employee
> instance SelectSal Person
> instance SelectSal Salary where
>   selectSal sal = [sal] -- The interesting part

-- Examples

-- Binary Tree Salary collection

> salTree :: BinTree Salary
> salTree = Bin (B.Leaf (S 2.8)) (Bin (B.Leaf (S 3.8)) (B.Leaf (S 15.3)))

-- Company Salary collection

> selectSalary :: (SelectSal a) => a -> [Salary]
> selectSalary = selectSal

> gapplySelectCompanies :: [Company] -> [[Salary]]
> gapplySelectCompanies = gmap selectSalary

-- WTree Salary collection

> instance (SelectSal a, SelectSal w) => SelectSal (WTree a w)

> salWTree :: WTree Salary Salary
> salWTree = T.Fork (WithWeight (T.Fork (T.Leaf (S 5.5)) (T.Leaf (S 8.9))) (S 10.0)) (T.Fork (T.Leaf (S 20.5)) (T.Leaf (S 35.1)))