{-# OPTIONS --universe-polymorphism #-}

module OrnNat where

open import Prelude
open import Orn

-- Code
NatD : Desc ?
NatD = s Bool (false? say tt
               true?  ask tt * say tt)

-- Interpreted code
Nat' : Set
Nat' = µ NatD tt

zero' : Nat'
zero' = ? false , refl ?

suc' : Nat' ? Nat'
suc' n = ? true , n , refl ?
