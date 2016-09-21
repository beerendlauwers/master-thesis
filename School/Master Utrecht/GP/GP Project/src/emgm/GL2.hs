{-# LANGUAGE TypeOperators, FlexibleInstances, FlexibleContexts #-}
module GL2 where

import Generics.EMGM

infixr 8 <*>
infixr 7 <|>

(<|>) :: Generic2 g => g a1 a2 -> g b1 b2 -> g (a1 :+: b1) (a2 :+: b2)
(<|>) = rsum2

(<*>) :: Generic2 g => g a1 a2 -> g b1 b2 -> g (a1 :*: b1) (a2 :*: b2)
(<*>) = rprod2

class FunctorRep f where
     functorRep  :: Generic2 g => g a1 a2 -> g (f a1) (f a2)

class GRep2 t where
   over2 :: t
instance Generic2 g => GRep2 (g Unit Unit) where
   over2 = runit2
instance Generic2 g => GRep2 (g Int Int) where
   over2 = rint2
instance Generic2 g => GRep2 (g Char Char) where
   over2 = rchar2
instance (Generic2 g, GRep2 (g a1 a2), GRep2 (g b1 b2)) => GRep2 (g (a1 :+: b1) (a2 :+: b2)) where
   over2 = rsum2 over2 over2
instance (Generic2 g, GRep2 (g a1 a2), GRep2 (g b1 b2)) => GRep2 (g (a1 :*: b1) (a2 :*: b2)) where
   over2 = rprod2 over2 over2

-- Typereps

-- list
isoList :: EP [a] (Unit :+: (a :*: [a]))
isoList = EP fromList toList

fromList :: [a] -> Unit :+: (a :*: [a])
fromList []               = L Unit
fromList (x:xs)           = R (x :*: xs)

toList :: Unit :+: (a :*: [a]) -> [a]
toList (L Unit)        = []
toList (R (x :*: xs))  = x : xs

instance FunctorRep [] where
  functorRep   =  rList2

rList2 :: Generic2 g => g a1 a2 -> g [a1] [a2]
rList2 a = rtype2 isoList isoList (runit2 <|> (a <*> rList2 a))
