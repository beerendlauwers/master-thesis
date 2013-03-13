\documentclass[10pt]{report}

\usepackage{amsthm}
\usepackage{bussproofs}
\usepackage[pdftex]{graphicx}
\usepackage{url}
\usepackage{float}
\usepackage{tikz}
\usepackage{setspace}
\usepackage{stmaryrd}

\newcommand{\HRule}{\rule{\linewidth}{0.5mm}}

\newtheorem{prop}{Proposition}
\newtheorem{defn}{Definition}
\newtheorem{conj}{Conjecture}

\newcommand{\C}{\mathcal{C}}
\newcommand{\W}{$\mathcal{W}$}
\newcommand{\CW}{$\mathcal{CW}$}
\newcommand{\Lang}{\mathcal{L}}
\newcommand{\lc}{$\lambda_c$}
\newcommand{\sem}[1]{\llbracket{#1}\rrbracket{}}

%include polycode.fmt
%options ghci -fglasgow-exts

%include Contract.fmt

%format == = "{\equiv{}}"
%format SUBSET = "{\subset{}}"
%format SUBSETEQ = "{\subseteq{}}"
%format C = "{\mathcal{C}}"
%format C_0
%format C_1
%format C_2
%format C_3
%format C_4
%format C_n
%format c = "c"
%format c_0
%format c_1
%format c'
%format c1
%format c1'
%format c_1'
%format c_2
%format c_3
%format c_4
%format c_5
%format c_6
%format c_7
%format c_8
%format c_n
%format c_xs
%format e = "e"
%format e_0
%format e_1
%format e_2
%format e_3
%format e_4
%format e_i
%format e_n
%format p = "p"
%format p_0
%format p_1
%format p_i
%format p_n
%format ce = "ce"
%format ce_1
%format ce_2
%format DOTS = "{\ldots}"
%format ALPHA = "{\alpha}"
%format ALPHA_1
%format ALPHA_2
%format ALPHA_3
%format TAU = "{\tau}"
%format TAU_1
%format TAU_2
%format TAU_3
%format TH = "{\theta}"
%format TH_1
%format TH_2
%format TH_3
%format TH_4
%format GAMMA = "{\Gamma}"
%format SCHEME = "{\sigma}"
%format BIN = "{\oplus}"
%format UNIFY = "{\mathcal{U}}"
%format UNIFY'
%format |-> = "{\!\!~\mapsto\!\!~}"
%format <@> = "<\!\!\!@\!\!\!>"
%format <@@> = "<\!\!\!@\!\!@\!\!\!>"
%format +++ = "\!\!+\!\!+\!\!+"
%format COMP = "{\circ}"
%format CW = "{\mathcal{CW}}"
%format MARGS = "{\overrightarrow{ys}}"
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
%format false = "false"
%format false_1
%format false_2
%format false_3
%format false_4
%format false_5
%format false_i
%format false_j
%format t = "t"
%format t_1
%format t_2
%format t_3
%format t_4
%format t_5
%format NIL = "[\!~]"
%format NIL_1
%format NIL_2
%format NIL_3
%format NIL_4
%format NIL_5
%format NIL_i
%format NIL_j
%format nil = "[\!~]"
%format nil_1
%format nil_2
%format nil_3
%format nil_4
%format nil_5
%format nil_i
%format nil_j
%format LIST = "list"
%format LIST_1
%format LIST_2
%format LIST_3
%format LIST_4
%format LIST_5
%format LIST_i
%format LIST_j
%format list = "list"
%format list_1
%format list_2
%format list_3
%format list_4
%format list_5
%format list_i
%format list_j
%format MAYBE = "maybe"
%format MAYBE_i
%format MAYBE_j
%format maybe = "maybe"
%format maybe_i
%format maybe_j
%format PAIR = "pair"
%format PAIR_i
%format PAIR_j
%format pair = "pair"
%format pair_i
%format pair_j
%format EITHER = "either"
%format EITHER_i
%format EITHER_j
%format either = "either"
%format either_i
%format either_j
%format INT = "int"
%format INT_1
%format INT_2
%format INT_3
%format INT_4
%format INT_i
%format INT_j
%format int = "int"
%format int_1
%format int_2
%format int_3
%format int_4
%format int_5
%format int_i
%format int_j
%format NAT = "nat"
%format NAT_1
%format NAT_2
%format NAT_3
%format NAT_4
%format NAT_i
%format NAT_j
%format nat = "nat"
%format nat_1
%format nat_2
%format nat_3
%format nat_4
%format nat_5
%format nat_i
%format nat_j
%format nat_k
%format nat_l
%format BOOL = "bool"
%format BOOL_1
%format BOOL_2
%format BOOL_3
%format BOOL_4
%format BOOL_5
%format BOOL_i
%format BOOL_j
%format bool = "bool"
%format bool_1
%format bool_2
%format bool_3
%format bool_4
%format bool_5
%format bool_i
%format bool_j
%format CHAR = "char"
%format CHAR_i
%format CHAR_j
%format char = "char"
%format char_i
%format char_j
%format STRING = "string"
%format STRING_i
%format STRING_j
%format string = "string"
%format string_i
%format string_j
%format INENV = "{\Gamma \vdash}"
%format LLB = "\llbracket"
%format RRB = "\rrbracket"
%format SEM (x) = "{\llbracket{}" x "\rrbracket{}}"
%format MARGS = "\vec{xs}"
%format MARGS' = "\vec{ys}"
%format <== = "\Leftarrow"
%if style == newcode

> import Test.QuickCheck

%endif

\author{Jurri\"en Stutterheim}
\title{Contract Inferencing for Functional Programs}

\begin{document}
\begin{titlepage}

\begin{center}


% Upper part of the page
\includegraphics[width=0.6\textwidth]{./uulogo}\\[0.75cm]

\textsc{\Large Department of Computing Science}\\[1.5cm]

\textsc{\Large MSc Thesis, ICA-3555003}\\[0.5cm]


% Title
\HRule \\[0.4cm]
{ \huge \bfseries Contract Inferencing for Functional Programs}\\[0.4cm]

\HRule \\[1.5cm]

% Author and supervisor
\begin{minipage}{0.4\textwidth}
\begin{flushleft} \large
\emph{Author:}\\
Jurri\"en \textsc{Stutterheim}
\end{flushleft}
\end{minipage}
\begin{minipage}{0.4\textwidth}
\begin{flushright} \large
\emph{Supervisor:} \\
Prof. dr.~J.T. \textsc{Jeuring}
\end{flushright}
\end{minipage}

\vfill

% Bottom of the page
{\large \today}

\end{center}

\end{titlepage}
\tableofcontents
\listoffigures

\begin{abstract}
  Ask-Elle is a programming tutor that allows students to learn Haskell at
  their own pace, without a teacher's direct supervision. To enable this, the
  tutor requires model solutions to be specified up front by a teacher, after
  which the tutor is able to guide the student towards one of these solutions.
  However, should the student deviate from the model solutions too much, the
  tutor can no longer give assistance. In an attempt to still provide the
  student with feedback once that happens, we propose using both QuickCheck and
  contracts to locate potential bugs in the student's program. Since we, in
  general, do not know anything about the structure of a student's solution, we
  propose and implement a method for inferring contracts for the student's
  program.
\end{abstract}

\chapter{Introduction}
Last year's (mandatory) bachelor level course in Functional Programming at
Utrecht University had over 200 bachelor students attending lectures and lab
sessions. While a great turn-up by itself, it is unfortunately practically
impossible to answer every student's questions during such busy lab sessions.
Once the lab sessions come to an end, the students that did not get to ask all
their questions won't be able to ask them until the next lab sessions. While
the teachers and assistants in the functional programming course had their
hands full with supporting all of the enrolled students, the number they had to
deal with pales in comparison with the numbers achieved in a relatively new
phenomenon, called MOOCs: Massive Open On-line Courses. In a single MOOC
instance, several tens of thousands of students from all over the world can
take part at the same time, usually free of charge.

As one can image, no single one teacher can assist that many students at the
same time, even with a small army of student assistants. So, instead of being
constantly guided by a professor or a teaching assistant, students need to be
able to study independently. While even in small courses, independent studying
is strongly encouraged, small courses have the advantage that students can ask
teachers and assistants for help when they get stuck. When classes reach the
size of the functional programming course at Utrecht University, or when they
reach a MOOC-level number of students, this gets significantly more difficult.
One solution may be to encourage students to do peer-reviews of the exercises
and help each other out when stuck. In practice, however, social barriers and
variable availability of fellow students may limit the amount of useful
feedback a student can receive. Automated teaching tools, also known as tutors,
can provide a solution to this problem. These tutors allow students to work at
home at their own pace, and provide consistent feedback on the student's
progress.

Gerdes et al.~\cite{Gerdes:ui} have developed a tutor, called Ask-Elle, that
assists students in doing exercises for a bachelor-level functional programming
course. In this course, students learn the basics of functional programming in
Haskell~\cite{PeytonJones:2010p548}. Students can choose from several
exercises, taken from the ``H-99: Ninety-Nine Haskell Problems'' exercise
set\footnote{\texttt{http://www.haskell.org/haskellwiki/99\_Haskell\_exercises}}.
After selecting an exercise, students are presented with a short problem
description and the type signature of the function they should implement. For
example, if a student selects the insertion-sort exercise, he may be presented
with a description similar to the following:

\begin{quote}
Write a function that sorts a list: |sort :: Ord a => [a] -> [a]|. For example:

\begin{verbatim}
Data.List> sort [3,2,6,8,1]
[1,2,3,6,8]
\end{verbatim}
\end{quote}

An empty text field is presented and the student can start working on the
exercise. If the student finds himself truly stuck, he can ask the tutor for a
hint. Should the student still be stuck after receiving the hint, he can ask
the tutor to give a tiny snippet of code to help him work towards a solution.
Finally, the student arrives at a solution, either with or without help from
the tutor.

Of course, the situation described above is an ideal situation where the
student implements a known solution to the problem at hand. In practice,
guiding a student towards a solution is quite a bit trickier. Before the tutor
can give hints, or tell the student that he has successfully completed the
exercises (or not), the tutor needs to know what constitutes a solution to that
specific exercise. Since the tutor cannot come up with programs by itself, a
teacher will need to input one or more so-called model solutions beforehand.
The tutor can then parse the model solutions and device
strategies~\cite{Heeren:2010dn, Gerdes:2010vt} for working towards these
solutions. When a student requests a hint, the tutor parses the student's
program, and tries to match it against the known model solutions, or variations
thereof.

Unfortunately, there are limits to the tutor's abilities to detect whether a
student's program is a variation of one of the model solutions. Once a student
deviates too much from all known model solutions, the tutor cannot assist the
student further. While it very well might be that the student has implemented a
correct program, the tutor cannot verify this any more. It is this situation
that this thesis will focus on. Can we still provide the student with useful
feedback, even when he has significantly deviated from the model solutions?
Can we do this even when their programs might not be completely implemented
yet? If a student has a bug in his program, can we find the bug's location and
point the student to it?

As it turns out, we can do so, to some extent. In this thesis, we develop a
method for inferring \textit{contracts} (for an introduction to contracts, see
Section~\ref{sec:contracts}) for functions and their sub-expressions. These
contracts can be used to approximately locate a bug. Combined with
QuickCheck~\cite{Claessen:2000p592}, we can automatically generate input that
triggers a contract violation. Specifically, this thesis makes the following
contributions:

\begin{itemize}
  \item We extend the Ask-Elle tutor to fall back on QuickCheck when strategies
    and model solutions fall short, even when programs still contain holes.
  \item We infer contracts for a function and all its sub-expressions.
  \item Using counter-examples from QuickCheck, contract inference, and program
    transformations, we locate the position of bugs in a program.
\end{itemize}

We introduce our solution in the following chapters:
Chapter~\ref{chp:background} provides the reader with background information on
the various concepts used in this thesis, describes the problem we have
attempted to solve, and motivates our proposed solution.
Chapter~\ref{chp:contract-inferencing} then continues with a formal and
technical description of our solution, after which
Chapter~\ref{chp:shortcomings} concludes with a discussion of the results and
future work.


\chapter{\label{chp:background}Background}

In this chapter we provide the reader with some background-information on the
various concepts that are used throughout this thesis, and we clarify the
problems that we have attempted to solve.

\section{\label{sec:tutor-strategies-quickcheck}Ask-Elle, strategies, and QuickCheck}

As mentioned in the introduction, the work we present here is motivated by the
Ask-Elle programming tutor; a programming tutor that allows students to work on
Haskell programming exercises at their own pace, without direct supervision of
a teacher, while still being able to receive feedback on their progress.
Enabling students to work by themselves in this way is more challenging than it
may sound. Not only does the tutor need to be sophisticated enough to know when
the student has finished an exercise, it also needs to be able to give the
student feedback when he gets stuck. Enabling this in Ask-Elle is done by
introducing \textit{strategies}~\cite{Gerdes:2010vt,Gerdes:ui,Gerdes:2012wh}.
When creating an exercise, all a teacher has to do is enter one or more model
solutions, which, in their simplest form, are just Haskell implementations of
possible solutions to the exercise in question. These model solutions are
parsed by the tutor and compiled into strategies. Using these strategies, the
tutor can identify whether a student is working towards one of the model
solutions, even if the variable names are different from the model solution, or
if the program structure is different.

Despite the fact that the tutor's strategy system is sophisticated enough to
recognise programs that deviate from a model solution, there are limits to this
ability. Another situation where the use of strategies may fall short is when
not all possible model solutions have been provided by the teacher, so the
tutor cannot guide the student towards potentially good solutions. Practically,
it is also impossible to come up with all possible model solutions, unless the
exercise is trivial.

Rather than forcing a teacher to spend all his time trying to input all
possible model solutions, we propose a different solution, which we have
implemented in the tutor. In addition to specifying model solutions, we ask the
teacher to also provide \textit{properties} for the exercise. These properties
are then used with QuickCheck~\cite{Claessen:2000p592} to use property-based
testing on the submitted exercise. For example, for a sorting function, |sort|,
we may define the following property:

\begin{spec}
  prop_Sort :: Ord a => [a] -> Bool
  prop_Sort xs = isNonDesc (sort xs) && isPermutation xs (sort xs)
    where  isPermutation xs ys = xs `elem` permutations ys
           isNonDesc (x : y : ys)  = x <= y && isNonDesc (y : ys)
           isNonDesc _             = True
\end{spec}

QuickCheck then proceeds to generate \textit{random} lists and applies the
property function to them. After |n| (by default 100) successful tests,
QuickCheck terminates and reports that, for these 100 random lists, |sort|
adheres to the |prop_Sort| property. Should the |sort| function have a bug
which causes it to violate the property, QuickCheck will produce a
\textit{counter-example}. It does by taking the randomly generated values and
\textit{shrinking} them. For example, suppose QuickCheck generates a list
|[2,0,1]|, which causes the property to fail. It will then try to to see if the
property still fails with the smaller list |[2,0]|. If it does, it will try
again with the even smaller list\footnote{In reality, QuickCheck generates
several other intermediate lists, but we omit them for brevity.} |[]|. Should
that succeed, it will return the counter-example |[2,0]| and show it to the
user.

Using QuickCheck, we can give the student some feedback, even though the tutor
is no longer able to use strategies to give exact feedback. If all tests
succeed, the tutor can inform the student that, even though it is not entirely
certain\footnote{There is always the chance that a counter-example is found
with the |n+1|th randomly generated value. Strictly speaking this also holds
true for finite data structures, because QuickCheck does not guarantee that all
permutations are tested.} that the implementation is correct, it certainly
looks like the student is doing the right thing. Should the property fail, then
the student is presented with a concrete counter-example, helping him to
manually debug the program code.

While the addition of QuickCheck is certainly an improvement over having no
feedback at all, it is still a sub-ideal way to give the student feedback.
After all, the only lead a student has to find out \textit{where} the bug in
his program is, is the counter-example. Can we do better? It turns out that we
can, by using \textit{contracts}, which will be introduced in the next section.

\subsection{Holes}
Before continuing with a section about contracts, we need to answer one more
question. Ask-Elle has the ability to analyse a student's incomplete program
and provide feedback on the student's progress, allowing the student to
incrementally develop his program. For this to work, the student needs to
explicitly indicate the \textit{holes} in the program. To incrementally
implement |map|, for example, we might go through the following steps, in which
|?| indicates a hole:

\begin{spec}
map = ?

map f xs = ?

map f []      = ?
map f (x:xs)  = ?

map f []      = []
map f (x:xs)  = ? : ?

map f []      = []
map f (x:xs)  = f x : map f xs
\end{spec}

But what happens if we want to run QuickCheck on the second-last case? Clearly
it is incomplete. QuickCheck supports a special |discard| exception since
version 2.5. If this exception is thrown by the property under test, QuickCheck
simply discards the test case and continues with a new one, until the given
number of test cases has been reached. In the programming tutor we replace all
holes with these |discard| exceptions, allowing us to QuickCheck students'
programs, even if they are incomplete. For our specific example, this means
that QuickCheck will need to generate |n| empty lists before the test succeeds.

% TODO: Say something about holes?

%- Schets context tutor
%- Vertel hoe de tutor werkt met strategies etc
%- Geef aan wat de grenzen van strategies zijn
%- Vertel dat QuickCheck een mogelijke oplossing is
%- Vertel kort over hoe QC in de tutor ingebakken zit
%- Vertel dat QC enkel een tegenvoorbeeld, randomly kan geven en niet in staat
%is om de lokatie van de fout te identificeren
%- Introduceer contracts als oplossing


\section{\label{sec:contracts}Contracts}

Contracts and the ``design by contract'' paradigm go back to at least Bertrand
Meyer~\cite{Meyer:0q21ig4Y,Mandrioli:1991vv}, who coined the term in the 1980s
in the context of his Eiffel~\cite{Meyer:1988wp} programming language. A
contract specifies restrictions and gives guarantees for functions, much like a
contract does so in real life between two parties. For example, a contract may
specify that a function requires a natural number as argument, and that,
provided a natural number is passed to the function, a natural number is
returned as a result.

If a contract is violated, an exception is thrown which can include the
location of the contract violation, and an indication as to which function is
to blame for the contract violation. Adding contracts to programs therefore
makes it easier to debug them, and incorporates tests in the program's code.

Contracts have been implemented in many imperative programming languages. Some
languages, such as Eiffel, incorporate contracts as a language feature, while
many of today's popular imperative programming languages support contracts as a
library.

Contracts for functional programming languages are less widely applied.
Nevertheless, contracts in functional languages are an active field of
research.  Findler and Felleisen~\cite{Findler:2002wha} were the first to
propose contracts for higher-order functions in Scheme~\cite{Sperber:2007ue}.
Later, in 2006, Xu~\cite{Xu:2006ul} introduced a static contract system, in
which contracts can be written in Haskell and checked, using symbolic
computation, at compile-time. Static contract systems like this share traits
with dependently typed programming languages and theorem provers. Xu's work was
followed by another paper in 2009, together with Peyton-Jones and
Claessen~\cite{Xu:2009vc}. An upcoming paper by Vytiniotis et
al.~\cite{Vytiniotis:2013ww} takes static contract checking a step further by
translating contracts into first-order logic formulae and using an
off-the-shelf theorem prover, to prove these formulae, rather than writing a
custom contract system from scratch. On the other end of the spectrum, there is
dynamic contract checking, which checks contracts at runtime. Hinze et
al.~\cite{Hinze:2006ju} presented a library for dynamic contract checking in
2006 which was completely implemented in Haskell, without the need for
modifications in the Haskell compiler. Based on the work by Hinze et al.,
Chitil~\cite{Chitil:2012ua} presents a newer library for typed lazy contracts,
also implemented as a library in Haskell, which is claimed to preserve a
program's lazy semantics, as opposed to the library by Hinze et al.

For this thesis we make use of the library by Hinze et al., called
\texttt{typed-contracts}, whenever we need a concrete implementation of
contracts. We chose this library mainly because we did not know of Chitil's
work until after we had started implementing our ideas with the
\texttt{typed-contracts} library. Concepts in this thesis should be portable to
other libraries, and likely also to static contract systems. Our choice for a
dynamic contract system is motivated by the desire to apply contracted
functions to QuickCheck counter-examples, which can only be obtained at
run-time, and by the fact that the dynamic contract systems are, at the moment
of writing, readily usable after simply installing them, while the current
static systems require installing experimental branches of GHC.


\subsection{\label{sec:asserting-implementing}Asserting and implementing contracts}

Contracts in the \texttt{typed-contracts} library have the same shape as the
type of the function for which they are defined. For example, a contract for a
function that goes from natural numbers to natural numbers is defined as
follows:

> nat >-> nat

In order to assert a contract for a given function, the contract needs to be
attached to, or wrapped around, the function first, which is done by the
|assert| function. We borrow Hinze et al.'s example of a contracted definition
of |head|, but change their naming convention to match our goals. When writing
a contracted version of a function |f|, we rename the original function to |f'|
and call the contracted version |f|.

\begin{spec}
  head :: [a] -> a
  head = assert (nonempty >-> true) (\xs -> head' xs)
\end{spec}

Since |head| is a partial function that is undefined for empty lists, we
require the input list to be non-empty, which is ensured by the |nonempty|
contract. From the type signature, we can see that the contracted |head| can be
used as a drop-in replacement for the original |head|. Given the type-signature
of |assert|, this is not surprising:

< assert :: Contract a -> (a -> a)

Given a contract, |assert| acts as a \textit{partial identity}. It is partial,
because the assertion raises an exception if the contract is violated.
In the original paper by Hinze et al., the |Contract| type was implemented as a
follows (using Generalised Algebraic Data Types; GADTs):

\begin{spec}
data Contract a where
  Prop       ::  (a -> Bool) -> Contract a
  Function   ::  Contract a -> (a -> Contract b) -> Contract (a :-> b)
  Pair       ::  Contract a -> (a -> Contract b) -> Contract (a, b)
  List       ::  Contract a -> Contract [a]
  And        ::  Contract a -> Contract a -> Contract a
\end{spec}

The |Prop| constructor takes a predicate and lifts it into a |Contract|, and
the |And| constructor represents the conjunction of two contracts. The meaning
of the remaining constructors is straight-forward. Note that both |Function|
and |Pair| take a function as section argument, rather than simply a |Contract
b|.  This allows you to model \textit{dependent function contracts} which allow
you to use values from function arguments in the Definition of the contract.
Section~\ref{sec:dependent-contracts} discusses dependent contracts in the
context of our work.  For this thesis, we have added two new constructors for
functors (types of kind |* -> *|) and bifunctors\footnote{Haskell's base
  packages do not provide the |Bifunctor| type class. Instead, we use the class
  found in the |Data.Bifunctor| module in the \texttt{bifunctors} package found
  on Hackage. This choice is rather arbitrary, and other bifunctor
  implementations are easily used instead.} (types of kind |* -> * -> *|) to
  the |Contract| GADT, which allow us to abstract over the |Pair| and |List|
  constructors:

\begin{spec}
data Contract a where
  Prop       ::  (a -> Bool) -> Contract a
  Function   ::  Contract a -> (a -> Contract b) -> Contract (a :-> b)
  Pair       ::  Contract a -> (a -> Contract b) -> Contract (a, b)
  List       ::  Contract a -> Contract [a]
  Functor    ::  Functor f => Contract a -> Contract (f a)
  Bifunctor  ::  Bifunctor f => Contract a -> Contract b -> Contract (f a b)
  And        ::  Contract a -> Contract a -> Contract a
\end{spec}

In its simplest form, |assert|'s implementation is straight-forward and follows
the |Contract| GADT closely:

\begin{spec}
assert  ::  Contract a -> (a -> a)
assert  (Prop p)           a         =  if p a then a else error "contract failed"
assert  (Function c1 c2)   f         =  (\ x' -> (assert (c2 x') `o` f) x') `o` assert c1
assert  (Pair c1 c2)       (a1, a2)  =  (\ a1' -> (a1', assert (c2 a1') a2)) (assert c1 a1)
assert  (List c)           as        =  map (assert c) as
assert  (Functor c)        as        =  fmap (assert c) as
assert  (Bifunctor c1 c2)  as        =  bimap (assert c1) (assert c2) as
assert  (And c1 c2)        a         =  (assert c2 `o` assert c1) a
\end{spec}

Asserting a |Prop p| simply applies the predicate |p| to the value |a|. If the
predicate holds, |assert| acts as identity. If not, it raises an exception,
signalling that the contract is violated. In case of a |Function| contract, we
build up a new function in which the contract assertions are inlined. When this
new function is applied to some argument, the contract for the function's
domain is first asserted. Provided the first contract succeeds, the result
value is used for the assertion of the co-domain contract. A |Pair| contract is
similar in this respect, as it first asserts the contract for the left element,
after which the left element's value is passed on to the right element's
contract.  Asserting |List|, |Functor|, and |Bifunctor| is straight-forward, as
it just involves applying the corresponding homomorphisms. Lastly, the |And|
contract requires that both contracts hold for the same value.

As Hinze et al. already indicate, and what the implementation also shows, is
that the contracts for |Pair| and |List| follow a similar pattern. This
observation is strengthened by the way |assert| is implemented for |Functor|
and |Bifunctor|. Repeating what Hinze et al. already note in their paper, for
some arbitrary container type |T|, we can define an assertion

< assert (T c_1 DOTS c_n) = mapT (assert c_1) DOTS (assert c_n)

for some mapping function |mapT| for that specific type |T|.

|assert|'s actual implementation is a bit more involved, as it needs to cope
with proper blame-assignment in which the correct function is identified as
violating a contract. For a more detailed discussion about blame assignment,
see the original paper. The simplified implementation above suffices for this
thesis.

To make defining contracts more intuitive, the contract library exposes several
convenience functions:

\begin{spec}
c1  >->   c2         = Function c1 (const c2)
c1  >>->  c2         = Function c1 c2
(&)                  = And
c1  <@>    c2        = c1 & Functor c2
c1  <@@>   (c2, c3)  = c1 & Bifunctor c2 c3
\end{spec}

Of these convenience functions, the last two are the most interesting. Instead
of being a simple wrapper for the |Functor| and |Bifunctor| contracts, they are
a conjunction of the (bi)functor contracts and some other contract |c1|. As an
intuitive example of why this should be necessary, consider a list of integers.
We could define a |List| contract that ensures that the list contains only
natural numbers. However, knowing that a list contains only natural numbers
does not say anything about the list as a whole. After all, we might want to
require that the list be sorted, which can only be checked on the complete
list. Our last two convenience functions combine the \textit{outer contract}
|c1|, with which properties such as sorting can be captured, and \textit{inner
contract(s)}, with which properties like natural numbers can be captured.
Capturing both outer and inner contracts at the same time is easy enough when
defining contracts by hand, so having a convenience function available might
not be a big improvement. However, as we will see in
Chapter~\ref{chp:contract-inferencing}, these abstraction become very useful
when inferring contracts.
%TODO: Review bit above

With the |Contract| type and the convenience functions, we can define concrete
contracts, the most extreme of which are the |true| and |false| contracts. The
|true| contract always succeeds, while the |false| contract never succeeds and
always raises an exception. An example where both are used is the |const|
function, which always returns its first argument and always discards its
second argument. Its contract can be defined as follows:

< true >-> false >-> true

However, since |true| always succeeds, a perfectly valid, albeit less precice,
contract for |const| is

< true >-> true >-> true

and even just

< true

in which case the |true| contract will just accept the |const| function as a
whole.

We can also specify higher-order contracts, and using the (bi)functor
contracts, we can also write contracts that closely follow the function's type.
For example, for

< map :: (a -> b) -> [a] -> [b]

we can define a contract

< (c_1 >-> c_2) >-> (c_3 <@> c_1) >-> (c_4 <@> c_2)

for some contracts |c_1, c_2, c_3| and |c_4|. Since lists are functors, we
choose to use the functor function here. The resulting contract looks very
similar to |map|'s type. Contracts for universally quantified type variables
behave very much like the type variables; the same type variable gets the same
inner contract. However, we cannot, in general, say anything about the
relationship between the two lists, so we assign them (potentially) different
outer contracts.


\subsection{Contracts in Ask-Elle}
As mentioned in Section~\ref{sec:tutor-strategies-quickcheck}, QuickCheck is
only able to give us a counter-example, and cannot tell us where in the program
the property is being violated. Contracts, on the other hand, are ideally
suited to locate the source of a property-violation, since they can be added to
every single function in a program. In the context of Ask-Elle, however, we
cannot expect the student to manually annotate the program with contracts, and
since we are working in the situation where strategies can no longer help us,
we cannot rely on strategies to annotate the program with contracts either.
Luckily, all is not lost. What we do know is \textit{which} function the
student is currently trying to implement, even though we do not know
\textit{how} the student is implementing it. Since we know which function the
student is implementing, we can, at the very least, specify a contract for the
top-level function. Together with this top-level contract, we can then try to
\textit{infer} contracts for the rest of the program, much in the same way as
types are being inferred by a compiler's type-checker in the presence of an
explicit type signature. How this process works is detailed in
Chapter~\ref{chp:contract-inferencing}. With a fully contracted program, and a
QuickCheck counter-example, we are in a very good position to find the location
of a bug. After all, we know for a fact that the counter-example is an input
for which the function's property fails.  Therefore, if a function is
completely covered with contracts, applying it to the counter-example should
lead us to the location of the bug.

We are not the first to propose inferring contracts. Dynamically
inferring program invariants in imperative programming languages goes back to
at least Ernst's dissertation~\cite{Ernst:2000uf} in 2000. Static invariant
analysis goes back even further, to work by Cousot and
Cousot~\cite{Cousot:1977bk} in 1977. One can even argue that Hoare's work on
axiomatising computer programming~\cite{Hoare:1969wt} can be seen as one of the
first forms of static contract inferencing. More recently, Cousot et
al.~\cite{Cousot:2012tl} describe a method for inferring contracts for
extracted methods in imperative languages. In between Hoare's original
publication and Cousot's latest publication, a vast collection of work on
deducing contracts for imperative programs is available, which mostly focusses
on use-cases in C or Java. Contract inference for functional programs is
significantly less well explored, however. To our knowledge, this thesis is the
first to describe contract inferencing for (modern) functional languages.



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                    Chapter contract inferencing                          %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\chapter{\label{chp:contract-inferencing}Contract inferencing}
Contract inferencing is the process of automatically deducing contracts from a
program's implementation. In many ways contract inferencing is similar, and in
some places identical, to type inferencing as described by Damas and
Milner~\cite{Damas:1982ve}, both conceptually and practically.

In contract inferencing, we want to achieve the following goals:

\begin{itemize}
  \item Infer a well-typed contract for every function in a program
  \item Inferred contracts must allow a (non-strict) subset of the values
    allowed by the types
  \item The most general inferred contract must never fail an assertion
\end{itemize}

We have developed a contract system and an inferencing algorithm that is
heavily based on Milner's Algorithm \W~\cite{Milner:1978kx}, Damas and Milner's
extension of this algorithm, and, like Damas and Milner's work, uses Robinson's
unification algorithm~\cite{Robinson:1965wt}. Our contracting system and our
inferencing algorithm, called Algorithm \CW, will be discussed in
Section~\ref{sec:the-contract-system}.  The inferencing has some shortcomings,
which will be discussed in Chapter~\ref{chp:shortcomings}.


\section{\label{sec:lam-c}The \lc~language}
In order to explore the problem of contract inferencing, and develop our
contract inferencing algorithm, we have created a small, simple let-polymorphic
expression language called \lc, presented in Figure~\ref{fig:expr-grammar}.
While this language is in no way suited for day-to-day programming, it features
the main concepts of full-fledged functional programming languages, such as
Haskell, hence we expect that the results from this thesis carry over to more
mature languages.

\begin{figure}[ht]
\begin{center}
\begin{spec}
expr   ::=  x                               -- Variable
        |   \ expr -> expr                  -- Lambda abstraction
        |   expr expr                       -- Application
        |   let expr = expr in expr         -- Let binding
        |   case expr of                    -- Case block
              { expr -> expr (; expr -> expr)* }
        |   const                           -- Constants
        |   expr : expr                     -- List cons constructor
        |   []                              -- List nil constructor
        |   Just expr                       -- Maybe Just constructor
        |   Nothing                         -- Maybe Nothing constructor
        |   (expr, expr)                    -- Pair
        |   Left expr                       -- Either left constructor
        |   Right expr                      -- Either right constructor
        |   expr BIN expr                   -- Binary operation
        |   ?                               -- Holes


const  ::=  n                               -- Integers
        |   b                               -- Booleans
        |   c                               -- Characters
        |   s                               -- Strings
\end{spec}
\end{center}
\caption{\label{fig:expr-grammar}Grammar for the expression language}
\end{figure}

In addition to the usual lambda calculus expressions, |let|-blocks, and
|case|-blocks, the language has support for constants, built-in support for
several data-types, such as lists, |Maybe|, pairs, and |Either|, and binary
operations. To simulate the programming tutor, the language also supports
holes, denoted by a question mark. With its basis in the lambda calculus, and
due to its declarative nature, it is not hard to imagine that we can apply
Algorithm \W~to infer types in this language.
Section~\ref{sec:the-contract-system} will confirm that we can also infer
contracts for this language.


\section{\label{sub:formalising-contract-language}Formalising the contract
language}

We define a contract language that is agnostic of a specific contract library.
The grammar of this language is formalised in
Figure~\ref{fig:contract-grammar}. Since our implementation uses the contract
library by Hinze et al.~\cite{Hinze:2006ju}, the language is inspired by their
notation and the notation of our additions to the library. Contracts for
specific libraries can be generated from our language. In this thesis, we
generate contracts for the library by Hinze et al., but we can also generate
code for other libraries, such as the library by Chitil~\cite{Chitil:2012ua}.

\begin{figure}[ht]
\begin{center}
\begin{spec}
  -- Contracts
  c             ::=  {-"\rho_{\alpha}"-}                                        -- User-defined concrete contract
                |    {-"true_{\alpha}"-}                                        -- true contract
                |    {-"false_{\alpha}"-}                                       -- false contract
                |    {-"c_{\alpha}"-} >-> {-"c_{\beta}"-}                       -- Function contracts
                |    {-"c_{\alpha}"-} <@> {-"c_{\beta}"-}                       -- Functor contracts
                |    {-"c_{\alpha}"-} <@@> ({-"c_{\beta}"-}, {-"c_{\gamma}"-})  -- Bifunctor contracts
                |    {-"int_{\alpha}"-}                                         -- Succeeds for all integers, and only for integers
                |    {-"bool_{\alpha}"-}                                        -- Succeeds for all booleans, and only for all booleans
                |    {-"char_{\alpha}"-}                                        -- Succeeds for all characters, and only for all characters
                |    {-"string_{\alpha}"-}                                      -- Succeeds for all strings, and only for all strings
                |    {-"list_{\alpha}"-}                                        -- Succeeds for all lists, and only for all lists
                |    {-"either_{\alpha}"-}                                      -- Succeeds for all |Either|s, and only for all |Either|s
                |    {-"maybe_{\alpha}"-}                                       -- Succeeds for all |Maybe|s, and only for all |Maybe|s
                |    {-"pair_{\alpha}"-}                                        -- Succeeds for all pairs, and only for all pairs

  -- Contract schemes
  {-"\sigma"-}  ::=  c                                                          -- Contract
                |    {-"\forall{true_{\alpha}}.\sigma"-}                        -- Universal quantification for contract indices
\end{spec}
\end{center}
\caption{\label{fig:contract-grammar}Grammar for the contract language}
\end{figure}

A contract is a user-defined concrete contract, a |true| contract which never
fails, a |false| contract which always fails, a contract for functions, which
goes from a contract to a contract, or a contract for (bi)functors. We also
explicitly add terminals for constants and data types, which serve as default
contracts for the corresponding types. Lastly, we have contract schemes, with
which we can universally quantify over |true| contracts. We will see that these
contracts can be refined by unifying with more specific contracts.

Contracts for |true|, |false|, and the data types have an index $\alpha$ in
order to distinguish between two instances of the same contract. We will omit
the indices in our examples when doing so does not lead to ambiguity. Why we
need indices will be discussed in Section~\ref{sec:unif-sub}. For now it
suffices to know when two contracts are different, or stated otherwise, when
they are equivalent:

\begin{defn}[Equivalency of contracts]\label{def:contract-equivalency}
  $c_i \equiv d_j$ iff $c \equiv d$ and $i \equiv j$.
\end{defn}


\section{\label{sec:contract-relations}Contract relations}
In Haskell, a function's type statically guarantees that a function will be
applied to a value of that type. Haskell's type system guarantees that a
function |f| of type |Int -> Int| is only applied to an integer in the range
$[-2^{29}, 2^{29}-1]$ on a 32 bit machine, and that it returns an integer in
the same range as result. Any contract we infer for |f| must allow a subset of
integers in that range as well. Since we know from the types that |f| ranges
over integers, we can infer the contract

< int_1 >-> int_2

for it. If possible, however, we still want to refine this contract, since by
itself it does not offer more guarantees than Haskell's type system; it always
succeeds. We want to be able to make the contract more specific and allow a
smaller subset of Haskell values. By making a contract more specific than the
types, we enable it to fail assertion. For example, suppose we know that |f|
does not range over all integers, but only over the natural numbers. We want to
be able to make |f|'s contract more specific and replace it with the contract

< nat_1 >-> nat_2

In order to know when we can make a contract more specific, we need to define
relations between contracts. By regarding contracts as sets of Haskell values,
we can do so. We formalise this idea in Definition~\ref{def:contracts-as-sets}.

\begin{defn}[Semantics of contracts]\label{def:contracts-as-sets}
  The semantics of a contract $c$, written $\sem{c}$, is defined as the set of
  Haskell values for which it never fails assertion.
\end{defn}

From Definition~\ref{def:contracts-as-sets} follows that |SEM(true)| is the set
of all Haskell values, since assertion never fails, and |SEM(false)| is the
empty set, since assertion always fails. The semantics of any contract is
therefore a subset of |SEM(true)| and a superset of |SEM(false)|. We formalise
this thought in Proposition~\ref{prop:c-true-false}.

\begin{prop}[Contract relations with |true| and
  |false|]\label{prop:c-true-false} For all contracts |c|, $\sem{false}
  \subseteq \sem{c} \subseteq \sem{true}$
\begin{proof}
  This follows from the definition of |SEM (false)|, |SEM (true)| and $\subseteq$.
%%If |c=false|, then $false \subseteq false \subseteq true$, which
%%holds. If |c=true|, then $false \subseteq true \subseteq true$, which holds.
%%For any other |c|, since |true| is the set of all Haskell values, |c| can never
%%contain values that are not in |true|.
\end{proof}
\end{prop}

Using these subset relations, we can refine contracts and make them more
specific, increasing the chances that a contract assertion will fail, thereby
locating a potential bug in the program. If $\sem{c_1} \subseteq \sem{c_2}$,
then we can substitute $\sem{c_1}$ for $\sem{c_2}$ during refinement. With the
subset relation we keep the property that if an assertion fails for $c_2$, it
will also fail for $c_1$ (Proposition~\ref{prop:subfail}), and conversely that
if assertion succeeds for $c_1$, it will also succeed for $c_2$
(Proposition~\ref{prop:supsuc}).

\begin{prop}[Assertion fails for subset]\label{prop:subfail}
  For all contracts $c_1$, $c_2$, if $\sem{c_1} \subseteq \sem{c_2}$ and
  |assert c_2 e = blame|, then |assert c_1 e = blame|.
  \begin{proof}
    By Definition~\ref{def:contracts-as-sets} we can restate this in terms of
    sets: for all contracts $c_1$, $c_2$, if $\sem{c_1} \subseteq \sem{c_2}$
    and $e \notin \sem{c_2}$, then $e \notin \sem{c_1}$. This follows from the
    set-theoretic definitions of $\subseteq$ and $\notin$.
  \end{proof}
\end{prop}

\begin{prop}[Assertion succeeds for superset]\label{prop:supsuc}
  For all contracts $c_1$, $c_2$, if $\sem{c_1} \subseteq \sem{c_2}$ and
  |assert c_1 e = e|, then |assert c_2 e = e|.
  \begin{proof}
    By Definition~\ref{def:contracts-as-sets} we can restate this in terms of
    sets: for all contracts $c_1$, $c_2$, if $\sem{c_1} \subseteq \sem{c_2}$
    and $e \in \sem{c_1}$, then $e \in \sem{c_2}$. This follows from the
    set-theoretic definitions of $\subseteq$ and $\in$.
  \end{proof}
\end{prop}

The semantics of function contracts also adheres to the subset relation. For
example,

< true_1 >-> true_2

is the contract of all functions. Using Proposition~\ref{prop:c-true-false}, we
can order it as follows

< {-"\sem{false} \subseteq{} \llbracket{}"-} true_1 >-> true_2 {-"\rrbracket{} \subseteq{} \sem{true_3}"-}

Since not all Haskell values are functions and |SEM (true_1 >-> true_2)| is not
empty, we can even make this a strict subset relation:

< {-"\sem{false} \subset{} \llbracket{}"-} true_1 >-> true_2 {-"\rrbracket{} \subset{} \sem{true_3}"-}

Intuitively, it seems likely that we can use the subset relation for two
function contracts as well. For example, if we have two contracts |nat| and
|int|, for which holds that $\sem{nat} \subseteq \sem{int}$ (which follows from
the conventional mathematical subset relation between natural numbers and
integers), we can imagine that

< {-"\llbracket{}"-} nat >-> nat {-"\rrbracket{} \subseteq{} \llbracket{}"-} int >-> int {-"\rrbracket{}"-}

holds as well. We show that this is indeed the case in
Proposition~\ref{prop:sub-fun}.

%TODO: Kunnen we het nog aannemelijker maken dat je de contracten zo kan vervangen?
\begin{prop}[Superset relation for function contract semantics]\label{prop:sub-fun}
  For all contracts $c_1, c_2, c_3, c_4$, if $\sem{c_1} \subseteq \sem{c_2}$
  and $\sem{c_3} \subseteq \sem{c_4}$, then |SEM(c_1 >-> c_3)| |SUBSETEQ|
  |SEM(c_2 >-> c_4)|.
\begin{proof}
  By Proposition~\ref{prop:supsuc}, we can reason that if |assert (c_1 >-> c_3)
  f = f| implies |assert (c_2 >-> c_4) f = f|, then |SEM(c_1 >-> c_3)|
  |SUBSETEQ| |SEM(c_2 >-> c_4)|. We show this by equational reasoning.
  \begin{description}
    \item[H1] $\sem{c_1} \subseteq \sem{c_2}$
    \item[H2] $\sem{c_3} \subseteq \sem{c_4}$
  \end{description}
  \begingroup
  \def\commentbegin{\quad\{\ }
  \def\commentend{\}}
  \begin{spec}
          assert (c_1 >-> c_3) f = f
      ==  {- Definition of |(>->)| and |assert| -}
          \ x' -> (assert (const c_3 x') COMP f) x' COMP assert c_1 = f
      ==  {- Definition of |const| -}
          \ x' -> (assert c_3 COMP f) x' COMP assert c_1 = f
      =>  {- Apply H1 by Proposition~\ref{prop:supsuc} -}
          \ x' -> (assert c_3 COMP f) x' COMP assert c_2 = f
      =>  {- Apply H2 by Proposition~\ref{prop:supsuc} -}
          \ x' -> (assert c_4 COMP f) x' COMP assert c_2 = f
      ==  {- Definition of |const| -}
          \ x' -> (assert (const c_4 x') COMP f) x' COMP assert c_2 = f
      ==  {- Definition of |assert| and |(>->)| -}
          assert (c_2 >-> c_4) f = f
  \end{spec}
  \endgroup
\end{proof}
\end{prop}

A variation of the proof of Proposition~\ref{prop:sub-fun} can be given by
using Proposition~\ref{prop:subfail} instead and by starting with |assert (c_2
>-> c_4) f = blame|. For our example, we can now use
Proposition~\ref{prop:sub-fun} to refine the function contract

< int_1 >-> int_2

to

< nat_1 >-> nat_2

%With contracts defined as sets, we can define a partial order on them, with the
%subset relation as binary operation (Definition~\ref{def:poset}).
%
%\begin{defn}[Partially ordered set for contracts]\label{def:poset}
%Contracts form a partially ordered set $(C, \subseteq)$, where $C$ is the set
%of contracts.
%\end{defn}
%
%Having defined contracts as a poset, we can also define a lattice for
%contracts, in which top and bottom are represented by |true| and |false|, and
%meet and join by the set intersection and union, respectively
%(Definition~\ref{def:lattice}).
%
%\begin{defn}[Lattice for contracts]\label{def:lattice}
%  The partially ordered set $(C, \subseteq)$ for contracts forms a lattice,
%  with |true| as top, |false| as bottom, union $\cup$ as meet, and intersection
%  $\cap$ as join.
%\end{defn}



\section{\label{sec:the-contract-system}The contract system}

This section describes a contracting system with which we can infer contracts
from expressions. In this system, $\Gamma$ represents a \textit{contract
environment} that maps variables to contracts and is defined as

\begin{doublespace}
  $\Gamma ::= [\!~]\!~||\!~\Gamma_1[x \mapsto c]$
\end{doublespace}

where $\Gamma$ is either the empty environment, or some environment $\Gamma_1$
extended by a mapping from some variable $x$ to some contract $c$. We write
$\Gamma(x)=c$ if the right-most binding for $x$ in $\Gamma$ maps $x$ to $c$.
For a contracting relation, we write $\Gamma \vdash e : c$ to denote that in
environment $\Gamma$, expression $e$ has contract $c$.  We write $fc(\sigma)$
for the set of |true| contracts that appear free in contract scheme $\sigma$,
and $fc(\Gamma)$ for the set of |true| contracts that appear free in codomain
of $\Gamma$. In addition, we define two support functions, shown in
Figure~\ref{fig:gen-inst}.

\begin{figure}[H]
\begin{center}
\begin{spec}
gen :: Environment -> ContractScheme -> ContractScheme
gen GAMMA c = {-"\forall true_i. \ldots \forall true_n. "-} c
  where {{-"true_i, \ldots, true_n"-}} = {-"fc(c)\setminus{fc(\Gamma)}"-}

inst :: ContractScheme -> ContractScheme
inst ({-"\forall true_i, \ldots, \forall true_n"-}. c) = {-"[true_i\mapsto{true}_{i^\prime}]\ldots[true_n\mapsto{true}_{n^\prime}]"-}c
  where {-"true_{i^\prime},\ldots,true_{n^\prime}"-} are fresh
\end{spec}
\end{center}
\caption{\label{fig:gen-inst}Generalization and instantiation functions}
\end{figure}

Starting from the top, |gen| generalises a contract by introducing universally
quantified |true| contracts. Any |true| contract that occurs free in the
contract and is not bound in the environment is quantified over. Instantiation,
implemented by |inst|, removes the quantifiers and replaces all
previously-bound |true| contracts with fresh ones. Both |gen| and |inst| are
essentially the same as in Damas-Milner type inference, except we quantify over
indexed |true| contracts, rather than type variables. Finally, we present the
contracting rules in Figure~\ref{fig:inference-rules}.

\begin{figure}[H]
\begin{center}
%  \RightLabel{C-Inst\quad}
%  \AxiomC{$\Gamma \vdash$ |e ::| $\forall{\alpha}.\sigma$}
%  \UnaryInfC{$\Gamma \vdash$ |e ::| $[\alpha \mapsto c]\sigma$}
%  \DisplayProof
  \RightLabel{\textsc{C-Var}\quad}
  \AxiomC{$\Gamma(x) = c$}
  \UnaryInfC{$\Gamma \vdash$ |x :: inst(c)|}
  \DisplayProof
  \RightLabel{\textsc{C-Lam}\quad}
  \AxiomC{$\Gamma[x \mapsto c_1] \vdash$ |e :: c_2|}
  \UnaryInfC{$\Gamma \vdash$ |\ x -> e :: c_1 >-> c_2|}
  \DisplayProof
  \vskip 0.5em
  \RightLabel{\textsc{C-App}\quad}
  \AxiomC{$\Gamma \vdash$ |e_1 :: c_2 >-> c|}
  \AxiomC{$\Gamma \vdash$ |e_2 :: c_2|}
  \BinaryInfC{$\Gamma \vdash$ |e_1 e_2 :: c|}
  \DisplayProof
  \RightLabel{\textsc{C-True}\quad}
  \AxiomC{$fresh(i)$}
  \UnaryInfC{$\Gamma \vdash$ |e :: true_i|}
  \DisplayProof
  \vskip 0.5em
%  \RightLabel{C-Gen\quad}
%  \AxiomC{$\Gamma \vdash$ |e ::| $\sigma$}
%  \AxiomC{$\alpha \notin fc(\Gamma)$}
%  \BinaryInfC{$\Gamma \vdash$ |e :: forall ALPHA. SCHEME|}
%  \DisplayProof
  \vskip 0.5em
  \RightLabel{\textsc{C-Let}\quad}
  %\AxiomC{$\Gamma[x \mapsto fresh(c_0)] \vdash$ |e_1 :: c_1|}
  \AxiomC{$\Gamma[x \mapsto c_1] \vdash$ |e_1 :: c_1|}
  \AxiomC{$\Gamma[x \mapsto gen_{\Gamma}(c_1)] \vdash$ |e_2 :: c|}
  \BinaryInfC{$\Gamma \vdash$ |let x = e_1 in e_2 :: c|}
  \DisplayProof
  \vskip 0.5em
  \RightLabel{\textsc{C-Cons}\quad}
  \AxiomC{$\Gamma \vdash$ |x :: c|}
  \AxiomC{$\Gamma \vdash$ |xs :: list <@> c|}
  \BinaryInfC{$\Gamma \vdash$ |(x : xs) :: list <@> c|}
  \DisplayProof
  \RightLabel{\textsc{C-Nil}\quad}
  \AxiomC{|fresh(i, j)|}
  \UnaryInfC{$\Gamma \vdash$ |[] :: LIST_i <@> true_j|}
  \DisplayProof
  \vskip 0.5em
  \RightLabel{\textsc{C-Just}\quad}
  \AxiomC{$\Gamma \vdash$ |x :: c|}
  \AxiomC{|fresh(i)|}
  \BinaryInfC{$\Gamma \vdash$ |Just x :: MAYBE_i <@> c|}
  \DisplayProof
  \vskip 0.5em
  \RightLabel{\textsc{C-Nothing}\quad}
  \AxiomC{|fresh(i, j)|}
  \UnaryInfC{$\Gamma \vdash$ |Nothing :: MAYBE_i <@> true_j|}
  \DisplayProof
  \vskip 0.5em
  \RightLabel{\textsc{C-Pair}\quad}
  \AxiomC{$\Gamma \vdash$ |x :: c_1|}
  \AxiomC{$\Gamma \vdash$ |y :: c_2|}
  \AxiomC{|fresh(i)|}
  \TrinaryInfC{$\Gamma \vdash$ |(x, y) :: PAIR_i <@@> (c_1, c_2)|}
  \DisplayProof
  \vskip 0.5em
  \RightLabel{\textsc{C-EitherL}\quad}
  \AxiomC{$\Gamma \vdash$ |x :: c_1|}
  \AxiomC{|fresh(i, j)|}
  \BinaryInfC{$\Gamma \vdash$ |Left x :: EITHER_i <@@> (c_1, true_j)|}
  \DisplayProof
  \vskip 0.5em
  \RightLabel{\textsc{C-EitherR}\quad}
  \AxiomC{$\Gamma \vdash$ |x :: c_2|}
  \AxiomC{|fresh(i, j)|}
  \BinaryInfC{$\Gamma \vdash$ |Right x :: EITHER_i <@@> (true_j, c_2)|}
  \DisplayProof
%  \RightLabel{C-Finalize}
%  \AxiomC{$\Gamma(x) = c$}
%  \UnaryInfC{$\Gamma \vdash$ |x :: finalize(c)|}
%  \DisplayProof
  \RightLabel{\textsc{C-Hole}}
  \AxiomC{|fresh(i)|}
  \UnaryInfC{$\Gamma \vdash$ |? :: true_i|}
  \DisplayProof
  \vskip 0.5em
  \RightLabel{\textsc{C-Integer}}
  \AxiomC{|n| is an integer}
  \AxiomC{|fresh(i)|}
  \BinaryInfC{$\Gamma \vdash$ |n :: INT_i|}
  \DisplayProof
  \vskip 0.5em
  \RightLabel{\textsc{C-Boolean}}
  \AxiomC{|b| is a boolean}
  \AxiomC{|fresh(i)|}
  \BinaryInfC{$\Gamma \vdash$ |b :: BOOL_i|}
  \DisplayProof
  \vskip 0.5em
  \RightLabel{\textsc{C-Character}}
  \AxiomC{|c| is a character}
  \AxiomC{|fresh(i)|}
  \BinaryInfC{$\Gamma \vdash$ |c :: CHAR_i|}
  \DisplayProof
  \vskip 0.5em
  \RightLabel{\textsc{C-String}}
  \AxiomC{|s| is a string}
  \AxiomC{|fresh(i)|}
  \BinaryInfC{$\Gamma \vdash$ |s :: STRING_i|}
  \DisplayProof
  \vskip 0.5em
  \RightLabel{\textsc{C-Case}}
  \AxiomC{$\Gamma \vdash$ |m :: c_1|}
  \AxiomC{$\forall{i}\in[0\ldots{n}] \Gamma \vdash$ |p_i :: c_1|}
  \AxiomC{$\forall{i}\in{[0\ldots{n}]} \Gamma \vdash$ |e_i :: c_2|}
  \TrinaryInfC{$\Gamma \vdash$ |case m of {p_0 -> e_0; DOTS; p_n -> e_n} :: c_2|}
  \DisplayProof
  \vskip 0.5em
  \RightLabel{\textsc{C-BinOp}}
  \AxiomC{$\Gamma \vdash$ |e_1 :: c_1|}
  \AxiomC{$\Gamma \vdash$ |e_2 :: c_2|}
  \AxiomC{$\Gamma \vdash \oplus$|:: c_1 >-> c_2 >-> c_3|}
  \TrinaryInfC{$\Gamma \vdash e_1 \oplus e_2 :: c_3$}
  \DisplayProof
\end{center}
\caption{\label{fig:inference-rules}Contracting rules}
\end{figure}

We will not discuss the rules for \textsc{C-Var}, \textsc{C-Lam} and
\textsc{C-App}, because they are the same as in Damas and Milner's work. Not
explicitly described by Damas and Milner, however, is our treatment of data
types. After all, a data type can be converted into a lambda expression, after
which the rules for the lambda calculus apply again. Our explicit modelling of
functors and bifunctors in the contract language also requires us to explicitly
specify contract rules for these contracts. In addition to the data types, the
following paragraph will also expand on the rule for \textsc{C-True} and the
rules for case blocks and binary operators.

Starting with \textsc{C-True}, we see that at any time we can create a |true|
contract for an expression. After all, the |true| contract succeeds for all
Haskell values, including functions. Continuing with with the case for
\textsc{C-Nil}, we get a list functor contract with fresh indices. Since we
know nothing about the contract of either the inner, or the outer contract,
both contracts need to be fresh. The same holds for \textsc{C-Nothing}. In the
case for \textsc{C-Cons}, we do know the contract for the element in the list.
This element needs to have the same contract as the inner contract of the tail
of the list in the same way that elements of a list need to have the same type.
Hence, given that the element on top of the list has the same contract as the
inner contract of the tail of the list, we can give it the same contract as for
the tail of the list. For \textsc{C-Just}, we already know the contract for the
variable inside the |Just|, but we need a fresh |just| contract for the outer
contract. \textsc{C-Pair}, although it being a bifunctor, works similarly to
\textsc{C-Just}, with the difference that it has two inner elements. The cases
for \textsc{C-EitherL} and \textsc{C-EitherR} are more interesting. For either
constructor, we can only know one of the inner contracts: either the left, or
the right one. As a result, we need a fresh |true| contract for one of the
inner contracts. Next, we have a case for a hole in a program, \textsc{C-Hole}.
Since we cannot say anything about the contract of the hole, we just create a
single fresh |true| contract. For each of the constants, such as integers,
strings, characters, and booleans, we give a fresh type-specific contract.
\textsc{C-Case} describes contract inference for case blocks with an arbitrary
number of cases. Lastly, \textsc{C-BinOp} describes how we deal with binary
operators.


\subsection{Applying the contract rules}

We present three examples to intuitively show how we can use our contracting
rules from Figure~\ref{fig:inference-rules} to deduce contracts from
expressions. To save horizontal space on the page, we write |t| for the |true|
contract.

\subsubsection*{|const|}
\begin{prooftree}
        \AxiomC{$\Gamma[x \mapsto t_1, y \mapsto t_2](x)=t_1$}
      \UnaryInfC{$\Gamma[x \mapsto t_1, y \mapsto t_2] \vdash$ |x :: t_1|}
    \UnaryInfC{$\Gamma[x \mapsto t_1] \vdash$ |\ y -> x :: t_2 >-> t_1|}
  \UnaryInfC{$\Gamma \vdash$ |\ x -> \ y -> x :: t_1 >-> t_2 >-> t_1|}
\end{prooftree}


\subsubsection*{|fix|}
\begin{prooftree}
    \AxiomC{left subtree}
      \AxiomC{$\Gamma[fix \mapsto gen_{\Gamma}$ |((t >-> t) >-> t)|$](fix) = $ |(t >-> t) >-> t|}
    \UnaryInfC{$\Gamma[fix \mapsto gen_{\Gamma}$ |((t >-> t) >-> t)|$] \vdash$ |fix :: (t >-> t) >-> t|}
  \BinaryInfC{$\Gamma \vdash$ |let fix = \ f -> f (fix f) in fix :: (t >-> t) >-> t|}
\end{prooftree}

\begin{prooftree}
        \AxiomC{left left subtree}
      \UnaryInfC{$\Gamma[fix \mapsto$ |(t >-> t) >-> t|$, f \mapsto$ |t >-> t| $] \vdash$ |f (fix f) :: t|}
    \UnaryInfC{$\Gamma[fix \mapsto$ |(t >-> t) >-> t|$] \vdash$ |\ f -> f (fix f) :: (t >-> t) >-> t|}
  \UnaryInfC{left subtree}
\end{prooftree}

\begin{prooftree}
      \AxiomC{$\Gamma[fix \mapsto$ |(t >-> t) >-> t|$, f \mapsto$ |t >-> t| $](f) = $ |t >-> t|}
    \UnaryInfC{$\Gamma[fix \mapsto$ |(t >-> t) >-> t|$, f \mapsto$ |t >-> t| $] \vdash$ |f :: t >-> t|}
      \AxiomC{right subtree}
    \UnaryInfC{$\Gamma[fix \mapsto$ |(t >-> t) >-> t|$, f \mapsto$ |t >-> t| $] \vdash$ |fix f :: t|}
  \BinaryInfC{$\Gamma[fix \mapsto$ |(t >-> t) >-> t|$, f \mapsto$ |t >-> t| $] \vdash$ |f (fix f) :: t|}
  \UnaryInfC{left left subtree}
\end{prooftree}

\begin{prooftree}
      \AxiomC{$\Gamma[fix \mapsto$ |(t >-> t) >-> t|$, f \mapsto$ |t >-> t| $](fix) = $ |(t >-> t) >-> t|}
    \UnaryInfC{$\Gamma[fix \mapsto$ |(t >-> t) >-> t|$, f \mapsto$ |t >-> t| $] \vdash$ |fix :: (t >-> t) >-> t|}
    \AxiomC{right right subtree}
  \BinaryInfC{$\Gamma[fix \mapsto$ |(t >-> t) >-> t|$, f \mapsto$ |t >-> t| $] \vdash$ |fix f :: t|}
  \UnaryInfC{right subtree}
\end{prooftree}

\begin{prooftree}
      \AxiomC{$\Gamma[fix \mapsto$ |(t >-> t) >-> t|$, f \mapsto$ |t >-> t| $](f) = $ |t >-> t|}
    \UnaryInfC{$\Gamma[fix \mapsto$ |(t >-> t) >-> t|$, f \mapsto$ |t >-> t| $] \vdash$ |f :: t >-> t|}
  \UnaryInfC{right right subtree}
\end{prooftree}

\subsubsection*{|null|}

\begin{prooftree}
      \AxiomC{left subtree}
      \AxiomC{right subtree}
    \BinaryInfC{$\Gamma[xs \mapsto $ |LIST_1 <@> t_2| $] \vdash$ |case xs of {[] -> True; (y : ys) -> False} :: BOOL_3|}
  \UnaryInfC{$\Gamma \vdash$ |\ xs -> case xs of {[] -> True; (y : ys) -> False} :: LIST_1 <@> t_2 >-> BOOL_3|}
\end{prooftree}

\begin{prooftree}
      \AxiomC{$\Gamma[xs \mapsto $ |LIST_1 <@> t_2|$](xs)=$ |LIST_1 <@> t_2|}
    \UnaryInfC{$\Gamma[xs \mapsto $ |LIST_1 <@> t_2|$] \vdash$ |xs :: LIST_1 <@> t_2|}
    \AxiomC{|fresh(1, 2)|}
  \UnaryInfC{$\Gamma[xs \mapsto $ |LIST_1 <@> t_2|$] \vdash$ |[] :: LIST_1 <@> t_2|}
  \BinaryInfC{left subtree}
\end{prooftree}

\begin{prooftree}
      \AxiomC{|fresh(3)|}
    \UnaryInfC{$\Gamma[xs \mapsto $ |LIST_1 <@> t_2| $] \vdash$ |True :: BOOL_3|}
      \AxiomC{|fresh(3)|}
    \UnaryInfC{$\Gamma[xs \mapsto $ |LIST_1 <@> t_2| $, y \mapsto t_2, ys \mapsto $ |LIST_1 <@> t_2| $] \vdash$ |False :: BOOL_3|}
  \BinaryInfC{right subtree}
\end{prooftree}


\subsection{\label{sec:unif-sub}Unification and substitutions}
As in Algorithm \W, we use Robinson's unification algorithm to generate
substitutions during inferencing. For completeness,
Figure~\ref{fig:subst-grammar} shows the grammar for substitutions, while
Figure~\ref{fig:unification-rules} shows the unification rules for contracts.

\begin{figure}[H]
\begin{center}
\begin{spec}
TH  ::=  Id                 -- Identity substitution
    |    TH_1 COMP TH_2     -- Substitution composition
    |    [c_1 |-> c_2]      -- Substitution for |c_1| with a contract |c_2|
\end{spec}
\end{center}
\caption{\label{fig:subst-grammar} Grammar for substitutions}
\end{figure}

\begin{figure}[H]
\begin{spec}
  UNIFY :: (Contract, Contract) -> Substitution
  UNIFY (c,    c)    = Id
  UNIFY (c_1,  c_2)  = [c_1 |-> c_2] (iff {-"c_1 \notin fc(c_2) \wedge \sem{c_2} \subseteq \sem{c_1}"-})
  UNIFY (c_1,  c_2)  = [c_2 |-> c_1] (iff {-"c_2 \notin fc(c_1) \wedge \sem{c_1} \subseteq \sem{c_2}"-})
  UNIFY (c_1 >-> c_2, c_3 >-> c_4) =
    let  TH_1   = UNIFY(c_1, c_3)
         TH_2   = UNIFY(TH_1 c_2, TH_1 c_4)
    in   TH_2 COMP TH_1
  UNIFY (c_1 <@> c_2)  (c_3 <@> c_4) =
    let  TH_1   = UNIFY(c_1, c_3)
         TH_2   = UNIFY(TH_1 c_2, TH_1 c_4)
    in   TH_2 COMP TH_1
  UNIFY (c_1 <@@> (c_2, c_3), c_4 <@@> (c_5, c_6))  =
    let  TH_1   = UNIFY(c_1, c_4)
         TH_2   = UNIFY(TH_1 c_2, TH_1 c_5)
         TH_3   = UNIFY(TH_2 TH_1 c_3, TH_2 TH_1 c_6)
    in   TH_3 COMP TH_2 COMP TH_1
  UNIFY (_, _)  = undefined
\end{spec}
\caption{\label{fig:unification-rules}Unification rules for contracts}
\end{figure}

Unification for two identical contracts and for contract arrows is identical to
the way one would unify types. We add two special cases for functors and
bifunctors. These extra cases are similar to the case for contract arrows.
First, we unify the outer contracts, after which we unify the inner contracts,
apply substitutions, and finally return the composition of the new
substitutions. More interesting are the two cases for unifying two different
contracts. These cases are the same as in Algorithm \W, except for one extra
condition. In order for |c_1| to be unified with |c_2|, we require |c_1| to be
a subset of |c_2|, or the other way around. Using this condition, we can refine
contracts upon unification. For example

< UNIFY (INT, NAT)

would generate a substitution

< [INT |-> NAT]

since $\sem{nat} \subseteq \sem{int}$.

We need to take care to generate the correct substitutions when unifying. In
types, unification is straight-forward. Unifying |a -> b| and |c -> d| will
correctly generate substitutions |([a ||-> c] COMP [b ||-> d])|, because type
variables can be distinguished by name. With contracts, unification is harder,
because instead of fresh type variables, we assign concrete contracts. Why this
is harder is illustrated by the following example:

< UNIFY (true >-> true, int >-> nat)

Unification in this example would proceed as follows. First, we |UNIFY(true,
int)| giving a substitution |[true ||-> int]|, which is then applied to both
the second |true| and |nat|, replacing the second |true| with |int|. Next, we
|UNIFY(int, nat)|, which would give us a substitution |[int ||-> nat]|.
Applying these substitutions to the left-hand contract would give the following
result:

< ([int |-> nat] COMP [true |-> int]) (true >-> true) = nat >-> nat

In the situation where we see the |true >-> true| contract analogous to |a ->
a| in types, the unification result is actually the desired outcome. However,
if we wanted the |true >-> true| contract to be analogous to |a -> b| in types,
we would want the following contract as a result of the unification:

< int >-> nat

For this to be possible, we need to be able to distinguish between the same
concrete contracts, e.g., between the one |true| contract and another |true|
contract. This is exactly what Definition~\ref{def:contract-equivalency} allows
us to do by adding indices to contracts. If instead of |true >-> true|, we have
|true_1 >-> true_2|, unification would proceed differently:

< UNIFY (true_1 >-> true_2, int_3 >-> nat_4) = [true_1 |-> int_3] COMP [true_2 |-> nat_4]

and applying the substitution would give us a different answer:

< ([true_1 |-> int_3] COMP [true_2 |-> nat_4])(true_1 >-> true_2) = int_3 >-> nat_4


%For unification between branches in case blocks we define a special unification
%case |UNIFY'|, since we do not want to unify the outer contracts there. (TODO:
%Why not?) |UNIFY'| is shown in figure \ref{fig:unification-rules-case}.
%
%\begin{figure}[ht]
%\begin{spec}
%  UNIFY'(_ <@>   c_1,         _ <@> c_2)          = UNIFY(c_1, c_2)
%  UNIFY'(_ <@@>  (c_1, c_2),  _ <@@> (c_3, c_4))  =
%    let  TH_1  = UNIFY(c_1, c_3)
%         TH_2  = UNIFY(TH_1 c_2, TH_2 c_4)
%    in   TH_2 COMP TH_1
%\end{spec}
%\caption{\label{fig:unification-rules-case}Unification rules for contracts in case blocks}
%\end{figure}


\subsection{\label{sub:algorithm-cw}Algorithm \CW}
Combining the inference rules and the unification algorithm described in the
previous subsection, we can now define an inferencing algorithm which when
given a \lc~expression, infers a contract of that expression. Since the
algorithm is heavily based on Algorithm \W, we call it Algorithm \CW. We
present it in Figure~\ref{fig:algorithm-cw}, but we omit the case blocks and
binary operations, because they do not add anything new.

Our Algorithm \CW~differs from Algorithm \W~in several ways. Firstly,
\CW~explicitly implements inference for data types and holes. Secondly, it
explicitly implements |let| as a recursive |let|, whereas the implementation
for |let| by Damas and Milner is non-recursive. Their argument for omitting a
recursive |let| was that adding it is simple and they wanted to keep their
language in the paper minimal. We choose to explicitly model a recursive |let|,
because Haskell's |let| is also recursive and we want the step to implementing
contract inference for Haskell to be as small as possible. Lastly, rather than
generating fresh variables, we generate fresh indexed |true| contracts, which
can be refined by unification.


\begin{figure}[H]
\begin{spec}
  CW :: Environment -> Expression -> (Substitution, Contract)
  CW GAMMA x                     =  if   x `elem` dom(GAMMA)
                                         then  (Id, inst GAMMA(x))
                                         else  undefined
  CW GAMMA (\ x -> e)            =  let  i be fresh
                                         (TH, c) = CW (GAMMA[x |-> true_i]) e
                                    in   (TH, TH true_i >-> c)
  CW GAMMA (e_1 e_2)             =  let  i be fresh
                                         (TH_1, c_1 >-> c)  = CW GAMMA e_1
                                         (TH_2, c_2)        = CW (TH_1 GAMMA) e_2
                                         TH_3               = UNIFY(TH_2 c_1 >-> c, c_2 >-> true_i)
                                    in   (TH_3 COMP TH_2 COMP TH_1, TH_3 true_i)
  CW GAMMA (let x = e_1 in e_2)  =  let  i be fresh
                                         (TH_1, c_1)  = CW (GAMMA[x |-> true_i]) e_1
                                         TH_2         = UNIFY(TH_1 true_i, c_1)
                                         (TH_3, c)    = CW (TH_2 COMP TH_1 GAMMA[x |-> gen (TH_2 COMP TH_1 GAMMA) TH_2 c_1]) e_2
                                    in   (TH_3 COMP TH_2 COMP TH_1, c)
  CW GAMMA []                    =  let  i, j be fresh
                                    in   (Id, LIST_i <@> true_j)
  CW GAMMA (x : xs)              =  let  (TH_1,  c)             = CW GAMMA x
                                         (TH_2,  LIST_i <@> c)  = CW GAMMA xs
                                    in   (TH_2 COMP TH_1, LIST_i <@> c)
  CW GAMMA Nothing               =  let  i, j be fresh
                                    in   (Id, MAYBE_i <@> true_j)
  CW GAMMA (Just x)              =  let  i be fresh
                                         (TH, c) = CW GAMMA x
                                    in   (TH, MAYBE_i <@> c)
  CW GAMMA (x, y)                =  let  i be fresh
                                         (TH_1,  c_1) = CW GAMMA x
                                         (TH_2,  c_2) = CW GAMMA y
                                    in   (TH_2 COMP TH_1, PAIR_i <@@> (c_1, c_2))
  CW GAMMA (Left x)              =  let  i, j be fresh
                                         (TH, c) = CW GAMMA x
                                    in   (TH, EITHER_i <@@> (c, true_j))
  CW GAMMA (Right x)             =  let  i, j be fresh
                                         (TH, c) = CW GAMMA x
                                    in   (TH, EITHER_i <@@> (true_j, c))
  CW GAMMA ?                     =  let  i be fresh
                                    in   (Id, true_i)
\end{spec}
\caption{\label{fig:algorithm-cw}Algorithm \CW}
\end{figure}

We show that Algorithm \CW~is sound with respect to contracting rules in
Figure~\ref{fig:inference-rules} in Proposition~\ref{prop:soundness}.

\begin{prop}[\label{prop:soundness}Soundness of inference]
  If |CW GAMMA e = (TH, c)|, then $\Gamma \vdash e : c$.
\begin{proof}
  Proof by induction on |e|. The full proof is given in
  Appendix~\ref{app:cw-soundness}.
\end{proof}
\end{prop}


\subsubsection{Asserting inferred contracts}
Algorithm \CW~infers contracts in our intermediate contract language. Before
these contracts can be asserted, they need to be translated to executable
program code for a particular contract library. Since our work is based on the
work by Hinze et al. and our contract language is inspired by their notation,
the translation between the contract language and the contract library types is
easy. Contracts for |true|, |false|, |int|, |bool|, |list|, |either|, etc.  are
translated into an executable form, maintaining their semantics. The contract
arrow, functor and bifunctor contracts have a direct translation to the
contract library. Contract schemes are instantiated first, before being
translated into executable code.

Once inferred contracts have been translated into an executable form, we can
show in Proposition~\ref{prop:assertid} that if Algorithm \CW~infers a contract
for an expression |e|, the inferred contract will never fail assertion for that
expression. In other words, applying the |assert| function to the inferred
contract will give the identity function for expression |e|.

\begin{prop}[\label{prop:assertid}Asserting inferred contract is identity]
  If |CW GAMMA e = (TH, c)|, then |assert c e = e|.
\begin{proof}
  Proof by induction on |e|. The full proof is given in
  Appendix~\ref{app:cw-assert-id}. Conversion to an executable contract is left
  implicit.
\end{proof}
\end{prop}

Not only is asserting the inferred contract the identity, the inferred contract
is also the most specific contract. I.e., the semantics of the inferred
contract is a subset of any other contract that can be described in the
contract system. We formulate this in Conjecture~\ref{conj:most-specific}.
Intuitively, this seems true, because \CW~will infer contracts specific to
certain types. E.g., it will infer a functor contract with a |list| outer
contract for lists. However, this is not the only valid contract for a list in
the contract system. We can also replace the functor contract with a |true|
contract. While this is less specific, it will still be a valid contract for a
list, since $\llbracket{}$|list <@> true|$\rrbracket{}\subseteq{\sem{true}}$.
A formal proof for this conjecture is left for future work.

\begin{conj}[\label{conj:most-specific}An inferred contract is the most specific]
  If |CW GAMMA e = (TH, c)| and $\Gamma \vdash e : c$, then for all $\Gamma
  \vdash e : c'$, $\sem{c} \subseteq \sem{c'}$.
\end{conj}

\section{\label{sec:dependent-contracts}Dependent contracts}

So far, we have only dealt with contracts in the form of

< c_1 >-> c_2

However, such contracts cannot capture all properties of a function. Contracts
that capture the properties of a function completely commonly rely on a
function's \textit{input}, i.e., they are \textit{dependent contracts}.
Consider again the |sort| function. We can define a contract

< (list <@> true) >-> (ord <@> true)

that can correctly identify problems when |sort|, or one of the functions it
uses, does not return an ordered list. However, if we implement |sort| as

< sort xs = []

it trivially satisfies its contract, since an empty list is always sorted, and
the contract will never fail. Still, it is clear that this function is not a
sorting function, as it just ignores the input.

This problem is due to the fact that we have not made our contract specific
enough. Sorting a list does not only mean delivering a sorted list, it also
means that the resulting list is a permutation of the input list. In other
words, the contract for the function's result \textit{depends} on the
function's input. We can capture the correct contract for |sort| in a dependent
contract

< (xs :: list <@> true) >>-> (sorted xs)

where |sorted| is a contract that checks whether the output is sorted and is a
permutation of the input list |xs|. Recapping from
Section~\ref{sec:asserting-implementing}, the dependent contract arrow (|>>->|)
is defined as

< (>>->) = Function

where |Function| is a constructor from the |Contract| GADT, which allows the
function contract's argument to be used in its result. It is the same
constructor used for the non-dependent contract arrows |(>->)|, with the only
difference that |(>->)| applies |const| to the second argument. One might be
tempted to simply replace the non-dependent contract arrow with a dependent
contract arrow in the inferencing algorithm. As we will see shortly, this is
not enough to successfully infer dependent contracts. For example, suppose
|sort| was implemented in terms of |foldr|:

< foldr :: (a -> b -> b) -> b -> [a] -> b

Now imagine that the dependent contract for |sort| was naively unified with the
contract of |foldr|. Doing so would produce the following contract for |foldr|,
where |y|, |ys| and |b| are freshly generated variable names:

> ((y :: true) >>-> (ys :: sorted xs) >>-> (sorted xs)) >>-> (b :: sorted xs)
> >>-> (xs :: list <@> true) >>-> (sorted xs)

Several problems plague this contract. Firstly, |xs| is bound only in the
second-last argument, but it is already referred to before it comes into scope.
Secondly, the contract for |ys| also requires a list |xs|, but since there
simply is no list argument defined before |b|, this is impossible. Lastly, the
contract for the result of the function argument should be |(sorted (y : ys))|,
instead of |(sorted xs)|, because |sort|'s |insert| function produces a sorted
list by inserting the element |y| into the list |ys|.

We can solve the first and second problem by only assigning contracts to
function \textit{results}. However, it is unclear how to solve the last
problem. The following contract is the desired dependent contract for |foldr|
in the context of the |sort| function:

> ((y :: true_1) >>-> (ys :: true_2) >>-> (sorted (y:ys))) >>-> (b :: true_2)
> >>-> (xs :: true_3) >>-> (sorted xs)

If at all possible, inferring this contract from code is a hard problem which
we will not attempt to solve in this thesis. For this reason, we do not attempt
to infer dependent contracts at all.


\subsection{Eliminating dependent contracts}
Working around the problem of inferring dependent contracts, rather than
solving it, is also possible in certain cases. Instead of trying to infer
dependent contracts, we get rid of them altogether, eliminating the problems
described above. We do so by inlining a QuickCheck counter-example in a
function's contract. The intuition behind this approach is that since
QuickCheck has found a counter-example, contract assertion fails for the same
input. For this to work, it is essential that the QuickCheck properties and the
contracts are exactly the same.

To understand why using a QuickCheck counter-example allows us to eliminate
dependent contracts, we need to understand how QuickCheck produces a
counter-example. When starting a QuickCheck test, QuickCheck will generate
random values and apply the property under test to them. When QuickCheck has
generated a value that violates the property under test, it will try to
\textit{shrink} it, i.e., it will try to make the counter-example structurally
as small as possible, ensuring that it keeps violating the property under test.
It does this, because the values it finds are random values, not necessarily
minimal counter-examples. For example, suppose QuickCheck has randomly
generated the list

< [0,1,2]

and has determined that this value causes the property under test to fail.
Before returning this value to the user, QuickCheck will try to systematically
reduce the number of elements in the list, until it finds the smallest list
that causes the property to fail. In this specific example, it will first try
all of the values from the following list\footnote{The list is generated by
QuickCheck's |shrink| function. It does not necessarily contain all
permutations of the original list}:

< [[],[1,2],[0,2],[0,1],[0,0,2],[0,1,0],[0,1,1]]

It will then try to shrink all of these lists. For example, when it tries to
shrink the list |[1,2]|, it will generate the list

< [[],[2],[1],[0,2],[1,0],[1,1]]

From which each element is tested again. Eventually QuickCheck will return one
of the smallest counter-examples it can find. Indeed, in QuickCheck's current
implementation there is no guarantee that it is a minimal counter-example. We
will discuss this problem in Section~\ref{sec:fw-dependent-contracts}. In the
mean time, we will consider the counter-example returned by QuickCheck to be
minimal in order to demonstrate how we work around dependent contracts.

When we have a minimal counter-example, e.g. |[0,1]|, we can assume that the
property under test succeeds for the smaller list |[1]|. We can use this
knowledge when embedding contract assertions in our program. Suppose we have
a function

\begin{spec}
  f :: [Int] -> [Int]
  f xs = assert c g xs
    where  g []      = []
           g (y:ys)  = (y + 1 : assert c g ys)
           c         = (xs' :: true) >>-> (silly xs')
\end{spec}

where |silly| is some contract that fails for |xs' = [0,1]| (and possibly
larger lists), but not for |xs' = [1]| and |xs' = []|. Now we want to eliminate
the dependent contract. Since QuickCheck gives us |[0,1]| as counter-example
for this function, we inline it in the place of |xs'| in the |silly| contract,
and replace the dependent contract arrow with a plain contract arrow, resulting
in the following code:

\begin{spec}
  f :: [Int] -> [Int]
  f xs = assert c g xs
    where  g []      = []
           g (y:ys)  = (y + 1 : g ys)
           c         = true >-> (silly [0,1])
\end{spec}

Note that we do not assert the contract in recursive applications of |g|. Since
we know that QuickCheck's counter-example is minimal, we do not have to,
because having a minimal counter-example implies that the contract will succeed
for smaller lists. Now when we apply |f| to |[0,1]|, we can expect the |silly|
contract to fail and blame the right location. While this particular example is
rather contrived, experimentation with the |sort| function has indicated that
this approach works for bigger examples as well.

So far, we only have initial experimental results for eliminating dependent
contracts. Section~\ref{sec:fw-dependent-contracts} will explore some of the
problems that affect this idea.

%%%%\begin{figure}[H]
%%%%\begin{center}
%%%%\begin{spec}
%%%%let  sort = \ xs ->
%%%%             let  insert = \ x -> \ xs ->
%%%%                             case xs of
%%%%                               []      ->  [x]
%%%%                               (y:ys)  ->  case x <= y of
%%%%                                             True   -> x : y : ys
%%%%                                             False  -> y : insert x ys
%%%%             in   let  cinsert = \ c -> \ x -> \ xs -> assert c (insert x xs)
%%%%                  in   let  foldr = \ f' -> \ f -> \ b -> \ xs ->
%%%%                                      case xs of
%%%%                                        []      -> b
%%%%                                        (x:xs)  -> f x (foldr f' f' b xs)
%%%%                       in   let  cfoldr = \ c -> \ f' -> \ f -> \ b -> \ xs -> assert c (foldr f' f b xs)
%%%%                            in   cfoldr (DOTS) insert (cinsert (DOTS)) [] xs
%%%%in   let  csort = \ c -> \ xs -> assert c (sort xs)
%%%%     in   csort (DOTS)
%%%%\end{spec}
%%%%\end{center}
%%%%\caption{\label{fig:isort-qc}|sort| with QuickCheck counter-example inlined}
%%%%\end{figure}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%                    Chapter discussion                                    %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\chapter{\label{chp:shortcomings}Discussion and future work}

% Section~\ref{sec:shortcomings} discusses these shortcomings and proposes
% potential solutions. One of the most prominent problems discussed in this
% section is that of inferring dependent function contracts. In addition,
% section~\ref{sec:shortcomings} also discusses potential enhancements to the
% inferencing algorithm.

We have seen how contracts can be inferred from functional programs. We think
that the ideas presented in this thesis can be extended to a full-fledged
programming language, such as Haskell, and lifted outside the context of the
Ask-Elle tutor. Still, there are several aspects of contract inferencing we
have not fully explored. In this section we will look at aspects of contract
inferencing that we have not fully explored and the shortcomings of the current
implementation of our system.


\section{\label{sec:fw-dependent-contracts}Exploring dependent contracts}

Section~\ref{sec:dependent-contracts} discussed dependent contracts, the
problems with dependent contracts and contract inference, and how we can work
around the need for them using a QuickCheck counter-example. While the results
in that section look promising, only few experiments have been performed.
Further experimentation will be required to verify that the idea presented in
that section is valid in general, and that it can be applied to most or all
contracts and programs.

One of the problems identified in Section~\ref{sec:dependent-contracts} was
that QuickCheck currently does not necessarily give a minimal counter-example.
This is due to the current implementation of QuickCheck's |Arbitrary| class
instances, the type class which generates the random values. This particular
explanation was given by Nick Smallbone on the QuickCheck mailing list. Suppose
we have some function |f| and a property |p| for |f|. Now suppose that |p|
fails for the list |[0,0,0]|, succeeds for |[0,0]|, but fails again for |[0]|.
QuickCheck will always shrink |[0,0,0]| to |[0,0]| first, before shrinking it
to |[0]|. In the example, QuickCheck will never try shrinking to |[0]|, because
|[0,0]| has already succeeded. To make this more concrete, |f| and |p| could be
implemented as follows:

\begin{spec}
  f [_]        = False
  f [_, _, _]  = False
  f _          = True

  p xs = f xs
\end{spec}
%TODO: re-read this part

Outside the context of our work, QuickCheck's current shrinking behaviour is
desired, because it reduces the number of shrink operations, speeding up
testing. However, since we are interested in minimal examples, we want
QuickCheck to also shrink |[0,0]|, so we can find the even smaller
counter-example |[0]|. Different shrinking behaviour can be obtained by
re-implementing the instances for the |Arbitrary|.

Another problem with relying on QuickCheck for shrinking a counter-example is
that it is not always clear what it means for a counter-example to be the
smallest. For lists, it's clear: the empty list is the smallest lists one can
have. If natural numbers in Haskell were defined as

< data Nat = Succ Nat | Zero

then it would be clear that |Zero| is the smallest natural number. However,
Haskell only has |Int| and |Integer| to represent whole numbers. QuickCheck
will shrink integers towards $0$. For example, suppose it finds |(-7)| as
counter-example, it will produce the following shrink list:

< [7,0,-4,-6]

while another perfectly reasonable shrink list would have been

< [-11,-13,-17,-19]

There is no guarantee that either of these lists contain a ``smallest'' number
such that the function under test needs to make a minimum number of recursive
calls before it terminates. This is illustrated by the following function |f|,
which generates an infinite list of integers:

< f :: Int -> [Int]
< f n =  n : f (n + 1)

Even though |Int| has a definition for |maxBound|, simply increasing the number
of |n| will eventually cause the number's sign bit to flip, appending the
|minBound| value for |Int| to the list, after which the function will continue
until it reaches  the |maxBound| for |Int| again. |f| will never terminate.
From this we can conclude that it is hard to define what it means for a number
to be the smallest, and our approach for eliminating dependent contracts in its
current form will probably not work for |Int|. A similar argument holds for
|Integer|, because it is not bounded.  How we can eliminate dependent contracts
when integers (and possibly other types) are used remains an open question.


\section{\label{sec:embedding-in-tutor}Embedding contract inference in Ask-Elle}

Our original motivation for this work was the Ask-Elle Haskell tutor. By
combining QuickCheck and contract inferencing, we wanted to locate where a
program failed its contracts when the Ask-Elle strategies could no longer do
so. Integrating contract inference into Ask-Elle still remains to be done.

In the context of the tutor, we want the student to focus only on learning. The
student should not be required to do any extra work to make use of contract
inferencing. As such, we want the tutor to automatically infer contracts and
augment the student's program with the inferred contracts, so they may be
asserted by applying the student's function to a QuickCheck counter-example.
Initial experimentation has shown that it is possible to do so, although it
remains to be seen if it is possible to define transformations that achieve
this in general.

%%%%One of the problems with automatically augmenting programs with contracts
%%%%arises in the case of recursive functions. Consider the following (contrived)
%%%%example. We use regular Haskell here to keep the code shorter, although this
%%%%program can easily be translated to \lc.
%%%%
%%%%\begin{spec}
%%%%silly =  let  map f []        = []
%%%%              map f (x : xs)  = f x : map f xs
%%%%         in   map (+1) [1,2,3]
%%%%\end{spec}
%%%%
%%%%A reasonable contract for |silly| would be
%%%%
%%%%< (list <@> nat)
%%%%
%%%%Using contract inference, and unifying the inferred contract with the contract
%%%%for |silly| would give us the following contract for |map|:
%%%%
%%%%< (int >-> nat) >-> (list <@> int) >-> (list <@> nat)
%%%%
%%%%This contract should not only hold fold our first application of |map|, but
%%%%also for recursive applications. One way to do this would be to wrap all
%%%%applications of |map| in an assertion with the corresponding contract:
%%%%
%%%%\begin{spec}
%%%%silly =
%%%%  let  map f []        = []
%%%%       map f (x : xs)  = f x : assert (list <@> nat) (map f xs)
%%%%  in   assert (list <@> nat) (map (+3) [1,2,3])
%%%%\end{spec}
%%%%
%%%%But what if we now add another application of |map| to our program?
%%%%
%%%%\begin{spec}
%%%%silly2 =
%%%%  let  map f []        = []
%%%%       map f (x : xs)  = f x : map f xs
%%%%  in   (map (+3) [1,2,3]), map (-3) [1,2,3])
%%%%\end{spec}
%%%%
%%%%The resulting list in the left-hand side of the tuple still adheres to the
%%%%contract |(list <@> nat)|, but the resulting list in the right-hand side of the
%%%%tuple does not. A more fitting contract for the right-hand side is |list <@>
%%%%int|, which would give us the following contract for |map|:
%%%%
%%%%< (int >-> int) >-> (list <@> int) >-> (list <@> int)
%%%%
%%%%Inlining assertions is now no longer an option. Consider the following
%%%%(wrong) code for |silly2|:
%%%%
%%%%\begin{spec}
%%%%silly2 =
%%%%  let  map f []        = []
%%%%       map f (x : xs)  = f x : assert (list <@> nat) (map f xs)
%%%%  in   (  assert (list <@> nat)  (map (+3)  [1,2,3])
%%%%       ,  assert (list <@> int)  (map (-3)  [1,2,3])
%%%%\end{spec}
%%%%
%%%%Asserting the contracts for the left-hand side of the tuple succeeds, as
%%%%expected, but will fail for the right-hand side of the tuple, since it will
%%%%assert the wrong contract. To remedy the situation, we need to abstract from
%%%%the contract by adding an extra parameter to |map|:
%%%%
%%%%\begin{spec}
%%%%silly2' =
%%%%  let  map c f []        = []
%%%%       map c f (x : xs)  = f x : assert c (map c' c f xs)
%%%%  in   (  assert (list <@> nat)  (map (list <@> nat)  (+3)  [1,2,3])
%%%%       ,  assert (list <@> int)  (map (list <@> int)  (-3)  [1,2,3])
%%%%\end{spec}
%%%%
%%%%While this program will successfully assert its contracts, the solution is
%%%%still not satisfactory since we are only asserting the result of applying
%%%%|map|. However, contract inference also gave us a contract for |map|'s
%%%%function argument, which we want to assert as well. We could opt to apply the
%%%%same trick again:
%%%%
%%%%\begin{spec}
%%%%silly2'' =
%%%%  let  map c' c f []        = []
%%%%       map c' c f (x : xs)  = (assert c' f) x : assert c (map c' c f xs)
%%%%  in   (  assert (list <@> nat)  (map (int >-> nat)  (list <@> nat)  (+3)  [1,2,3])
%%%%       ,  assert (list <@> int)  (map (int >-> int)  (list <@> int)  (-3)  [1,2,3])
%%%%\end{spec}
%%%%
%%%%The implementation of |silly2''| is already becoming quite messy and we still
%%%%have the contract |(list <@> int)| which we can use to assert |map|'s input,
%%%%but which will obscure the code even further. We can also see a pattern here,
%%%%namely that we are breaking up the inferred contract for |map| into smaller
%%%%pieces, which we then feed back to |map| as parameters. We would be much better
%%%%off if we could use the inferred contracts for |map| without breaking them up
%%%%into smaller pieces.

As we saw in Section~\ref{sec:dependent-contracts}, we require QuickCheck
counter-examples in order to eliminate dependent contracts.  However, out of
the box, QuickCheck can only \textit{display} the counter example it finds, and
not return it for further use. Koen Claessen, one of the original authors of
QuickCheck, proposed a workaround on the QuickCheck mailing list. The
workaround involves wrapping QuickCheck's |quickCheck| function--the function
that starts testing the specified property--by a custom function that uses an
|IORef| that stores the counter-examples QuickCheck produces while testing.

\begin{spec}
quickCheckArg :: (Arbitrary a, Testable prop) => (a -> prop) -> IO (Maybe a)
quickCheckArg p = do
  ref <- newIORef Nothing
  quickCheck (\x -> whenFail (writeIORef ref (Just x)) (p x))
  readIORef ref
\end{spec}

We can then read the counter-example values from the |Maybe| value.

Lastly, when integrating contract inference with the tutor, we will need to be
able to infer more interesting contracts than those that never fail assertion.
Teachers need to be able to specify a contract for the exercise, and the
contract inferencing algorithm needs to be able to use this specific contract
to infer contracts for the rest of the program. In essence, this is not very
different from the way an explicit type annotation is persisted through a
program in type inference. Our implementation already largely supports using
explicit contracts during inference, although we still need to finish the
implementation and integrate this with the tutor.

%%%Merely inferring contracts for programs is not enough; the inferred contracts
%%%also need to be incorporated in the program code so they can be executed. In
%%%this section, we describe how a program can be transformed into a contracted
%%%program in a systematic way. We do so by transforming the non-contracted |sort|
%%%function in Figure~\ref{fig:isort-plain} into a fully contracted implementation
%%%of the |sort| function, shown in Figure~\ref{fig:isort-finaltrans}. For
%%%brevity, we have listed the contracts for the final code example separately in
%%%Figure~\ref{fig:isort-contracts}. In our implementation, we do contract
%%%inference and program transformation at the same time.
%%%
%%%
%%%\begin{spec}
%%%  LLB let x = e_1 in e_2 RRB {- |let| is top-level -}          =  LLB  let  x = \r -> [x |-> r]e_1
%%%                                                                       in   let  xc = \ c -> \ MARGS -> assert c (x (xc c) MARGS)
%%%                                                                            in   e_2 RRB
%%%  LLB let x = e_1 in e_2 RRB {- |let| is not top-level -}      =  let  xc = \ c -> \ MARGS -> assert c (x (xc c) MARGS)
%%%                                                                  in   LLB let x = \r -> [x |-> r]e_1 in e_2 RRB
%%%  LLB let x = \ r -> e_1 in let y = e_2 in e_3 RRB      =  let  x = \r -> e_1
%%%                                                           in   LLB let y = e_2 in e_3 RRB
%%%  LLB let cx = \ c -> \ MARGS -> e_1 in e_2 MARGS' RRB  =  let cx = \ c -> \ MARGS -> e_1 in e_2 MARGS'
%%%\end{spec}
%%%
%%%\begin{figure}[H]
%%%\begin{center}
%%%\begin{spec}
%%%let  sort = \ xs ->
%%%             let  insert = \ x -> \ xs ->
%%%                             case xs of
%%%                               []      ->  [x]
%%%                               (y:ys)  ->  case x <= y of
%%%                                             True   -> x : y : ys
%%%                                             False  -> y : insert x ys
%%%             in   let  foldr = \ f -> \ b -> \ xs ->
%%%                                 case xs of
%%%                                   []      -> b
%%%                                   (x:xs)  -> f x (foldr f b xs)
%%%                   in   foldr insert [] xs
%%%in   sort
%%%\end{spec}
%%%\end{center}
%%%\caption{\label{fig:isort-plain}Non-contracted |sort| function}
%%%\end{figure}
%%%
%%%\begin{figure}[H]
%%%\begin{center}
%%%\begin{spec}
%%%let  sort = \ r -> \ xs ->
%%%             let  insert = \ r -> \ x -> \ xs ->
%%%                             case xs of
%%%                               []      ->  [x]
%%%                               (y:ys)  ->  case x <= y of
%%%                                             True   -> x : y : ys
%%%                                             False  -> y : r x ys
%%%             in   let  cinsert = \ c -> \ x -> \ xs -> assert c (insert (cinsert c) x xs)
%%%                  in   let  foldr = \ r -> \ f -> \ b -> \ xs ->
%%%                                      case xs of
%%%                                        []      -> b
%%%                                        (x:xs)  -> f x (r f b xs)
%%%                       in   let  cfoldr = \ c -> \ f -> \ b -> \ xs -> assert c (foldr (cfoldr c) f b xs)
%%%                            in   cfoldr (DOTS) (cinsert (DOTS)) [] xs
%%%in   let  csort = \ c -> \ xs -> assert c (sort (csort c) xs)
%%%     in   csort (DOTS)
%%%\end{spec}
%%%\end{center}
%%%\caption{\label{fig:isort-finaltrans}Fully transformed |sort|}
%%%\end{figure}
%%%
%%%\begin{figure}[H]
%%%\begin{center}
%%%\begin{spec}
%%%  sort    = true <@> true >-> ord <@> true
%%%  foldr   =    (true >-> ord <@> true >-> ord <@> true)
%%%          >->  ord <@> true >-> true <@> true >-> ord <@> true
%%%  insert  = true >-> ord <@> true >-> ord <@> true
%%%\end{spec}
%%%\end{center}
%%%\caption{\label{fig:isort-contracts} Inferred and specified contracts for |sort|}
%%%\end{figure}
%%%
%%%
%%%\subsection{Removing recursion}
%%%
%%%When we encounter a |let| binding, we want to abstract from any potential
%%%recursion by introducing a new lambda and by replacing all occurrences of the
%%%let-bound variable with the variable bound in the lambda. By abstracting from
%%%the recursion, we can parameterise the function with recursive calls to
%%%instantiations of the same function with possibly different contracts. The
%%%result of this first transformation is shown in Figure~\ref{fig:isort-remrec}.
%%%Note that, even though it is not recursive, the Definition of |sort| has
%%%received an extra lambda for a recursive call as well.  Later on we will see
%%%that this is not problematic.
%%%
%%%\begin{figure}[H]
%%%\begin{center}
%%%\begin{spec}
%%%let  sort = \ r -> \ xs ->
%%%             let  insert = \ r -> \ x -> \ xs ->
%%%                             case xs of
%%%                               []      ->  [x]
%%%                               (y:ys)  ->  case x <= y of
%%%                                             True   -> x : y : ys
%%%                                             False  -> y : r x ys
%%%             in   let  foldr = \ r -> \ f -> \ b -> \ xs ->
%%%                                 case xs of
%%%                                   []      -> b
%%%                                   (x:xs)  -> f x (r f b xs)
%%%                   in   foldr insert [] xs
%%%in   sort
%%%\end{spec}
%%%\end{center}
%%%\caption{\label{fig:isort-remrec} |sort| after abstracting away from recursion}
%%%\end{figure}
%%%
%%%
%%%\subsection{Adding a contracted wrapper}
%%%
%%%After abstracting away from the recursion, we introduce a contracted version of
%%%the same function. For our |sort| example, we get the code in
%%%Figure~\ref{fig:isort-addlet} after applying this step. Since the same function
%%%may have several valid contracts, depending on where in the program it is
%%%applied, we introduce a lambda for abstracting over the specific contracts.
%%%Inside this new lambda, we also add lambdas for the original function's
%%%arguments, after which we add the code responsible for asserting the contract.
%%%In the assertion code, the contract is being checked for the call to the
%%%original function |x|, parameterized by the variable from the newly created
%%%|let| binding, which in turn is parameterized by the contract. This
%%%construction allows us to contract (mutually) recursive functions with
%%%different contracts, depending on where the original function is applied in the
%%%program.
%%%
%%%\begin{figure}[H]
%%%\begin{center}
%%%\begin{spec}
%%%let  sort = \ r -> \ xs ->
%%%             let  insert = \ r -> \ x -> \ xs ->
%%%                             case xs of
%%%                               []      ->  [x]
%%%                               (y:ys)  ->  case x <= y of
%%%                                             True   -> x : y : ys
%%%                                             False  -> y : r x ys
%%%             in   let  cinsert = \ c -> \ x -> \ xs -> assert c (insert (cinsert c) x xs)
%%%                  in   let  foldr = \ r -> \ f -> \ b -> \ xs ->
%%%                                      case xs of
%%%                                        []      -> b
%%%                                        (x:xs)  -> f x (r f b xs)
%%%                       in   let  cfoldr = \ c -> \ f -> \ b -> \ xs -> assert c (foldr (cfoldr c) f b xs)
%%%                            in   foldr insert [] xs
%%%in   let  csort = \ c -> \ xs -> assert c (sort (csort c) xs)
%%%     in   sort
%%%\end{spec}
%%%\end{center}
%%%\caption{\label{fig:isort-addlet} |sort| after adding a contract wrapper}
%%%\end{figure}
%%%
%%%
%%%\subsection{Applying contracts}
%%%
%%%Lastly, the original function applications need to be replaced with the
%%%contracted function applications. The result of this transformation is shown in
%%%Figure~\ref{fig:isort-finaltrans}. The contracted function is applied to the
%%%contract that has been inferred for that particular application.  Higher-order
%%%arguments are replaced as well. Before the function application code is
%%%generated, the contract in question is finalized, meaning that any remaining
%%%contract variables are defaulted to |true| contracts.  As we saw in the
%%%contract grammar, the grammar has no notion of concrete contracts; all
%%%contracts eventually consist of variables woven together with function and
%%%(bi)functor contracts.  Contracts in this form are not executable, as it is not
%%%clear \textit{which} conditions they should enforce. However, just as it is
%%%common for type inferencing to infer a universally quantified type variable, so
%%%is it common for the contract inferencing algorithm to infer a universally
%%%quantified contract variable. To ensure that these contracts become executable,
%%%all contract variables are replaced by |true| contracts, once the inference
%%%process is done. Since |true| contracts never fail, this is a safe default.


\section{\label{sec:constant-expressions}Constant expression contracts}

Contracts inferred using Algorithm \CW~are not very useful if they always
succeed. However, in some cases, we may be able to infer more specific
contracts from the code, making it more likely that we will find a situation
where an assertion fails. Consider the following (contrived) example:

> silly :: a -> Int
> silly x = 1

The resulting tuple will always have an integer |1| for its left element. A
perfectly valid and reasonable contract for |silly| would therefore be:

> true >-> equalsOne

Where |equalsOne| is an inferred contract that only succeeds for the constant
value |1|.  We can easily infer this contract from the code. Such contracts
could be called \textit{constant expression contracts}, as they check for
constant values.  Unfortunately, naively generating these constant expression
contracts will quickly lead to problematic contracts. Consider, for example, a
constant expression contract for |silly2|:

< silly2 xs =  let  f  []      = []
<                   f  (y:ys)  = (if y == 1 then y + 1 else 0) : f (map (+1) ys)
<              in   f  (map (\ y -> 1) xs)

Using constant expression inferencing, we can infer the contract

< (true >-> equalsOne) >-> (LIST_1 <@> true) >-> (LIST_2 <@> equalsOne)

for the first application of |map| in the |in| branch of the |let| block, which
will be unified with the contract for |f|. If we would infer a contract for |f|
alone, it would get contract

< (LIST_1 <@> INT_2) >-> (LIST_3 <@> INT_2)

due to its type

< f :: (Eq a, Num a) => [a] -> [a]

After unification with |map|'s contract, |f| gets the following contract:

< (LIST_1 <@> equalsOne) >-> (LIST_3 <@> equalsOne)

This contract is clearly not correct, because the list |f| produces never
contains a |1| as element. Inferring constant expression contracts in this
form requires program analysis to ensure that values remain constant. However,
this is outside the scope of this thesis.

One possible solution to this problem would be to not allow constant expression
contracts to be unified. Instead, upon unification, a superset contract could
be used in the substitution. For example, when unifying

< LIST_1 <@> equalsOne

and

< LIST_1 <@> INT_2

we could opt to maintain the |INT_2| contract, rather that generating a |[INT_2
||-> equalsOne]| substitution. Clearly, this problem is under-explored and more
work is required to before useful constant expression contracts can be
inferred.

%%%%expression contract for |encode|, which has (simplified) type
%%%%
%%%%< encode :: (Eq a) => [a] -> [(Int, a)]
%%%%
%%%%It compresses a list by counting the number of subsequent occurrences of an
%%%%element and storing the resulting number in a tuple. A definition is given in
%%%%Figure~\ref{fig:encode-constant}.
%%%%
%%%%\begin{figure}[ht]
%%%%\begin{center}
%%%%\begin{spec}
%%%%let  encode = \xs ->
%%%%  let  merge = \xs ->
%%%%                 case xs of
%%%%                   []                      ->  []
%%%%                   ((n, x) : [])           ->  (n, x) : []
%%%%                   ((m, x) : (n, y) : ys)  ->  case x == y of
%%%%                                                 True   -> merge ((m + n, x) : ys)
%%%%                                                 False  -> (m, x) : merge ((n, y) : ys)
%%%%  in   let  map = \f -> \xs ->
%%%%                    case xs of
%%%%                      [] -> []
%%%%                      (y : ys) -> f y : map f ys
%%%%       in   merge (map (\z -> (1, z)) xs)
%%%%in   encode
%%%%\end{spec}
%%%%\end{center}
%%%%\caption{\label{fig:encode-constant}|encode| function}
%%%%\end{figure}
%%%%
%%%%|encode| is defined in terms of |merge|, which has type
%%%%
%%%%< merge :: (Eq a) => [(Int, a)] -> [(Int, a)]
%%%%
%%%%|merge| receives as input a list of tuples, of which the left-most element
%%%%represents the number of subsequent occurrences of the right-most element.
%%%%Initially, the number of occurrences is set to |1| by mapping a lambda function
%%%%over the input list before apply |merge| to it. Afterwards, the individual
%%%%tuples are merged together by incrementing the counter if their subsequent
%%%%right-most elements are the same.
%%%%
%%%%For the result of mapping the lambda function over the input list, we can infer
%%%%a constant contract, since we know that the result of applying |map| will
%%%%always be a list of tuples, of which the left-most element is |1|. If we choose
%%%%to infer this constant expression contract, and continue the inferencing
%%%%process, we will infer the following contract for |encode|:
%%%%
%%%%< true_1 <@> true_2 >-> true_3 <@> true_4 <@@> (prop (== 1), true_2)
%%%%
%%%%Unfortunately, this contract is completely wrong. After all, both in our
%%%%description of what the function should do, as well as in the Definition of
%%%%|merge| we can see that the number on the left side of the tuple is likely to
%%%%be incremented, causing the constant expression contract to fail, even though
%%%%the function may be implemented correctly. In order for us to correctly infer
%%%%constant expression contracts like the one above, we will first need to perform
%%%%program analysis to ensure that the value remains constant throughout the
%%%%program. Performing such an analysis is outside the scope of this thesis.


\appendix

\chapter{\label{chp:proofs}Proofs}

\def\commentbegin{\quad\{\ }
\def\commentend{\}}

\section{\label{app:cw-soundness}Soundness of Algorithm \CW}
We want to show that if |CW GAMMA e = (TH, c)|, then $\Gamma \vdash e : c$.
For variables, application, abstraction, and |let| bindings we refer to Damas
and Milner's original proof, as contract inference and type inference are the
same for these rules. We also forego explicitly proving soundness for |[]|,
|Nothing|, and |?|, since these proofs are trivial. We also omit the proof for
case blocks and binary operations, since they are not represented in
presentation of \CW. Lastly, we also omit the proof for |Right|, as it is very
similar to the proof for |Left|. For the remaining expressions, we proceed by
induction on |e|. We assume fresh contract variables to be tautologies.


\subsection*{Case |(x : xs)|}
To show: if |CW GAMMA (x : xs) = (TH_2 COMP TH_1, list <@> c)|, then $\Gamma
\vdash$ |(x : xs) :: list <@> c|

\begin{description}
  \item[IH1] If |CW GAMMA x = (TH_1, c)|, then $\Gamma \vdash$ |x :: c|
  \item[IH2] If |CW GAMMA xs = (TH_2, list <@> c)|, then $\Gamma \vdash$ |xs ::
    list <@> c|
\end{description}

%%%%%\subsubsection*{Definition of |CW|:}
%%%%%
%%%%%\begin{spec}
%%%%%CW GAMMA (x : xs)  =  let  (TH_1,  c)           = CW GAMMA x
%%%%%                           (TH_2,  list <@> c)  = CW GAMMA xs
%%%%%                      in   (TH_2 COMP TH_1, list <@> c)
%%%%%\end{spec}

\subsubsection{Proof:}
\begin{spec}
       INENV (x : xs) :: list <@> c
  <==  {- Rule \textsc{C-Cons} -}
       INENV x :: c, INENV xs :: list <@> c
  <==  {- Case |x|, apply IH1 -}
       CW GAMMA x = (TH_1, c)
  <==  {- Case |xs|, apply IH2 -}
       CW GAMMA xs = (TH_2, list <@> c)
\end{spec}

from which follows that if |CW GAMMA (x : xs) = (TH_2 COMP TH_1, list <@> c)|,
then $\Gamma \vdash$ |(x : xs) :: list <@> c|.


\subsection*{Case |Just x|}

To show: if |CW GAMMA (Just x) = (TH, maybe <@> c)|, then $\Gamma \vdash$ |Just
x :: maybe <@> c|.

\begin{description}
  \item[IH] If |CW GAMMA x = (TH, c)|, then $\Gamma \vdash$ |x :: c|
\end{description}

%%%%\subsubsection*{Definition of |CW|:}
%%%%
%%%%\begin{spec}
%%%%CW GAMMA (Just x)  =  let  (TH, c) = CW GAMMA x
%%%%                      in   (TH, maybe <@> c)
%%%%\end{spec}

\subsubsection*{Proof:}
\begin{spec}
       INENV Just x :: maybe <@> c
  <==  {- Rule \textsc{C-Just} -}
       INENV x :: c
  <==  {- Apply IH -}
       CW GAMMA x = (TH, c)
\end{spec}

from which follows that if |CW GAMMA (Just x) = (TH, maybe <@> c)|, then
$\Gamma \vdash$ |Just x :: maybe <@> c|.


\subsection*{Case |(x, y)|}

To show: if |CW GAMMA (x, y) = (TH_2 COMP TH_1, pair <@@> (c_1, c_2))|, then
$\Gamma \vdash$ |(x, y) :: pair <@@> (c_1, c_2)|.

\begin{description}
  \item[IH1] If |CW GAMMA x = (TH_1, c_1)|, then $\Gamma \vdash$ |x :: c_1|
  \item[IH2] If |CW GAMMA y = (TH_2, c_2)|, then $\Gamma \vdash$ |y :: c_2|
\end{description}

%%%%\subsubsection{Definition of |CW|:}
%%%%
%%%%\begin{spec}
%%%%CW GAMMA (x, y)  =  let  (TH_1,  c_1) = CW GAMMA x
%%%%                         (TH_2,  c_2) = CW GAMMA y
%%%%                    in   (TH_2 COMP TH_1, pair <@@> (c_1, c_2))
%%%%\end{spec}

\subsubsection{Proof:}
\begin{spec}
       INENV (x, y) :: pair <@@> (c_1, c_2)
  <==  {- Rule \textsc{C-Pair} -}
       INENV x :: c_1, INENV y :: c_2
  <==  {- Case |x|, apply IH1 -}
       CW GAMMA x = (TH_1, c_1)
  <==  {- Case |y|, apply IH2 -}
       CW GAMMA y = (TH_2, c_2)
\end{spec}

from which follows that if |CW GAMMA (x, y) = (TH_2 COMP TH_1, pair <@@> (c_1,
c_2))|, then $\Gamma \vdash$ |(x, y) :: pair <@@> (c_1, c_2)|.


\subsection*{Case |Left x|}

To show: if |CW GAMMA (Left x) = (TH, either <@@> (c, true_i))|, then $\Gamma
\vdash$ |Left x :: either <@@> (c, true_i)|.

\begin{description}
  \item[IH] If |CW GAMMA x = (TH, c)|, then $\Gamma \vdash$ |x :: c|
\end{description}

%%%%\subsubsection{Definition of |CW|:}
%%%%
%%%%\begin{spec}
%%%%CW GAMMA (Left x)  =  let  i be fresh
%%%%                           (TH, c) = CW GAMMA x
%%%%                      in   (TH, either <@@> (c, true_i))
%%%%\end{spec}


\subsubsection{Proof:}
\begin{spec}
       INENV Left x :: either <@@> (c, true_i)
  <==  {- Rule \textsc{C-Left} -}
       INENV x :: c, fresh(i)
  <==  {- Apply IH -}
       CW GAMMA x = (TH, c)
\end{spec}

from which follows that if |CW GAMMA (Left x) = (TH, either <@@> (c, true_i))|,
then $\Gamma \vdash$ |Left x :: either <@@> (c, true_i)|.


\section{\label{app:cw-assert-id}Asserting inferred contract is identity}
We want to show that if |CW GAMMA e = (TH, c)|, then |assert c e = e|.  We
forego providing explicit proofs for variables, |[]|, |Nothing|, and |?|, since
these proofs are trivial. We also omit the proof for case blocks and binary
operations, since they are not represented in presentation of \CW. Lastly, we
also omit the proof for |Right|, as it is very similar to the proof for |Left|.
For the remaining expressions, we proceed by induction on |e|.

For lambda abstraction and function application we failed to give a full proof,
due to the important role unification and substitutions play in these parts of
the algorithm. It was not clear how to incorporate these in the proofs. Instead
of completing the proof, we opted to give an informal reasoning as to why we
think the proof can be completed.

\subsection*{Case |\ x -> e|}

If |CW GAMMA (\ x -> e) = (TH, TH true_i >-> c)|, then |assert (TH true_i >-> c) (\ x -> e) = (\ x -> e)|

\begin{description}
  \item[IH] If |CW (GAMMA[x ||-> true_i]) e = (TH, c_2)|, then |assert c_2 e = e|
\end{description}

\subsubsection*{Proof:}
\begin{spec}
      assert ((TH true_i) >-> c_2) (\ x -> e)
  ==  {- Definition of |>->| -}
      assert (Function (TH true_i) (const c_2)) (\ x -> e)
  ==  {- Definition of |assert| -}
      \ x' -> (assert (const c_2 x') COMP \ x -> e) x' COMP assert (TH true_i)
  ==  {- Definition of |const| -}
      \ x' -> (assert c_2 COMP \ x -> e) x' COMP assert (TH true_i)
  ==  {- Apply |x'| -}
      \ x' -> (assert c_2 (e[x/x'])) COMP assert (TH true_i)
  ==  {- Missing steps -}
      \ x' -> assert c_2 (e[x/x'])
  ==  {- Apply IH -}
      \ x' -> e[x/x']
\end{spec}

Part of this proof is missing, because it could not be proved in time. Instead
of a formal proof, we give an informal reasoning for why we think it is
possible to give a proof for this case. We can reason that a valid contract
will be inferred by \CW~for |x| somewhere in expression |e|. A substitution
will be returned which will substitute the inferred contract for the fresh
contract |true_i|. By this Proposition, we then know that asserting this
inferred contract yields the identity of the value for which we assert this
contract. This allows us to eliminate the right-most assertion:

\begin{spec}
      \ x' -> (assert c_2 (e[x/x'])) COMP assert (TH true_i)
  ==  {- |assert| is identity -}
      \ x' -> assert c_2 (e[x/x'])
\end{spec}

With all occurrences of |x| replaced by |x'|

< \ x' -> assert c_2 (e[x/x'])

is equivalent to

< \ x -> assert c_2 e

up to $\alpha$-conversion, so we can apply our induction hypothesis, completing
our proof.


\subsection*{Case |e_1 e_2|}

If |CW GAMMA (e_1 e_2) = (TH_3 COMP TH_2 COMP TH_1, TH_3 true_i)|, then |assert
(TH_3 true_i) (e_1 e_2) = (e_1 e_2)|

\begin{description}
  \item[IH1] If |CW GAMMA e_1 = (TH_1, c_1 >-> c)|, then |assert (c_1 >-> c) e_1 = e_1|
  \item[IH2] If |CW (TH_1 GAMMA) e_2 = (TH_2, c_2)|, then |assert c_2 e_2 = e_2|
\end{description}

\subsubsection{Proof:}
\begin{spec}
      assert (TH_3 true_i) (e_1 e_2)
  ==  {- Definition of |TH_3| -}
      assert (UNIFY (TH_2 c_1 >-> c, c_2 >-> true_i) true_i) (e_1 e_2)
  ==  {- Definition of |UNIFY| -}
      assert ((UNIFY (TH_2 c, UNIFY (TH_2 c_1, c_2) true_i) COMP UNIFY (TH_2 c_1, c_2)) true_i) (e_1 e_2)
  ==  {- Missing steps -}
      ...
  ==  {- Case |e_1| -}
      assert (c_1 >-> c) e_1
  ==  {- Apply IH1 -}
      e_1
  ==  {- Case |e_2| -}
      assert c_2 e_2
  ==  {- Apply IH2 -}
      e_2
\end{spec}

Again, part of the proof is missing and is left as future work. We assume that
this proof can also be given, because |e_1| will be some function and |e_2|
some other expression. If we finish the proof for lambda abstraction, we can
reason that we can also complete this proof for |e_1|. When we then also assume
that this case can be proved, we can also reason that the case for |e_2| can be
proved.


\subsection*{Case |let x = e_1 in e_2|}

If |CW GAMMA (let x = e_1 in e_2) = (TH_3 COMP TH_2 COMP TH_1, c)|, then
|assert c (let x = e_1 in e_2) = (let x = e_1 in e_2)|

\begin{description}
  \item[IH1] If |CW (GAMMA[x ||-> true_i]) e_1 = (TH_1, c_1)|, then |assert c_1 e_1 = e_1|
  \item[IH2] If |CW (TH_2 COMP TH_1 GAMMA[x ||-> gen(TH_2 COMP TH_1 GAMMA) TH_2 c_1]) e_2 = (TH_3, c)|, then |assert c e_2 = e_2|
\end{description}

\subsubsection{Proof:}
True by IH2, from which follows that if |CW GAMMA (let x = e_1 in e_2) = (TH_3
COMP TH_2 COMP TH_1, c)|, then |assert c (let x = e_1 in e_2) = (let x = e_1 in
e_2)|


\subsection*{Case |(x : xs)|}

To show: if |CW GAMMA (x : xs) = (TH_2 COMP TH_1, LIST_i <@> c)|, then |assert
(LIST_i <@> c) (x : xs) = (x : xs)|

\begin{description}
  \item[IH1] If |CW GAMMA x = (TH_1, c)|, then |assert c x = x|
  \item[IH2] If |CW GAMMA xs = (TH_2, LIST_i <@> c)|, then |assert (LIST_i <@> c) xs = xs|
\end{description}

\subsubsection{Proof:}
\begin{spec}
      assert (list <@> c) (x : xs) = (x : xs)
  ==  {- Definition of |<@>| -}
      assert (list & Functor c) (x : xs) = (x : xs)
  ==  {- Definition of |&| -}
      (assert (Functor c) COMP assert list) (x : xs)
  ==  {- Definition of |assert| and |list| -}
      assert (Functor c) (x : xs)
  ==  {- Definition of |assert| -}
      fmap (assert c) (x : xs)
  ==  {- Definition of |fmap| -}
      (assert c x : fmap (assert c) xs)
  ==  {- Apply IH1 -}
      (x : fmap (assert c) xs)
  ==  {- Definition of |<@>|, |&|, |assert| and |list| in IH2, then apply IH2 -}
      (x : xs)
\end{spec}

from which follows that if |CW GAMMA (x : xs) = (TH_2 COMP TH_1, LIST_i <@>
c)|, then |assert (LIST_i <@> c) (x : xs) = (x : xs)|


\subsection*{Case |Just x|}

To show: if |CW GAMMA (Just x) = (TH, maybe <@> c)|, then |assert (maybe <@> c)
(Just x) = (Just x)|.

\begin{description}
  \item[IH] If |CW GAMMA x = (TH, c)|, then |assert c x = x|
\end{description}

\subsubsection*{Proof:}
\begin{spec}
      assert (maybe <@> c) (Just x)
  ==  {- Definition of |<@>| -}
      assert (maybe & Functor c) (Just x)
  ==  {- Definition of |&| -}
      (assert (Functor c) COMP assert maybe) (Just x)
  ==  {- Definition of |assert| and |maybe| -}
      assert (Functor c) (Just x)
  ==  {- Definition of |assert| -}
      fmap (assert c) (Just x)
  ==  {- Definition of |fmap| -}
      Just (assert c x)
  ==  {- Apply IH -}
      Just x
\end{spec}

From which follows that if |CW GAMMA (Just x) = (TH, maybe <@> c)|, then
|assert (maybe <@> c) (Just x) = (Just x)|.


\subsection*{Case |(x, y)|}

To show: if |CW GAMMA (x, y) = (TH_2 COMP TH_1, pair <@@> (c_1, c_2))|, then
|assert (pair <@@> (c_1, c_2)) (x, y) = (x, y)|.

\begin{description}
  \item[IH1] If |CW GAMMA x = (TH_1, c_1)|, then |assert c_1 x = x|
  \item[IH2] If |CW GAMMA y = (TH_2, c_2)|, then |assert c_2 y = y|
\end{description}

\subsubsection*{Proof:}
\begin{spec}
      assert (pair <@@> (c_1, c_2)) (x, y)
  ==  {- Definition of |<@@>| -}
      assert (pair & Bifunctor c_1 c_2) (x, y)
  ==  {- Definition of |&| -}
      (assert (Bifunctor c_1 c_2) COMP assert pair) (x, y)
  ==  {- Definition of |assert| and |pair| -}
      assert (Bifunctor c_1 c_2) (x, y)
  ==  {- Definition of |assert| -}
      bimap (assert c_1) (assert c_2) (x, y)
  ==  {- Definition of |bimap| -}
      (assert c_1 x, assert c_2 y)
  ==  {- Apply IH1, IH2 -}
      (x, y)
\end{spec}

from which follows that if |CW GAMMA (x, y) = (TH_2 COMP TH_1, pair <@@> (c_1,
c_2))|, then |assert (pair <@@> (c_1, c_2)) (x, y) = (x, y)|.


\subsection*{Case |Left x|}

To show: if |CW GAMMA (Left x) = (TH, either <@@> (c, true))|, then |assert
(either <@@> (c, true)) (Left x) = (Left x)|.

\begin{description}
  \item[IH] If |CW GAMMA x = (TH, c)|, then |assert c x = x|
\end{description}

\subsubsection*{Proof:}
\begin{spec}
      assert (either <@@> (c, true)) (Left x)
  ==  {- Definition of |<@@>| -}
      assert (either & Bifunctor c true) (Left x)
  ==  {- Definition of |&| -}
      (assert (Bifunctor c true) COMP assert either) (Left x)
  ==  {- Definition of |assert| and |either| -}
      assert (Bifunctor c true) (Left x)
  ==  {- Definition of |assert| -}
      bimap (assert c) (assert true) (Left x)
  ==  {- Definition of |bimap| -}
      Left (assert c x)
  ==  {- Apply IH -}
      Left x
\end{spec}

from which follow that if |CW GAMMA (Left x) = (TH, either <@@> (c, true))|,
then |assert (either <@@> (c, true)) (Left x) = (Left x)|.

\bibliographystyle{plain}
\bibliography{bibliography}
\end{document}
