> {-# LANGUAGE RankNTypes #-}

NOTE: it's unclear as to how we could define GMapQ. The authors of generic-deriving note that gfoldl cannnot be expressed in their library yet, which may make
it hard to define GMapQ as well.

> module GMapQ where

> import Generics.Deriving

gmapQ :: (forall d. Data d => d -> u) -> a -> [u]

> class GmapQ where 
>   gmapQ :: (forall d. Generic d => d -> u) -> a -> [u]

> gapplyShowList = error "It was unclear as to how gmapQ could be defined"