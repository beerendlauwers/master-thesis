

-- UUAGC 0.9.40.2 (src\CCO\HM\AG.ag)
module CCO.HM.AG where

{-# LINE 2 "src\\CCO\\HM\\AG/Base.ag" #-}

import CCO.SourcePos
{-# LINE 10 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM\\AG.hs" #-}
{-# LINE 10 "src\\CCO\\HM\\AG/Base.ag" #-}

type Var = String    -- ^ Type of variables.
{-# LINE 14 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM\\AG.hs" #-}
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