

-- UUAGC 0.9.40.2 (AG.ag)
module CCO.HM.AG where

{-# LINE 2 ".\\AG/Base.ag" #-}

import CCO.SourcePos
{-# LINE 10 "AG.hs" #-}
{-# LINE 10 ".\\AG/Base.ag" #-}

type TyVarName = String    -- ^ Type of type variables. 
type Var = String          -- ^ Type of variables.
type TyScheme = Ty
{-# LINE 16 "AG.hs" #-}
-- Tm ----------------------------------------------------------
data Tm = Tm (SourcePos) (Tm_)
-- cata
sem_Tm :: Tm ->
          T_Tm
sem_Tm (Tm _pos _t) =
    (sem_Tm_Tm _pos (sem_Tm_ _t))
-- semantic domain
type T_Tm = ( )
data Inh_Tm = Inh_Tm {}
data Syn_Tm = Syn_Tm {}
wrap_Tm :: T_Tm ->
           Inh_Tm ->
           Syn_Tm
wrap_Tm sem (Inh_Tm) =
    (let ( ) = sem
     in  (Syn_Tm))
sem_Tm_Tm :: SourcePos ->
             T_Tm_ ->
             T_Tm
sem_Tm_Tm pos_ t_ =
    (let
     in  ( ))
-- Tm_ ---------------------------------------------------------
data Tm_ = App (Tm) (Tm)
         | Lam (Var) (Tm)
         | Let (Var) (Tm) (Tm)
         | Var (Var)
-- cata
sem_Tm_ :: Tm_ ->
           T_Tm_
sem_Tm_ (App _t1 _t2) =
    (sem_Tm__App (sem_Tm _t1) (sem_Tm _t2))
sem_Tm_ (Lam _x _t1) =
    (sem_Tm__Lam _x (sem_Tm _t1))
sem_Tm_ (Let _x _t1 _t2) =
    (sem_Tm__Let _x (sem_Tm _t1) (sem_Tm _t2))
sem_Tm_ (Var _x) =
    (sem_Tm__Var _x)
-- semantic domain
type T_Tm_ = ( )
data Inh_Tm_ = Inh_Tm_ {}
data Syn_Tm_ = Syn_Tm_ {}
wrap_Tm_ :: T_Tm_ ->
            Inh_Tm_ ->
            Syn_Tm_
wrap_Tm_ sem (Inh_Tm_) =
    (let ( ) = sem
     in  (Syn_Tm_))
sem_Tm__App :: T_Tm ->
               T_Tm ->
               T_Tm_
sem_Tm__App t1_ t2_ =
    (let
     in  ( ))
sem_Tm__Lam :: Var ->
               T_Tm ->
               T_Tm_
sem_Tm__Lam x_ t1_ =
    (let
     in  ( ))
sem_Tm__Let :: Var ->
               T_Tm ->
               T_Tm ->
               T_Tm_
sem_Tm__Let x_ t1_ t2_ =
    (let
     in  ( ))
sem_Tm__Var :: Var ->
               T_Tm_
sem_Tm__Var x_ =
    (let
     in  ( ))
-- Ty ----------------------------------------------------------
data Ty = Arrow (Ty) (Ty)
        | Forall (TyVarName) (Ty)
        | TypeVar (TyVarName)
-- cata
sem_Ty :: Ty ->
          T_Ty
sem_Ty (Arrow _ty1 _ty2) =
    (sem_Ty_Arrow (sem_Ty _ty1) (sem_Ty _ty2))
sem_Ty (Forall _a _ty1) =
    (sem_Ty_Forall _a (sem_Ty _ty1))
sem_Ty (TypeVar _a) =
    (sem_Ty_TypeVar _a)
-- semantic domain
type T_Ty = ( )
data Inh_Ty = Inh_Ty {}
data Syn_Ty = Syn_Ty {}
wrap_Ty :: T_Ty ->
           Inh_Ty ->
           Syn_Ty
wrap_Ty sem (Inh_Ty) =
    (let ( ) = sem
     in  (Syn_Ty))
sem_Ty_Arrow :: T_Ty ->
                T_Ty ->
                T_Ty
sem_Ty_Arrow ty1_ ty2_ =
    (let
     in  ( ))
sem_Ty_Forall :: TyVarName ->
                 T_Ty ->
                 T_Ty
sem_Ty_Forall a_ ty1_ =
    (let
     in  ( ))
sem_Ty_TypeVar :: TyVarName ->
                  T_Ty
sem_Ty_TypeVar a_ =
    (let
     in  ( ))