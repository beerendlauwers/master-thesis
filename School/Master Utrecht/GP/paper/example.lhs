> import Data.Generics.Multiplate
> import Data.Functor.Constant
> import Data.Functor.Identity
> import Control.Applicative

> data Expr = Con Int
>           | Add Expr Expr
>           | Mul Expr Expr
>           | EVar Var
>           | Let Decl Expr
>           deriving (Eq, Show)
> 
> data Decl = Var := Expr
>           | Seq Decl Decl
>           deriving (Eq, Show)
> 
> type Var = String

> data Plate f = Plate
>            { expr :: Expr -> f Expr
>            , decl :: Decl -> f Decl
>            }

> instance Multiplate Plate where
>  multiplate child = Plate buildExpr buildDecl
>   where
>    buildExpr (Add e1 e2) = Add <$> expr child e1 <*> expr child e2
>    buildExpr (Mul e1 e2) = Mul <$> expr child e1 <*> expr child e2
>    buildExpr (Let d e) = Let <$> decl child d <*> expr child e
>    buildExpr e = pure e
>    buildDecl (v := e) = (:=) <$> pure v <*> expr child e
>    buildDecl (Seq d1 d2) = Seq <$> decl child d1 <*> decl child d2
>  mkPlate build = Plate (build expr) (build decl)

> doConstFold :: Plate Identity
> doConstFold = purePlate { expr = expr }
>  where
>   expr (Add (Con x) (Con y)) = return (Con (x + y))
>   expr (Mul (Con x) (Con y)) = return (Con (x * y))
>   expr x = pure x

> constFoldPlate = mapFamily doConstFold

> d1 :: Decl
> d1 = "x" := (Add (Mul (Con 42) (Con 68)) (Con 7))

> evaluate = traverseFor decl constFoldPlate