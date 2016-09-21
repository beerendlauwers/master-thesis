%include lhs2TeX.fmt

> module PosParser where

This module uses the package EitherT in hackage.

> import Control.Applicative
> import Control.Monad.Trans.Either
> import Control.Monad.Trans.Class
> import Control.Monad.Trans.State
> import Control.Monad.Trans.List
> import Control.Monad.Identity

> data PosParser a = PP ((Int,String) -> Either Int [(a, (Int,String))])

> instance Functor PosParser where
>   f `fmap` PP p = PP (\inp -> case p inp of
>                        (Right xs) -> Right (map (\(x,y) -> (f x, y)) xs)
>                        (Left o)   -> Left o)
 
> comb (Left p)  (Left q)  = Left (p `max` q)
> comb (Left _)  (Right q) = Right q 
> comb (Right p) (Left _)  = Right p
> comb (Right p) (Right q) = Right (p ++ q)

> instance Alternative PosParser where
>   empty = PP (\(pos,_) -> Left pos)
>   PP p <|> PP q = PP (\inp -> (p inp) `comb` (q inp))

> instance Applicative PosParser where
>   PP p <*> ~ab@(PP q)
>     = PP (\pi@(pos,inp) -> case p pi of
>       (Left pos) -> Left pos
>       (Right es) -> foldr1 comb $ [test (r `fmap` ab) qi | (r, qi) <- es]
>         )
>   pure v = PP (\pi -> Right [(v,pi)])

> pSym v = PP (\(pos,inp) -> case inp of
>   []     -> Left pos
>   (x:xs) -> if x == v
>               then Right [(x, (pos+1,xs))]
>               else Left pos
>                 )

> test (PP p) i = p i

> p1 = (\a b -> a:[b]) <$> pSym 'a' <*> pSym 'b'

> instance Monad PosParser where
>   return = pure
>   (PP a) >>= b
>     = PP (\inp -> case a inp of
>       (Left pos) -> Left pos
>       (Right es) -> foldr1 comb $ [test (b r) qi | (r, qi) <- es]
>         )

Examples, working as expected:
< test p1 (0,"ab")
Right [("ab",(2,""))]
< test p1 (0,"abc")
Right [("ab",(2,"c"))]
< test p1 (0, "ac")
Left 1


To get something isomorphic to the PosParser above we can use the monad transformers StateT, ListT and EitherT as follows:

> type PosParserIso a = StateT (Int, String) (ListT (EitherT Int Identity)) a