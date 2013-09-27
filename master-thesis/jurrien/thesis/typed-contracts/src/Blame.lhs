%if style==newcode

> module Blame (module Loc, Locs, blame, blame', makeloc, (+>))
> where
> import Loc
> import Data.List (intersperse)

> cause       ::  [Loc] -> String
> cause []    =   ""
> cause locs  =   " (the violation was caused by the expression(s) " 
>             ++  concat (intersperse ", " (map show locs)) ++ ")"

%endif

It is apparent that `|+>|' throws away information: location~|2|,
which possibly causes the contract violation, is ignored. We can
provide a more informative error message if we keep track of all the
locations involved. To this end we turn |Locs| into a pair of stacks,
see Fig.~\ref{fig:blame}. Blame is assigned to the top-most element of
the stack of positive locations; the remaining entries if any detail
the cause of the contract violation. The new version of `|+>|' simply
concatenates the stacks after swapping the two stacks of its first
argument.
%
%As before, actual source locations are positive.
\begin{figure}[t]

> data Locs = NegPos { neg :: [Loc], pos :: [Loc] }
>
> blame'        ::  Locs -> String -> String
> blame' locs fi =   
>  "\nA part of your code, or a supplied argument to a function, does not fullfil a required property. This occurred at " ++ 
>  show (head (pos locs))
>               ++  (  case tail (pos locs) of
>                       []     ->  ", does not fullfil the following property: "
>                       locs'  ->  ", in the following higher-order parameter(s):\n\n" ++
>                                  concat (intersperse ", \n" (map (\s -> "--> " ++ show s) locs')) ++ ",\n" )
>               ++ fi

>
> blame       ::  Locs -> String
> blame locs  =   "the expression " ++ show (head (pos locs)) ++ " is to blame" 
>             ++  (  case tail (pos locs) of
>                    []     ->  "."
>                    locs'  ->  " (the violation was caused by the expression(s) " ++
>                               concat (intersperse ", " (map show locs')) ++ ")." )
>
> makeloc      ::  Loc -> Locs
> makeloc loc  =   NegPos [] [loc]
>
> (+>) :: Locs -> Locs -> Locs
> NegPos ns ps +> NegPos ns' ps'  =   NegPos (ps ++ ns') (ns ++ ps')

\caption{\label{fig:blame}Extended blame assignment.}
\end{figure}
%
Just in case you wonder: the total length of the stacks is equal to
the order of the contracted function plus one. Thus, the stacks seldom
contain more than~|2| or~|3| elements.
