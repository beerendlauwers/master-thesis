{-# LANGUAGE GADTs
           , KindSignatures
           , MultiParamTypeClasses
           , TypeFamilies
           , TypeOperators
           , TemplateHaskell
           #-}
module ListRep where

import Generics.MultiRec
import Generics.MultiRec.TH

data ListU :: * -> * -> * where
    List :: ListU a [a]

-- $(deriveConstructors [''ListU a])
-- $(deriveFamily ''ListU [''ListU] "PF_ListU")

-- type instance PF ListU = PF_ListU
type instance PF (ListU a) = U :>: [a]
                         :+: (K a :*: I ([a])) :>: [a]

instance Fam (ListU a) where
    from List [] = L (Tag U)
    from List (x : xs) = R (Tag (K x :*: I (I0 xs)))
    to List (L (Tag U)) = []
    to List (R (Tag (K x :*: I (I0 xs)))) = x : xs

index = List

instance EqS (ListU a) where
    eqS List List = Just Refl
