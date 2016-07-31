{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE DefaultSignatures #-}
{-# LANGUAGE FlexibleContexts #-}

module Encode where


import Generics.Deriving

data Bit = Zero | One

class GEncode f where
    gencode :: f a -> [Bit]

instance GEncode U1 where
    gencode U1 = []
instance (GEncode a, GEncode b) => GEncode (a :+: b) where
    gencode (L1 x) = Zero : gencode x
    gencode (R1 x) = One : gencode x
instance (GEncode a, GEncode b) => GEncode (a :*: b) where
    gencode (x :*: y) = gencode x ++ gencode y
instance (Encode a) => GEncode (K1 i a) where
    gencode (K1 x) = encode x
instance (GEncode a) => GEncode (M1 i c a) where
    gencode (M1 x) = gencode x

class Encode a where
    encode :: a -> [Bit]
    default encode :: (Generic a, GEncode (Rep a)) => a -> [Bit]
    encode = gencode.from
    
instance Encode Int where encode = gencode.from