{-# LANGUAGE StandaloneDeriving #-}

module CCO.DerivingInstances where

import qualified CCO.SystemF as SF

deriving instance Eq SF.Ty
deriving instance Ord SF.Ty