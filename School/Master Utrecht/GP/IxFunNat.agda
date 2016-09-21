{-# OPTIONS --type-in-type #-}
{-# OPTIONS --no-termination-check #-}
module IxFunNat where

open import Prelude
open import IxFun

-- Code for the functor (0 parameters, 1 recursive position)
`NatF' : (? + ?) ? ?
`NatF' = U ? I (inr tt)

-- Code for the fixed point
`Nat' : ? ? ?
`Nat' = Fix `NatF'

-- Actual type is in Prelude

-- Conversions
fromNat : {r : Indexed ?} {o : ?} ? Nat ? ? `Nat' ? r o
fromNat zero    = ? inl tt ?
fromNat (suc n) = ? inr (fromNat n) ?

toNat : {r : Indexed ?} {o : ?} ? ? `Nat' ? r o ? Nat
toNat ? inl tt ? = zero
toNat ? inr n ?  = suc (toNat n)

-- Proofs of isomorphism
toFromNat? : ? {r o} {n : Nat} ? toNat {r} {o} (fromNat n) = n
toFromNat? {n = zero}  = refl
toFromNat? {n = suc _} = cong= suc toFromNat?

fromToNat? : ? {r o} {x : ? `Nat' ? r o} ? (fromNat (toNat x)) = x
fromToNat? {x = ? inl tt ?} = refl
fromToNat? {x = ? inr _  ?} = cong= (?_? ° inr) fromToNat?

`NatE' : ? ? ?
`NatE' = Iso `Nat' (? _ _ ? Nat) (? r o ? record { from = fromNat 
                                                 ; to   = toNat
                                                 ; iso1 = toFromNat?
                                                 ; iso2 = fromToNat? })

-- Catamorphism
cataNat : ? {R} ? R ? (R ? R) ? Nat ? R
cataNat z s n = cata {r = ? ()} `NatF' (? i ? const z ? s) tt (fromNat n)

-- Example use
addNat : Nat ? Nat ? Nat
addNat m = cataNat m suc