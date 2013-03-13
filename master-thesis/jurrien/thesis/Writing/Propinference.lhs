\documentclass{article}

\usepackage[T1]{fontenc}
\usepackage{bussproofs}

%include polycode.fmt
%format UNIFY = "{\mathcal{U}}"
%format UNIFY_0
%format ALPHA = "{\alpha}"
%format RHO = "{\rho}"
%format A_1
%format A_2
%format PI = "\pi"
%format PI_1
%format PI_2
%format PI_3
%format PI_4
%format l_1
%format l_2
%format r_1
%format r_2
%format PI_l_1
%format PI_l_2
%format PI_r_1
%format PI_r_2
%format TH = "\theta"
%format TH_1
%format TH_2
%format :@: = ":\!\!@\!\!:"
%format OPR = "\{\!-\!\#~\textit{PROP}"
%format CPR = "\#\!-\!\}"

\newcommand{\inenv}[3][]{$#1{\Gamma\vdash\textrm{#2}:\textrm{#3}}$}
\newcommand{\inenvinf}[3][]{$#1{\Gamma\vdash\textrm{#2}:_\uparrow\textrm{#3}}$}
\newcommand{\inenvchk}[3][]{$#1{\Gamma\vdash\textrm{#2}:_\downarrow\textrm{#3}}$}

\begin{document}


\subsection*{Definitions}
Where $\alpha$ is a property variable, $o$ is a hole property, and $\rho$ is a
concrete property. We let $\sigma$ be an unevaluated type expression.

\paragraph{Properties:} $\pi$ ::= $\alpha$ || $\pi_1 \rightarrow \pi_2$ || $o$ || $\rho$
\paragraph{Substitutions:} $\theta$ ::= \textit{id} || $[\alpha \rightarrow \pi]$ || $\theta_1 \circ \theta_2$

\subsection*{Property typing rules}

\begin{center}
% P-Var
\RightLabel{\textsc{P-Var}}
\AxiomC{$\Gamma(x)=\pi$}
\UnaryInfC{\inenvinf{$x$}{$\pi$}}
\DisplayProof{}
% P-Lam
\RightLabel{\textsc{P-Lam}}
\AxiomC{\inenvchk{$x$}{$\pi_1$}}
\AxiomC{\inenvchk{$e$}{$\pi_2$}}
\BinaryInfC{\inenvchk{$\lambda{x.e}$}{$\pi_1\rightarrow\pi_2$}}
\DisplayProof{}
\RightLabel{\textsc{P-Chk}}
\AxiomC{\inenvinf{$e$}{$\pi$}}
\UnaryInfC{\inenvchk{$e$}{$\pi$}}
\DisplayProof{}

~

% P-App
\RightLabel{\textsc{P-App}}
\AxiomC{\inenvinf{$f$}{$\pi_1 \rightarrow \pi_2$}}
\AxiomC{\inenvchk{$x$}{$\pi_1$}}
\BinaryInfC{\inenvinf{$f x$}{$\pi_2$}}
\DisplayProof{}
%\RightLabel{\textsc{P-Let}}
%\AxiomC{\inenv{$e_1$}{$\pi_1$}}
%\AxiomC{\inenv{$e_2$}{$\pi_2$}}
%\BinaryInfC{\inenv{\textbf{let} $x=e_1$ \textbf{in} $e_2$}{$\pi_2$}}
%\DisplayProof{}
%
%~
%
%\RightLabel{\textsc{P-If}}
%\AxiomC{\inenv{$c$}{$Bool$}}
%\AxiomC{\inenv{$t$}{$\pi$}}
%\AxiomC{\inenv{$e$}{$\pi$}}
%\TrinaryInfC{\inenv{\textbf{if} $c$ \textbf{then} $t$ \textbf{else} $e$}{$\pi$}}
%\DisplayProof{}
%
%~
%
%\RightLabel{\textsc{P-Case}}
%\AxiomC{\inenv{$e$}{$\pi_1$}}
%\AxiomC{\inenv[\overline]{$p \rightarrow e$}{$\pi_1 \rightarrow \pi_2$}}
%\BinaryInfC{\inenv{\textbf{case} $e$ \textbf{of} $\overline{p \rightarrow e}$}{$\pi_2$}}
%\DisplayProof{}
\end{center}

\subsection*{Property unification}

< UNIFY(PI_l_1 -> PI_l_2, PI_r_1 -> PI_r_2) =  let  TH_1  = UNIFY(PI_l_1, PI_r_1)
<                                                   TH_2  = UNIFY(PI_l_2, PI_r_2)
<                                              in   TH_2 . TH_1
< UNIFY(PI,     PI)     = id
< UNIFY(PI,     ALPHA)  = [ALPHA -> PI]
< UNIFY(ALPHA,  PI)     = [ALPHA -> PI]
< UNIFY(PI_1,   PI_2)   = undefined

\subsection*{Prelude functions with property signatures}

< id :: PI -> PI
< const :: PI_1 -> PI_2 -> PI_1

Do we want something like
< map :: (PI_1 -> PI_2) -> PI_3 -> PI_4
or something like
< map :: (PI_1 -> PI_2) -> [PI_1] -> [PI_2]
My initial guess would be the former.


< foldr : (PI_1 -> PI_2 -> PI_2) -> PI_2 -> PI_3 -> PI_2
or
< foldr : (PI_1 -> PI_2 -> PI_2) -> PI_2 -> [PI_1] -> PI_2

\subsection*{General idea}
We first assume that we have some counter-example, e.g. [3,1,2]. Since we
already have a counter-example, we know that there is a bug in the program
somewhere.  What we do not know, is where this bug originates from. If we were
to just test the top-level property, e.g. |propInsert| (see below), then we
wouldn't know much more than we already knew, namely that the property fails.
To find out where the properties start failing, we need to do a depth-first
search through the property definitions. By the definition of |propSort| we
know that it is defined in terms of |propInsert|, hence we continue our DFS
with propInsert. Our initial application of |propInsert| is parameterized by
|3| and |[1,2]|. Since |3| can have any property |PI|, we do nothing with it.
We proceed with a DFS traversal of |propSort [1,2]|. This entire scheme repeats
until we hit some base-case (like |[]|), or until all properties pass. Once we
hit that, we start to back-track until we encounter the deepest failing
property. Now how do we deal with the result property type of |propInsert|? In
this particular case, the shape of the base-cases is exactly |(x:xs)|. However,
this is not always the case. Suppose one base-case is |flip (:) (y:ys) x|, then
we need to be able to change the type of the property into |propSort (flip (:)
xs x)|, or perhaps something even more detailed.

For dealing with the result type, do we need to make a case-distinction in the
property type definition? E.g.:

< propSort :: (xs :: PI) -> (ys :: isSorted xs ys)
< propSort :: ([] :: PI) -> (ys :: isSorted [] ys)
< propSort :: ((x:xs) :: PI) -> (ys :: isSorted (x:xs) ys)
<
< propInsert :: (x :: PI)  -> (xs :: propSort xs) -> (rs :: propSort rs)
< propInsert :: (x :: PI)  -> ([] :: propSort []) -> (rs :: propSort [x])
< propInsert :: (x :: PI)  -> ((z:zs) :: propSort (z:zs))
<                          -> (rs :: propSort (x:z:zs))

Both of these cases can be simplified to just:

< propSort :: (xs :: PI) -> (ys :: isSorted xs ys)
<
< propInsert :: (x :: PI)  -> (xs :: propSort xs) -> (rs :: propSort (x:xs))

What about

< propSort :: (xs :: PI) -> (ys :: isSorted xs ys)
<
< propInsert :: (x :: PI)  -> (xs :: isSorted xs xs) -> (rs :: isSorted (x:xs) rs)

We might not even need to give these properties a different name. What if we
would just have the following annotations:

< OPR sort :: (xs :: PI A) -> (ys :: isSorted xs ys) CPR
< sort :: Ord a => [a] -> [a]
<
< OPR insert  ::  (x :: PI A)  -> (xs :: isSorted xs xs)
<             ->  (rs :: isSorted (x:xs) rs) CPR
< insert :: Ord a => a -> [a] -> [a]

Then the definition of |sort| and |insert| can tell us in what terms the
functions are implemented.

Should we split the actual property function and its arguments? That would
solve the unification problem... What if instead we knew that a concrete
property always consists of two parts: the property function itself, and a
tuple with its arguments. I.e., all property annotations are uncurried
functions. Then, propert-polymorphic functions can have the form |PI_1 A_1 ->
PI_2  A_2|. Would this mean that properties are inherently functorial?
Actually, this might not be needed. What if the algorithm implicitly generates
fresh argument variables with which we can unify? Then we solve the unification
problem and we don't force developers to use uncurried functions.

So, when |UNIFY(isSorted xs xs, PI)|, we observe that |isSorted| has arity 2
and enforce that |PI| has the same arity by generating fresh variables to which
we apply |PI|. These fresh variables can then be unfied with the various
arguments.


< OPR sort :: (xs :: PI) -> (ys :: isSorted xs ys) CPR
< sort :: Ord a => [a] -> [a]
<
< OPR insert  ::  (x :: PI)  -> (xs :: isSorted xs xs)
<             ->  (rs :: isSorted (x:xs) rs) CPR
< insert :: Ord a => a -> [a] -> [a]

But in case of the |head| or |tail| functions, we might only want to give one
case:

< propHead :: ((x:xs) :: PI) -> (x :: PI)
<
< propTail :: ((x:xs) :: PI) -> (xs :: PI)

Or, in case of a function where the result needs to do pattern matching on the
argument values:

< propSilly :: (x :: PI) -> ([] :: PI) -> ([] :: True)
< propSilly :: (x :: PI) -> ((y:ys) :: PI) -> (rs :: rs == (y:x:ys))

Although the latter case could also be abstracted:

< propSwitch :: ((x:y:xs) :: PI) -> (rs :: isSwitched (x:y:xs) rs)
< propSwitch :: (xs :: PI) -> (xs :: True)
<
< propSilly' :: (x :: PI) -> (xs :: PI) -> (rs :: propSwitch (x:xs))

We can write this in a GADT-like syntax as well, which might help with parsing
and understanding the code:

< prop propSilly where
<   silly_nil :: (x :: PI) -> ([] :: PI) -> ([] :: PI)
<   silly_cons :: (x :: PI) -> ((y:ys) :: PI) -> ((y:x:ys) :: PI)

What would |propSort| and |propInsert| look like with GADT-like notation?

< prop propSort :: PI -> Prop where
<   prop_sort :: (xs :: PI) -> (ys :: isSorted xs ys)
<
< prop propInsert :: PI -> propSort PI -> propSort PI -> Prop where
<   prop_insert :: (x :: PI) -> (xs :: propSort xs) -> (rs :: propSort rs)

We can define |sort| in at least two ways: by using explicit recursion, or by
using |foldr|. In case of the |foldr| definition, we need to define a
$\textit{PROP}$ annotation for |foldr| first:

< OPR foldr propFoldr  ::  (f :: PI_1 -> PI_2 -> PI_2) -> (x :: PI_2)
<                      ->  (xs :: PI_3) -> (rs :: PI_2)
< propFoldr _  z []      = z
< propFoldr f  z (x:xs)  = f x (propFoldr f z xs)

The implementation of |propFoldr| makes use of only function application and no
other functions, so its implementation can possibly be left implicit. We list
it here anyway.

Now, how do we deal with two different, but correct implementations of |sort|?
We know that, regardless of implementation, |sort| has type |Ord a => [a] ->
[a]|. It gets this type by deconstructing the list it gets as argument and
applying the individual parts in the right-hand side of the function
definition. The problem with the two definitions is that the manual definition
has two explicit cases, whereas the |foldr| definition just has one. In the
latter the case distinction is made in the implementation of |foldr|, rather
than |sort|. Equational reasoning may help here as well. With a bit of
hand-waving: suppose we see the definition:

< sort xs = foldr insert [] xs

By the property definition, we can deduce that |propFoldr| is the corresponding
property for |foldr|. Normally, this still wouldn't get us anywhere. However,
since we have a counter-example by QuickCheck, we can unroll the fold and
produce a concrete expression. Suppose we have [3,2,1] as counter-example:

< propFoldr propInsert [] [3,2,1]
< ==
< propInsert 3 (propInsert 2 (propInsert 1 []))

This is the same as we would get in the |sort| definition without |foldr|.
Using property-inference, we can infer the property types of the students'
functions and try to match them with known property types, so we can proceed
with testing.

Suppose we have a student implementation of |sort|, which has different names
than the model solutions:

< sort []      = []
< sort (x:xs)  = foo x (sort xs)
<   where  foo x []      = [x]
<          foo x (y:ys)  = if x < y then x : y : ys else x : foo x ys

This will result in an inferred property type for |foo|: (TODO: Verify)

< foo :: (x ::: PI_1) -> (xs :: PI_2) -> (rs :: PI_2)

Now we can unify |foo| and |propInsert|, resulting in the following
substitutions: |[PI_1 -> PI_3, PI_2 -> propSort xs, PI_2 -> propSort (x:xs)]|.
We get a collision when trying to find a substitution for |PI_2|.  We need to
find a way to temporarily ignore the arguments to the property definitions, or
to add an index to the substitutions. Instead of yielding a list of
substitutions, we could yield a list of pairs, of which the first element is a
list of indices, and the second element is the type to be unified.  Our
improved unification algorithm would yield the following list: |[PI_1 -> [(0,
PI_3)], PI_2 -> [(1, propSort xs), (2, propSort (x:xs))]]|. We should, however,
make sure that both the first |PI_2| and the second |PI_2| have the same
property, namely |propSort|. This is easily achieved by traversing all elements
in the inner substitution list, checking that they are all the same property.
To make this work, we need to modify the unification algorithm to pass along a
counter and add the counter to the result once a substitution has been found:

< UNIFY(PI_l_1 -> PI_l_2, PI_r_1 -> PI_r_2) n  =  let  (m,   TH_1)  = UNIFY(PI_l_1, PI_r_1) n
<                                                      (m',  TH_2)  = UNIFY(PI_l_2, PI_r_2) (m + 1)
<                                                 in   (m',  TH_2 . TH_1)
< UNIFY(PI,     PI)     n = (n, id)
< UNIFY(PI,     ALPHA)  n = (n, [ALPHA -> (n, PI)])
< UNIFY(ALPHA,  PI)     n = (n, [ALPHA -> (n, PI)])
< UNIFY(PI_1,   PI_2)   n = undefined

Substitution composition, as is used in the function unification case, will
need to make sure that correct substitution lists are produced. We also add
|UNIFY_0| to start the counter at |0|:

< UNIFY_0(PI_1, PI_2) = UNIFY(PI_1, PI_2) 0

Of course, we can also just not reinvent the wheel and look at how, for
example, Na's work on contracts deals with this, or how Agda does unification.
For Agda, just read chapter 2 of Norell's thesis. For now, just assume it works
and worry about the details when we get to implementing the unification.


\subsection*{Sort example}

Haskell definition, annotated with a property specification

< OPR sort propSort :: (xs :: PI) -> (ys :: isSorted xs ys) CPR
< sort :: Ord a => [a] -> [a]
< sort = foldr insert []

Observation for propInsert is that the cases where the recursion terminates
always have the form |x : zs|, where |zs| is either |[]| or |y:ys|. This is
exactly the shape of the property type definition |(x:xs)|. The value of |zs|
is also always (in this particular function) the left-hand side as-is, although
that is likely to be more of a coincidence.
< OPR insert propInsert :: (x :: PI)  -> (xs :: propSort xs)
<                                     -> (rs :: propSort (x:xs)) CPR
< insert :: Ord a => a -> [a] -> [a]
< insert x []      =  [x]
< insert x (y:ys)  =  if x <= y
<                       then  x : y : ys
<                       else  y : insert x ys

We use the |propSort| and |propInsert| definitions initially just for
type-checking the arguments to the functions and assume that the actual
property and to-be-tested code are type-correct. For propInsert, for example,
we accept any argument for the first parameter; for the second parameter we
accept a list that must be sorted, which we will check using the definition of
propSort; and finally, we check that the functions result is sorted. How then
do we use property inference to locate errors in a program?

We start with a bottom-up property inferencing, as described above. In general,
we only know the top-level property declaration, so we infer only propety
variables until we hit the top. At that point, we first type-check against the
property declaration. If this all type-checks, we can start to refine the
infered variables in a top-down manner.

\subsubsection*{Property definitions}

< isSorted :: Ord a => [a] -> [a] -> Bool
< isSorted xs ys = isPermutation && isNondesc ys
<   where  isPermutation = ys `elem` permutations xs
<          isNondesc (z:z':zs)  = z <= z' && isNondesc (z':zs)
<          isNondesc _          = True

While the definitions are isomorphic to the implementation of |sort|, we still
require them in some form. Remember that |sort| is the definition as
implemented by a student, so it may be incorrect or extremely verbose. Having
these property equations corresponds to having model solutions.
< propSort []      = []
< propSort (x:xs)  = propInsert x (propSort xs)
<
< propInsert x []      =  [x]
< propInsert x (y:ys)  =  if x <= y
<                           then  x : y : ys
<                           else  y : propInsert x ys


\end{document}
