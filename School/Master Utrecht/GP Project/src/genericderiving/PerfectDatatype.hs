{-# LANGUAGE DeriveGeneric #-}

module PerfectDatatype where

import Generics.Deriving

data Perfect a = Zero a | Succ (Perfect (Fork a)) deriving (Show, Generic)
data Fork a = Fork a a deriving (Show, Generic)

perfect :: Perfect Int
perfect = Succ (Succ (Succ (Zero (Fork (Fork (Fork 2 3)
                                             (Fork 5 7))
                                       (Fork (Fork 11 13)
                                             (Fork 17 19))))))
perfect2 :: Perfect Int
perfect2 = Succ (Zero (Fork 1 2))
