{-# LANGUAGE MultiParamTypeClasses, FlexibleInstances, FlexibleContexts, UndecidableInstances #-}
module GRoseReps where

import GL
import GRoseDatatype
import Generics.EMGM

grose f a =  rtype isoGrose (a <*> f)

isoGrose = EP fromGrose toGrose

fromGrose (GRose x trees)  =  x :*: trees
toGrose (x :*: trees)      = GRose x trees

instance (Generic g, GRep g a, GRep g (f (GRose f a))) => GRep g (GRose f a) where
  over = grose over over
