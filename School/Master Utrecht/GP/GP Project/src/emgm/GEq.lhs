> module GEq where
> import GL
> import Generics.EMGM
> import CompanyDatatypes hiding (Unit)
> import CompanyReps
> import GRoseDatatype
> import GRoseReps
> import NGRoseDatatype
> import NGRoseReps
> import BinTreeDatatype
> import BinTreeReps

Implementation of generic equality

> newtype Geq a             =  Geq { geq' :: a -> a -> Bool }

> instance Generic Geq where
>   runit                   =  Geq (\ x y -> case (x, y) of
>                                            (Unit, Unit) -> True)
>   rsum a b                =  Geq (\ x y -> case (x, y) of
>                                            (L xl, L yl) -> geq' a xl yl
>                                            (R xr, R yr) -> geq' b xr yr
>                                            _                -> False)
>   rprod a b               =  Geq (\ x y -> geq' a (outl x) (outl y) && geq' b (outr x) (outr y))
>   rtype ep a              =  Geq (\ x y -> geq' a (from ep x) (from ep y))
>   rchar                   =  Geq (\ x y -> x == y)
>   rint                    =  Geq (\ x y -> x == y)
>   rfloat                  =  Geq (\ x y -> x == y)
>   rinteger                =  error "Not implemented"
>   rdouble                 =  error "Not implemented"
> instance GenericCompany Geq where
> instance GenericList Geq where

> equalCompany :: Company -> Company -> Bool
> equalCompany = geq' over

> equalGRoseListInt :: GRose [] Int -> GRose [] Int -> Bool
> equalGRoseListInt = geq' over

Representations for higher-kinded datatypes do not get
a dispatcher (GRep) instance, that is why we cannot write

  equalNGRoseListInt = geq' over

Instead, we write:

> equalNGRoseListInt :: NGRose [] Int -> NGRose [] Int -> Bool
> equalNGRoseListInt = geq' (ngrose list over)

> equalBTreeInt :: BinTree Int -> BinTree Int -> Bool
> equalBTreeInt = geq' over


