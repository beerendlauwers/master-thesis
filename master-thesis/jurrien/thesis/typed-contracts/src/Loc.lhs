%if style==newcode

> module Loc
> where

%endif

> data Loc  =  Def String | App Int | DefPos String String
>
> instance Show Loc where
>   show (Def s)  =  "`" ++ s ++ "'"
>   show (DefPos s pos) = s ++ " " ++ pos
>   show (App n)  =  "labelled `" ++ show n ++ "'"
