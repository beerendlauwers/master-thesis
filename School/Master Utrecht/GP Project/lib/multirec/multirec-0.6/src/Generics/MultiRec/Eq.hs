{-# LANGUAGE FlexibleContexts      #-}
{-# LANGUAGE RankNTypes            #-}
{-# LANGUAGE TypeOperators         #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE GADTs                 #-}

-----------------------------------------------------------------------------
-- |
-- Module      :  Generics.MultiRec.Eq
-- Copyright   :  (c) 2008--2010 Universiteit Utrecht
-- License     :  BSD3
--
-- Maintainer  :  generics@haskell.org
-- Stability   :  experimental
-- Portability :  non-portable
--
-- Generic equality.
--
-----------------------------------------------------------------------------

module Generics.MultiRec.Eq where

import Generics.MultiRec.Base

-- * Generic equality

class HEq phi f where
  heq :: (forall ix. phi ix -> r ix -> r ix -> Bool) ->
         phi ix -> f r ix -> f r ix -> Bool

class Eq1 f where
  eq1 :: (a -> a -> Bool) -> f a -> f a -> Bool

-- TODO: Think about more generic instances
instance Eq1 [] where
  eq1 eq []       []       = True
  eq1 eq (x1:xs1) (x2:xs2) = eq x1 x2 && eq1 eq xs1 xs2
  eq1 eq _        _        = False

instance Eq1 Maybe where
  eq1 eq Nothing   Nothing   = True
  eq1 eq (Just x1) (Just x2) = eq x1 x2
  eq1 eq _         _         = False

instance El phi xi => HEq phi (I xi) where
  heq eq _ (I x1) (I x2) = eq proof x1 x2

-- | For constant types, we make use of the standard
-- equality function.
instance Eq a => HEq phi (K a) where
  heq eq _ (K x1) (K x2) = x1 == x2

instance HEq phi U where
  heq eq _ U U = True

instance (HEq phi f, HEq phi g) => HEq phi (f :+: g) where
  heq eq p (L x1) (L x2) = heq eq p x1 x2
  heq eq p (R y1) (R y2) = heq eq p y1 y2
  heq eq _ _     _       = False

instance (HEq phi f, HEq phi g) => HEq phi (f :*: g) where
  heq eq p (x1 :*: y1) (x2 :*: y2) = heq eq p x1 x2 && heq eq p y1 y2

instance (Eq1 f, HEq phi g) => HEq phi (f :.: g) where
  heq eq p (D x1) (D x2) = eq1 (heq eq p) x1 x2

-- The following instance does not compile with ghc-6.8.2
instance HEq phi f => HEq phi (f :>: ix) where
  heq eq p (Tag x1) (Tag x2) = heq eq p x1 x2

instance (Constructor c, HEq phi f) => HEq phi (C c f) where
  heq eq p (C x1) (C x2) = heq eq p x1 x2

eq :: (Fam phi, HEq phi (PF phi)) => phi ix -> ix -> ix -> Bool
eq p x1 x2 = heq (\ p (I0 x1) (I0 x2) -> eq p x1 x2) p (from p x1) (from p x2)

-- Note:
-- 
-- We do not declare an equality instance such as
--
--   instance (El phi ix, HEq phi (PF phi)) => Eq ix where
--     (==) = eq proof
--
-- because "phi" is not mentioned on the right hand side.
-- One datatype may belong to multiple families, and
-- although the generic equality instances should be
-- the same, there is no good way to decide which instance
-- to use.
--
-- For a concrete "phi", it is still possible to manually
-- define an "Eq" instance as above.
