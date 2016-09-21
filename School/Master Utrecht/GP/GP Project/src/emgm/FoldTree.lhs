> {-# LANGUAGE FlexibleContexts #-}
> module FoldTree where

> import GL hiding (Fork, Tree)
> import Generics.EMGM
> import TreeDatatype
> import TreeReps(GenericWTree)
> import CompanyDatatypes
> import CompanyReps(GenericCompany(salary))
> import qualified PerfectDatatype as P
> import PerfectReps
> import GMapQ(gmapQ)

Accumulate all ints in a datastructure
just a simple type-indexed function. Not protected by a type class.

> newtype SelectInt a = SelectIntG { appSelectInt :: a -> [Int] }

> instance Generic SelectInt where
>   runit        =  SelectIntG (\ x -> [])
>   rsum a b     =  SelectIntG (\ x -> case x of
>                                      L l -> appSelectInt a l
>                                      R r -> appSelectInt b r)
>   rprod a b    =  SelectIntG (\ x -> appSelectInt a (outl x) ++
>                                     appSelectInt b (outr x))
>   rtype ep a   =  SelectIntG (\ x -> appSelectInt a (from ep x))
>   rint         =  SelectIntG (\ x -> [x]) -- ** only special case
>   rchar        =  SelectIntG (\ x -> [])
>   rfloat       =  SelectIntG (\ x -> [])
>   rinteger     =  error "Not implemented"
>   rdouble      =  error "Not implemented"
> instance GenericList    SelectInt
> instance GenericCompany SelectInt
> instance GenericWTree   SelectInt

> selectIntWTree :: GRep SelectInt a => a -> [Int]
> selectIntWTree = appSelectInt over

> selectIntPerfect :: GRep SelectInt a => a -> [Int]
> selectIntPerfect = appSelectInt over

> newtype SelectSalaryG a = SelectSalaryG { selectSalaryG :: a -> [Salary] }

> instance Generic SelectSalaryG where
>   runit        =  SelectSalaryG (\ x -> [])
>   rsum a b     =  SelectSalaryG (\ x -> case x of
>                                     L l -> selectSalaryG a l
>                                     R r -> selectSalaryG b r)
>   rprod a b    =  SelectSalaryG (\ x -> selectSalaryG a (outl x) ++
>                                        selectSalaryG b (outr x))
>   rtype ep a   =  SelectSalaryG (\ x -> selectSalaryG a (from ep x))
>   rint         =  SelectSalaryG (\ x -> [])
>   rchar        =  SelectSalaryG (\ x -> [])
>   rfloat       =  SelectSalaryG (\ x -> [])
>   rinteger     =  error "Not implemented"
>   rdouble      =  error "Not implemented"
> instance GenericList SelectSalaryG
> instance GenericCompany SelectSalaryG where
>   salary      =  SelectSalaryG (\ x -> [x]) -- ** only special case

> selectSalary :: GRep SelectSalaryG a => a -> [Salary]
> selectSalary =  selectSalaryG over

> mysal :: WTree Salary Int
> mysal = Fork (WithWeight (Leaf (S 1.0)) 1)
>              (WithWeight (Fork (Leaf (S 2.0)) (Leaf (S 2.3))) 2)

> gapplySelectCompanies :: [Company] -> [[Salary]]
> gapplySelectCompanies = gmapQ selectSalaryG


-- ----------------------------------------------------------------

> newtype SelectFloat a = SelectFloatG { appSelectFloat :: a -> [Float] }

> instance Generic SelectFloat where
>   runit        =  SelectFloatG (\ x -> [])
>   rsum a b     =  SelectFloatG (\ x -> case x of
>                                        L l -> appSelectFloat a l
>                                        R r -> appSelectFloat b r)
>   rprod a b    =  SelectFloatG (\ x -> appSelectFloat a (outl x) ++
>                                        appSelectFloat b (outr x))
>   rtype ep a   =  SelectFloatG (\ x -> appSelectFloat a (from ep x))
>   rint         =  SelectFloatG (\ x -> [])
>   rchar        =  SelectFloatG (\ x -> [])
>   rfloat       =  SelectFloatG (\ x -> [x])
>   rinteger     = error "Not implemented"
>   rdouble      = error "Not implemented"
> instance GenericList    SelectFloat
> instance GenericCompany SelectFloat

> selectFloat :: GRep SelectFloat a => a -> [Float]
> selectFloat = appSelectFloat over


