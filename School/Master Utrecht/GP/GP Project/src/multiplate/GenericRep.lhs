> {-# OPTIONS_GHC -XDeriveDataTypeable -XRankNTypes  #-}

> module GenericRep where

> import Prelude hiding(sum)
> import Control.Applicative
> import Data.Generics.Multiplate
> import Data.Functor.Constant

> data Unit    = Unit       deriving Show
> data Sum a b = L a | R b  deriving Show
> data Prod a b = a :*: b    deriving Show

> data Rep a b = AUnit Unit | Sum a b | Prod a b


> data RepPlate a b f = RepPlate 
>                       { unit :: f (Rep a b)
>                       , sum :: a -> b -> f (Rep a b)
>                       , prod :: a -> b -> f (Rep a b)
>                       }

> convertToRepPlate :: RepPlate a b f -> [a] -> f (Rep a b)
> convertToRepPlate plate (x:xs) = sum plate x xs
> convertToRepPlate plate [] = unit plate


 instance Multiplate (RepPlate a b) where
   multiplate child = WTreePlate (\a -> Leaf <$> pure a) (\t1 t2 -> Fork <$> treePlateAW child t1 <*> treePlateAW child t2) (\t w -> WithWeight <$> treePlateAW child t <*> pure w)
   mkPlate build = WTreePlate (\a -> build treePlateAW (Leaf a)) (\t1 t2 -> build treePlateAW (Fork t1 t2)) (\ t w -> build treePlateAW (WithWeight t w))