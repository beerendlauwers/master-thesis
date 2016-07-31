{-# LANGUAGE DeriveGeneric #-}  


module GRoseDatatype where
import Generics.Deriving

data GRose f a = GRose a (f (GRose f a))
                 deriving Generic