{-# OPTIONS --universe-polymorphism #-}

module Orn where

open import Prelude hiding (_×_)

-- Dependent sum
record S {a b} (A : Set a) (B : A ? Set b) : Set (a ? b) where
  constructor _,_
  field
    proj1 : A
    proj2 : B proj1

infixr 4 _,_

-- Product
_×_ : ? {a b} (A : Set a) (B : Set b) ? Set (a ? b)
A × B = S A (? _ ? B)

--------------------------------------------------------------------------------

-- Conor's development of ornaments (plus some additional lemmas)

-- Description of indexed types
data Desc (I : Set) : Set1 where
  say    : (i : I) ? Desc I
  s      : (S : Set) (D : S ? Desc I) ?  Desc I
  ask_*_ : (i : I) (D : Desc I) ? Desc I

-- Interpretation of Desc
?_? : ? {I} ? Desc I ? (I ? Set) ? (I ? Set)
? say i' ? X i = i' = i
? s S D ? X i = S S ? s ? ? D s ? X i
? ask i' * D ? X i = X i' × ? D ? X i

-- Fixpoint of interpretation
data µ {I : Set} (D : Desc I) (i : I) : Set where
  ?_? : ? D ? (µ D) i ? µ D i

infix 1 ?_?

--------------------------------------------------------------------------------

-- Iteration (fold)

_?_ : ? {I} ? (I ? Set) ? (I ? Set) ? Set
X ? Y = ? {i} ? X i ? Y i

infixr 4 _?_

mutual

  fold : ? {I X} {D : Desc I} ? (? D ? X ? X) ? µ D ? X
  fold {D = D} phi ? ds ? = phi (mapFold D D phi ds)

  mapFold : ? {I X} (D E : Desc I) ? (? D ? X ? X) ? ? E ? (µ D) ? ? E ? X
  mapFold D (say i)     phi q        = q
  mapFold D (s S E)     phi (s , xs) = s ,          mapFold D (E s) phi xs
  mapFold D (ask i * E) phi (x , xs) = fold phi x , mapFold D E phi xs

fmap : ? {I} (D : Desc I) {X Y} ? (X ? Y) ? ? D ? X ? ? D ? Y
fmap (say i) f refl = refl
fmap (s S D) f (s , xs) = s , fmap (D s) f xs
fmap (ask i * D) f (x , xs) = f x , fmap D f xs

mapFold-as-fmap : ? {I} (D E : Desc I) {X} (f : ? D ? X ? X) {i} (xs : ? E ? (µ D) i) ?
               mapFold D E f xs = fmap E (fold f) xs
mapFold-as-fmap D (say i) f refl = refl
mapFold-as-fmap D (s S E) f (s , xs) = cong= (_,_ s) (mapFold-as-fmap D (E s) f xs)
mapFold-as-fmap D (ask i * E) f (x , xs) = cong= (_,_ (fold f x)) (mapFold-as-fmap D E f xs)

--------------------------------------------------------------------------------

-- Ornamented datatypes

data _?¹_ {I J : Set} (e : J ? I) : I ? Set where
  ok : (j : J) ? e ?¹ (e j)

data Orn {I} (J : Set) (e : J ? I) : Desc I ? Set1 where
  say    : {i : I} ? e ?¹ i ? Orn J e (say i)
  s      : (S : Set) ? ? {D} ? ((s : S) ? Orn J e (D s)) ? Orn J e (s S D)
  ask_*_ : {i : I} ? e ?¹ i ? ? {D} ? Orn J e D ? Orn J e (ask i * D)
  ?      : (S : Set) ? ? {D} ? (S ? Orn J e D) ? Orn J e D

-- Elaboration of ornamented to unornamented
?_? : ? {I J e} {D : Desc I} ? Orn J e D ? Desc J
? say (ok j) ?     = say j
? s S O ?          = s S ? s ? ? O s ?
? ask (ok j) * O ? = ask j * ? O ?
? ? S O ?          = s S ? s ? ? O s ?

idOrn : ? {I} ? (D : Desc I) ? Orn I id D
idOrn (say i) = say (ok i)
idOrn (s S D) = s S ? s ? idOrn (D s)
idOrn (ask i * D) = ask ok i * idOrn D

--------------------------------------------------------------------------------

-- Ornamental algebras

erase : ? {I J e} {D : Desc I} {X : I ? Set} ?
        (O : Orn J e D) ? ? ? O ? ? (X ° e) ? ? D ? X ° e
erase (say (ok j))     refl     = refl
erase (s S O)          (s , rs) = s , erase (O s) rs
erase (ask (ok j) * O) (r , rs) = r , erase O rs
erase (? S O)          (s , rs) =     erase (O s) rs  -- s is erased

ornAlg : ? {I J e} {D : Desc I} (O : Orn J e D) ? ? ? O ? ? (µ D ° e) ? µ D ° e
ornAlg O ds = ? erase O ds ?

forget : ? {I J e} {D : Desc I} (O : Orn J e D) ? (µ ? O ?) ? µ D ° e
forget O = fold (ornAlg O)