This test exercices GENERIC show for the infamous company datatypes. The
output of the program should be some representation of the infamous
"genCom" company.


NOTE that this program does not produce the SAME output as the SYB gshow.
Instead, it produces the same output as deriving Show would.

> module Paradise (increase) where

> import CompanyDatatypes
> import CompanyReps3
> import Generics.EMGM
> import GL3
> import GL

% - - - - - - - - - - - - - - - = - - - - - - - - - - - - - - - - - - - - - - -
\subsection{Function show}
% - - - - - - - - - - - - - - - = - - - - - - - - - - - - - - - - - - - - - - -

> newtype Gincrease a b c       =  Gincrease { applyGincrease :: Float -> a -> a }

> instance Generic3 Gincrease where
>   runit3                        =  Gincrease (\ f x -> x)
>   rsum3 a b                     =  Gincrease (\ f x -> case x of
>                                                 L l -> L (applyGincrease a f l)
>                                                 R r -> R (applyGincrease b f r))
>   rprod3 a b                    =  Gincrease (\ f x -> (applyGincrease a f (outl x)) :*: (applyGincrease b f (outr x)))
>   rtype3 ep _ _ a               =  Gincrease (\ f x -> to ep (applyGincrease a f (from ep x)))
>   rint3                         =  Gincrease (\ f x -> x)
>   rchar3                        =  Gincrease (\ f x -> x)
>   rfloat3                       =  Gincrease (\ f x -> x)
>   rinteger3                     =  error "Not implemented"
>   rdouble3                      =  error "Not implemented"
> instance GenericCompany Gincrease where
>   salary                      =  Gincrease (\ f x -> incS f x)


> -- "interesting" code for increase
> incS :: Float -> Salary -> Salary
> incS k (S s) = S (s * (1+k))

> increase :: Float -> Company -> Company
> increase = applyGincrease over3


