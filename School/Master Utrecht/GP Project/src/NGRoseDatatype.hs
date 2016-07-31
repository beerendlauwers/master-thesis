{-# LANGUAGE DeriveGeneric #-}  

module NGRoseDatatype where

import Generics.Deriving

-- Very nested GRose datatype

data NGRose f a = NGRose a (f (NGRose (Comp f f) a)) deriving Generic

newtype Comp f g a = Comp (f (g a))

-- data Fork a = Fork a a

ngrose1 :: NGRose [] Int
ngrose1 = NGRose 1 [NGRose 3 (Comp [])]

ngrose2 :: NGRose [] Int
ngrose2 = NGRose 1 [NGRose 3 (Comp [[NGRose 7 (Comp (Comp []))]])]

