\documentclass[fleqn,runningheads]{llncs}

\usepackage[latin1]{inputenc}
\usepackage{graphicx}
\usepackage{calc}
\usepackage{ulem}\normalem
\usepackage{deduction}
\usepackage{fontenc}

% First-class contracts
\pagestyle{headings}
\mainmatter
\title{Typed Contracts for Functional Programming}
\titlerunning{Typed Contracts for Functional Programming}
\author{Ralf Hinze\inst{1} \and Johan Jeuring\inst{2} \and Andres L\"oh\inst{1}}
\authorrunning{R.~Hinze, J.~Jeuring and A.~L\"oh}
\institute{Institut f\"ur Informatik III, Universit\"at Bonn\\
R\"omerstrasse 164, 53117 Bonn, Germany\\
\email{\{ralf,loeh\}\symbol{64}informatik.uni-bonn.de}
\and
Institute of Information and Computing Sciences, Utrecht University\\
P.O.Box 80.089, 3508 TB Utrecht, The Netherlands\\
\email{johanj\symbol{64}cs.uu.nl}}
\author[R. Hinze, J. Jeuring and A. L\"oh]
{RALF HINZE and ANDRES L\"oH
\\Institut f\"ur Informatik III, Universit\"at Bonn
\\R\"omerstrasse 164, 53117 Bonn, Germany
\\\email{\{ralf,andres\}\symbol{64}informatik.uni-bonn.de}
\and JOHAN JEURING
\\Institute of Information and Computing Sciences, Utrecht University
\\P.O.Box 80.089, 3508 TB Utrecht, The Netherlands
\\\email{johanj\symbol{64}cs.uu.nl}}

\newtheorem{remark}{Remark}
\newcounter{exerciseno}

\newenvironment{exercise}%
 {\refstepcounter{exerciseno}%
  \par\smallskip\noindent\textbf{Exercise~\arabic{exerciseno}.}}%
 {\hfill\hbox{\proofbox}}

%-------------------------------=  --------------------------------------------

%include lhs2TeX.sty
%include lhs2TeX.fmt
%include polycode.fmt
%include Contract.fmt

\mathindent8pt
\hfuzz2.75pt

%-------------------------------=  --------------------------------------------
% Locations

\newcounter{location}

\makeatletter

\newcommand\newloc[1]{%
  \@@ifundefined{loc#1}%
    {\global\@@namedef{loc#1}{}%
     \AtEndDocument{\refstepcounter{location}\label{loc#1}}}%
    {}%
  \ref{loc#1}}

\makeatother

%-------------------------------=  --------------------------------------------
%if style == newcode

> {-# LANGUAGE RankNTypes #-}
> {-# LANGUAGE TypeOperators #-}
> {-# LANGUAGE GADTs  #-}
> {-# LANGUAGE NoMonomorphismRestriction  #-}
>
> module Contract where
>
> import Data.Bifunctor
> import qualified Data.List as DL
> --import Control.Monad
> --import List hiding (foldr, sort,insert) -- (sort,sortBy,insert,insertBy)
> import Prelude hiding (id, foldr)
> import Blame -- our blame assignment
> --import SimpleBlame -- Findler and Felleisen blame assignment
>
>
> infixr 9 `o`
> o :: (t1 -> t) -> (t2 -> t1) -> t2 -> t
> f `o` g  =  \a -> f (g a)
>
> less3 :: Ord a => a -> a -> a -> Bool
> less3 a x b  =  a <= x && x < b
>
> sq :: Num a => a -> a
> sq x = x * x
>
> bag :: Ord a => [a] -> [a]
> bag  x = DL.sort x
>
> sort :: Ord a => [a] -> [a]
> sort x = DL.sort x

%endif
%-------------------------------=  --------------------------------------------

\begin{document}

\maketitle

\begin{abstract}
A robust software component fulfills a contract: it expects data
satisfying a certain property and promises to return data satisfying
another property. The object-oriented community uses the
design-by-contract approach extensively. Proposals for language
extensions that add contracts to higher-order functional programming
have appeared recently. In this paper we propose an embedded
domain-specific language for typed, higher-order and first-class
contracts, which is both more expressive than previous proposals, and
allows for a more informative blame assignment. We take some first steps towards
an algebra of contracts, and we show how to define a generic contract
combinator for arbitrary algebraic data types. The contract language
is implemented as a library in Haskell using the concept of
generalised algebraic data types.
\end{abstract}

%-------------------------------=  --------------------------------------------
\section{Introduction}
\label{sec:introduction}
%-------------------------------=  --------------------------------------------
%{ % \begin{suppress}
% We are suppressing locations in the first three sections.
%if style /= newcode
%format :->                     =  ->
%format FUN x (e)               =  \ x -> e
%format assert (l)              =  "\Varid{assert}"
%endif

Are you familiar with the following situation?
%
\begin{quote}
You are staring at the computer screen. The run of the program you are
developing unexpectedly terminated with a @Prelude.head: empty list@
message. A quick @grep@ yields a total of~|102| calls to |head| in
your program. % (actually, the count includes 34~calls to |lookahead|). 
It is all very well that the run wasn't aborted with a
@core dumped@ notification, but the error message provided isn't very
helpful either: which of the many calls to |head| is to blame?
\end{quote}
%
If this sounds familiar to you, then you might be interested in
\technical{contracts}. A contract between software components is much
like a contract in business, with obligations and benefits for both
parties. In our scenario, the components are simply functions: the
function |head| and the function that calls |head|. Here is a possible
contract between the two parties (from |head|'s perspective): if you
pass me a non-empty list, then I shall return its first element. The
contract implies obligations and benefits: the caller is obliged to
supply a non-empty list and has the benefit of receiving the first
element without further ado.  The restriction on the input is a
benefit for |head|: it need not deal with the case for the empty
list. If it receives a non-empty list, however, |head| is obliged to
return its first element.

As in business, contracts may be violated. In this case the contract
specifies who is to blame: the one who falls short of its promises.
Thus, if |head| is called with an empty list, then the call site is to
blame. In practical terms, this means that the program execution
is aborted with an error message that points to the location of the
caller, just what we needed above.

% Historical outline: pre- and postconditions, first-order, imperative languages.

The underlying design methodology \cite{Mey92App}, developing programs on the basis of
contracts, was popularised by Bertrand Meyer, the designer of
Eiffel \cite{meyer}. In fact, contracts are an integral part of Eiffel.
Findler and Felleisen \cite{FiF02Con} later adapted the approach to
higher-order functional languages. Their work has been the major
inspiration of the present paper, which extends and revises their
approach.

In particular, we make the following contributions:
%
\begin{itemize}
\item
we develop a small embedded domain-specific language for contracts with a handful
of basic combinators and a number of derived ones,
\item
we show how to define a generic contract combinator for algebraic data types,
\item
we present a novel approach to blame assignment that additionally
tracks the cause of contract violations,
%for more informative error messages,
\item 
as a proof of concept we provide a complete implementation of the
approach; the implementation makes use of \technical{generalised
algebraic data types},
\item
we take the first steps towards an algebra of contracts.
\end{itemize}

The rest of the paper is structured as
follows. Sec.~\ref{sec:contracts} introduces the basic contract
language, Sec.~\ref{sec:blame} then shows how blame is assigned in the
case of a contract violation.  We tackle the implementation in
Sec.~\ref{sec:impl-contracts} and~\ref{sec:impl-blame} (without
and with blame assignment).  Sec.~\ref{sec:examples} provides further
examples and defines several derived contract
combinators.  The algebra of contracts is studied in
Sec.~\ref{sec:properties}.  Finally, Sec.~\ref{sec:related-work}
reviews related work and Sec.~\ref{sec:conclusion} concludes.

We use Haskell \cite{SPJ03Has} notation throughout the paper. In fact,
the source of the paper constitutes a legal Haskell program that can
be executed using the Glasgow Haskell Compiler \cite{GHC-6.4.1}. For
the proofs it is, however, easier to pretend that we are working in a
strict setting. The subtleties of lazy evaluation are then addressed
in Sec.~\ref{sec:properties}. Finally, we deviate from Haskell syntax
in that we typeset `|x| has type |tT|' as |x :: tT| and `|a| is consed
to the list |as|' as |a : as| (as in Standard~ML).

%-------------------------------=  --------------------------------------------
\section{Contracts}
\label{sec:contracts}
%-------------------------------=  --------------------------------------------
% Naming: |Assertion| instead of |Contract|

This section introduces the main building blocks of the contract
language.

A contract specifies a desired property of an expression. A simple
contract is, for instance, |PROP i (i >= 0)| which restricts the value
of an integer expression to the natural numbers. In general, if |x| is a
variable of type |sT| and |e| is a Boolean expression, then |PROP x e|
is a contract of type |Contract sT|, a so-called \technical{contract
comprehension}. The variable |x| is bound by the construct and scopes
over |e|.

Contracts are first-class citizens: they can be passed to functions or
returned as results, and most importantly they can be given a name.

> nat :: Contract Int
> nat = Prop (\ i -> i >= 0)

As a second example, here is a contract over the list data type that
admits only non-empty lists.

> nonempty :: Contract [aT]
> nonempty = Prop (\ x -> not (null x))

The two most extreme contracts are

> false, true  ::  Contract aT
> false  = Prop (\ _ -> False)
> true   = Prop (\ _ -> True)

The contract |false| is very demanding, in fact, too demanding as it
cannot be satisfied by any value.  By contrast, |true| is very
liberal: it admits every value.

Using contract comprehensions we can define contracts for values of 
arbitrary types, including function types. The contract |PROP f (f 0 == 0)|, for 
instance, specifies that~|0| is a fixed point of a function-valued 
expression of type |Int -> Int|.
However, sometimes contract comprehensions are not expressive
enough. Since a comprehension is constrained by a Haskell Boolean
expression, we \emph{cannot} state, for example, that a function maps natural
numbers to natural numbers: |PROP f (forall n :: Int . n >=0 => f n >=
0)|. We consciously restrict the formula to the right of the bar to
Haskell expressions so that checking of contracts remains feasible. As
a compensation, we introduce a new contract combinator that allows us
to explicitly specify domain and codomain of a function: |nat >-> nat|
is the desired contract that restricts functions to those that take
naturals to naturals.  
%if full
As another example, the contract |false >-> c| for an arbitrary
contract |c| expresses `don't call me, I am dead code'.
%
\begin{exercise}
Can you think of a circumscription for |c >-> true|?
% Don't blame me:  (this does not hold for Findler/Felleisen, 
% see |g| in Sec.~\ref{sec:related-work}).
\end{exercise}
%endif

Unfortunately, the new combinator is still too weak. Often we want to
relate the argument to the result, expressing, for instance, that the
result is greater than the argument. To this end we generalise |e1 >->
e2| to the \technical{dependent function contract} |FUNCTION x e1
e2|. The idea is that |x|, which scopes over |e2|, represents the
argument to the function. The above constraint is now straightforward
to express: |FUNCTION n nat (PROP r (n < r))|.  In general, if |x| is
a variable of type |s1T|, and |e1| and |e2| are contracts of type
|Contract s1T| and |Contract s2T| respectively, then |FUNCTION x e1
e2| is a contract of type |Contract (s1T :-> s2T)|. Note that like
|PROP x e|, the dependent function contract |FUNCTION x e1 e2| is a
binding construct.
%if full
\begin{exercise}
Which function does the following contract specify?

< FUNCTION x true (PROP r (r == x)) :: (Eq aT) => Contract (aT -> aT)

% the identity
\end{exercise}
%endif

Many properties over data types such as the pair or the list data type
can be expressed using contract comprehensions.  However, it is also
convenient to be able to construct contracts in a compositional
manner. To this end we provide a pair combinator that takes two
contracts and yields a contract on pairs: |nat >*> nat|, for instance,
constrains pairs to pairs of natural numbers.

We also offer a \technical{dependent product contract} |PAIR x e1 e2|
with scoping and typing rules similar to the dependent function
contract.  %\ralf{asymmetric} 
As an example, the contract |PAIR n nat ((PROP i (i <=
n) >-> true))| of type |Contract (Int, Int -> aT)| constrains the
domain of the function in the second component using the value of the
first component.  While the dependent product contract is a logically
compelling counterpart of the dependent function contract, we expect
the former to be less useful in practice. The reason is simply that
properties of pairs that do \emph{not} contain functions can be easily
formulated using contract comprehensions. As a simple example,
consider |PROP (x1, x2) (x1 <= x2)|.

In general, we need a contract combinator for every parametric data
type. For the main bulk of the paper, we confine ourselves to the list
data type: the \technical{list contract combinator} takes a contract
on elements to a contract on lists. For instance, |list nat|
constrains integer lists to lists of natural numbers. Like |c1 >*>
c2|, the list combinator captures only \technical{independent
properties}; it cannot relate elements of a list. For this purpose, we
have to use contract comprehensions---which, on the other hand, cannot
express the contract |list (nat >-> nat)|.

Finally, contracts may be combined using conjunction: |c1 & c2| holds
if both |c1| and |c2| hold. However, we neither offer disjunction nor
negation for reasons to be explained later
(Sec.~\ref{sec:impl-contracts}). Fig.~\ref{fig:typings} summarises the
contract language.
%
\begin{figure}[t]
%if full
\[
\Ovr{|Gamma, x :: sT /-- e :: Bool|}
    {|Gamma /-- PROP x e :: Contract sT|}
\]
\[
\Ovr{|Gamma /-- e1 :: Contract s1T| \quad |Gamma /-- e2 :: Contract s2T|}
    {|Gamma /-- e1 >-> e2 :: Contract (s1T -> s2T)|}
\]
\[
\Ovr{|Gamma /-- e1 :: Contract s1T| \quad |Gamma, x :: s1T /-- e2 :: Contract s2T|}
    {|Gamma /-- FUNCTION x e1 e2 :: Contract (s1T :-> s2T)|}
\]
\[
\Ovr{|Gamma /-- e1 :: Contract s1T| \quad |Gamma /-- e2 :: Contract s2T|}
    {|Gamma /-- e1 >*> e2 :: Contract (s1T, s2T)|}
\]
\[
\Ovr{|Gamma /-- e1 :: Contract s1T| \quad |Gamma, x :: s1T /-- e2 :: Contract s2T|}
    {|Gamma /-- PAIR x e1 e2 :: Contract (s1T, s2T)|}
\]
\[
\Ovr{|Gamma /-- e :: Contract sT|}
    {|Gamma /-- list e :: Contract [sT]|}
\]
\[
\Ovr{|Gamma /-- e1 :: Contract sT| \quad |Gamma /-- e2 :: Contract sT|}
    {|Gamma /-- e1 & e2 :: Contract sT|}
\]
%else
\[
\renewcommand{\arraystretch}{2.5}
\begin{array}{cc}
\Ovr{|Gamma, x :: sT /-- e :: Bool|}
    {|Gamma /-- PROP x e :: Contract sT|}
&
\Ovr{|Gamma /-- e1 :: Contract s1T| \quad |Gamma, x :: s1T /-- e2 :: Contract s2T|}
    {|Gamma /-- FUNCTION x e1 e2 :: Contract (s1T :-> s2T)|}
\\
\Ovr{|Gamma /-- e :: Contract sT|}
    {|Gamma /-- list e :: Contract [sT]|}
&
\Ovr{|Gamma /-- e1 :: Contract s1T| \quad |Gamma, x :: s1T /-- e2 :: Contract s2T|}
    {|Gamma /-- PAIR x e1 e2 :: Contract (s1T, s2T)|}
\\
\multicolumn{2}{c}{
\Ovr{|Gamma /-- e1 :: Contract sT| \quad |Gamma /-- e2 :: Contract sT|}
    {|Gamma /-- e1 & e2 :: Contract sT|}}
\end{array}
\]
%endif
\caption{\label{fig:typings}Typing rules for contract combinators.}
\end{figure}

%-------------------------------=  --------------------------------------------
\section{Blame assignment}
\label{sec:blame}
%-------------------------------=  --------------------------------------------
% use/def, function: callee/caller, general: expression/context

A contract is attached to an expression using |assert|:

> head'  ::  [aT] :-> aT
> head'  =   assert "head" (nonempty >-> true) (fun (\ x -> head x))

The attached contract specifies that the predefined function |head|
requires its argument to be non-empty and that it ensures nothing. In
more conventional terms, |nonempty| is the \technical{precondition}
and |true| is the \technical{postcondition}. 
%if full
Here is a second example:

> length'  ::  [aT] :-> Int
> length'  =   assert "length" (true >-> nat) (fun (\ x -> length x))

The function that calculates the length of a list requires nothing and
ensures that its result is a natural number. 
%endif
Here and in what follows we adopt the convention that the `contracted'
version of the identifier |x| is written |x'|.
% In Haskell, both |head| and |length| are predefined.

Attaching a contract to an expression causes the contract to be
dynamically monitored at run-time. If the contract is violated, the
evaluation is aborted with an informative error message. If the
contract is fulfilled, then |assert c| acts as the
identity. Consequently, |assert| has type

< assert :: Contract aT -> (aT -> aT)


Contracts range from very specific to very liberal. The contract of |head|,
|nonempty >-> true|, is very liberal: many functions require a
non-empty argument. On the other hand, a contract may uniquely
determine a value. Consider in this respect the function |isqrt|,
which is supposed to calculate the integer square root.

> isqrt    ::  Int -> Int
> isqrt n  =   loop 0 3 1
>   where loop i k s  | s <= n     =  loop (i + 1) (k + 2) (s + k)
>                     | otherwise  =  i

It is not immediately obvious that this definition actually meets its
specification, so we add a contract.

> isqrt' :: Int :-> Int
> isqrt' = assert "isqrt"
>   (Function nat (\ n -> (Prop (\ r -> r >= 0 && less3 (sq r) n (sq (r + 1))))))
>   (fun (\ n -> isqrt n))

Here the postcondition precisely captures the intended semantics of
|isqrt|.

Now that we got acquainted with the contract language, it is time to
see contracts in action. When a \technical{contract comprehension} is
violated, the error message points to the expression to which the
contract is attached. Let us assume for the purposes of this paper
that the expression is bound to a name which we can then use for error
reporting (in the implementation we refer to the source location instead). 
%if full || style==newcode
As an example, given the following definitions,

> five, mfive :: Int
> five   =  assert "five"   nat 5
> mfive  =  assert "mfive"  nat (-5)

> five' = assert "five'" nat
> five'' x = five' x

we get the following results in an interactive session.

< << five
< 5
< << mfive
< {-"\textrm{*** contract failed: the expression `\textit{mfive}'' is to blame.}"-}

%else
As an example, given the definitions |five   =  assert "five"   nat 5|
and |mfive  =  assert "mfive"  nat (-5)|,
we get the following results in an interactive session.

< << five
< 5
< << mfive
< {-"\textrm{*** contract failed: the expression `\textit{mfive}'' is to blame.}"-}

%endif
The number |-5| is not a natural; consequently the |nat| contract
sounds alarm.

If a \technical{dependent function contract} is violated, then either
the function is applied to the wrong argument, or the function itself
is wrong.  In the first case, the precondition sends the alarm, in the
second case the postcondition. Consider the functions |inc| and
|dec|, which increase, respectively decrease, a number.

> inc, dec :: Int :-> Int
> inc  = assert "inc" (nat >-> nat) (fun (\ n -> n + 1))
> dec  = assert "dec" (nat >-> nat) (fun (\ n -> n - 1))

Here are some example applications of these functions in an
interactive session:
\begingroup
\invisiblecomments
%if style == newcode

> incloc1, incloc2 :: Int
> incloc1 = 11
> incloc2 = 12
>
> decloc1, decloc2 :: Int
> decloc1 = 21
> decloc2 = 22

%else
%format incloc1 = "\newloc{incloc1}"
%format incloc2 = "\newloc{incloc2}"
%format decloc1 = "\newloc{decloc1}"
%format decloc2 = "\newloc{decloc2}"
%endif

< << app inc incloc1 5
< 6
< << app inc incloc2 (-5)
< {- *** contract failed: the expression labelled `|incloc2|' is to blame. -}
< << app dec decloc1 5
< 4
< << app dec decloc2 0
< {- *** contract failed: the expression |dec| is to blame. -}

\endgroup
In the session we put labels in front of the function arguments,
$\mbox{}_{\loc{i}}e$, so that we can refer to them in error messages
(again, in the implementation we refer to the source
location). The first contract violation is caused by passing a
negative value to |inc|: its precondition is violated, hence the
argument is to blame. In the last call, |dec| falls short of its
promise to deliver a natural number, hence |dec| itself is to blame.

It is important to note that contract checking and detection of
violations are tied to program runs: |dec| obviously does not satisfy
its contract |nat >-> nat|, but this is not detected until |dec| is
applied to |0|. In other words, contracts do not give any static
guarantees (`|dec| takes naturals to naturals'), they only make
dynamic assertions about particular program runs (`|dec| always
received and always delivered a natural number during this run').

This characteristic becomes even more prominent when we consider
higher-order functions.
%if style == newcode

> codomloc0, codomloc1, codomloc2 :: Int
> codomloc0 = 30
> codomloc1 = 31
> codomloc2 = 32

%else
%format codomloc0 = "\newloc{codomloc0}"
%format codomloc1 = "\newloc{codomloc1}"
%format codomloc2 = "\newloc{codomloc2}"
%endif

> codom :: (Int :-> Int) :-> [Int]
> codom = assert "f"  ((nat >-> nat) >-> list nat)
>                     (fun (\ f -> [app f codomloc0 n | n <- [1 .. 9]]))

The function |codom| takes a function argument of type |Int :-> Int|.
We cannot expect that a contract violation is detected the very moment
|codom| is applied to a function---as we cannot expect that a contract
violation is detected the very moment we attach a contract to |FUN n
(n - 1)| in |dec|. Rather, violations are discovered when the function
argument |f| is later applied in the body of |codom|. In the extreme
case where the parameter does not appear in the body, we never get
alarmed, unless, of course, the result is negative.  Consider the
following interactive session: 
\begingroup 
\invisiblecomments

< << app codom codomloc1 (fun (\ x -> x - 1))
< [0,1,2,3,4,5,6,7,8]
< << app codom codomloc2 (fun (\ x -> x - 2))
< {- *** contract failed: the expression labelled `|codomloc2|' is to blame. -}
\endgroup
An error is only detected in the second call, though the first call is
also wrong. The error message points to the correct location: the
argument is to blame.

%if style == newcode

> gloc0, gloc1, gloc2, gloc3, gloc4, gloc5, gloc6, gloc7, gloc8, gloc9, gloc10 :: Int
> gloc0 = 40
> gloc1 = 41
> gloc2 = 42
> gloc3 = 43
> gloc4 = 44
> gloc5 = 45
> gloc6 = 46
> gloc7 = 47
> gloc8 = 48
> gloc9 = 49
> gloc10 = 50

%else
%format gloc0 = "\newloc{gloc0}"
%format gloc1 = "\newloc{gloc1}"
%format gloc2 = "\newloc{gloc2}"
%format gloc3 = "\newloc{gloc3}"
%format gloc4 = "\newloc{gloc4}"
%format gloc5 = "\newloc{gloc5}"
%format gloc6 = "\newloc{gloc6}"
%format gloc7 = "\newloc{gloc7}"
%format gloc8 = "\newloc{gloc8}"
%format gloc9 = "\newloc{gloc9}"
%format gloc10 = "\newloc{gloc10}"
%endif
The following example has been adapted from the paper by Blume and McAllester
\cite{BlM04Mod}.

> g :: (Int :-> Int) :-> (Int :-> Int)
> g = assert "g" ((nat >-> nat) >-> true) (fun (\ f -> fun(\ x -> app f gloc0 x)))

The higher-order function |g| expects a function satisfying |nat >->
nat|. Again, we cannot expect that the function contract is checked
immediately; rather, it is tested when the function argument is
applied.
\begingroup
\invisiblecomments

< << app (app g gloc3 (fun (\ x -> x - 1))) gloc4 1
< 0
< << app (app g gloc5 (fun (\ x -> x - 1))) gloc6 0
< {- *** contract failed: the expression labelled `|gloc5|' is to blame. -}
< << app (app g gloc1 (fun (\ x -> x))) gloc2 (-7)
< {- \parbox{.95\linewidth}{*** contract failed: the expression `|g|' is to blame (the violation
<    was caused by the expression(s) labelled `|gloc0|').} -}

% double violation
% < << app (app g gloc7 (fun (\ x -> x - 1))) gloc8 (-1)
% < {- \parbox{.95\linewidth}{*** contract failed: the expression `|g|' is to blame (the violation 
% <    was caused by the expression(s) labelled `|gloc0|').} -}
\endgroup

The last call shows that |g| is blamed for a contract violation even
though |g|'s postcondition is |true|. This is because |g| must also
take care that its argument is called correctly and it obviously does
not take sufficient measurements. The error message additionally
points to the location within |g| that \emph{caused} the contract
violation. This information is not available in the Findler and
Felleisen approach \cite{FiF02Con} (see also
Sec.~\ref{sec:impl-blame}). Since |g| returns a function, the cause is
not necessarily located in |g|'s body. As a simple example, consider
the $\eta$-reduced variant of |g|.

> g' :: (Int :-> Int) :-> (Int :-> Int)
> g' = assert "g'" ((nat >-> nat) >-> true) (fun (\ f -> f))

Now the second argument is identified as the cause of the contract
violation:
\begingroup
\invisiblecomments

< << app (app g' gloc9 (fun (\ x -> x))) gloc10 (-7)
< {- \parbox{.95\linewidth}{*** contract failed: the expression `|g'|' is to blame (the violation
<    was caused by the expression(s) labelled `|gloc10|').} -}

\endgroup

%if full || style == newcode
To pursue this a bit further here is a variant of |g| with pre- and
postcondition interchanged.

> h :: (Int :-> Int) :-> (Int :-> Int)
> h = assert "h" (true >-> (nat >-> nat)) (fun (\ f -> f))

Consider the following session:
\begingroup
\invisiblecomments
%if style == newcode

> hloc1, hloc2, hloc3, hloc4, hloc5, hloc6, hloc7, hloc8 :: Int
> hloc1 = 51
> hloc2 = 52
> hloc3 = 53
> hloc4 = 54
> hloc5 = 55
> hloc6 = 56
> hloc7 = 57
> hloc8 = 58

%else
%format hloc1 = "\newloc{hloc1}"
%format hloc2 = "\newloc{hloc2}"
%format hloc3 = "\newloc{hloc3}"
%format hloc4 = "\newloc{hloc4}"
%format hloc5 = "\newloc{hloc5}"
%format hloc6 = "\newloc{hloc6}"
%format hloc7 = "\newloc{hloc7}"
%format hloc8 = "\newloc{hloc8}"
%endif

< << app (app h hloc1 (fun (\ x -> x))) hloc2 (-7)
< {- *** contract failed: the expression labelled `|hloc2|' is to blame. -}
< << app (app h hloc3 (fun (\ x -> x - 1))) hloc4 1
< 0
< << app (app h hloc5 (fun (\ x -> x - 1))) hloc6 0
< {- *** contract failed: the expression `|h|' is to blame. -}

% double violation
% < << app (app h hloc7 (fun (\ x -> x - 1))) hloc8 (-1)
% < {-"\textrm{*** contract failed: the expression labelled `|hloc8|' is to blame.}"-}
\endgroup
When |h| is applied to |\ x -> x - 1|, it returns a function that does
not satisfy the postcondition. When this is later detected, blame is
put on |h|.
%endif

%} % \end{suppress}
%-------------------------------=  --------------------------------------------
\section{Implementing contracts}
\label{sec:impl-contracts}
%-------------------------------=  --------------------------------------------

In Sec.~\ref{sec:contracts} we have seen several ways to construct
contracts. The syntax we have used for contracts may seem to suggest
that we need an extension of Haskell to implement contracts.
However, using Generalised Algebraic Data Types
(GADTs)~\cite{gadt,Hin03Fun,PWW05Wob}, we can model contracts directly in
Haskell. Fig.~\ref{syntax} shows how the concrete syntax translates
to Haskell.
%
\begin{figure}[t]
\begin{center}
\begin{tabular}{l@@{\qquad}l}\hline
  concrete syntax        & Haskell syntax \\\hline
  |PROP x (p x)|         & |Prop (\ x -> p x)| \\
  |c1 >-> c2|            & |Function c1 (const c2)| \\
  |FUNCTION x c1 (c2 x)| & |Function c1 (\ x -> c2 x)| \\
  |c1 >*> c2|            & |Pair c1 (const c2)| \\
  |PAIR x c1 (c2 x)|     & |Pair c1 (\ x -> c2 x)| \\
  |list c|               & |List c| \\
  |c1 & c2|              & |And c1 c2| \\
\hline
\end{tabular}
\end{center}
\caption{\label{syntax}Concrete and abstract syntax of contracts.}
\end{figure}
%
Note that the binding constructs of the concrete syntax are realized
using functional components (higher-order abstract syntax).  If we
translate the typing rules listed in Fig.~\ref{fig:typings} to the
abstract representation of contracts, we obtain the following GADT.
%if False
Fig.~\ref{syntax} list five constructors of the data type
|Contract|: The basic constructor of |Contract| is the property
constructor |Prop|, which turns a Boolean function into a
contract. The dependent function constructor takes a contract for
|aT|, and a function which turns an |aT| into a contract for |bT|, and
returns a contract for a function of type |aT -> bT|. Likewise, the
dependent pair constructor takes a contract for |aT|, and a function
which given an |aT| returns a contract for |bT|, and returns a
contract for the pair |(aT,bT)|. The list constructor turns a contract
for |aT| into a contract for |[aT]|. Finally, the constructor |And|
takes two contracts for |aT|, and returns the conjunction of those
contracts. Thus, we define
%endif
%format STAR                    =  "\mathord{*}"

< data Contract :: STAR -> STAR where
<   Prop      ::  (aT -> Bool) -> Contract aT
<   Function  ::  Contract aT -> (aT -> Contract bT) -> Contract (aT -> bT)
<   Pair      ::  Contract aT -> (aT -> Contract bT) -> Contract (aT, bT)
<   List      ::  Contract aT -> Contract [aT]
<   And       ::  Contract aT -> Contract aT -> Contract aT

% We can generalise the |List| constructor to an arbitrary data type in
% a language with type-indexed functions and type-indexed data types
% \cite{tidata,associateddata}. More \ldots

Given this data type we can define |assert| by a simple case analysis.

< assert                          ::  Contract aT -> (aT -> aT)
< assert  (Prop p)      a         =   if p a then a else error "contract failed"
< assert  (Function c1 c2) f      =   (\ x' -> (assert (c2 x') `o` f) x') `o` assert c1
< assert  (Pair c1 c2)  (a1, a2)  =   (\ a1' -> (a1', assert (c2 a1') a2)) (assert c1 a1)
< assert  (List c)      as        =   map (assert c) as
< assert  (And c1 c2)   a         =   (assert c2 `o` assert c1) a

% Alternative definitions, which pass the original argument to the second
% contract. Violates idempotence.
% assert  (Function c1 c2)  f         =   \x -> (assert (c2 x) `o` f `o` assert c1) x
% assert  (Pair c1 c2)      (a1, a2)  =   (assert c1 a1, assert (c2 a1) a2)
The definition makes explicit that only contract comprehensions are
checked immediately. In the remaining cases, the contract is taken
apart and its constituents are attached to the corresponding
constituents of the value to be checked. Note that in the |Function|
case the \emph{checked argument} |x'| is propagated to the codomain
contract |c2| (ditto in the |Pair| case). There is a choice here:
alternatively, we could pass the original, unchecked argument. If we
chose this variant, however, we would sacrifice the idempotence of
`|&|'.  Furthermore, in a lazy setting the unchecked argument could
provoke a runtime error in the postcondition, consider, for instance,
|FUNCTION x nonempty (PROP y (y <= head x))|.

A moment's reflection reveals that the checking of \emph{independent
properties} boils down to an application of the \technical{mapping
function} for the type in question. In particular, we have

< assert  (Function c1 (const c2))  f         =  assert c2 `o` f `o` assert c1
< assert  (Pair c1 (const c2))      (a1, a2)  =  (assert c1 a1, assert c2 a2)

This immediately suggests how to generalise contracts and contract
checking to arbitrary container types: we map the constituent
contracts over the container.
%format c_1 = c "_1"
%format c_n = c "_n"

< assert  (T c_1 ldots c_n)  =  mapT (assert c_1) ldots (assert c_n)

Note that mapping functions can be defined completely generically for
arbitrary Haskell~98 data types \cite{Hin02Pol}. In the next section
we will show that we can do without the GADT; then the contract
combinator for an algebraic data type is just its mapping function.

It remains to explain the equation for |And|: the conjunction |And c1
c2| is tested by first checking |c1| and then checking |c2|, that is,
conjunction is implemented by functional composition. This seems odd
at first sight: we expect conjunction to be commutative; composition
is, however, not commutative in general. We shall return to this issue
in Sec.~\ref{sec:properties}. Also, note that we offer conjunction but
neither disjunction nor negation. To implement disjunction we would
need some kind of exception handling: if the first contract fails,
then the second is tried. Exception handling is, however, not
available in Haskell (at least not in the pure, non-|IO| part). For
similar reasons, we shy away from negation.
% not: unclear how to generate a sensible error message.

Although |assert| implements the main ideas behind contracts, the fact
that it returns an uninformative error message makes this
implementation rather useless for practical purposes. In the following
section we will show how to return the precise location of a contract
violation.

Nonetheless, we can use the simple definition of |assert| to
\emph{optimise} contracted functions. Re-consider the definition of
|inc| repeated below.

< inc   =  assert (nat >-> nat) (\ n -> n + 1)

Intuitively, |inc| satisfies its contract, so we can optimize the
definition by leaving out the postcondition. Formally, we have to
prove that

< assert (nat >-> nat) (\ n -> n + 1)  =  assert (nat >-> true) (\ n -> n + 1)

Note that we must keep the precondition to ensure that |inc| is
called correctly: the equation |assert (nat >-> nat) (\ n -> n + 1) =
\ n -> n + 1|  does not hold. Now, unfolding the definition of
|assert| the equation above rewrites to

< assert nat `o` (\ n -> n + 1) `o` assert nat  =  (\ n -> n + 1) `o` assert nat

which can be proved using a simple case analysis. 

In general, we say that \technical{|f| satisfies the contract |c|} iff

< assert c f  =  assert (positive c) f

where |positive c| is obtained from |c| by replacing all sub-contracts at
positive positions by |true|:
\begingroup
\invisiblecomments

> {- |positive (`o`) :: Contract aT -> Contract aT| -}
> positive (PropInfo _ _)    =  true
> positive (Prop _)          =  true
> positive (Function c1 c2)  =  Function (negative c1) (\ x -> positive (c2 x))
>
> {- |negative (`o`) :: Contract aT -> Contract aT| -}
> negative (PropInfo p i)    =  PropInfo p i
> negative (Prop p)          =  Prop p
> negative (Function c1 c2)  =  Function (positive c1) (\ x -> negative (c2 x))

\endgroup
In the remaining cases, |positive (`o`)| and |negative (`o`)| are just
propagated to the components. As an example, |\ n -> n + 1| satisfies
|nat >-> nat|, whereas |\ n -> n - 1| does not. The higher-order
function~|g| of Sec.~\ref{sec:blame} also does not satisfy its
contract |(nat >-> nat) >-> nat|. As an aside, note that |positive
(`o`)| and |negative (`o`)| are executable Haskell functions. Here,
the GADT proves its worth: contracts are data that can be as easily
manipulated as, say, lists.

%if full
\begin{exercise}
Define a variant of |assert| that checks only conditions at negative
positions (this is the default monitoring mode in Eiffel \cite{meyer}).
% that is, fuse |assert (positive c)|.
\end{exercise}
%endif
%if style==newcode

> positive, negative :: Contract aT -> Contract aT

%endif
%-------------------------------=  --------------------------------------------
\section{Implementing blame assignment}
\label{sec:impl-blame}
%-------------------------------=  --------------------------------------------
%if style/=newcode
%format +> = "\rightslice "
%format makeloc loc = "\loc{" loc "}"
%format function = "\Varid{fun}"
%endif

To correctly assign blame in the case of contract violations, we pass
program locations to both |assert| and to the contracted functions
themselves. For the purposes of this paper, we keep the type |Loc| of
source locations abstract. We have seen in Sec.~\ref{sec:blame} that
blame assignment involves at least one location. In the case of
function contracts two locations are involved: if the precondition
fails, then the argument is to blame; if the postcondition fails, then
the function itself is to blame. For the former case, we need to get
hold of the location of the argument. To this end, we extend the
function by an extra parameter, which is the location of the
`ordinary' parameter.

> infixr :->
> newtype aT :-> bT  =  Fun { apply :: Locs -> aT -> bT }

In fact, we take a slightly more general approach: we allow to pass a
data structure of type |Locs| containing one or more locations. We
shall provide two implementations of |Locs|, one that realizes blame
assignment in the style of Findler \&\ Felleisen and one that
additionally provides information about the causers of a contract
violation. We postpone the details until the end of this section and
remark that |Locs| records at least the locations of the parties
involved in a contract.

The type |aT :-> bT| is the type of \technical{contracted functions}:
abstractions of this type, |Fun (\ locs -> \ x -> e)|, additionally
take locations; applications, |apply e1 locs e2|, additionally pass
locations. We abbreviate |Fun (\ locs -> \ x -> e)| by |FUN x e| if
|locs| does not appear free in |e| (which is the norm for user-defined
functions).  Furthermore, |apply e1 locs e2| is written |apps e1 locs
e2|. In the actual program source, the arguments of |assert| and of
the contracted functions are always single locations, written |makeloc
loc|, which explains the notation used in Sec.~\ref{sec:blame}.

Since contracted functions have a distinguished type, we must adapt
the type of the |Function| constructor.

< Function :: Contract aT -> (aT -> Contract bT) -> Contract (aT :-> bT)

%\pagebreak[4]

Given these prerequisites, we can finally implement contract checking
with proper blame assignment.

> assert'                                       ::  Contract aT -> (Locs -> aT -> aT)
> assert'  (PropInfo p i)    locs   a   | p a        = a
>                                       | otherwise  = error (blame' locs i)
> assert'  (Prop p)          locs   a   | p a        = a
>                                       | otherwise  = error ("contract failed: " ++ blame locs)
> assert'  (Function c1 c2)  locsf  f
>   =  Fun (\ locx -> (\ x' -> (assert' (c2 x') locsf `o` apply f locx) x') `o` assert' c1 (locsf +> locx))
> assert'  (Pair c1 c2)      locs   (a1, a2)      =   (\ a1' -> (a1' , assert' (c2 a1') locs a2)) (assert' c1 locs a1)
> assert'  (List c)          locs   as            =   map (assert' c locs) as
> assert'  (Functor f)       locs   as            =   fmap (assert' f locs) as
> assert'  (Bifunctor f g)   locs   as            =   bimap (assert' f locs) (assert' g locs) as
> assert'  (And c1 c2)       locs   a             =   (assert' c2 locs `o` assert' c1 locs) a

%if False

> assert'  (Forall fT)   locs   f                =   Poly (\ c -> assert' (fT c) locs (instantiate f c))
> assert'  (Id c)        locs   f                =   (Identity `o` assert' c locs `o` unIdentity) f

%endif
% The following variant possibly causes a run-time exception in
% the postcondition (app (assert "test" (Function nonempty (\ x -> Prop (\ y -> sum y <= head x))) (fun (\ x -> [1]))) 0 []):
%   =  Fun (\ locx x -> (assert' (c2 x) locsf `o` apply f locx `o` assert' c1 (locsf +> locx)) x)
The |Function| case merits careful study. Note that |locsf| are the
locations involved in~|f|'s contract and that |locx| is \emph{the}
location of its argument (|locx| has type |Locs| but it is always a
single location of the form |makeloc loc|).  First, the precondition
|c1| is checked possibly blaming |locsf| or |locx|.  The single
location |locx| is then passed to |f|, whose evaluation may involve
further checking. Finally, the postcondition |c2 x'| is checked
possibly blaming a location in |locsf|.  Note that |c2| receives the
checked argument, not the unchecked one.

It may seem surprising at first that |assert c1| adds |locsf| to its
file of suspects: can |f| be blamed if the precondition fails? If |f|
is a first-order function, then this is impossible. However, if |f|
takes a function as an argument, then |f| must take care that this
argument is called correctly (see the discussion about |g| at the end
of Sec.~\ref{sec:blame}). If |f| does not to ensure this, then |f| is
to blame.

In essence, |assert| turns a contract of type |Contract aT| into a
contracted function of type |aT :-> aT|. If we re-phrase |assert| in
terms of this type, we obtain the implementation listed in
Fig.~\ref{fig:assert}. Note that the elements of |aT :-> bT| form the
arrows of a category, the Kleisli category of a comonad, with |FUN x
x| as the identity and `|<>|' acting as composition. Furthermore,
|list'| is the mapping function of the list functor. The
implementation also makes clear that we can do without the GADT
provided |assert| is the only operation on the data type |Contract|:
the combinators of the contract library can be implemented directly in
terms of |prop'|, |function|, |pair'|, |list'| and `|<>|'. Then
|assert| is just the identity.
%
\begin{figure}[t]

> varassert                    ::  Contract aT -> (aT :-> aT)
> varassert  (PropInfo p i)    =   propinfo' p i
> varassert  (Prop p)          =   prop' p
> varassert  (Function c1 c2)  =   function (varassert c1) (varassert `o` c2)
> varassert  (Pair c1 c2)      =   pair' (varassert c1) (varassert `o` c2)
> varassert  (List c)          =   list' (varassert c)
> varassert  (And c1 c2)       =   varassert c2 <> varassert c1
>
> propinfo'     ::  (aT -> Bool ) -> String -> (aT :-> aT)
> propinfo' p i =   Fun (\ locs a -> if p a then a else error (blame' locs i))
>
> prop'         ::  (aT -> Bool) -> (aT :-> aT)
> prop' p       =   Fun (\ locs a -> if p a then a else error ("contract failed: " ++ blame locs))
>
> function      ::  (a1T :-> b1T) -> (b1T -> a2T :-> b2T) -> ((b1T :-> a2T) :-> (a1T :-> b2T))
> function g h  =   Fun (\ locsf f -> Fun (\ locx -> 
>                     (\ x' -> (apply (h x') locsf `o` apply f locx) x') `o` apply g (locsf +> locx)))
>
> pair'         ::  (a1T :-> b1T) -> (b1T -> a2T :-> b2T) -> ((a1T, a2T) :-> (b1T, b2T))
> pair' g h     =   Fun (\ locs (a1, a2) -> (\ a1' -> (a1', apply (h a1') locs a2)) (apply g locs a1))
>
> list'         ::  (aT :-> bT) -> ([aT] :-> [bT])
> list' g       =   Fun (\ locs -> map (apply g locs))
>
> (<>)          ::  (bT :-> cT) -> (aT :-> bT) -> (aT :-> cT)
> g <> h        =   Fun (\ locs -> apply g locs `o` apply h locs)

% old version:
% function g h  =   Fun (\ locsf f -> Fun (\ locx x -> (apply (h x) locsf `o` apply f locx `o` apply g locx) x))
% pair' g h     =   Fun (\ locs (a1, a2) -> (apply g locs a1, apply (h a1) locs a2))
\caption{\label{fig:assert}Contract checking with proper blame assignment.}
\end{figure}

%if style/=newcode
%include SimpleBlame.lhs
%include Blame.lhs
%endif

%if style == newcode

> assert :: String -> Contract aT -> aT -> aT
> assert s c = assert' c (makeloc (Def s)) -- note the swap of arguments

> assertPos :: String -> String -> Contract aT -> aT -> aT
> assertPos s pos c = assert' c (makeloc (DefPos s pos))

> fun :: (aT -> bT) -> aT :-> bT
> fun f        =  Fun (\ _ x -> f x)

> app :: (aT :-> bT) -> Int -> aT -> bT
> app f loc x  =  apply f (makeloc (App loc)) x

> appParam :: (aT :-> bT) -> String -> aT -> bT
> appParam f s x = apply f (makeloc (Def s)) x

> id        ::  aT :-> aT
> id        =   fun (\ x -> x)

> data Contract aT where
>   PropInfo   ::  (aT -> Bool) -> String -> Contract aT
>   Prop       ::  (aT -> Bool) -> Contract aT
>   Function   ::  Contract aT -> (aT -> Contract bT) -> Contract (aT :-> bT)
>   Pair       ::  Contract aT -> (aT -> Contract bT) -> Contract (aT, bT)
>   List       ::  Contract aT -> Contract [aT]
>   Functor    ::  Functor f => Contract aT -> Contract (f aT)
>   Bifunctor  ::  Bifunctor f => Contract aT -> Contract bT -> Contract (f aT bT)
>   And        ::  Contract aT -> Contract aT -> Contract aT

%if False

>   Forall    ::  (forall aT . Contract aT -> Contract (fT aT)) -> Contract (Poly fT)
>   Id        ::  Contract (aT :-> aT) -> Contract (Identity aT)

%endif
Abbreviations.

> prop  ::  (aT -> Bool) -> Contract aT
> prop  =   Prop
>
> list :: Contract aT -> Contract [aT]
> list = List
>
> functor :: Functor f => Contract aT -> Contract (f aT)
> functor = Functor
>
> bifunctor :: Bifunctor f => Contract aT -> Contract bT -> Contract (f aT bT)
> bifunctor = Bifunctor
>
> infixr 4 >->
> (>->) :: Contract aT -> Contract bT -> Contract (aT :-> bT)
> pre >->   post  =  Function pre (const post)
>
> infixr 4 >>->
> (>>->) :: Contract aT -> (aT -> Contract bT) -> Contract (aT :-> bT)
> pre >>->  post  =  Function pre post
>
> infixl 3 &
> (&) :: Contract aT -> Contract aT -> Contract aT
> (&) = And
>
> infixr 5 <@>
> (<@>) :: Functor f => Contract (f a) -> Contract a -> Contract (f a)
> cO <@> cI = cO & functor cI
>
> infixr 6 <@@>
> (<@@>) :: Bifunctor f => Contract (f a b) -> (Contract a, Contract b) -> Contract (f a b)
> cO <@@> (cIl, cIr) = cO & bifunctor cIl cIr
>
> pairc :: Contract (aT, bT) -> Contract aT -> (aT -> Contract bT) -> Contract (aT, bT)
> pairc cO cIl cIr = cO & Pair cIl cIr
>
> cfoldr_sort = cf >>-> (\f -> sorted [] >>-> (\b -> true <@> true >>-> (\i -> sorted i)))
>   where cf = true >>-> (\x -> true <@> true >>-> (\xs -> sorted (x:xs)))
>         sorted rs = (ord & perms rs) <@> true
>         perms rs = prop (\xs -> xs `elem` DL.permutations rs)
>
> testconst = assert "testconst" true const

%endif

%-------------------------------=  --------------------------------------------
\section{Examples}
\label{sec:examples}
%-------------------------------=  --------------------------------------------
%if style /= newcode
%format assert (l)              =  "\Varid{assert}"
%endif

In this section we give further examples of the use of contracts.
Besides, we shall introduce a number of derived contract combinators.

%if full
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
\subsection{Factorization}
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%if style == newcode

> factors :: Integral a => a -> [a]
> factors 1 = []
> factors n = i : factors (n `div` i)
>   where i = head  [ i | i <- [2 .. n], n `mod` i == 0 ]

%endif

Assume that we have defined a function that factors a positive number
into primes. Its characteristic property---the product of the factors
yields the original number---can be easily expressed as a contract.

> factors'  ::  Int :-> [Int]
> factors'  =   assert "factors" (Function pos (\ n -> Prop (\ fs -> product fs == n))) (fun (\ n -> factors n))

% not specified: all isPrime fs
where |pos| is given by

> pos :: (Num a, Ord a) => Contract a
> pos = Prop (\ n -> n > 0)

The contract essentially formalizes that |factors| is the functional
inverse of |product|. We can capture this common idiom as a contract
combinator.

> inverse    ::  (Eq bT) => (aT -> bT) -> Contract (bT :-> aT)
> inverse f  =   Function true (\ x -> Prop (\ y -> f y == x))

Using |inverse| we can write |factors'| more succinctly:

> factors''  ::  Int :-> [Int]
> factors''  =   assert "factors" ((pos >-> true) & inverse product) (fun (\ n -> factors n))


Note that |inverse| takes a \emph{pure function} of type |aT -> bT| to
a contract of type |Contract (bT :-> aT)|. We have a choice here:
alternatively, |inverse| could take a \emph{contracted function} of
type |aT :-> bT| as an argument.  Then contract checking would happen
`recursively' within the body of |inverse|. Only further experience
with the contract library will show which variant is preferable.
%endif

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
\subsection{Sorting}
\label{sec:sorting}
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

An \technical{invariant} is a property that appears both as a pre- and
postcondition. To illustrate the use of invariants, consider the
implementation of insertion sort:

> insertionSort  ::  (Ord aT) => [aT] -> [aT]
> insertionSort  =   foldr insert [] 
>
> insert :: (Ord aT) => aT -> [aT] -> [aT]
> insert a   []                       =  [a]
> insert a1  (a2 : as)  |  a1 <= a2   =  a1 : a2 : as
>                       |  otherwise  =  a2 : insert a1 as

The helper function |insert| takes an element |a| and an ordered list,
and inserts the element at the right, according to the order, position
in the list. In other words, |insert a| takes an ordered list to an
ordered list.

> insert' :: (Ord aT) => aT :-> [aT] :-> [aT]
> insert' = assert "insert" (true >-> ord >-> ord) (fun (\ a -> fun (\ x -> insert a x)))

The contract |ord| for ordered lists is defined as follows:

> ord :: (Ord aT) => Contract [aT]
> ord = Prop (\ x -> ordered x)
>
> ordered                 ::  (Ord aT) => [aT] -> Bool
> ordered []              =   True
> ordered [_]             =   True
> ordered (a1 : a2 : as)  =   a1 <= a2 && ordered (a2 : as)

The type `ordered list' can be seen as an abstract data type (it is
concrete here, but it could easily be made abstract), whose invariant is
given by |ord|. Other ADTs such as heaps, search trees etc % abstract data types
can be handled in an analogous manner.
%if full
\begin{exercise}
Complete the implementation of heap sort below and assign suitable
contracts to the functions involved.

< heapSort  ::  (Ord aT) => [aT] -> [aT]
< heapSort  =   unheap `o` foldr sink Empty

\end{exercise}
%endif

For completeness, here is the contracted version of |insertionSort|:

> insertionSort' :: (Ord aT) => [aT] :-> [aT]
> insertionSort' = assert "sort" (true >-> ord) (fun (\ x -> insertionSort x))

% Note: |insertionSort'| does not use the contracted variant of |insert|.
Note that we did not specify that the output list is a permutation of
the input list. Assuming a function |bag :: (Ord aT) => [aT] -> Bag
aT| that turns a list into a bag, we can fully specify sorting:
|FUNCTION x true (ord & PROP s (bag x == bag s))|.
Loosely speaking, sorting preserves the `baginess' of the
input list. Formally, |g :: sT -> sT| preserves the function |f :: sT
-> tT| iff |f x == f (g x)| for all |x|. Again, we can single out this
idiom as a contract combinator.

> preserves    :: (Eq bT) => (aT -> bT) -> Contract (aT :-> aT)
> preserves f  = Function true (\ x -> Prop (\ y ->  f x == f y))

Using this combinator the sort contract now reads |(true >-> ord) & preserves bag|.
Of course, either |bag| or the equality test for bags is an
expensive operation (it almost certainly involves
sorting), so we may content ourselves with a weaker property,
for instance, that |insertionSort| preserves the length of the input list:
|(true >-> ord) & preserves length|.

The example of sorting shows that the programmer or library writer has
a choice as to how precise contracts are. The fact that contracts are
first-class citizens renders it possible to abstract out common
idioms. As a final twist on this topic, assume that you already have a
trusted sorting function at hand. Then you could simply specify that
your new sorting routine is extensionally equal to the trusted one.
We introduce the |is| contract combinator for this purpose.

> is    ::  (Eq bT) => (aT -> bT) -> Contract (aT :-> bT)
> is f  =   Function true (\ x -> Prop (\ y ->  y == f x))
>
> insertionSort''  = assert "sort" (is sort) (fun (\ x -> insertionSort x))

%if style==newcode

> insertionSort''  ::  (Ord aT) => [aT] :-> [aT]

 insertionSort'''  ::  (Ord aT) => [aT] :-> [aT]
 insertionSort''''  ::  (Ord aT) => [aT] :-> [aT]
 insertionSort'''''  ::  (Ord aT) => [aT] :-> [aT]

%endif
%if false 
Haskell's standard List library contains a definition of function |sort|, which 
makes use of the method |compare| from the |Ord| class.

> {-
> sort                       ::  (Ord a) => [a] -> [a]
> sort                       =   sortBy compare
>
> sortBy                     ::  (a -> a -> Ordering) -> [a] -> [a]
> sortBy cmp                 =   foldr (insertBy cmp) []
>
> insert                     ::  (Ord a) => a -> [a] -> [a]
> insert                     =   insertBy compare
>
> insertBy                   ::  (a -> a -> Ordering) -> a -> [a] -> [a]
> insertBy cmp x []          =   [x]
> insertBy cmp x ys@(y:ys')  =   case cmp x y of
>                                   GT  ->  y : insertBy cmp x ys'
>                                   _   ->  x : ys
> -}

Invariants (other examples: random-access lists, search trees, etc.;
abstract data types).

\NB\ rec call is unchecked. We can decide on a case by case basis
whether we want to check the recursive calls or not.

\NB\ call to |insert| is \emph{not} checked.
%endif
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
\subsection{Recursion schemes}
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
%if style == newcode

> comploc1, comploc2, foldloc1, foldloc2, isloc1, isloc2, whileloc1, isquloc1, isquloc2, isquloc3 :: Int
> comploc1 = 101
> comploc2 = 102
> foldloc1 = 111
> foldloc2 = 112
> isloc1 = 121
> isloc2 = 122
> whileloc1 = 131
> isquloc1 = 141
> isquloc2 = 142
> isquloc3 = 143

%else
%format comploc1 = "\newloc{comploc1}"
%format comploc2 = "\newloc{comploc2}"
%format foldloc1 = "\newloc{foldloc1}"
%format foldloc2 = "\newloc{foldloc2}"
%format isloc1 = "\newloc{isloc1}"
%format isloc2 = "\newloc{isloc2}"
%format whileloc1 = "\newloc{whileloc1}"
%format isquloc1 = "\newloc{isquloc1}"
%format isquloc2 = "\newloc{isquloc2}"
%format isquloc3 = "\newloc{isquloc3}"
%endif
%if False

> compose'     ::  Contract aT -> [aT :-> aT] :-> (aT :-> aT)
> compose' inv =   assert "compose"
>                    (list (inv >-> inv) >-> (inv >-> inv))
>                  (fun (\ fs -> foldr (\ f -> \ g -> fun (\ x -> app f comploc1 (app g comploc2 x))) (fun (\ x -> x)) fs))

%endif

The function |insertionSort| is defined in terms of |foldr|, the
catamorphism of the list data type. An intriguing question is whether
we can also attach a contract to |foldr| itself?

> foldr                ::  (aT -> bT -> bT) -> bT -> [aT] -> bT
> foldr _ e  []        =   e
> foldr f e  (a : as)  =   f a (foldr f e as)

The application to sorting gives |(true >-> ord >-> ord) >-> ord >->
true >-> ord| as a contract, but this one is, of course, way too
specific. The idea suggests itself to abstract from the invariant,
that is, to pass the invariant as an argument.

> foldr' :: Contract bT -> (aT :-> bT :-> bT) :-> bT :-> [aT] :-> bT
> foldr' inv =  assert "foldr"  ((true >-> inv >-> inv) >-> inv >-> true >-> inv)
>                               (fun (\ f -> fun (\ e -> fun (\ x -> foldr (\ a -> \ b -> app (app f foldloc1 a) foldloc2 b) e x))))

Again, the fact that contracts are first-class citizens proves its
worth.  Higher-order functions that implement general recursion
schemes or control constructs typically take contracts as arguments.
%if False

> isort''  ::  (Ord aT) => [aT] :-> [aT]
> isort''  =   app (app (foldr' ord) isloc1 insert') isloc2 []

%endif
% |unfoldr|?

%if full
Consider as another example the function |while| which implements
iteration.

> while'      ::  Contract aT -> (aT -> Bool) :-> (aT :-> aT) :-> (aT :-> aT)
> while' inv  =   assert "while"  (true >-> (inv >-> inv) >-> (inv >-> inv))
>                                 (fun (\ p -> fun (\ f -> fun (\ a -> while p (\ x -> app f whileloc1 x) a))))
>
> while        ::  (aT -> Bool) -> (aT -> aT) -> (aT -> aT)
> while p f a  =   if p a then while p f (f a) else a

The contract states that if the body of the loop preserves the
invariant, then also the loop itself. To illustrate the use of
|while'| here is an iterative variant of the integer square function.

> isqrt2    ::  Int -> Int
> isqrt2 n  =   let (i, _, _) = app loop isquloc1 (0, 3, 1) in i
>   where  loop  = app (app (while' inv) isquloc2 (\ (i, k, s) -> s <= n)) isquloc3 body
>          body  = fun (\ (i, k, s) -> (i + 1, k + 2, s + k))
>          inv   = Prop (\ (i, k, s) -> sq i <= n && k == (i + 1) * 2 + 1 && s == sq (i + 1))

\ralf{Say something about loop invariant; nothing special.}

Interestingly, we can optimize |foldr'| and |while'| as both recursion
schemes satisfy their contracts. We provide a proof for |foldr'|, the
correctness of |while'| is relegated to Ex.~\ref{ex:while}. 
For |foldr'| we have to prove that
%else
Interestingly, we can optimize |foldr'| as it satisfies its contract:
%endif
%format foldr_   =  "\overline{\Varid{foldr}}"
%format f_       =  "\bar{\Varid{f}}"
%format f'_      =  "\hat{\Varid{f}}"
%format e_       =  "\bar{\Varid{e}}"

< assert "foldr" ((true >-> inv >-> inv) >-> inv >-> true >-> inv) foldr_
<   =  assert "foldr" ((true >-> true >-> inv) >-> inv >-> true >-> true) foldr_

where |foldr_ = FUN f (FUN e (FUN x (foldr (\ a -> \ b -> app (app f
foldloc1 a) foldloc2 b) e x)))| is the contracted version of |foldr|.
If we unfold the definition of |assert|, the equation simplifies to
%
\begin{eqnarray}
\label{eqn:foldr}
  |assert "" inv `o` foldr f_ e_|  & = &  |foldr f'_ e_|
\end{eqnarray}
%
where |f_   =  assert "f"  (true >-> inv >-> inv)   f|,
|f'_  =  assert "f"  (true >-> true >-> inv)  f|, and
|e_   =  assert "e"  inv                      e|.
Equation~(\ref{eqn:foldr}) can be shown either by a simple appeal to
|foldr|'s fusion law \cite{Hut99Tut} or using parametricity
\cite{WadThe89}. In both cases, it remains to prove that

< assert "" inv e_         =  e_
< assert "" inv (f_ a as)  =  f'_ a (assert "" inv as)

Both parts follow immediately from the idempotence of conjunction: |c
& c = c| or more verbosely |assert "" c `o` assert "" c = assert "" c|,
see Sec.~\ref{sec:properties}.

%if full
\begin{exercise}
\label{ex:while}
Show that |while'| satisfies its contract.
\end{exercise}
%endif

%if False
\begin{verbatim}
(i, _, _)  =  app (app (app (while'  inv) 1 (\ (i, k, s) -> s <= n)) 2 (FUN (i, k, s) ((i + 1, k + 2, s + k)))) 3 (0, 3, 1)

*Contract> app (app (app (while' nat) 19 (<= 9)) 20 (Fun (\ l x -> x + 1))) 21 2
10
*Contract> app (app (app (while' nat) 22 (<= 9)) 23 (Fun (\ l x -> x + 1))) 24 (-1)
*** Exception: contract failed: `3' is to blame.
*Contract> app (app (app (while' nat) 25 (<= 9)) 26 (Fun (\ l x -> x - 1))) 27 2
*** Exception: contract failed: `2' is to blame.
\end{verbatim}

% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
\subsection{Example: |zipWith| and more}
% - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

> zipWith' :: (a -> b -> c) :-> ([a] :-> ([b] :-> [c]))
> zipWith' =  assert "zipWith"
>               (true >-> Function true (\ as1 -> Prop (\ as2 -> length as1 == length as2) >-> true))
>             (fun (\ f -> fun (\ as1 -> fun (\ as2 -> zipWith f as1 as2))))

uncurried version is more symmetric:

< zipWith' =  assert "zipWith"
<               (true >-> PROP (as1, as2) (length as1 == length as2) >-> true)
<             (FUN f (FUN p (zipWith f (fst p) (snd p))))

%endif

%-------------------------------=  --------------------------------------------
\section{Properties of contracts}
\label{sec:properties}
%-------------------------------=  --------------------------------------------

In this section we study the algebra of contracts. The algebraic
properties can be used, for instance, to optimize contracts: we shall
see that |list c1 & list c2| is the same as |list (c1 & c2)|, but the
latter contract is more efficient.  The properties are
also helpful for showing that a function satisfies its
contract: we have seen that the `correctness' of |foldr'| relies
on |c & c = c|.

Up to now we have pretended to work in a strict
language: we did not consider bottom in the proofs in the previous section. 
Let us now switch back to Haskell's non-strict semantics in
order to study the algebra of contracts in a more general setting.

It is easy to show that |assert "" c| is less than or equal to |assert
"" true|:
%format <~ = "\preccurlyeq "

< c <~ true

where `|<~|' denotes the standard information ordering. This property
implies, in particular, that |assert "" c| is \technical{strict}. Note
that, for brevity, we abbreviate the law |assert "" c1 <~ assert "" c2| by |c1
<~ c2| (ditto for equations).

Now, what happens if we apply the same contract twice; is the result the
same as applying it once? In other words, is `|&|' idempotent?
One can show that idempotence holds if `|&|' is commutative (the
other cases go through easily). Since `|&|' is implemented by function
composition, commutativity is somewhat doubtful and, indeed, it does
not hold in general as the following example shows: let |c1 = PROP x
(sum x == 0)| and |c2 = list false|, then
\begingroup
\invisiblecomments

< << length (assert "bah" (c1 & c2) [-2, 2])
< 2
< << length (assert "bah" (c2 & c1) [-2, 2])
< {- *** contract failed: the expression `|[-2, 2]|' is to blame. -}
< << length (assert "bah" ((c1 & c2) & (c1 & c2)) [-2, 2])
< {- *** contract failed: the expression `|[-2, 2]|' is to blame. -}

\endgroup
The reason is that |list false| is not the same as |false| in a lazy
setting: the first contract returns a lazy list of contract violations, the
second is a contract violation. In a strict setting, commutativity
holds trivially as |assert "" c x `elem` {undefined, x}|. The first and
the last call demonstrate that idempotence of `|&|' does not hold
for contracts that involve conjunctions, that is, these contracts
are not \technical{projections}.

Fig.~\ref{fig:conjunction} summarises the properties of conjunctions.
Equations that are marked with a $(\dagger)$ only hold  in a strict
setting.
%
%format pre1 = c1
%format pre2 = c2
%format post1 = d1
%format post2 = d2
\begin{figure}[t]
\begin{center}
$\begin{array}{rcl}
  |false & c| & = & |false| \\
  |c & false| & = & |false| \\
  |true & c| & = & |c| \\
  |c & true| & = & |c|
\end{array}
\qquad
\begin{array}{rcl@@{\quad}l}
%  |false| & = & |prop (\ a -> False)| \\
%  |true| & = & |prop (\ a -> True)| \\
  |c1 & (c2 & c3)| & = & |(c1 & c2) & c3| \\
  |c1 & c2| & = & |c2 & c1| & (\dagger) \\
  |c & c| & = & |c| & (\dagger) \\
  |PROP x p1 & PROP x p2| & = & |PROP x (p1 x && p2 x)|
\end{array}$
\end{center}
%if full
\caption{\label{fig:conjunction}Properties of conjunction.}
%else
\begin{center}
$\begin{array}{rcl@@{\quad}l}
  |true >-> true| & = & |true| \\
  |(pre1 >-> post1) & (pre2 >-> post2)| & = & |(pre2 & pre1) >-> (post1 & post2)| \\[1mm]
%if full
  |FUNCTION x true true| & = & |true| \\
  |(FUNCTION x pre1 (post1 x)) & (FUNCTION x pre2 (post2 x))|
    & = & |FUNCTION x (pre2 & pre1) (post1 x & post2 x)| \\[1mm]
%endif
  |true >*> true| & = & |true| \\
  |(pre1 >*> post1) & (pre2 >*> post2)| & = & |(pre1 & pre2) >*> (post1 & post2)| \\[1mm]
%if full
  |PAIR x true true| & = & |true| \\
  |(PAIR x pre1 (post1 x)) & (PAIR x pre2 (post2 x))|
    & = & |PAIR x (pre1 & pre2) (post1 x & post2 x)| \\[1mm]
%endif
  |list true| & = & |true| \\
  |list (c1 & c2)| & = & |list c1 & list c2|
\end{array}$
\caption{\label{fig:conjunction}Properties of contracts.}
\end{center}
%endif
\end{figure}
%
The list combinator and the \emph{independent} variants of `|>->|' and
`|>*>|' are implemented in terms of mapping functions. The
%if full
laws listed in Fig.~\ref{fig:functor}
%else
remaining laws listed in Fig.~\ref{fig:conjunction}
%endif
are immediate consequences of the well-known functor laws for these
maps (bearing in mind that |true| corresponds to |id| and `|&|' to
composition).
%
%if full
\begin{figure}[t]
\begin{center}
$\begin{array}{rcl@@{\quad}l}
%if full
  |true >-> true| & = & |true| \\
  |(pre1 >-> post1) & (pre2 >-> post2)| & = & |(pre2 & pre1) >-> (post1 & post2)| \\[1mm]
%endif
  |FUNCTION x true true| & = & |true| \\
  |(FUNCTION x pre1 (post1 x)) & (FUNCTION x pre2 (post2 x))|
    & = & |FUNCTION x (pre2 & pre1) (post1 x & post2 x)| \\[1mm]
%if full
  |true >*> true| & = & |true| \\
  |(pre1 >*> post1) & (pre2 >*> post2)| & = & |(pre1 & pre2) >*> (post1 & post2)| \\[1mm]
%endif
  |PAIR x true true| & = & |true| \\
  |(PAIR x pre1 (post1 x)) & (PAIR x pre2 (post2 x))|
    & = & |PAIR x (pre1 & pre2) (post1 x & post2 x)| \\[1mm]
  |list true| & = & |true| \\
  |list (c1 & c2)| & = & |list c1 & list c2|
\end{array}$
\end{center}
\caption{\label{fig:functor}Preservation and distribution laws.}
\end{figure}
%endif

%if False
The following law does \emph{not} preserve blame assignment:
%%
\begin{eqnarray*}
  |prop p1 >-> prop p2| & = & |FUNCTION x true (PROP y (p1 x && p2 y))|
\end{eqnarray*}
%endif

%if style==newcode

> c, c1, c2 :: Contract [Int]
> c   =  c1 & c2
> c1  =  Prop (\ x -> sum x == 0)
> c2  =  list false

> c3,c4 :: Contract ([Int] :-> Int)
> c3 = Function c2 d1
> c4 = Function c1 d2

> d1 :: t -> Contract aT
> d1 = (\ _ -> true)

> d2 :: [Int] -> Contract Int
> d2 = (\x -> Prop (\y -> product x /= y))

> c5 :: Contract ([Int] :-> Int)
> c5 = Function (And c1 c2) (\x -> And (d1 x) (d2 x))

> testlhs, testrhs :: Int
> testlhs = app (assert "1" (And c3 c4) (Fun (\ _ x -> (length  x)))) 3 [-2,2]
> testrhs = app (assert "1" c5 (Fun (\ _ x -> (length x)))) 3  [-2,2]

%endif
%if False
%-------------------------------=  --------------------------------------------
\section{I/O}
\label{sec:io}
%-------------------------------=  --------------------------------------------

old in Eiffel. |IOContract|
%endif

%-------------------------------=  --------------------------------------------
\section{Related work}
\label{sec:related-work}
%-------------------------------=  --------------------------------------------

%Findler/Felleisen et al.
Contracts are widely used in procedural and object-oriented
(first-order) programming languages~\cite{meyer}. The work on
higher-order contracts by Findler and
Felleisen~\cite{Findlerthesis,FiF02Con} has been the main inspiration
for this paper. Blume and Mc\-Alles\-ter~\cite{BlM04Mod,BlM06Mod}
describe a sound and complete model for F\&F contracts, which proves
that the contract checker discovers all violations, and always assigns 
blame properly. They show how by restricting the predicate contracts
in the F\&F language mixing semantics and soundness is avoided,
and they show how to regain the expressiveness of the original F\&F 
language by adding general recursive contracts.
Furthermore, Findler, Blume, and Felleisen~\cite{FBF04Inv}
prove many properties about contracts, for example, that contracts are
a special kind of \technical{projections} (which have been used to give a meaning
to types), and that contracts only modify the behaviour of a program
to assign blame.
%Our approach to higher-order contracts does not need a separate 
%language extension, which makes it much simpler. \ralf{I don't think that
%the F\&F proposes a scheme language extension; it's probably just a bunch
%of macros.}
We have implemented contracts as a library in Haskell, using
generalised algebraic data types, giving a strongly typed approach to
contracts. Our approach allows for a more informative blame
assignment. We provide contract constructors for pairs, lists and
algebraic data types and a combinator for conjunction. Conjunctions
greatly increase the usability of the contract language: they allow
the programmer to specify independent properties separately. However,
conjunctions also have a disturbing effect on the algebra: in a lazy
setting, contracts that include conjunctions are not necessarily
projections.

Stating and verifying properties of software is one of the central
themes in computer science. The properties of interest range from
simple properties like `this function takes an integer and returns an
integer' to complex properties that precisely describe the behaviour
of a function like the contract for |insertionSort| given in
Sec.~\ref{sec:sorting}. Relatively simple properties like
Hindley-Milner types can be statically checked by a compiler. To
statically prove a complex property for a function it is usually
necessary to resort to theorem provers or interactive type-checking
tools. Contracts also allow the specification of complex properties;
their checking, however, is relegated to run-time.  The design space
is summarised in the table below.
%
\begin{center}
% llncs tabcolsep is a ridiculously low value
\setlength\tabcolsep{6pt}%
\begin{tabular}{r||cc}
                   & static checking      & dynamic checking \\\hline
simple properties  & static type checking & dynamic type checking \\
complex properties & theorem proving      & contract checking 
\end{tabular}
\end{center}

%Contracts vs types. 
Contracts look a bit like types, but they are not. Contracts are
dynamic instead of static, and they dynamically change the program.
%if full || style == newcode
For example, consider the following function |g|:

< g  ::  (Int :-> Int) :-> (Int :-> Int)
< g  =   assert "g" ((nat >-> nat) >-> true) (FUN f f)

Function |g| is the identity function, except for the fact that it may 
fail due to contract violation. For example
\begingroup
\invisiblecomments
%if style == newcode

> ngloc1, ngloc2 :: Int
> ngloc1 = 201
> ngloc2 = 202

%else
%format ngloc1 = "\newloc{ngloc1}"
%format ngloc2 = "\newloc{ngloc2}"
%endif

< << app (app g ngloc1 (Fun (\ l x -> x))) ngloc2 (-7)
< {- \parbox{.95\linewidth}{*** contract failed: the expression `|g|' is to blame (the violation
<    was caused by the expression(s) labelled `|gloc0|').} -}
\endgroup
%endif
Contracts also differ from dependent types~\cite{martinlof}. A
dependent type may depend on a value, and may take a different form
depending on a value. A contract refines a type (besides changing the
behaviour as explained above). Dependently typed programs contain a
proof of the fact that the program satisfies the property specified in
the type. A contract is only checked, and might fail.

%Contracts vs algebraic properties.
As a characteristic property, contracts are attached to 
program points, which suggests that they cannot capture general
\technical{algebraic properties} such as associativity or
distributivity.  These properties typically involve several functions
or several calls to the same function, which makes it hard to
attach them to \emph{one} program point. Furthermore, they do not follow
the type structure as required by contracts. As a borderline example,
an algebraic property that can be formulated as a contract, since it
can be written in a type-directed fashion, is idempotence of a
function:

> f' :: Int :-> Int
> f' =  assert "f" (true >-> Prop (\ y -> y == f y)) (fun (\ x -> f x))

In general, however, algebraic properties differ from properties that
can be expressed using contracts. In practice, we expect that contract
checking is largely complementary to tools that support expressing and
testing general algebraic properties such as
Quickcheck~\cite{quickcheckafp}.  We may even observe a synergy:
Quickcheck can possibly be a lot more effective in a program that has good
contracts.

%Contracts vs assertions.
GHC \cite{GHC-6.4.1}, one of the larger compilers for Haskell,
provides \technical{assertions} for expressions: |assert p x| returns
|x| only if |p| evaluates to |True|. The function |assert| is a strict
function. Chitil et al.~\cite{CMR05Laz} show how to define |assert|
lazily. In contrast to contracts, assertions do not assign blame: if
the precondition of a function is not satisfied, the function is
blamed. Furthermore, contracts are type directed, whereas an assertion
roughly corresponds to a contract comprehension.

%if style==newcode

> f :: Int -> Int
> f = abs

%endif
%-------------------------------=  --------------------------------------------
\section{Conclusion}
\label{sec:conclusion}
%-------------------------------=  --------------------------------------------

We have introduced an embedded domain-specific language for typed,
higher-order and first-class contracts, which is both more expressive
than previous proposals, and allows for a more informative blame
assignment.  The contract language is implemented as a library in
Haskell using the concept of generalised algebraic data types. We have
taken some first steps towards an algebra of contracts, and we have
shown how to define a generic contract combinator for arbitrary
algebraic data types.

We left a couple of topics for future work. We intend to take an
existing debugger or tracer for Haskell, and use the available
information about source locations to let blaming point to real source
locations, instead of user-supplied locations as supported by the
implementation described in this paper.
%We want to prove the same properties for contracts as Findler et
%al.~\cite{FBF04Inv} do.
Furthermore, we want to turn the algebra for contracts into a more or less
complete set of laws for contracts.

%-------------------------------=  --------------------------------------------
\subsubsection*{Acknowledgements}
%-------------------------------=  --------------------------------------------

We are grateful to Matthias Blume, Matthias Felleisen, Robby Findler
and the five anonymous referees for valuable suggestions regarding
content and presentation.  Special thanks go to Matthias Blume and
referee \#5 for pointing out infelicities in the previous
implementation of blame assignment.

%if False
\appendix
%-------------------------------=  --------------------------------------------
\section{Contracts for polymorphic functions}
%-------------------------------=  --------------------------------------------

A new contract constructor:

<   Forall    ::  (forall aT . Contract aT -> Contract (fT aT)) -> Contract (Poly fT)

and an associated equation:

< assert'  (Forall fT)   loc   f                =   Poly (\ c -> assert' (fT c) loc (instantiate f c))

The new type for polymorphic functions (well, really values) is
analogous to `|:->|' for ordinary functions:

> newtype Poly fT  =  Poly { instantiate :: forall aT . Contract aT -> fT aT}

My favourite example:

> id'  ::  Poly Identity
> id'  =   assert "id"  (Forall (\ c -> Id (c >-> c)))
>                       (Poly (\ c -> Identity (fun (\ x -> x))))

Unfortunately, every polymorphic type must be wrapped with a |newtype|:

> newtype Identity aT  =  Identity { unIdentity :: aT :-> aT }

Furthermore, we need a construct combinator for the new type

< Id        ::  Contract (aT :-> aT) -> Contract (Identity aT)

and an associated equation:

< assert'  (Id c)        loc   f                =   (Identity `o` assert' c loc `o` unIdentity) f

Given the definition of |id'| we can now write:

> mfive2  ::  Int
> mfive2  =   app (unIdentity (instantiate id' nat)) 0 (-5)

We get

\begingroup
\invisiblecomments
< << mfive2
< {- *** contract failed: the expression labelled `|0|' is to blame. -}
\endgroup
%endif
%if False

Second-order properties: |id| preserves all properties: 
|forall inv . inv >-> inv|. Relation to `theorems for free'.

|Pair| $\cong$ independent projection.

TODO: loop invariant $\cong$ check of recursive call

\paragraph{Disjunctive contracts}

alternatives (or, exists) with exceptions.

< (+)  ::  neg  >->  neg  >->  neg
<      |   neg  >->  pos  >->  true
<      |   pos  >->  neg  >->  true
<      |   pos  >->  pos  >->  pos

Can be implemented with exceptions/|Maybe| monad (`| || |' is like
|handle|). Cannot be implemented in Haskell since every function must
be `monadized' (a Haskell function of type |(Int -> Int) -> Int|
cannot be passed a monadic function of type |Int -> Maybe Int|).

\paragraph{Mergesort}

Redoing some of the why dependent types matter stuff. All rather trivial.

> {-merge :: (Ord aT) => [aT] -> [aT] -> [aT]
> merge []   as2  =  as2
> merge as1  []   =  as1
> merge as1@(a1 : as1')  as2@(a2 : as2')  
>   |  a1 <= a2   =  a1 : merge  as1'  as2
>   |  otherwise  =  a2 : merge  as1   as2'
>
> merge'  ::  (Ord aT) => [aT] :-> [aT] :-> [aT]
> merge'  =   assert "merge" 
>               (FUNCTION as1 true (FUNCTION as2 true (PROP as (length as1 + length as2 == length as))))
>             (FUN as1 (FUN as2 (merge as1 as2)))
>
> deal :: [aT] -> ([aT], [aT])
> deal []              =  ([],   [])
> deal [a]             =  ([a],  []) 
> deal (a1 : a2 : as)  =  let (as1, as2) = deal as in (a1 : as1, a2 : as2)
>
> deal' ::  [aT] :-> ([aT], [aT])
> deal' =   assert "deal"
>             (FUNCTION as true (PROP (as1, as2) (length as == length as1 + length as2)))
>           (FUN as (deal as))
>
> sort     ::  (Ord aT) => [aT] -> [aT]
> sort as  =   case deal as of
>                (as1, [])           ->  as1
>                (as1, as2@(_ : _))  ->  merge (sort as1) (sort as2)
>
> sort_preserves_length  ::  (Ord aT) => [aT] :-> [aT]
> sort_preserves_length  =   assert "sort_preserves_length" 
>                              (preserve length)
>                            (FUN as (sort as))-}

  

> {-

> sort_ordered :: Ord a => Loc -> [a] -> [a]
> sort_ordered = contract "sort_ordered" (true >-> ord) sort
>
> sort_permutation :: Ord a => Loc -> [a] -> [a]
> sort_permutation = contract  "sort_permutation" 
>                              is_permutation 
>                              sort
> is_permutation :: Eq a => Contract ([a] -> [a])
> is_permutation = true >>-> \i -> prop (\o -> null (o\\i)) 
>
> sort_all :: Ord a => Loc -> [a] -> [a]
> sort_all = contract  "sort"  
>                      (      preserves_length 
>                      `And`  (true >-> ord) 
>                      `And`  is_permutation) 
>                      sort

\ralf{Still not sufficient: |sort [1, 2] = [1, 1]| satisfies the spec.}

> -}

%endif


> {-
> foo =  let  sort = \ xs ->
>                     let  insert = \ x -> \ xs ->
>                                     case xs of
>                                       []      ->  [x]
>                                       (y:ys)  ->  case x <= y of
>                                                     True   -> y : x : ys
>                                                     False  -> y : insert x ys
>                     in   let  cinsert = \ c -> \ x -> \ xs -> app (app (assert "cinsert" c (fun (\x -> fun (\xs -> insert x xs)))) 1 x) 2 xs
>                          in   let  foldr = \f' -> \ f -> \ b -> \ xs ->
>                                              case xs of
>                                                []      -> b
>                                                (x:xs)  -> f x (foldr f' f' b xs)
>                               in   let  cfoldr = \ c -> \ f' -> \ f -> \ b -> \ xs ->
>                                           app (app (app foldr' 2 (fun (\y -> fun (\ys -> f y ys)))) 3 b) 4 xs
>                                           where foldr' = assert "foldr" c (fun (\ f -> fun (\ e -> fun (\ xs -> foldr f' (\ a -> \ b -> app (app f 1 a) 2 b) e xs))))
>                                    in   cfoldr contr_foldr insert (cinsert contr_insert) [] xs
>        in   let  csort = \ c -> \ xs -> app (assert "csort" c (fun sort)) 1 xs
>             in   csort contr_sort
>  where  contr_foldr  = (true >-> true >-> sorted) >-> true >-> true >-> sorted
>         contr_sort   = true >-> sorted
>         contr_insert = true >-> true >-> sorted
>         sorted = prop (prop_Sort [0, 1])
>
> prop_Sort :: Ord a => [a] -> [a] -> Bool
> prop_Sort dep std = isNonDesc std && isPermutation dep std
>   where  isPermutation xs ys = xs `elem` DL.permutations ys
>          isNonDesc (x : y : ys)  = x <= y && isNonDesc (y : ys)
>          isNonDesc _             = True
> -}

\bibliographystyle{splncs}
\bibliography{abbr,rh,Contract}

\end{document}

Matthias' example (a variation of |g|):

> c12 :: Contract ((Int :-> Int) :-> (Int :-> Int))
> c12 = ((Prop (\ n -> n > 0)) >-> nat) >-> (nat >-> nat)
>
> g1, g2  ::  (Int :-> Int) :-> (Int :-> Int)
> g1  =   assert "g1" c12 (fun (\ f -> f))
> g2  =   assert "g2" c12 (fun (\ f -> fun (\ x -> app f 0 x)))

< << app (app g1 1 id) 2 0
< << app (app g2 1 id) 2 0

2nd-order function (slope of a function):

> slope :: (Double -> Double) -> (Double -> Double -> Double)
> slope f a b = (f b - f a) / (b - a)
>
> slope' :: (Double :-> Double) :-> (Double :-> Double :-> Double)
> slope' = assert "slope"
>            ((pos >-> pos) >-> (pos >-> pos >-> pos))
>            (fun (\ f -> fun (\ a -> fun (\ b -> slope (\ n -> app f 0 n) a b))))

< << app (app (app slope' 1 (Fun (\l x -> x + 1))) 2 (-1.0)) 3 1.0
*** Exception: contract failed: the expression labelled `2' is to blame.
< << app (app (app slope' 1 (Fun (\l x -> x - 1))) 2 2.0) 3 3.0
1.0
< << app (app (app slope' 1 (Fun (\l x -> x - 1))) 2 0.0) 3 1.0
*** Exception: contract failed: the expression labelled `1' is to blame.
< << app (app (app slope' 1 (Fun (\l x -> 1 / x))) 2 2.0) 3 3.0
*** Exception: contract failed: the expression `slope' is to blame.

3rd-order function:

> x0   ::  (((Int :-> Int) :-> Int) :-> Int)
> x0   =   assert "x0" (((nat >-> nat) >-> nat) >-> nat) (fun (\ x1 -> app x1 2 (fun (\ x3 -> x3))))
> x0'  ::  (((Int :-> Int) :-> Int) :-> Int)
> x0'  =   assert "x0" (((nat >-> nat) >-> nat) >-> nat) (fun (\ x1 -> app x1 2 (fun(\ x3 -> x3 - 1))))

< << app x0 1 (fun (\ x2 -> app x2 3 0))
< 0
< << app x0 1 (fun (\ x2 -> app x2 3 (-1)))
< *** Exception: contract failed: the expression labelled `1' is to blame (the violation
<     was caused by the expression(s) labelled `3').

4th-order function:

> nat4 :: Contract ((((Int :-> Int) :-> Int) :-> Int) :-> Int)
> nat4  =  (((nat >-> nat) >-> nat) >-> nat) >-> nat
>
> y0, y0' :: (((Int :-> Int) :-> Int) :-> Int) :-> Int
> y0    =  assert "y0"   nat4  (fun (\ y1 -> app y1 2 (fun (\ y3 -> app y3 4 1))))
> y0'   =  assert "y0'"  nat4  (fun (\ y1 -> app y1 2 (fun (\ y3 -> app y3 4 (-1)))))

\begingroup
\invisiblecomments

< << app y0 1 (fun (\ y2 -> app y2 3 (fun (\ y4 -> -y4))))
< {- \parbox{.95\linewidth}{*** contract failed: the expression labelled `|1|' is to blame (the violation
<    was caused by the expression(s) labelled `|3|').} -}
< << app y0' 1 (fun (\ y2 -> app y2 3 (fun (\ y4 -> y4))))
< {- \parbox{.95\linewidth}{*** contract failed: the expression `|y0'|' is to blame (the violation
<    was caused by the expression(s) labelled `|2|', labelled `|4|').} -}

\endgroup
