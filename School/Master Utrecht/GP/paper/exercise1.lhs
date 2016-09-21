> import Data.Generics.Multiplate
> import Data.Functor.Constant
> import Data.Functor.Identity
> import Control.Applicative

Convert the following Exp GADT to a multiplate-compatible datatype and
define a multiplate instance for it. Then, write a function 'evaluate' that evaluates
valid Exp values.

Example:
evaluate $ Add (IntE 5) (If (IsZero (Add (IntE 5) (IntE (-5)))) (IntE 20) (IntE 25))
IntE 25

data Exp :: * -> * where
IntE :: Int -> Exp Int
BoolE ::Bool -> Exp Bool
IsZero :: Exp Int -> Exp Bool
Add :: Exp Int -> Exp Int -> Exp Int
If :: Exp Bool -> Exp a -> Exp a -> Exp a

Solution:

> data Exp = IsZero Exp | Add Exp Exp | If Exp Exp Exp | IntE Int | BoolE Bool deriving (Eq,Show)

> data Plate f = Plate { expr :: Exp -> f Exp }

> instance Multiplate Plate where
>  multiplate child = Plate buildExp
>   where
>    buildExp (IsZero x) = IsZero <$> expr child x
>    buildExp (Add x y) = Add <$> expr child x <*> expr child y
>    buildExp (If p t f) = If <$> expr child p <*> expr child t <*> expr child f
>    buildExp x = pure x
>  mkPlate build = Plate (build expr)

> foldingPlate :: Plate Identity
> foldingPlate = Plate { expr = exprEval }

> exprEval (IsZero (IntE x)) = return (BoolE (x==0))
> exprEval (Add (IntE x) (IntE y)) = return (IntE (x+y))
> exprEval (If (BoolE p) (IntE t) (IntE f)) = return (IntE (if p then t else f))
> exprEval (If (BoolE p) (BoolE t) (BoolE f)) = return (BoolE (if p then t else f))
> exprEval x = pure x

> transformPlate = mapFamily foldingPlate

> value1 = Add (IntE 5) (If (IsZero (Add (IntE 5) (IntE (-5)))) (IntE 20) (IntE 25))

> evaluate = traverseFor expr transformPlate