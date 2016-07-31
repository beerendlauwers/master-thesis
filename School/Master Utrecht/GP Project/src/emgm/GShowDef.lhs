> {-# LANGUAGE FlexibleContexts #-}

This test exercices GENERIC show for the infamous company datatypes. The
output of the program should be some representation of the infamous
"genCom" company.


NOTE that this program does not produce the SAME output as the SYB gshow.
Instead, it produces the same output as deriving Show would.

> module GShowDef where

> import GL
> import CompanyDatatypes
> import CompanyReps
> import Generics.EMGM hiding (shows)
> import GMapQ
> import Data.List

% - - - - - - - - - - - - - - - = - - - - - - - - - - - - - - - - - - - - - - -
\subsection{Function show}
% - - - - - - - - - - - - - - - = - - - - - - - - - - - - - - - - - - - - - - -

> newtype Gshows a             =  Gshows { applyGshow :: a -> ShowS }

> instance Generic Gshows where
>   runit                        =  Gshows (\ _x -> showString "")
>   rsum a b                     =  Gshows (\ x -> case x of
>                                                 L l -> applyGshow a l
>                                                 R r -> applyGshow b r)
>   rprod a b                    =  Gshows (\ x -> applyGshow a (outl x) . showString " " . applyGshow b (outr x))
>   rtype ep a                   =  Gshows (\ x -> applyGshow a (from ep x))
>   rchar                        =  Gshows (\ x -> shows x)
>   rint                         =  Gshows (\ x -> shows x)
>   rfloat                       =  Gshows (\ x -> shows x)
>   rcon (ConDescr n ar _ _) a   =  Gshows (\ x -> if ar == 0 then
>                                                     showString (n)
>                                                 else
>                                                     showChar '(' . showString (n) . showChar ' '
>                                                         . (applyGshow a (x)) . showChar ')')
>   rinteger                     =  error "Not implemented"
>   rdouble                     =  error "Not implemented"

> gshows                       :: GRep Gshows a => a -> ShowS
> gshows                       =  applyGshow over
