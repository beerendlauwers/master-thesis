
> module GEq where

> import BinTreeDatatype
> import CompanyDatatypes
> import GRoseDatatype
> import NGRoseDatatype

> errorNotSupported  = error "Multiplate.GEq: generic equality not supported in Multiplate"

> equalCompany :: Company -> Company -> Bool
> equalCompany = errorNotSupported

> equalGRoseListInt :: GRose [] Int -> GRose [] Int -> Bool
> equalGRoseListInt = errorNotSupported

> equalNGRoseListInt :: NGRose [] Int -> NGRose [] Int -> Bool
> equalNGRoseListInt = errorNotSupported

> equalBTreeInt :: BinTree Int -> BinTree Int -> Bool
> equalBTreeInt = errorNotSupported
