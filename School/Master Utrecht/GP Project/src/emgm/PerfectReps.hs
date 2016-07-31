{-# LANGUAGE FlexibleInstances, MultiParamTypeClasses #-}
module PerfectReps where

import GL hiding (Fork)
import PerfectDatatype
import Generics.EMGM

perfecttree :: (Generic g) => g a -> g (Perfect a)
perfecttree a =  rtype isoPerfectTree (a <|> perfecttree (fork a))

isoPerfectTree = EP fromPerfectTree toPerfectTree

fromPerfectTree (Zero x)              =  L x
fromPerfectTree (Succ p)              =  R p

toPerfectTree (L x)                 =  Zero x
toPerfectTree (R p)                 =  Succ p

instance FunctorRep Perfect where
   functorRep   =  perfecttree

instance (Generic g, GRep g a) => GRep g (Perfect a) where
  over = perfecttree over


fork :: (Generic g) => g a -> g (Fork a)
fork a = rtype isoFork (a <*> a)

isoFork = EP fromFork toFork

fromFork (Fork x y)      =  x :*: y
toFork (x :*: y)         =  Fork x y

instance FunctorRep Fork where
   functorRep   =  fork

instance (Generic g, GRep g a) => GRep g (Fork a) where
  over = fork over
