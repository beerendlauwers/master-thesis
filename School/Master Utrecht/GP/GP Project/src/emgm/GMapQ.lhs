> {-# LANGUAGE RankNTypes, FlexibleContexts #-}
> module GMapQ where

> import GL
> import Generics.EMGM
> import CompanyReps


This function is like SYB's gmapQ. It applies a generic function
to every field of a constructor.
The isTopLevel field is used to ensure that this is a shallow
mapping. This function would be simplified if the products would
be more spine-like. See Generic Views paper, the SYB section.

This is for the test of higher-orderness.

This function is buggy because it doesn't work for ad-hoc definitions
outside the Generic type-class.
The view case should not transform to the structure representation if
not at the top level anymore. In that case, it should instead call the
generic function argument.

Another problem lies with the representation of BinTree: it transforms
to the structure representation in a deep way. This makes it harder to
write GMapQ. This should be fixable by changing the representation though.

> data GMapQ g a = GMapQ {
>     genFunc      :: g a, 
>     applyGMapQ  :: forall b . Bool -> (forall a . g a -> a -> b) -> a -> [b]}

> instance Generic g => Generic (GMapQ g) where
>   runit             =  GMapQ (runit) (\ _b f u -> [f runit u])
>   rint              =  GMapQ (rint) (\ _b f u -> [f rint u])
>   rfloat            =  GMapQ (rfloat) (\ _b f u -> [f rfloat u])
>   rchar             =  GMapQ (rchar) (\ _b f u -> [f rchar u]) 
>   rprod a b         =  GMapQ (rprod (genFunc a) (genFunc b)) 
>                              (\ isTop f x -> applyGMapQ a isTop f (outl x)
>                                              ++
>                                              applyGMapQ b isTop f (outr x)) 
>   rsum a b          =  GMapQ (rsum (genFunc a) (genFunc b))
>                              (\ isTop f x -> case x of
>                                                 L l -> applyGMapQ a isTop f l
>                                                 R r -> applyGMapQ b isTop f r)
>   rtype ep a        =  GMapQ (rtype ep (genFunc a))
>                              (\ isTop f x -> if isTop
>                                              then applyGMapQ a False f (from ep x)
>                                              else [f (genFunc a) (from ep x)])
>   rcon cd a         = GMapQ (rcon cd (genFunc a))
>                                (applyGMapQ a)
>   rinteger          = error "Not implented"
>   rdouble           = error "Not implented"

> gmapQ :: GRep (GMapQ g) a => (forall a. g a -> a -> b) -> a -> [b]
> gmapQ = applyGMapQ over True


Note: The argument of GMapQ might have an ad-hoc case. This means that it is not enough
calling it in standard cases above (and in fact calling it from view might be a bug?).
So, we must write a painful case like below for all possible ad-hoc invocation points.
Below, we give a solution that works only for Salary.

Wanted: A better solution that works! 

> instance (GenericList g, GenericCompany g) => GenericCompany (GMapQ g) where
>   salary  = GMapQ farg
>                   (\ isTop f x -> if isTop
>                                     -- isTop distinguishes a Salary argument from a
>                                     -- Salary occurrence as a constructor field
>                                     -- e.g.
>                                     --   gMapQ selectSalary (S 1.0) => [[]]
>                                     --   gMapQ selectSalary (S 1.0,S 2.0) => [[1.0],[2.0]]
>                                   then applyGMapQ salary isTop f x
>                                   else [f farg x])
>     where
>       farg = salary -- invokes ad-hoc case from h.o. function argument

Note: We are assuming that the querying argument does not have an ad-hoc case
for lists!

> instance GenericList g => GenericList (GMapQ g)

