

module BeerendLauwers4 where

open import Prelude
open import Orn

-- Code
MaybeD : Desc ?
MaybeD = s Bool (false? say tt
                 true?  ask tt * say tt)

-- Interpreted code
Nat' : Set
Nat' = µ NatD tt

zero' : Nat'
zero' = ? false , refl ?

suc' : Nat' ? Nat'
suc' n = ? true , n , refl ?
