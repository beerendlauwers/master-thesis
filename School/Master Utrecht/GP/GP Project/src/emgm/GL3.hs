{-# LANGUAGE TypeOperators, MultiParamTypeClasses, FlexibleInstances #-}
{- In this module a Generic class support up-to 3 geric type arguments is developed.
This combines the ideas in Section 4 of the JFP version of GM with the extensibility 
provided by GL. 

-}

module GL3 where

import Generics.EMGM

infixr 8 <*>
infixr 7 <|>

(<|>)  :: Generic3 g => g a1 a2 a3 -> g b1 b2 b3 -> g (a1 :+: b1) (a2 :+: b2) (a3 :+: b3)
(<|>)  = rsum3

(<*>)  :: Generic3 g => g a1 a2 a3 -> g b1 b2 b3 -> g (a1 :*: b1) (a2 :*: b2) (a3 :*: b3)
(<*>)  = rprod3

class FunctorRep g f where
     functorRep  :: g a1 a2 a3 -> g (f a1) (f a2) (f a3)

class GRep3 g a where
   over3 :: g a a a
instance Generic3 g => GRep3 g Unit where
   over3 = runit3
instance Generic3 g => GRep3 g Int where
   over3 = rint3
instance Generic3 g => GRep3 g Char where
   over3 = rchar3
instance (Generic3 g, GRep3 g a, GRep3 g b) => GRep3 g (a :+: b) where
   over3 = rsum3 over3 over3
instance (Generic3 g, GRep3 g a, GRep3 g b) => GRep3 g (a :*: b) where
   over3 = rprod3 over3 over3
instance (Generic3 g, GRep3 g a) => GRep3 g [a] where
   over3 = functorRep over3

-- Typereps

-- list
isoList3 :: EP [a] (Unit :+: (a :*: [a]))
isoList3 = EP fromList3 toList3

fromList3 :: [a] -> Unit :+: (a :*: [a])
fromList3 []               = L Unit
fromList3 (x:xs)           = R (x :*: xs)

toList3 :: Unit :+: (a :*: [a]) -> [a]
toList3 (L Unit)        = []
toList3 (R (x :*: xs))  = x : xs

instance Generic3 g => FunctorRep g [] where
  functorRep   =  rList3

rList3 :: Generic3 g => g a1 a2 a3 -> g [a1] [a2] [a3]
rList3 a = rtype3 isoList3 isoList3 isoList3 (runit3 <|> (a <*> rList3 a))

