%if style==newcode

> module Loc
> where

%endif

> data Loc  =  Def String | App Int
>
> instance Show Loc where
>   show (Def s)  =  "`" ++ s ++ "'"
>   show (App n)  =  "labelled `" ++ show n ++ "'"