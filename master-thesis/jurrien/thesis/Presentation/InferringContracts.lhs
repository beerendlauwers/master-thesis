
%----------------------------------------------------------------------------
%
%  Title       :  Inferring contracts
%  Author      :  Jurriën Stutterheim
%  Created     :  24 January 2013
%
%  Purpose     :  To be presented at COSC
% 
%----------------------------------------------------------------------------
\documentclass[]{beamer}

\usepackage{amsthm}
\usepackage{color}
\usepackage{bussproofs}
\usepackage{float}
\usepackage{tikz}
\usepackage{setspace}
\usepackage{stmaryrd}
%include InferringContracts.fmt
%include Contract.fmt

%include polycode.fmt
%format <@> = "<\!\!\!@\!\!\!>"
%format <@@> = "<\!\!\!@\!\!@\!\!\!>"
%format true = "true"
%format true_1
%format true_2
%format true_3
%format true_4
%format true_5
%format true_i
%format true_j
%format true_k
%format true_l
%format list = "list"
%format list_1
%format list_2
%format list_3
%format list_4
%format list_5
%format list_i
%format list_j
%format UNIFY = "{\mathcal{U}}"
%format |-> = "{\!\!~\mapsto\!\!~}"
%format c = "c"
%format c_0
%format c_1
%format c_2


\newcommand{\askelle}{{\sc Ask-Elle}}
\newcommand{\W}{$\mathcal{W}$}
\newcommand{\CW}{$\mathcal{CW}$}
\newcommand{\sem}[1]{\llbracket{#1}\rrbracket{}}

\usetheme{uucs}

\title{Inferring Contracts for Functional Programs}
\subtitle{Thesis defense}
\author[Jurri\"en~Stutterheim]{Jurri\"en~Stutterheim}

\date{24 January 2013}

\subject{Inferring Contracts for Functional Programs}

\begin{document}

\frontmatter

\frame{\titlepage}

\mainmatter

%if style == newcode

> {-# LANGUAGE NoMonomorphismRestriction #-}
>
> module InferringContracts where
>
> import Blame
> import Contract
> import Data.List
> import Loc
> import Test.QuickCheck
>
> prop_Encode :: [Int] -> Bool
> propSort :: [Int] -> Bool

%endif

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\frame{\frametitle{\askelle: A programming tutor for Haskell}

  Gerdes et al. are developing a programming tutor for Haskell. Using the
  tutor, a student can:
\begin{itemize}
\item develop her program incrementally %, in a topdown fashion
\item receive feedback about whether or not she is on the right track
\item can ask for a hint when she is stuck
\item see how a complete program is constructed step by step
\end{itemize}

The tutor targets first-year computer science students.

}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\frame{
\begin{center}
\includegraphics[scale=0.29]{fptutor.png}
\end{center}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\frame{\frametitle{Main ideas behind \askelle}

\begin{itemize}
\item A teacher specifies \emph{model solution} solutions for an exercise
\item \askelle\ compares possibly partial student solutions against model
  solutions using \emph{strategies}
\item As long as a student follows a model solution, \askelle\ can give hints
\end{itemize}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\frame{\frametitle{And what if a student makes an error?}

\begin{verbatim}
You have made a, possibly incorrect,
step that does not follow the strategy.
\end{verbatim}

}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\frame{\frametitle{Our goal}

\begin{itemize}
\item Specify the \emph{properties} a solution should satisfy
\item \emph{Test} the properties using QuickCheck
\item Express the properties a solution should satisfy as a \emph{contract}
\item Use \emph{contract inference} to infer contracts for user-defined functions
\item Use \emph{contract checking} to report property violations as precisely as possible
\end{itemize}

}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\frame{\frametitle{This talk}
\begin{itemize}
\item Gives a quick introduction to QuickCheck and contracts
\item Presents contract inference
\item Touches on the current limitations of contract inference
\end{itemize}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\frame{\frametitle{QuickCheck}
  \begin{itemize}
    \item A library for \emph{property-based testing} of programs
    \item Programmer specifies \emph{properties} a function has to adhere to
    \item QuickCheck generates \emph{random values} and applies the property
      to them
    \item If the property fails, QuickCheck tries to shrink the random value to
      produce a minimal counter-example
  \end{itemize}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\frame{\frametitle{QuickCheck: an example}

> propEven :: Int -> Bool
> propEven n = even n

\begin{verbatim}
*Main> quickCheck propEven
*** Failed! Falsifiable (after ...):
1
\end{verbatim}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\frame{\frametitle{QuickCheck and \askelle}
\begin{itemize}
  \item Specify QuickCheck properties for exercises
  \item When strategies fail, fall back to QuickCheck
  \item Problem: \textit{where} is the error?
\end{itemize}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\frame{\frametitle{Contracts}
  \begin{itemize}
    \item Impose restrictions and give guarantees for programs
    \item If a contract is violated, an exception is thrown containing the
      location of the violation
      \begin{itemize}
        \item Easier debugging
        \item Easier runtime enforcement of invariants
      \end{itemize}
    \item We use the \texttt{typed-contracts} library by Hinze et al.
  \end{itemize}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\frame{\frametitle{Specifying contracts}

Contracts are represented by a GADT:

>{-"\onslide<1->{"-} data Contract a where
>                      Prop       ::  (a -> Bool) -> Contract a{-"}"-}
>{-"\onslide<2->{"-}   Function   ::  Contract a -> Contract b
>                                 ->  Contract (a -> b){-"}"-}
>{-"\onslide<3->{"-}   And        ::  Contract a -> Contract a -> Contract a{-"}"-}
>{-"\onslide<4->{"-}   List       ::  Contract a -> Contract [a]
>                      Pair       ::  Contract a -> Contract b -> Contract (a, b){-"}"-}
>{-"\onslide<5->{"-}   Functor    ::  Functor f => Contract a -> Contract (f a)
>                      Bifunctor  ::  Bifunctor f => Contract a -> Contract b
>                                 ->  Contract (f a b){-"}"-}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\frame{\frametitle{Asserting contracts}

> assert :: Contract a -> a -> a

|assert| is a \emph{partial identity}: if the contract is satisfied, it acts as
identity, if not, it throws an exception.

}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\frame{\frametitle{Notation}

> {p}                 = Prop p
> c1 >-> c2           = Function c1 c2
> (&)                 = And
> [c]                 = List c
> c1 <@>   c2         = c1 & Functor c2
> c1 <@@>  (c2, c3)   = c1 & Bifunctor c2 c3

}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\frame{\frametitle{Asserting contracts: example}

> f :: Int -> Int
> f = assert (nat >-> nat) (+1)

\begin{verbatim}
*Main> f 1
2
*Main> f (-1)
*** Exception: `f' is to blame
\end{verbatim}

}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\frame{\frametitle{An example problem in \askelle}
\begin{verbatim}
Write a function that sorts a list

sort :: Ord a => [a] -> [a]

For example:

Data.List> sort [1,2,1,3,2,4]
[1,1,2,2,3,4]
\end{verbatim}

}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\frame{\frametitle{Sorting: a model solution}

%if style /= newcode
%format Contract.foldr = foldr
%format InferringContracts.insert = insert
%format InferringContracts.insert' = insert'
%endif

> sort = Contract.foldr InferringContracts.insert []
>
> insert x []                   =  [x]
> insert x (y:ys)  | x <= y     =  x:y:ys
>                  | otherwise  =  y:InferringContracts.insert x ys

}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\frame{\frametitle{An error in sorting}

> sort' = Contract.foldr InferringContracts.insert' []
>
> insert' x []                   =  [x]
> insert' x (y:ys)  | x <= y     =  y:x:ys
>                   | otherwise  =  y:InferringContracts.insert' x ys

}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\frame{\frametitle{Sorting: a property}

> propSort xs         =  isNonDesc (sort' xs)

> isNonDesc (x:y:xs)  =  x <= y && isNonDesc (y:xs)
> isNonDesc _         =  True

~ \\

\scriptsize{\textcolor{gray}{For the astute observer: no, this property does
not fully cover what it means for a list to be sorted, but please bear with
me}}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\frame{\frametitle{Running QuickCheck}

\begin{verbatim}
*Main> quickCheck propSort
*** Failed! Falsifiable (after ...):
[0,1]
\end{verbatim}

But where is the error?

}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\frame{\frametitle{Contracts...}

Contracts to the rescue.

}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\frame{\frametitle{A contracted sort}

%if style /= newcode
%format :->                     =  ->
%format FUN x (e)               =  \ x -> e
%format assert (l)              =  "\Varid{assert}"
%endif

> sortc = assert "sort"
>   ([true] >-> {isNonDesc})
>   (FUN xs (sort' xs))

}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\frame{\frametitle{Blaming}

\begin{verbatim}
*Main> sortc [0,1]
*** Exception: contract failed: 
the expression `sort' is to blame.
\end{verbatim}

But where is the error?

}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\frame{\frametitle{A more precise location}

To get a more precise location for the error: replace all functions in the 
definition of |sort| by their contracted counterparts.

}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\frame{\frametitle{A contracted |insert|}

%if style /= newcode
%format insert2' = insert'
%endif

> insertc = assert "insert" 
>   (true >-> {isNonDesc} >-> {isNonDesc})
>   (FUN x (FUN xs (InferringContracts.insert' x xs)))

}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\frame{\frametitle{Blaming II}

\begin{verbatim}
*Main> sortc [0,1]
*** Exception: contract failed:
the expression `insert' is to blame.
\end{verbatim}

}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\frame{\frametitle{But wait}

\begin{itemize}
\item In the context of the tutor, we only know the contract for |sort|
\item A student can implement |sort| in many different ways
\item We want to \emph{infer} the contracts for the components of a function
\end{itemize}

}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\frame{\frametitle{Problem:}
Given a well-typed program, determine the contracts for the components of the
function.
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\frame{\frametitle{Inferring contracts}
\begin{itemize}
  \item We have developed a contract inference algorithm
  \item Based on Algorithm \W\ by Damas and Milner
  \item We call it Algorithm \CW
  \item We have implemented Algorithm \CW\ for a small, |let|-polymorphic
    lambda-calculus based language with several built-in data types
    \begin{itemize}
      \item We expect the results to carry over to Haskell
      \item We use Haskell in these slides
    \end{itemize}
\end{itemize}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\frame{\frametitle{Predefined contracts}

  \begin{itemize}
    \item |true|: never fails assertion
    \item |false|: always fails assertion
    \item |list|: succeeds for lists
    \item |maybe|: succeeds for |Maybe| values
    \item |pair|: succeeds for pairs
    \item |either|: succeeds for |Either| values
    \item |int|: succeeds for integers
    \item |bool|: succeeds for booleans
    \item |char|: succeeds for characters
  \end{itemize}

}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\frame{\frametitle{A contract for |id|}

For

\begin{itemize}
  \item |id :: a -> a|
\end{itemize}

we infer

\begin{itemize}
  \item |true >-> true|
\end{itemize}

Instead of type variables, we infer |true| contracts
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\frame{\frametitle{Inferred contract for |const|}
For

\begin{itemize}
  \item |const :: a -> b -> a|
\end{itemize}

we infer

\begin{itemize}
  \item |true_1 >-> true_2 >-> true_1|
\end{itemize}

}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\frame{\frametitle{Inferred contract for |map|}
For

\begin{itemize}
  \item |map :: (a -> b) -> [a] -> [b]|
\end{itemize}

we infer

|(true_1 >-> true_2) >-> (list_1 <@> true_1) >-> (list_2 <@> true_2)|

}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\frame{\frametitle{Types and contracts}
  \begin{itemize}
    \item The same type variable gets the same |true| contract
    \item For concrete types we introduce fresh specific contracts
    \item For (bi)functorial types we infer the more general (bi)functor
      contracts
    \item We infer the most specific contracts that never fails assertion
  \end{itemize}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\frame{\frametitle{Contract unification}
  Contracts can be unified, creating substitutions:

> UNIFY(true, char) = [true |-> char]

> UNIFY(true_1 >-> true_2,  int >-> bool) =  [  true_2 |-> bool
>                                            ,  true_1 |-> int]

}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\frame{\frametitle{Contract unification}
  We can also unify two non-|true| contracts:

> UNIFY(int, nat) = [int |-> nat]

  This is essential, because we want assertion to be able to fail.

  Why can we do this?
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\frame{\frametitle{Contract semantics as sets}
  The semantics of a contract $c$, written $\sem{c}$, is defined as the set of
  Haskell values for which it never fails assertion.

  For all contracts |c|, $\sem{false} \subseteq \sem{c} \subseteq \sem{true}$
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\frame{\frametitle{Unification}

Unification of two different contracts is defined as

> UNIFY (c_1,  c_2)  = [c_1 |-> c_2] (iff {-"c_1 \notin ftc(c_2) \wedge \sem{c_2} \subseteq \sem{c_1}"-})
> UNIFY (c_1,  c_2)  = [c_2 |-> c_1] (iff {-"c_2 \notin ftc(c_1) \wedge \sem{c_1} \subseteq \sem{c_2}"-})

$ftc(c)$ is the set of free |true| contracts in |c| and $c_1 \notin ftc(c_2)$
is the occurs check.

Since $int \notin ftc(nat) \wedge \sem{nat} \subseteq \sem{int}$

> UNIFY(int, nat) = [int |-> nat]
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\frame{\frametitle{Dependent contracts: sorting revisited}

Sorting not just returns a non-descending list, it is also a permutation of the
input:

> isSorted xs ys = isNonDesc ys && ys `elem` permutations xs

The contract for the output \emph{depends} on the input of the function; it is
a \emph{dependent contract}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\frame{\frametitle{Defining dependent contracts}
  To model dependent contracts, we modify the |Contract| GADT

> data Contract a where
>   ..
>   Function  ::  Contract a -> (a -> Contract b)
>             ->  Contract (a -> b)
>   ..

and introduce new notation:

> c_1 >->   c_2 = Function c_1 (const c_2)
> c_2 >>->  c_2 = Function c_1 c_2
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\frame{\frametitle{Dependent contract for sorting}
> sortContract = (xs :: list <@> true) >>-> {isSorted xs}

In general, if at all possible, inferring and correctly unifying dependent
contracts is hard, so we do not attempt it
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\frame{\frametitle{Working around dependent contracts}
  \begin{itemize}
    \item We can eliminate the need for dependent contracts by inling a
      QuickCheck counter-example in the contract
    \item QuickCheck shrinks its counter-example
      \begin{itemize}
        \item We know smaller values will not violate the contract
        \item We know that the counter-example will violate the contract
      \end{itemize}
  \end{itemize}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\frame{\frametitle{Eliminating dependent contracts: |sort|}
Using counter-example |[0,1]|:

> sortCntr'    = (list <@> true) >-> {isSorted [0,1]}
> insertCntr'  = true >-> true >-> {isSorted [0, 1]}
> sortc'       = assert "sort" sortCntr' sort'
> insertc'     = ..

\begin{verbatim}
*Main> sortc' [0,1]
*** Exception: contract failed:
the expression `insert' is to blame.
\end{verbatim}

N.B.: we must only assert |insertCntr'| once, because the contract will now
always fail for smaller lists in recursive calls
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\frame{\frametitle{Future work: eliminating dependent contracts}
  \begin{itemize}
    \item Inlining works for inductive types, because they have a base-case
    \item By default, QuickCheck doesn't actually guarantee a minimal
      counter-example, but this is easily implemented
    \item What about non-inductive (flat) types, like |Int|, |Integer| and
      |Char|?
  \end{itemize}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\frame{\frametitle{Future work: constant expression contracts}
  For

> f x = 1

we could infer a constant expression contract

> true >-> {== 1}

Can we always infer constant expression contracts?
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\frame{\frametitle{Future work: constant expression contracts}
  \begin{itemize}
    \item Under-explored aspect of contract inference
    \item In some cases, unifying constant expression contracts leads to wrong
      contracts for sub-expressions
    \item Can we modify Algorithm \CW\ to infer constant expression contracts
      and unify them correctly?
  \end{itemize}
}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\frame{\frametitle{Future work: overview}
  \begin{itemize}
    \item Make the dependent contract workaround work for non-inductive types
      \begin{itemize}
        \item Or find a way to correctly infer dependent contracts
      \end{itemize}
    \item Correctly infer and unify constant expression contracts
    \item Implement contract inference in \askelle
  \end{itemize}
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\frame{\frametitle{Conclusions}

\begin{itemize}
  \item We can infer and unify non-dependent contracts easily
  \item For inductive types we can eliminate the need for dependent contracts
    by inlining a QuickCheck counter-example
  \item For non-inductive types, it is unclear whether we can eliminate
    dependent contracts
  \item We can infer constant expression contracts easily, but unifying them
    correctly may be more difficult
\end{itemize}
}


\end{document}
