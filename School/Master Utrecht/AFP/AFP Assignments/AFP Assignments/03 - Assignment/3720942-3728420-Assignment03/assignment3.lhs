\documentclass{article}
%include lhs2TeX.fmt
\usepackage[utf8]{inputenc}
\usepackage{verbatim}

\title{Assignment 3 --- Advanced Functional Programming, 2011/2012}
\author{
	Beerend Lauwers\\
	\and 
	Augusto Passalaqua\\	
	\hbox{\{B.Lauwers, A.PassalaquaMartins\}@@students.uu.nl}
	\and
	\newline Utrecht University, The Netherlands
}

\begin{document}

\begin{comment}

> import qualified Data.Map as M
> import Trie

\end{comment}

\maketitle

\section*{Exercise 1}

This is troublesome in Haskell due to the fact that the 'let' expression is polymorphic and unsafe, so any IO operation on x can accept a different type.

ML's typing system splits types in two camps: strong and weak. Strong type variables can only be used in strong types. Only strong types can be stored in references, preventing polymorphic references.

\section*{Exercise 2}

> type Square a = Square' Nil a
> data Square' t a = Zero (t (t a)) | Succ (Square' (Cons t) a)
> data Nil a = Nil
> data Cons t a = Cons a (t a)

Raw: sq2 = Succ $ Succ $ Zero ( Cons ( Cons 5 $ Cons 5 Nil ) (Cons (Cons 5 $ Cons 5 Nil) Nil))
Prettified:

> cons x = Cons x Nil
> sq2 = Succ $ Succ $ Zero $ Cons (Cons 1 $ cons 0) $ Cons (Cons 0 $ cons 1) Nil

Raw : sq3 = Succ $ Succ $ Succ $ Zero $ Cons (Cons 1 (Cons 2 (Cons 3 Nil))) $ (Cons (Cons 4 (Cons 5 (Cons 6 Nil))) $ Cons (Cons 7 (Cons 8 (Cons 9 Nil))) Nil )
Prettified:

> sq3 = Succ $ Succ $ Succ $ Zero $ Cons (Cons 1 $ Cons 2 $ cons 3) $
>       (Cons (Cons 4 $ Cons 5 $ cons 6) $ Cons (Cons 7 $ Cons 8 $ cons 6) Nil )

\section*{Exercise 3}

> forceBoolList :: [Bool] -> r -> r
> forceBoolList (True:xs)  r = forceBoolList xs r
> forceBoolList (False:xs) r = forceBoolList xs r
> forceBoolList []         r = r

A function of type [Bool] -> [Bool] would not allow the construction of expressions that use the list of bools to depend on the forced evaluation of the list.
Due to lazyness, the function forceBoolList will not be necessarily called before (or might not be called at all) before the evaluation of an expression that depends on the list of bools. In practice, this means no strictness at all.

 A function defined as

> force :: a -> a
> force a = seq a a

will present the same problem mentioned above.
There is no functional dependency between the "force a" expression and any other that might depend on its value a.
In a lazy environment this call will be deferred until the value of "force a" is necessary.

\section*{Exercise 4}

Exercise 4 is defined in its own module (imported by the lhs version of this document) as the following:

\input{Trie}

\section*{Exercise 5}

Exercise 5 has also been defined in its own file to allow the normal execution of the code of the other tasks.

\input{exercise5}

\end{document}
