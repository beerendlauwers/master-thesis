{-# LANGUAGE GADTs
           , KindSignatures
           , MultiParamTypeClasses
           , TypeFamilies
           , TypeOperators
           #-}
module ListRepF where

import Generics.MultiRec.BaseF

data ListU :: (* -> *) -> * where
    List :: ListU []

type instance PF (ListU) = K () :>: []
                         :+: (E :*: I []) :>: []

instance Fam ListU [] where
    from [] = L (Tag (K ()))
    from (x : xs) = R (Tag (E x :*: I (I0F xs)))
    to (L (Tag (K ()))) = []
    to (R (Tag (E x :*: I (I0F xs)))) = x : xs
    index = List
