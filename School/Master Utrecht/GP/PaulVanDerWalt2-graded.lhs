\documentclass[]{article}
%include lhs2TeX.fmt
%include forall.fmt
%include greek.fmt
\usepackage{hyperref}

\author{Paul van der Walt\\ \url{paul@@denknerd.org}}
\date{\today}
\title{GP Exercise set \#2}
\renewcommand \thesection{\Roman{section}}
\renewcommand \thesubsection{\alph{subsection}}
\renewcommand \thesubsubsection{\roman{subsubsection}}
\begin{document}

\maketitle

\section*{Preamble}\label{sec:pre}

Here we start by showing our Haskell module header and introducing the
data type.
which we will be using for these exercises.


\begin{code}

{-# LANGUAGE NoMonomorphismRestriction,
             DeriveDataTypeable,
             GADTs #-}
{-# LANGUAGE KindSignatures,
             RankNTypes,
             FlexibleInstances #-}
{-# LANGUAGE StandaloneDeriving,
             FlexibleContexts,
             MultiParamTypeClasses #-}
{-# LANGUAGE TypeOperators #-}

module Exercise2 where

import Generics.SYB (Typeable, Data, everything, mkQ, toConstr, isAlgType, dataTypeOf)
import Generics.EMGM hiding (show, max)
import Generics.EMGM.Functions.Collect
import Generics.EMGM.Functions.Crush
import Control.Monad
import Control.Applicative
import Data.Char
import Debug.Trace (trace)
\end{code}

\section{Exercise 1: SYB}
Grade: 1 / 1
Comment: Nice use of the everything functionality!

Here we recall the function |typeInfo| from exercise set 1; we will now implement that
same function in SYB.

\begin{code}
-- for testing purposes.
data Company    = C [Dept]               deriving (Eq, Show, Typeable, Data)
data Dept       = D Name Manager [CUnit] deriving (Eq, Show, Typeable, Data)
data ThinkTank  = TK Name [CUnit]        deriving (Eq, Show, Typeable, Data)
data CUnit      = PU Employee | DU Dept  deriving (Eq, Show, Typeable, Data)
data Employee   = E Person Salary        deriving (Eq, Show, Typeable, Data)
data Person     = P Name Address         deriving (Eq, Show, Typeable, Data)
data Salary     = Salary Int             deriving (Eq, Show, Typeable, Data)
type Manager    = Employee
type Name       = String
type Address    = String

augusto, justin, andrei, raymond :: Employee
augusto = E (P "Augusto"    "Brazil")       (Salary 1000)
justin  = E (P "Justin"     "England")      (Salary 4000)
raymond = E (P "Raymond"    "Netherlands")  (Salary 7000)
andrei  = E (P "Andrei"     "Romania")      (Salary 9000)
genCom  :: Company
genCom  = C [ D "Research" augusto [PU justin, PU andrei]
            , D "Strategy" raymond [ ]
            ]

\end{code}

For interest's sake, try |typeInfo mytree| or |typeInfo genCom|.
\begin{code}

typeInfo       :: Data alpha => alpha -> (Int, Char, [String])
typeInfo a     = (sumInts a,
                  maxChar a,
                  constructors a
                 )


sumInts :: Data alpha => alpha -> Int
sumInts = everything (+) (mkQ 0 id)

maxChar :: Data alpha => alpha -> Char
maxChar = everything max (mkQ '\NUL' id)

constructors :: (Data alpha, Typeable alpha) => alpha -> [String]
constructors = everything (++) (\x -> [show (toConstr x) | isAlgType (dataTypeOf x)])

-- A parameterised datatype for binary trees with data at the leafs
data (Data a, Data w) =>
     Tree a w = Leaf a
              | Fork (Tree a w) (Tree a w)
              | WithWeight (Tree a w) w
       deriving (Typeable, Data, Show)


-- A typical tree
mytree :: Tree Int Int
mytree = Fork (WithWeight (Leaf 42) 1)
              (WithWeight (Fork (Leaf 88) (Leaf 37)) 2)



\end{code}

\section{Exercise 2: Spine view}

\subsection{Spine lib implementation}

In this exercise we will implement a spine library whose universe is formed of the types found in the
   spine package as well as the following Exp GADT:

\begin{code}
data Exp    :: * -> * where
  IntE      :: Int                              -> Exp Int
  BoolE     :: Bool                             -> Exp Bool
  IsZero    :: Exp Int                          -> Exp Bool
  Add       :: Exp Int      -> Exp Int          -> Exp Int
  If        :: Exp Bool     -> Exp a -> Exp a   -> Exp a

\end{code}

The following code was taken from the @spine@ package and will be extended.
\begin{code}

-- Ripped from SPL's spine package.
data Type :: * -> * where
  Char  :: Type Char
  Int   :: Type Int
  Bool  :: Type Bool
  List  :: Type a -> Type [a]
  Pair  :: Type a -> Type b -> Type (a, b)
  Exp   :: Type a -> Type (Exp a) -- added this case for Exp :: * -> *

data Typed a = (:>) { typeOf :: Type a, val :: a }

infixl 1 :>

data Constr a = Constr { constr :: a, name :: String }

data Spine  :: * -> * where
  Con       :: Constr a                     -> Spine a
  (:<>:)    :: Spine (a -> b) -> Typed a    -> Spine b

infixl 0 :<>:

type Datatype a = [Signature a]

data Signature  :: * -> * where
  Sig           :: Constr a                         -> Signature a
  (:&:)         :: Signature (b -> a) -> Type b     -> Signature a

infixl 0 :&:


\end{code}

2a
Grade: 1.5 / 1.5

\begin{code}

fromSpine               :: Spine a -> a
fromSpine (Con c)       = constr c
fromSpine (f :<>: x)    = fromSpine f (val x)

toSpine   :: Typed a -> Spine a
toSpine (Char       :> c)      = Con (Constr c (show c))
toSpine (Int        :> i)      = Con (Constr i (show i))
toSpine (Bool       :> b)      = Con (Constr b (show b))
toSpine (List _     :> [])     = Con (Constr [] "[]")
toSpine (List a     :> (x:xs)) = Con (Constr (:) ":") :<>: (a :> x) :<>: (List a :> xs)
toSpine (Pair a b   :> (x, y)) = Con (Constr (,) ",") :<>: (a :> x) :<>: (b :> y)
toSpine (Exp a      :> e)      = toSpineExp (Exp a :> e)

-- split the Exp-conversion bit into a separate function for clarity.
toSpineExp   :: Typed (Exp a) -> Spine (Exp a)
toSpineExp (Exp Int  :> IntE i)         = Con  (Constr IntE "Int")   :<>: (Int      :> i)
toSpineExp (Exp Bool :> BoolE b)        = Con  (Constr BoolE  "Bool") :<>: (Bool     :> b)
toSpineExp (Exp Bool :> IsZero i)       = Con  (Constr IsZero "IsZero") :<>: (Exp Int  :> i)
toSpineExp (Exp Int  :> Add e_1 e_2)    = Con  (Constr Add    "Add") :<>: (Exp Int  :> e_2)
                                                      :<>: (Exp Int  :> e_2)
toSpineExp (Exp a    :> If c e_1 e_2)   = Con  (Constr If "If")     :<>: (Exp Bool :> c)
                                                      :<>: (Exp a    :> e_1)
                                                      :<>: (Exp a    :> e_2)
toSpineExp _                            = error "This isn't be possible."

instance Show a => Show (Spine a) where
  show c = show (fromSpine c)

-- a nice expression printer.
instance Show a => Show (Exp a) where
  show (IntE i) = show i
  show (BoolE b) = show b
  show (IsZero e) = "( 0 == " ++ show e ++ " )"
  show (Add e_1 e_2) = "("++show e_1++"+"++show e_2++")"
  show (If  c e_1 e_2) = "if " ++ show c ++ " {\n  "++show e_1++"\n} else {\n  " ++ show e_2 ++ "\n}"

-- example generic function:
gsum :: Type a -> a -> Int
gsum Int n = n
gsum t v   = gsum' (toSpine (t :> v))
  where gsum' :: Spine a -> Int
        gsum' (Con c)       = 0
        gsum' (f :<>: (t' :> v')) = gsum' f + gsum t' v'

\end{code}
\subsection{fromConstrM}

Defining a version of @fromConstrM@ using the spine view.
Grade: 2 / 2

\begin{code}


fromConstrM :: forall m a. (Monad m) => (forall b.Type b -> m (Signature b)) -> Type a -> m a
fromConstrM f a = f a >>= unSig f

unSig :: (Monad m) => (forall b.Type b -> m (Signature b)) -> Signature a -> m a
unSig f (Sig c_a)        = return (constr c_a)
unSig f (sig_ba :&: t_b) = unSig f sig_ba
                                    `ap`
                                    fromConstrM f t_b



\end{code}
\subsection{Value generation}
Here we use the function @fromConstrM@ (our own implementation) to generate some values from
our universe.

Grade: 0.5 / 0.5
Comment: Shouldn't it be 0 .. 127 for Char?

\begin{code}
datatype            :: Type a -> Datatype a
datatype Char       = [ Sig (Constr (chr i) (show i))   | i <- [0 .. 126]]
datatype Int        = [ Sig (Constr i (show i))         | i <- [minBound .. maxBound]]
datatype Bool       = [ Sig (Constr False "False")
                      , Sig (Constr True  "True" )
                      ]
datatype (List a)   = [ Sig (Constr [] "[]"  )
                      , Sig (Constr (:) ":"  ) :&: a :&: List a
                      ]
datatype (Pair a b) = [ Sig (Constr (,) ","  )  :&: a :&: b]
datatype a@(Exp _)  = datatypeExp a

datatypeExp             :: Type (Exp a) -> Datatype (Exp a)
datatypeExp (Exp Int)   =    [ Sig (Constr (IntE i) (show i)) | i <- [minBound .. maxBound]]
                          ++ [ Sig (Constr Add "Add") :&: Exp Int  :&: Exp Int ]
                          ++ [ Sig (Constr If "If")   :&: Exp Bool :&: Exp Int :&: Exp Int ]
datatypeExp (Exp Bool)  =    [ Sig (Constr (BoolE True) "True")
                             , Sig (Constr (BoolE False) "False")
                             ]
                          ++ [ Sig (Constr IsZero "IsZero") :&: Exp Int ]
                          ++ [ Sig (Constr If "If" )  :&: Exp Bool :&: Exp Bool :&: Exp Bool ]

-- we need to generate all possible lists and values.
-- the function generateBounded was useful for testing; constructors
-- up to and including a specified depth are output.
generateBounded :: Type a -> Int -> [a]
generateBounded a 0 = []
generateBounded a n = concat [generate' s (n - 1) | s <- datatype a]
generate' :: Signature a -> Int -> [a]
generate' (Sig c) d = [constr c]
generate' (s :&: a) d = [f x | f <- generate' s d
                             , x <- generateBounded a d]

-- okay, do stuff with fromConstrM in the List monad.
generate     :: Type a -> [a]
generate     = fromConstrM datatype


generateExp  :: Type a -> [Exp a]
generateExp  = generate . Exp


\end{code}

\section{Exercise 3: EMGM maximum depth}

Here we  define a generic function in EMGM to compute the maximum "depth" of a value.
   Depth is measured by the number of nested constructors. For example, |depth 'a' == 0| ,
   | depth [ ] == 1| , | depth [1] == 2 | , |depth ["abc", "ab"] == 5| , etc.

Grade: 1 / 1
   
\begin{code}
newtype Gdepth a = Gdepth {selDepth :: a -> Int}

gdepth_null       _           = 0
gdepth_plus ra rb (  L a)     = selDepth ra a
gdepth_plus ra rb (  R b)     = selDepth rb b
gdepth_prod ra rb (a :*: b)   = max (selDepth ra a) (selDepth rb b)
gdepth_dt   ep ra a           =     selDepth ra (from ep a)
gdepth_con     ra a           = 1 + selDepth ra a

instance Generic Gdepth where
  runit       = Gdepth gdepth_null
  rint        = Gdepth gdepth_null
  rinteger    = Gdepth gdepth_null
  rfloat      = Gdepth gdepth_null
  rdouble     = Gdepth gdepth_null
  rchar       = Gdepth gdepth_null
  rsum  ra rb = Gdepth (gdepth_plus ra rb)
  rprod ra rb = Gdepth (gdepth_prod ra rb)
  rtype ep ra = Gdepth (gdepth_dt ep ra)
  rcon  d  ra = Gdepth (gdepth_con ra)

-- Note that `depth []` will fail, since we cannot figure
-- out which instance of `Rep Gdepth a` to use. Something like
-- `depth ([]::[Int])` (explicit annotation) will work, since a
-- specific instance can be called. This is normal behaviour.
--
-- For the same reason you should annotate `depth [1::Int]`.
depth :: (Rep Gdepth a) => a -> Int
depth = selDepth rep

\end{code}
\section{Exercise 4: EMGM}

\subsection{Zig and Zag instances}
Here we will embed @Zig@ and @Zag@ in the universe of EMGM.

\begin{code}

data Zig a b    =   ZigEnd  a
                |   ZigCons a   (Zag a b)
data Zag a b    =   ZagEnd  b
                |   ZagCons b   (Zig a b)

deriving instance (Show a, Show b) => Show (Zig a b)
deriving instance (Show a, Show b) => Show (Zag a b)
\end{code}

The way to do this is to define representations for both.

\begin{code}

rZig :: (Generic g, Rep g a, Rep g (Zag a b)) => g a -> g b -> g (Zig a b)
rZig r_a r_b = rtype (EP fromZig toZig)
                     (rsum (rcon (ConDescr "ZigEnd" 1 False Prefix) rep)
                           (rcon (ConDescr "ZigCons" 2 False Prefix) (rprod rep rep))
                     )

rZag :: (Generic g, Rep g b, Rep g (Zig a b)) => g a -> g b -> g (Zag a b)
rZag r_a r_b = rtype (EP fromZag toZag)
                     (rsum (rcon (ConDescr "ZagEnd" 1 False Prefix) rep)
                           (rcon (ConDescr "ZagCons" 2 False Prefix) (rprod rep rep))
                     )


fromZig :: Zig t a -> t :+: (t :*: Zag t a)
fromZig (ZigEnd a)      = L a
fromZig (ZigCons a zag) = R (a :*: zag)
toZig :: (a :+: (a :*: Zag a b)) -> Zig a b
toZig   (L a)           = ZigEnd a
toZig   (R (a :*: zag)) = ZigCons a zag


fromZag :: Zag t a -> a :+: (a :*: Zig t a)
fromZag (ZagEnd b)      = L b
fromZag (ZagCons b zig) = R (b :*: zig)
toZag :: (t :+: (t :*: Zig a t)) -> Zag a t
toZag   (L b)           = ZagEnd b
toZag   (R (b :*: zig)) = ZagCons b zig

\end{code}

We also need a few instances to make the generic functions from @Generics.EMGM.Functions.*@ work. Specifically,
we need the following.

Grade: 1.0 / 2
Comment: Missing FRep, BiFRep2, Collect, Everywhere, Everywhere' instances

Note that the functions from @Show@, @Read@, @Compare@, @Enum@, @Collect@, @Everywhere@, 
\begin{code}


instance (Generic g, Rep g a, Rep g b) => Rep g (Zig a b) where
  rep = rZig rep rep
instance (Generic g, Rep g a, Rep g b) => Rep g (Zag a b) where
  rep = rZag rep rep


\end{code}


\subsection{Some functions on Zig and Zag}
Here we define some generic consumer functions on @Zig@ and @Zag@
structures.

Here are some test values first.

\begin{code}

test_collect :: Zig Int Char
test_collect = ZigCons 1 (ZagCons 'a' (ZigCons 2 (ZagEnd 'b')))

test_collect_allChar :: Zig Char Char
test_collect_allChar = ZigCons 'x' (ZagCons 'a' (ZigCons 'x' (ZagEnd 'b')))

\end{code}

\subsubsection{collectChars}

|collectChars| collects a list of all characters from a |Zig| value.

Grade: 0.5 / 0.5

\begin{code}

collectChars :: (Rep (Collect [] Char) a, Rep (Collect [] Char) b) => Zig a b -> [Char]
collectChars = collect

\end{code}

\subsubsection{collectZagChars}

--TODO make this work.
|collectZagChars| collects a list of only the characters found in |Zag|
values within a |Zig| value.

% \begin{code}
% 
% -- This is an instance I think I want.
% --instance (Generic g, Rep g a) => FRep g (Zig a) where
% --  frep = rZigA
% 
% --rZigA :: (Generic g, Rep g a, Rep g (Zag a b)) => g a -> g b -> g (Zig a b)
% -- rZigA r_b = rtype (EP fromZigA toZigA)
% --                       (rsum (rcon (ConDescr "ZigEnd-dropvalue" 1 False Prefix) runit)
% --                             (rcon (ConDescr "ZigCons" 2 False Prefix) (rprod runit rep))
% --                       )
% -- fromZigA :: Zig t a -> t :+: (t :*: Zag t a)
% -- fromZigA (ZigEnd _)      = Unit
% -- fromZigA (ZigCons _ zag) = R (Unit :*: zag)
% -- --toZigA :: (a :+: (a :*: Zag a b)) -> Zig a b
% -- toZigA   (Unit)             = ZigEnd undefined
% -- toZigA   (R (Unit :*: zag)) = ZigCons undefined zag
% --eeeeeh....
% --instance (Generic g, Rep g a) => FRep g (Zag a) where
% --  frep = trace "hm" frepZag
% \end{code}
\begin{code}
frepZig = undefined
frepZag = undefined


-- I would expect this to work.
collectZagChars :: (FRep (Crush [Char]) (Zig b)) => Zig b Char -> [Char]
collectZagChars = flattenl
\end{code}

\subsubsection{collectZigChars}
Bla. %TODO

|collectZigChars| collects a list of only the characters found in Zig
values within a Zig value.

\begin{code}

collectZigChars :: () => Zig Char b -> [Char]
collectZigChars = undefined

\end{code}

\subsubsection{collectZigZagChars}
Bla. %TODO

|collectZigZagChars| collects two lists of characters found in |Zig| values
(without requiring types to indicate). The first list is the collection of |Zig|-based
characters, and the second is the collection of |Zag|-based characters.

Possibly using |Data.Typeable.cast| here.

\begin{code}

-- use unzipwith here?

collectZigZagChars :: () => Zig a b -> ([Char],[Char])
collectZigZagChars = undefined

\end{code}


Final Grade: 7.5 / 10



\end{document}
