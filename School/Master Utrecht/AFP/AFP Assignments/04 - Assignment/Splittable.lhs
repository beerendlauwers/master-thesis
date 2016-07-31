%include lhs2TeX.fmt

> {-# LANGUAGE FlexibleInstances, MultiParamTypeClasses #-}
> module Splittable where

> import qualified System.Random as R
> import Control.Monad.Reader
> import Data.Map hiding (split)

> class Splittable a where
>   split :: a -> (a,a)

> instance Splittable R.StdGen where
>   split = R.split

> instance (Splittable a) => Splittable [a] where
>   split = organize ([],[])
>    where
>       organize (l,r) (x:xs) = let (n1,n2) = split x
>                               in organize (n1:l,n2:r) xs
>       organize done _ = done

> instance Splittable Int where
>   split n = (2*n,2*n+1)

> data SplitReader r a = SplitReader { runSplitReader :: r -> a }

> -- withSplitReader definition borrowed from Control.Monad.Reader.
> withSplitReader :: (r' -> r) -> SplitReader r a -> SplitReader r' a
> withSplitReader f m = SplitReader $ runSplitReader m . f

> instance (Splittable r) => Monad (SplitReader r) where
>   return a = withSplitReader split $ SplitReader (\r -> a)
>   m >>= f = SplitReader (\r -> runSplitReader (f $ runSplitReader m (fst $ s r)) (snd $ s r))
>     where s = split

> type Bindings = [Int]

> test :: SplitReader Bindings ()
> test = return ()

> instance (Splittable r) => MonadReader r (SplitReader r) where
>   ask = SplitReader id
>   local = withSplitReader

> data Tree a = Leaf | Node (Tree a) a (Tree a) deriving Show

> labelTree :: Int -> SplitReader Int (Tree Int)
> labelTree 0 = return Leaf
> labelTree n = return () >> liftM3 Node (labelTree (n-1)) ask (labelTree (n-1))

> test2 :: SplitReader Int (Tree Int)
> test2 = return () >> liftM3 Node (return Leaf) ask (return Leaf)

> test3 :: SplitReader Int (Tree Int)
> test3 = liftM3 Node (return Leaf) ask (return Leaf)

> test4 :: SplitReader Int (Tree Int)
> test4 = liftM3 Node (labelTree 1) ask (return Leaf)

> test5 :: SplitReader Int (Tree Int)
> test5 = liftM3 Node (labelTree 1) ask (labelTree 1)

\subsection*{Explanation}

When removing the 'return () $>>$' clause, the result looks similar, only that the value has been split once more when recursing.
This implies that the removed clause's side-effects (=the splitting of the value) are passed, even if the definition of ($>>$) notes as follows:
"Sequentially compose two actions, discarding any value produced by the first (...)". Writing out the split values manually, however, it becomes clear that here it is not the case.

runSplitReader (labelTree 3) 0 results in the following values:

\begin{verbatim}
Node(
    Node(
        Node Leaf 2 Leaf
        2
        Node Leaf 26 Leaf
        )
    2
    Node(
        Node Leaf 50 Leaf
        26
        Node Leaf 218 Leaf
        )
    )
\end{verbatim}

Replacing all the constructors and primitives with their split values, we get

\begin{verbatim}
(0,1)(
    (0,1)(
        (0,1) (0,1) (2,3) (6,7)
        (2,3)
        (6,7) (12,13) (26,27) (54,55)
        )
    (2,3)
    (6,7)(
        (12,13) (24,25) (50,51) (102,103)
        (26,27)
        (54,55) (108,109) (218,219) (438,439)
        )
    )
\end{verbatim}

Semantics:
\begin{itemize}
    \item Note that recursing reduces the produced value by 1. Hence, Nodes always pass the first element of the tuple.
    \item Every other element passes the second element of the tuple. (Remember that liftM3 rewrites the arguments in do-notation, which is how values are passed.)
    \item The passed value is used to generate a new tuple when the 'split' function is applied to it.
    \item ask returns the first element of the tuple.
\end{itemize}
    
Now, let's do the same for the original function definition:

\begin{verbatim}
return () >> Node(
                 return () >> Node(
                                  return () >> Node Leaf 86 Leaf
                                               22
                                               Node Leaf 374 Leaf
                                  )
                              6
                              Node(
                                  return () >> Node Leaf 470 Leaf
                                               118
                                               Node Leaf 1910 Leaf
                                  )
                 )
\end{verbatim}

Replacing everything with their split values, we get:

\begin{verbatim}
(0,1) >> (0,1)(
                 (2,3) >> (4,5)  (
                                  (10,11) >> (20,21) (42,43) \
                                                (86,87) (174,175)
                                             (22,23)
                                             (92,93) (186,187) \
                                                (374,375) (750,751)
                                 )
                          (6,7)
                          (28,29)(
                                  (58,59) >> (116,117) (234,235) \
                                               (470,471) (942,943)
                                             (118,119)
                                             (476,477) (954,955) \
                                                (1910,1911) (3822,3823)
                                 )
              )
\end{verbatim}
                 
New semantics:
\begin{itemize}
    \item Return () does the following:
    \begin{itemize}
        \item Passes the first element of the tuple to the first argument of liftM3
        \item Passes the second element of the tuple to the second argument of liftM3 (the 'ask' function)
    \end{itemize}
    \item Node now passes its second element of the tuple and not its first.
    \item During passing of the 'ask' function's second element of the tuple, an extra side-effect occurs:
    \begin{itemize}
        \item The element is split again, and the first element of this resulting tuple is passed to the third argument of liftM3. (In other words, the initial values is multiplied by 4)
    \end{itemize}
    \item Note: The Node value of the third argument of liftM3 can also be calculated with the formula (second element of tuple of return())$ * 8 + 5$. ex: $59 * 8 + 4 = 476$.
\end{itemize}
