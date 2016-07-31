

-- UUAGC 0.9.40.2 (AG.ag)
module CCO.HM.AG where

{-# LINE 2 ".\\AG/Base.ag" #-}

import CCO.SourcePos
{-# LINE 10 "AG.hs" #-}
{-# LINE 10 ".\\AG/Base.ag" #-}

type TyVarName = String    -- ^ Type of type variables. 
type VarType = String          -- ^ Type of variables.
type TyScheme = Ty
{-# LINE 16 "AG.hs" #-}
-- Tm ----------------------------------------------------------
data Tm = Tm (SourcePos) (Tm_)
-- Tm_ ---------------------------------------------------------
data Tm_ = App (Tm) (Tm)
         | Lam (VarType) (Tm)
         | Let (VarType) (Tm) (Tm)
         | Var (VarType)
-- Ty ----------------------------------------------------------
data Ty = Arrow (Ty) (Ty)
        | Forall (TyVarName) (Ty)
        | TypeVar (TyVarName)
        deriving ( Eq,Show)