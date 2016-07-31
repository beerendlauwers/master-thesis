> {-# LANGUAGE FlexibleContexts #-}
> {-# LANGUAGE UndecidableInstances #-}

> module GEq where

> import Generics.Deriving
> import Generics.Deriving.Eq

> import BinTreeDatatype
> import CompanyDatatypes
> import GRoseDatatype
> import TreeDatatype
> import NGRoseDatatype

Binary Trees

> instance (GEq a) => GEq (BinTree a)
> equalBTreeInt :: BinTree Int -> BinTree Int -> Bool
> equalBTreeInt = geq

Mutually recursive datatype

> instance GEq Company
> instance GEq Dept
> instance GEq Unit
> instance GEq Employee
> instance GEq Person
> instance GEq Salary
> equalCompany :: Company -> Company -> Bool
> equalCompany = geq

Generalized Rose Trees

> instance (GEq a, GEq (f (GRose f a))) => GEq (GRose f a)
> equalGRoseListInt :: GRose [] Int -> GRose [] Int -> Bool
> equalGRoseListInt = geq

> gRoseExample :: GRose [] Int
> gRoseExample = GRose 1 [GRose 3 []]

Weighted Trees

> instance (GEq a, GEq w) => GEq (WTree a w)
> equalTreeIntInt :: WTree Int Int -> WTree Int Int -> Bool
> equalTreeIntInt = geq

NG Rose Trees

> equalNGRoseListInt :: NGRose [] Int -> NGRose [] Int -> Bool
> equalNGRoseListInt = error "Because generic-deriving abstracts over only a single type-parameter, it is not possible to represent higher-kinded datatypes."

 --Couldn't get this to work.
 instance (GEq a, GEq (f (NGRose (Comp f f) a)), GEq (Comp [] [] (NGRose (Comp (Comp [] []) (Comp [] [])) Int))) => GEq (NGRose f a)
 equalNGRoseListInt :: NGRose [] Int -> NGRose [] Int -> Bool
 equalNGRoseListInt = geq
