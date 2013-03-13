\documentclass{article}

\usepackage[T1]{fontenc}
\usepackage{bussproofs}

%include polycode.fmt
%format UNIFY = "{\mathcal{U}}"
%format UNIFY_0
%format ALPHA = "{\alpha}"
%format ALPHA_1
%format ALPHA_2
%format ALPHA_3
%format ALPHA_4
%format ALPHA_n
%format ALPHA_m
%format BETA = "{\beta}"
%format BETA_1
%format BETA_2
%format BETA_3
%format BETA_n
%format GAMMA = "{\gamma}"
%format GAMMA_1
%format GAMMA_2
%format GAMMA_3
%format GAMMA_4
%format GAMMA_n
%format GAMMA_m
%format DELTA = "{\delta}"
%format DELTA_1
%format DELTA_2
%format DELTA_n
%format DELTA_m
%format RHO = "{\rho}"
%format KAPPA = "{\kappa}"
%format KAPPA_1
%format KAPPA_2
%format TAU = "{\tau}"
%format A_1
%format A_2
%format a_1
%format a_2
%format a_3
%format a_4
%format b_1
%format b_2
%format b_3
%format b_4
%format PI = "\pi"
%format PI_1
%format PI_2
%format PI_3
%format PI_4
%format PI_5
%format PI_6
%format PI_7
%format PI_8
%format PI_9
%format l_1
%format l_2
%format r_1
%format r_2
%format PI_l_1
%format PI_l_2
%format PI_r_1
%format PI_r_2
%format TAU_1
%format TAU_2
%format TAU_3
%format TAU_4
%format TH = "\theta"
%format TH_1
%format TH_2
%format TH_3
%format TH_4
%format TH_5
%format :@: = ":\!\!@\!\!:"
%format :&&: = ":\!\!\&\!\&\!\!:"
%format OPR = "\{\!-\!\#~\textit{PROP}"
%format CPR = "\#\!-\!\}"
%format ~> = "{\!\!~\leadsto\!\!~}"
%format DOTS = "{..}"

\newcommand{\inenv}[3][]{$#1{\Gamma\vdash\textrm{#2}:\textrm{#3}}$}
\newcommand{\inenvinf}[3][]{$#1{\Gamma\vdash\textrm{#2}:_\uparrow\textrm{#3}}$}
\newcommand{\inenvchk}[3][]{$#1{\Gamma\vdash\textrm{#2}:_\downarrow\textrm{#3}}$}

\begin{document}


\subsection*{Annotating functions}

\begin{code}
OPR id :: (x :: PI x' x -> y :: PI x y) CPR
id :: a -> a
id x = x
\end{code}

Now what happens if we define

\begin{code}
OPR sid :: (xs :: isSorted xs' xs -> ys :: isSorted xs' ys) CPR
sid :: Ord a => [a] -> [a]
sid = id
\end{code}

TODO for |const|: do we need to use |y| somewhere in |z|?
< OPR const :: (x :: PI_1 x' x -> y :: PI_2 y' y -> z :: PI_1 x' z) CPR
< const :: a -> b -> a
< const x = \ _ -> x

< OPR map  ::  (f :: (x :: PI_1 x' x -> y :: PI_2 x' y)
<          ->  xs :: PI_3 xs' xs
<          ->  ys :: PI_4 {map f} xs' ys) CPR
< map :: (a -> b) -> [a] -> [b]
< map _  []      = []
< map f  (x:xs)  = f x : map f xs

%Here we see an additional, partially applied function |map f| explicitly
%specified in the return value. If not specified, this will default to |id|.
%Hence, the above property annotation actually defines the following:
%
%< OPR map  ::  (f :: (x :: PI_1 {id} x' x -> y :: PI_2 {id} x y)
%<          ->  xs :: PI_3 {id} xs' xs
%<          ->  ys :: PI_4 {map f} xs ys) CPR
%
%This partially applied function can be applied to the first argument, resulting
%in an input value for the property.

< OPR foldr  ::  (f  ::  (x :: PI_1 x' x
<                    ->  y :: PI_2 {foldr f e} xs' y
<                    ->  r :: PI_2 {foldr f e} (x':xs') r)
<            ->  e :: PI_2 {foldr f e} [] e
<            ->  ys :: pmap PI_1 ys' ys :&&: PI_3 ys' ys
<            ->  s :: PI_2 {foldr f e} ys' s) CPR
< foldr :: (a -> b -> b) -> b -> [a] -> b
< foldr _  b []       = b
< foldr f  b (x:xs)   = f x (foldr f b xs)

< OPR sort :: (xs :: PI xs' xs -> ys :: isSorted {sort} xs' ys) CPR
< sort :: Ord a => [a] -> [a]
< sort = foldr insert []
<   where  insert x []      = [x]
<          insert x (y:ys)  = if x <= y  then  x : y : ys
<                                        else  y : insert x ys

Where |pmap| is

\begin{code}
pmap :: (a -> b -> Bool) -> [a] -> [b] -> Bool
pmap PI xs = and . zipWith PI xs
\end{code}

What happens if we start to infer contracts? For |insert| we can infer the
contract |x :: PI_1 x' x -> y :: PI_2 y' y -> z :: PI_3 z' z|. Since we know
the contract for |foldr|, we can refine this with the following substitutions
(leaving out the trivial substitutions):

< [z' -> (x':xs'), PI_3 -> PI_2]

Applying the substitutions to the inferred contract for |insert| results in the
same contract as |f| in |foldr|:

< insert :: (x :: PI_1 x' x  -> y :: PI_2 {foldr f e} xs' y
<                            -> r :: PI_2 {foldr f e} (x':xs') r)

Unifying |foldr insert []| with |sort|, gives us the following substitutions in
|foldr| (with a bit of hand-waving for alpha-renaming):

< [PI_2 -> isSorted]

Giving us the following contract for |foldr|:

< OPR foldr  ::  (f  ::  (x :: PI_1 x' x
<                    ->  y :: isSorted {foldr f e} xs' y
<                    ->  r :: isSorted {foldr f e} (x':xs') r)
<            ->  e :: isSorted {foldr f e} [] e
<            ->  ys :: pmap PI_1 ys' ys :&&: PI_3 ys' ys
<            ->  s :: isSorted {foldr f e} ys' s) CPR

Now suppose we have the following implementation of |sort|, where the |y| and
|x| in the second case of |insert| are switched:

\begin{code}
OPR sort :: (xs :: PI xs' xs -> ys :: isSorted {sort} xs' ys) CPR
sort :: Ord a => [a] -> [a]
sort = foldr insert []
  where  insert x []      = [x]
         insert x (y:ys)  = if x <= y  then  y : x : ys
                                       else  y : insert x ys
\end{code}

This code should give us a counter-example when trying to sort the list
|[1,3]|, as it will return the list |[3,1]| as a result, which is clearly not
sorted.

Starting at the top-level, we have |[xs -> [1,3], xs' -> [1,3], ys -> [3,1]]|.
Applying |isSorted| to |[1,3]| and |[3,1]| results in |False|, failing the
property. Since |sort| is implemented as |foldr insert []|, we proceed  with
doing the same check for |foldr insert []|, obviously giving us the same
result. We descend into the definition of |foldr|, where we end up in the
second case:

< foldr _  b []       = b
< foldr f  b (x:xs)   = f x (foldr f b xs)

We now see that |foldr| is implemented in terms of |f|, which in our case is
|insert|. So far, still every property fails. We continue recursing into
|foldr| until we hit the base-case, where |b| becomes the empty list. For the
empty list, the contract succeeds, as inserting |x| into the empty list is
correctly implemented.  We make one step up, and run the contract check again
and we find out that the contract fails when |x=1| and |xs=[3]|. This is the
point where the error is located, namely in the second case of |insert|. We
could go further and explore the |if| as well:

\begin{code}
OPR if :: (x :: PI_1 x' x -> y :: PI_2 y' y -> z :: PI_2 z' z) CPR
\end{code}

Then we could possibly even indicate that the error is in the then-branch of
the if.


\subsection*{Grammars}

\begin{description}
  \item[Properties] |KAPPA ::= PI || RHO|
  \item[Contracts] |GAMMA ::= ALPHA :: KAPPA DELTA ALPHA || ALPHA :: GAMMA_1 -> GAMMA_2 || ALPHA_1 :: f KAPPA ALPHA_2 ALPHA_1 :&&: GAMMA|
  \item[Arguments] |DELTA ::= ALPHA || C DELTA_1 DOTS DELTA_n|
\end{description}

Where |PI| is a contract variable, |RHO| is a concrete contract, |ALPHA| is a
contract parameter variable, and |C| is a constructor.

Instances of variables, etc. can contain Haskell constructors |C|. Invariant:
|PI| is always of type |a -> b -> Bool|, possibly with some constraint kind
|Constr a b| which could be defined by a type family:

< type family Constr a b :: Constraint

\subsection*{Unification}

Contracts are unified as follows:

\begin{code}
  UNIFY(KAPPA, KAPPA)      = id
  UNIFY(GAMMA, GAMMA)      = id
  UNIFY(DELTA, DELTA)      = id
  UNIFY(ALPHA_1, ALPHA_2)  = [ALPHA_1 -> ALPHA_2]
  UNIFY(PI_1, PI_2)        = [PI_1 -> PI_2]
  UNIFY(PI, RHO)           = [PI -> RHO]
  UNIFY(RHO, PI)           = [PI -> RHO]
  UNIFY(ALPHA_1 :: KAPPA_1 DELTA_1 ALPHA_1, ALPHA_2 :: KAPPA_2 DELTA_2 ALPHA_2)  =  let   TH_1  = UNIFY(KAPPA_1, KAPPA_2)
                                                                                          TH_2  = UNIFY(ALPHA_1, ALPHA_2)
                                                                                          TH_3  = UNIFY(TH_2 DELTA_1, TH_2 DELTA_2)
                                                                                    in    TH_3 . TH_2 . TH_1
  UNIFY(ALPHA_1 :: GAMMA_1 -> GAMMA_2, ALPHA_2 :: GAMMA_3 -> GAMMA_4)            =  let  TH_1  = UNIFY(ALPHA_1, ALPHA_2)
                                                                                         TH_2  = UNIFY(TH_1 GAMMA_2, TH_1 GAMMA_4)
                                                                                         TH_3  = UNIFY(TH_1 GAMMA_1, TH_1 GAMMA_3)
                                                                                    in  TH_3 . TH_2 . TH_1
  UNIFY(ALPHA_1 :: f KAPPA ALPHA_2 ALPHA_1 :&&: GAMMA_1, GAMMA_2)                = UNIFY(GAMMA_1, GAMMA_2)
  UNIFY(ALPHA_1, C ALPHA_n DOTS ALPHA_m)  = [ALPHA_1 -> C ALPHA_n DOTS ALPHA_m]
  UNIFY(C ALPHA_n DOTS ALPHA_m, ALPHA_1)  = [ALPHA_1 -> C ALPHA_n DOTS ALPHA_m]
  UNIFY(_, _)         = undefined
\end{code}

Unifying the same concrete contracts results in an identity substitution.
Unifying any contract variable with a concrete contract results in a
substitution from variable to concrete contract. Unifying two variables yields
a substitution from the one to the other variable. Concrete constructors can
only be unified with variables, or with identical constructors. We have a
special case for unifying a complete property specification. It unifies the
individual parts and composes the unifications.

\end{document}
