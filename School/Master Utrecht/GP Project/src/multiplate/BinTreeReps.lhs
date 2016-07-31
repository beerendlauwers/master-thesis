> module BinTreeReps where

> import BinTreeDatatype
> import Control.Applicative
> import Data.Generics.Multiplate
> import Data.Functor.Constant

data BinTree a = Leaf a | Bin (BinTree a) (BinTree a)
                 deriving Show

> data BinTreePlate a f = BinTreePlate 
>                       { leaf :: a -> f (BinTree a )
>                       , bin :: BinTree a -> BinTree a -> f (BinTree a )
>                       }

> treePlateA :: BinTreePlate a f -> BinTree a -> f (BinTree a)
> treePlateA plate (Leaf x) = leaf plate x
> treePlateA plate (Bin t1 t2) = bin plate t1 t2

> instance Multiplate (BinTreePlate a) where
>   multiplate child = BinTreePlate (\a -> Leaf <$> pure a) (\t1 t2 -> Bin <$> treePlateA child t1 <*> treePlateA child t2)
>   mkPlate build = BinTreePlate (\a -> build treePlateA (Leaf a)) (\t1 t2 -> build treePlateA (Bin t1 t2))