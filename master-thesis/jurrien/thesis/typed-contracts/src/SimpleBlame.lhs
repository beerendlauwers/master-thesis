%if style==newcode

> module SimpleBlame (module Loc, Locs, blame, makeloc, (+>))
> where
> import Loc

%endif 
It remains to implement the data type |Locs| and the associated
functions. Let us start with a simple version that supports blame
assignment in the style of Findler \&\ Felleisen.  A contract either
involves one or two parties.

> data Locs = Pos { pos :: Loc} | NegPos { neg :: Loc, pos :: Loc}

We distinguish between positive and negative locations corresponding
to function and argument locations. Blame is always assigned to the
positive location.

> blame       ::  Locs -> String 
> blame locs  =   "the expression " ++ show (pos locs) ++ " is to blame."

The actual locations in the source are positive.
%> makeloc      ::  Loc -> Locs

> makeloc :: Loc -> Locs
> makeloc loc  =   Pos loc

The magic lies in the implementation of `|+>|', which combines two
elements of type |Locs|.

> (+>) :: Locs -> Locs -> Locs
> Pos     loc       +> Pos loc'  =  NegPos loc loc'
> NegPos  loc' loc  +> _         =  NegPos loc loc'

Two single locations are merged into a double location; if the first
argument is already a double location, then the second argument is
ignored. Furthermore, positive and negative occurrences are
interchanged in the second case. This is vital for functions of
order~|2| or higher. Re-consider the function~|g| of
Sec.~\ref{sec:blame}.

< g  =   app (assert' ((nat >-> nat) >-> true)) 0 (FUN f (FUN x (app f 2 x)))
<
< ... app (app g 1 (FUN x x)) 3 (-7) ...

The precondition of |g|, |nat >-> nat|, and the postcondition of |g|'s
argument |f|, |nat|, are checked using |Pos 0 +> Pos 1 = NegPos 0 1|.
The precondition of |f|, however, is checked using |NegPos 0 1 +> Pos
2 = NegPos 1 0|. Thus, if |f|'s precondition fails, |g| itself is
blamed.
