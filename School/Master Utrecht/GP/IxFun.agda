{-# OPTIONS --no-termination-check #-}
{-# OPTIONS --no-positivity-check #-}
module IxFun where

open import Prelude

----------------------------------------------------------------------
-- The universe of indexed functors
----------------------------------------------------------------------

-- Indexed family.
Indexed : Set ? Set1
Indexed I = I ? Set

-- Natural transformations.
_?_ : ? {I} ? Indexed I ? Indexed I ? Set
r ? s = forall i ? r i ? s i

-- Identity natural transformation.
id? : {I : Set} {r : Indexed I} ? r ? r
id? i = id

-- Composing natural transformations
_?°_ : {I : Set} {r s t : Indexed I} ? s ? t ? r ? s ? r ? t
(f ?° g) i x = f i (g i x)

-- Special case of const.
T : Set ? Indexed ?
T A tt = A

-- Lifting a function to a (unit-type-indexed) natural transformation.
? : ? {A B : Set} ? (A ? B) ? (T A ? T B)
? f tt x = f x

-- Merging indexed families.
infixr 5 _|_
_|_ : ? {I J} ? Indexed I ? Indexed J ? Indexed (I + J)
(r | s) (inl i) = r i
(r | s) (inr j) = s j

-- Merging natural transformations.
infixr 5 _?_
_?_ : {I J : Set} {r u : Indexed I} {s v : Indexed J} ?
     (r ? u) ? (s ? v) ? ((r | s) ? (u | v))
_?_ f g (inl x) = f x
_?_ f g (inr y) = g y

----------------------------------------------------------------------
-- Properties of morphism merging
----------------------------------------------------------------------
infix 4 _?_
_?_ : ? {I : Set}{r s : Indexed I} (f g : r ? s) ? Set
f ? g = ? i x ? f i x = g i x

?-cong : {I J : Set}{r u : Indexed I}{s v : Indexed J}{f1 f2 : r ? u}{g1 g2 : s ? v} ?
         f1 ? f2 ? g1 ? g2 ? (f1 ? g1) ? (f2 ? g2)
?-cong if ig (inl i) x = if i x
?-cong if ig (inr j) x = ig j x

?-id : {I J : Set} {r : Indexed I} {s : Indexed J}{f : r ? r}{g : s ? s} ?
       f ? id? ? g ? id? ? (f ? g) ? id?
?-id if ig (inl i) x = if i x
?-id if ig (inr j) x = ig j x

?-° : {I J : Set}{r1 s1 t1 : Indexed I}{r2 s2 t2 : Indexed J} ? 
      {f1 : s1 ? t1}{g1 : r1 ? s1}{f2 : s2 ? t2}{g2 : r2 ? s2} ?
      (f1 ?° g1 ? f2 ?° g2) ? ((f1 ? f2) ?° (g1 ? g2))
?-° (inl i) x = refl
?-° (inr j) x = refl

-- Binary relations (move to prelude)
Rel : Set ? Set ? Set1
Rel A B = A ? B ? Set

-- Indexed functors
_?_ : Set ? Set ? Set1
I ? O = Indexed I ? Indexed O

-- Codes for indexed functors
infixr 3 _?_
infixr 4 _?_
infixr 5 _?_

data Wrap {I I' : Set} (f : I' ? I) (r : Indexed I) : Indexed I' where
  wrap : {i' : I'} ? r (f i') ? Wrap f r i'

mapWrap : {I I' : Set} {r : Indexed I} {s : Indexed I} {f : I' ? I}
        ? (r ? s) ? (Wrap f r ? Wrap f s)
mapWrap f _ (wrap r) = wrap (f _ r)

-- The proofs are not optional
infix 3 _?_
record _?_ (A B : Set) : Set where
  field
    from  : A ? B
    to    : B ? A
    iso1  : ? {x} ? to (from x) = x
    iso2  : ? {x} ? from (to x) = x


mutual
  data _?_ : Set ? Set ? Set1 where
    Z      :  ? {I O} ? I ? O
    U      :  ? {I O} ? I ? O

    I      :  ? {I O} ? I  ? I ? O
    !      :  ? {I O} ? O  ? I ? O

    _?_    :  ? {I O}     ? I ? O  ? I ? O  ?  I ? O
    _?_    :  ? {I O}     ? I ? O  ? I ? O  ?  I ? O
    _?_    :  ? {I M O}   ? M ? O  ? I ? M  ?  I ? O

    _?_?_  :  ? {I I' O O'} ? I' ? O' ? 
              (I' ? I) ? (O ? O') ?  I ? O
 
    Fix    :  ? {I O} ? (I + O) ? O ? I ? O

    S      :  ? {I O}  ? {C : ? ? ?} ? 
              (? C ? (? _ ? ?) tt ? I ? O) ? I ? O

    Iso    :  ? {I O}  ? (C : I ? O) ? (D : I ? O) ? 
              ((r : Indexed I) ? (o : O) ? D r o ? ? C ? r o) ?
              I ? O
-- Interpretation of codes as indexed functors.
  data µ {I O : Set} (F : (I + O) ? O) (r : Indexed I) (o : O) : Set where
    ?_? : ? F ? (r | µ F r) o ? µ F r o

  ?_? : ? {I O : Set} ? I ? O ? I ? O
  ? Z         ? r o = ?
  ? U         ? r o = ?
  ? I i       ? r o = r i
  ? F ? f ? g ? r o = ? F ? (r ° f) (g o)
  ? F ? G     ? r o = ? F ? r o + ? G ? r o
  ? F ? G     ? r o = ? F ? r o × ? G ? r o
  ? F ? G     ? r o = ? F ? (? G ? r) o
  ? ! o'      ? r o = o = o'
  ? S f       ? r o = ? (? i ? ? f i ? r o)
  ? Fix F     ? r o = µ F r o
  ? Iso C D e ? r o = D r o


----------------------------------------------------------------------
-- Definition of map for indexed functors
----------------------------------------------------------------------

map : {I O : Set} {r s : Indexed I} (C : I ? O) ?
      (r ? s) ? (? C ? r ? ? C ? s)
map Z           f o ()
map U           f o x                   = x
map (I i)       f o x                   = f i x
map (F ? g ? h) f o x                   = map F (f ° g) (h o) x
map (F ? G)     f o (inl x)             = inl (map F f o x)
map (F ? G)     f o (inr y)             = inr (map G f o y)
map (F ? G)     f o (x , y)             = map F f o x , map G f o y
map (F ? G)     f o x                   = map F (map G f) o x
map (! o')      f o x                   = x
map (S g)       f o (some {i} x)        = some (map (g i) f o x)
map (Fix F)     f o ? x ?               = ? map F (f ? map (Fix F) f) o x ?

map {r = r} {s = s} (Iso C D e) f o x with (e r o , e s o)
map (Iso C _ _) f o x | (ep1 , ep2) = _?_.to ep2 (map C f o (_?_.from ep1 x))

map-cong : {I O : Set}{r s : Indexed I}{f g : r ? s}?
           (C : I ? O) ? f ? g ?
           map C f ? map C g
map-cong Z           ip i ()
map-cong U           ip i x          = refl
map-cong (I i')      ip i x          = ip i' x
map-cong (F ? g ? h) ip i x          = map-cong F (ip ° g) (h i) x
map-cong (F ? G)     ip i (inl x)    = cong= inl (map-cong F ip i x)
map-cong (F ? G)     ip i (inr x)    = cong= inr (map-cong G ip i x)
map-cong (F ? G)     ip i (x , y)    = cong=2 _,_ (map-cong F ip i x) (map-cong G ip i y)
map-cong (F ? G)     ip i x          = map-cong F (map-cong G ip) i x
map-cong (! o')      ip i x          = refl
map-cong (S g)       ip i (some x)   = cong= some (map-cong (g _) ip i x)
map-cong (Fix F)     ip i ? x ?      = cong= ?_? (map-cong F (?-cong ip (map-cong (Fix F) ip)) i x)
map-cong {r = r} {s = s} (Iso C D e) ip i x 
  = cong= (_?_.to (e s i)) (map-cong C ip i (_?_.from (e r i) x))

map-id : {I O : Set}{r : Indexed I}(C : I ? O) ?
         map {r = r} C id? ? id?
map-id Z          i ()
map-id U          i x               = refl
map-id (I i')     i x               = refl
map-id (F ? g ? h)  i x             = map-id F (h i) x
map-id (F ? G)    i (inl x)         = cong= inl (map-id F i x)
map-id (F ? G)    i (inr x)         = cong= inr (map-id G i x)
map-id (F ? G)    i (x , y)         = cong=2 _,_ (map-id F i x) (map-id G i y)
map-id (F ? G)    i x               = trans= (map-cong F (map-id G) i x) (map-id F i x)
map-id (! o')     i x               = refl
map-id (S g)      i (some x)        = cong= some (map-id (g _) i x)
map-id (Fix F)    i ? x ?           = cong= ?_? (trans= (map-cong F (?-id (? _ _ ? refl)
                                                                    (map-id (Fix F))) i x)
                                                        (map-id F i x))
map-id {r = r} (Iso C D e) i x = sym= (trans= (sym= (_?_.iso1 (e r i))) 
                                  (sym= (cong= (_?_.to (e r i)) 
                                              (map-id C i (_?_.from (e r i) x)))))

-- The second proof proceeds in the same way
map-° : {I O : Set} {r s t : Indexed I}
        (C : I ? O) (f : s ? t) (g : r ? s)
      ? map C (f ?° g) ? map C f ?° map C g
map-° Z           f g i ()
map-° U           f g i x            = refl
map-° (I i')      f g i x            = refl
map-° (F ? h ? y) f g i x            = map-° F (f ° h) (g ° h) (y i) x
map-° (F ? G)     f g i (inl x)      = cong= inl (map-° F f g i x)
map-° (F ? G)     f g i (inr x)      = cong= inr (map-° G f g i x)
map-° (F ? G)     f g i (x , y)      = cong=2 _,_ (map-° F f g i x) (map-° G f g i y)
map-° (F ? G)     f g i x            = trans= (map-cong F (map-° G f g) i x)
                                              (map-° F (map G f) (map G g) i x)
map-° (! o')      f g i x            = refl
map-° (S h)       f g i (some x)     = cong= some (map-° (h _) f g i x)
map-° (Fix F)     f g i ? x ?        = cong= ?_? (trans= (map-cong F (?-cong (? _ _ ? refl)
                                                                             (map-° (Fix F) f g))
                                                                   i x)
                                                 (trans= (map-cong F ?-° i x)
                                                         (map-° F (f ? map (Fix F) f)
                                                                  (g ? map (Fix F) g) i x)))

map-° {r = r} {s = s} {t = t} (Iso C D e) f g i x
  = cong= (_?_.to (e t i))
      (trans= (map-° C f g i (_?_.from (e r i) x)) (cong= (map C f i) (sym= (_?_.iso2 (e s i)))))

-- Applicative version of map
record Applicative (F : Set ? Set) : Set1 where
  infixl 4 _?_
  field
    pure : ? {A} ? A ? F A
    _?_  : ? {A B} ? F (A ? B) ? F A ? F B

module tmap {a : Set ? Set} (A : Applicative a) where
  open Applicative A

  _?a_ : ? {I} ? Indexed I ? Indexed I ? Set
  r ?a s = forall i ? r i ? a (s i)

  infixr 5 _?a_
  _?a_ : ? {I J} {r u : Indexed I} {s v : Indexed J}
       ? r ?a u ? s ?a v ? (r | s) ?a (u | v)
  _?a_ f g (inl x) = f x
  _?a_ f g (inr x) = g x

  -- _?_ == _<$>_
  infixl 4 _?_
  _?_ : {A B : Set} ? (A ? B) ? a A ? a B
  f ? x = pure f ? x

  tmap : {I O : Set} {r s : Indexed I} ? (C : I ? O)
       ? (r ?a s) ? (? C ? r ?a ? C ? s)
  tmap Z       f o x            = pure x
  tmap U       f o x            = pure x
  tmap (I i)   f o x            = f i x
  tmap (F ? g ? h) f o x        = tmap F (f ° g) (h o) x
  tmap (F ? G) f o (inl y)      = inl ? tmap F f o y
  tmap (F ? G) f o (inr y)      = inr ? tmap G f o y
  tmap (F ? G) f o (x , y)      = _,_ ? tmap F f o x ? tmap G f o y
  tmap (F ? G) f o x            = tmap F (tmap G f) o x
  tmap (! o')  f o x            = pure x
  tmap (S g)   f o (some {i} x) = some ? tmap (g i) f o x
  tmap (Fix F) f o ? x ?        = ?_? ? tmap F (f ?a tmap (Fix F) f) o x

  tmap {r = r} {s = s} (Iso C D e) f o x with (e r o , e s o)
  tmap (Iso C _ _) f o x | (ep1 , ep2) = (_?_.to ep2) ? tmap C f o (_?_.from ep1 x)

----------------------------------------------------------------------
-- Recursion patterns
----------------------------------------------------------------------

cata : {I O : Set} {r : Indexed I} {s : Indexed O} ? (C : (I + O) ? O) ?
       (? C ? (r | s) ? s) ? ? Fix C ? r ? s
cata C f o ? x ? = f o (map C (id? ? cata C f) o x)

ana : {I O : Set} {r : I ? Set} {s : O ? Set} ? (C : (I + O) ? O) ?
      (s ? ? C ? (r | s)) ? s ? ? Fix C ? r
ana C ? o x = ? map C (id? ? ana C ?) o (? o x) ?

hylo : {I O : Set} {r : I ? Set} {s t : O ? Set} ? (C : (I + O) ? O) ?
       (? C ? (r | t) ? t) ? (s ? ? C ? (r | s)) ? s ? t
hylo C f ? o x = f o (map C (id? ? hylo C f ?) o (? o x))

para : {I O : Set} {r : I ? Set} {s : O ? Set} ? (C : (I + O) ? O) ?
       (? C ? (r | ? o ? s o × ? Fix C ? r o) ? s) ? ? Fix C ? r ? s
para C f o ? x ? = f o (map C (id? ? (? i ? (para C f i) ? id)) o x)

apo : {I O : Set} {r : I ? Set} {s : O ? Set} ? (C : (I + O) ? O) ?
       (s ? ? C ? (r | ? o ? s o + ? Fix C ? r o)) ? s ? ? Fix C ? r
apo C ? o x = ? map C (id? ? (? i ? (apo C ? i) ? id)) o (? o x) ?