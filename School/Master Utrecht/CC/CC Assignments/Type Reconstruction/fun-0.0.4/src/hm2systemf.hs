

-- UUAGC 0.9.40.2 (hm2systemf.ag)
module CCO.HM2SystemF where

{-# LINE 7 "hm2systemf.ag" #-}

import Data.Set (Set,fromList,union,difference,toList)
import CCO.DerivingInstances
import qualified CCO.SystemF as SF
{-# LINE 12 "hm2systemf.hs" #-}

{-# LINE 2 ".\\CCO/HM/AG/Base.ag" #-}

import CCO.SourcePos
{-# LINE 17 "hm2systemf.hs" #-}
{-# LINE 13 "hm2systemf.ag" #-}

data Subst = Id | Sub SF.Ty SF.Ty | AppSub Subst Subst
		   
type Environment = [(Var, SF.Ty)]
type Label = Int
{-# LINE 24 "hm2systemf.hs" #-}

{-# LINE 51 "hm2systemf.ag" #-}

unify :: SF.Ty -> SF.Ty -> Environment -> Subst
unify f@(SF.TyVar a) s@(SF.TyVar a') env = 
 if a == a' 
	then Id
	else case (lookup a env) of
	 (Just _) -> case (lookup a' env) of
				(Just _) -> error "fail"
				Nothing -> Sub s f
	 Nothing -> Sub f s
unify f@(SF.Arr t1 t2) s@(SF.Arr t1' t2') env = AppSub (Sub t1 t1') (Sub t2 t2')
unify _ _ _ = error "fail"

applySubst :: Subst -> SF.Ty -> SF.Ty
applySubst Id           a           = a
applySubst sub          (SF.Arr t1 t2) = SF.Arr (applySubst sub t1) (applySubst sub t2)
applySubst (Sub a t0)   (SF.Forall a' ty1) = if a /= (SF.TyVar a') then SF.Forall a' (applySubst (Sub a t0) ty1) else SF.Forall a' ty1
applySubst (Sub a t0)   a'          = if a /= a' then a' else t0
applySubst (AppSub s1 s2) ty        = applySubst s1 $ applySubst s2 ty

applySubstEnv :: Subst -> Environment -> Environment
applySubstEnv s = map (\(x,ty) -> (x,applySubst s ty))

inst :: SF.Ty -> SF.Ty
inst (SF.Forall a (SF.Forall b xs)) = let newVar = undefined -- getNewVar
                                      in applySubst (Sub (SF.TyVar a) newVar) $ inst (SF.Forall b xs)
inst (SF.Forall a xs)               = let newVar = undefined -- getNewVar
                                      in applySubst (Sub (SF.TyVar a) newVar) xs
                                
gen :: Environment -> SF.Ty -> SF.Ty
gen env t1 = let tyset = ftvty t1 `difference` ftvenv env
             in foldr (\(SF.TyVar x) xs -> SF.Forall x xs) t1 (toList tyset)
  
algoW :: Environment -> Tm -> (SF.Ty,Subst)
algoW env (Tm _ (Var x)) = 
 case lookup x env of -- is this correct?
  Just a  ->  (inst a,Id)
  Nothing -> error "Nope"

algoW env (Tm _ (Lam x t1)) =
 let newVar = undefined -- getNewVar
     (ty2,sub1) = algoW (applySubstEnv (Sub (SF.TyVar x) newVar) env) t1 
 in (applySubst sub1 (SF.Arr newVar ty2),sub1)
 
algoW env (Tm _ (App t1 t2)) =
 let newVar = undefined -- getNewVar
     (ty1,sub1) = algoW env t1
     (ty2,sub2) = algoW (applySubstEnv sub1 env) t2
     sub3       = unify (applySubst sub2 ty1) (SF.Arr ty2 newVar) env
 in ((applySubst sub3 newVar),(AppSub sub3 (AppSub sub2 sub1)))
 
algoW env (Tm _ (Let x t1 t2)) =
 let (ty1,sub1) = algoW env t1
     (ty, sub2) = algoW (applySubstEnv sub1 $ applySubstEnv (Sub (SF.TyVar x) $ gen (applySubstEnv sub1 env) ty1) env) t2 -- ask Atze if this corresponds with slides
 in (ty,(AppSub sub2 sub1))

-- TODO: use these functions in the appropriate places
ftv :: SF.Ty -> Environment -> Set SF.Ty
ftv ty env = ftvty ty `union` ftvenv env

ftvty :: SF.Ty -> Set SF.Ty
ftvty (SF.TyVar a) = fromList [SF.TyVar a]
ftvty (SF.Arr t1 t2) = ftvty t1 `union` ftvty t2
ftvty (SF.Forall a xs) = ftvty xs `difference` (fromList [SF.TyVar a]) -- check if this really is difference, or is intersection

ftvenv :: Environment -> Set SF.Ty
ftvenv xs = foldr union (fromList []) $ map (\(x,ty) -> ftvty ty) xs
{-# LINE 94 "hm2systemf.hs" #-}

{-# LINE 10 ".\\CCO/HM/AG/Base.ag" #-}

type Var = String    -- ^ Type of variables.
{-# LINE 99 "hm2systemf.hs" #-}
-- Tm ----------------------------------------------------------
data Tm = Tm (SourcePos) (Tm_)
-- cata
sem_Tm :: Tm ->
          T_Tm
sem_Tm (Tm _pos _t) =
    (sem_Tm_Tm _pos (sem_Tm_ _t))
-- semantic domain
type T_Tm = Environment ->
            ( Environment,Subst,(SF.Ty))
data Inh_Tm = Inh_Tm {env_Inh_Tm :: Environment}
data Syn_Tm = Syn_Tm {env_Syn_Tm :: Environment,subst_Syn_Tm :: Subst,ty_Syn_Tm :: (SF.Ty)}
wrap_Tm :: T_Tm ->
           Inh_Tm ->
           Syn_Tm
wrap_Tm sem (Inh_Tm _lhsIenv) =
    (let ( _lhsOenv,_lhsOsubst,_lhsOty) = sem _lhsIenv
     in  (Syn_Tm _lhsOenv _lhsOsubst _lhsOty))
sem_Tm_Tm :: SourcePos ->
             T_Tm_ ->
             T_Tm
sem_Tm_Tm pos_ t_ =
    (\ _lhsIenv ->
         (let _lhsOty :: (SF.Ty)
              _lhsOsubst :: Subst
              _lhsOenv :: Environment
              _tOenv :: Environment
              _tIenv :: Environment
              _tIsubst :: Subst
              _tIty :: (SF.Ty)
              _lhsOty =
                  ({-# LINE 26 "hm2systemf.ag" #-}
                   _tIty
                   {-# LINE 133 "hm2systemf" #-}
                   )
              _lhsOsubst =
                  ({-# LINE 27 "hm2systemf.ag" #-}
                   _tIsubst
                   {-# LINE 138 "hm2systemf" #-}
                   )
              _lhsOenv =
                  ({-# LINE 28 "hm2systemf.ag" #-}
                   _tIenv
                   {-# LINE 143 "hm2systemf" #-}
                   )
              _tOenv =
                  ({-# LINE 35 "hm2systemf.ag" #-}
                   _lhsIenv
                   {-# LINE 148 "hm2systemf" #-}
                   )
              ( _tIenv,_tIsubst,_tIty) =
                  t_ _tOenv
          in  ( _lhsOenv,_lhsOsubst,_lhsOty)))
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
type T_Tm_ = Environment ->
             ( Environment,Subst,(SF.Ty))
data Inh_Tm_ = Inh_Tm_ {env_Inh_Tm_ :: Environment}
data Syn_Tm_ = Syn_Tm_ {env_Syn_Tm_ :: Environment,subst_Syn_Tm_ :: Subst,ty_Syn_Tm_ :: (SF.Ty)}
wrap_Tm_ :: T_Tm_ ->
            Inh_Tm_ ->
            Syn_Tm_
wrap_Tm_ sem (Inh_Tm_ _lhsIenv) =
    (let ( _lhsOenv,_lhsOsubst,_lhsOty) = sem _lhsIenv
     in  (Syn_Tm_ _lhsOenv _lhsOsubst _lhsOty))
sem_Tm__App :: T_Tm ->
               T_Tm ->
               T_Tm_
sem_Tm__App t1_ t2_ =
    (\ _lhsIenv ->
         (let _t2Oenv :: Environment
              _lhsOty :: (SF.Ty)
              _lhsOsubst :: Subst
              _lhsOenv :: Environment
              _t1Oenv :: Environment
              _t1Ienv :: Environment
              _t1Isubst :: Subst
              _t1Ity :: (SF.Ty)
              _t2Ienv :: Environment
              _t2Isubst :: Subst
              _t2Ity :: (SF.Ty)
              _newVar =
                  ({-# LINE 43 "hm2systemf.ag" #-}
                   undefined
                   {-# LINE 199 "hm2systemf" #-}
                   )
              _t2Oenv =
                  ({-# LINE 44 "hm2systemf.ag" #-}
                   applySubstEnv _t1Isubst _lhsIenv
                   {-# LINE 204 "hm2systemf" #-}
                   )
              _s3 =
                  ({-# LINE 45 "hm2systemf.ag" #-}
                   unify (applySubst _t2Isubst _t1Ity) (Arr (_t2Ity) _newVar    ) _lhsIenv
                   {-# LINE 209 "hm2systemf" #-}
                   )
              _lhsOty =
                  ({-# LINE 46 "hm2systemf.ag" #-}
                   applySubst _s3     _newVar
                   {-# LINE 214 "hm2systemf" #-}
                   )
              _lhsOsubst =
                  ({-# LINE 47 "hm2systemf.ag" #-}
                   AppSub _s3     (AppSub _t2Isubst _t1Isubst)
                   {-# LINE 219 "hm2systemf" #-}
                   )
              _lhsOenv =
                  ({-# LINE 34 "hm2systemf.ag" #-}
                   _t2Ienv
                   {-# LINE 224 "hm2systemf" #-}
                   )
              _t1Oenv =
                  ({-# LINE 24 "hm2systemf.ag" #-}
                   _lhsIenv
                   {-# LINE 229 "hm2systemf" #-}
                   )
              ( _t1Ienv,_t1Isubst,_t1Ity) =
                  t1_ _t1Oenv
              ( _t2Ienv,_t2Isubst,_t2Ity) =
                  t2_ _t2Oenv
          in  ( _lhsOenv,_lhsOsubst,_lhsOty)))
sem_Tm__Lam :: Var ->
               T_Tm ->
               T_Tm_
sem_Tm__Lam x_ t1_ =
    (\ _lhsIenv ->
         (let _lhsOenv :: Environment
              _t1Oenv :: Environment
              _lhsOty :: (SF.Ty)
              _lhsOsubst :: Subst
              _t1Ienv :: Environment
              _t1Isubst :: Subst
              _t1Ity :: (SF.Ty)
              _newVar =
                  ({-# LINE 38 "hm2systemf.ag" #-}
                   undefined
                   {-# LINE 251 "hm2systemf" #-}
                   )
              _lhsOenv =
                  ({-# LINE 39 "hm2systemf.ag" #-}
                   [(x_, _newVar    )]
                   {-# LINE 256 "hm2systemf" #-}
                   )
              _t1Oenv =
                  ({-# LINE 40 "hm2systemf.ag" #-}
                   _lhsIenv
                   {-# LINE 261 "hm2systemf" #-}
                   )
              _lhsOty =
                  ({-# LINE 41 "hm2systemf.ag" #-}
                   applySubst _t1Isubst (Arr (lookup x_ t1.env) (_t1Ity))
                   {-# LINE 266 "hm2systemf" #-}
                   )
              _lhsOsubst =
                  ({-# LINE 42 "hm2systemf.ag" #-}
                   _t1Isubst
                   {-# LINE 271 "hm2systemf" #-}
                   )
              ( _t1Ienv,_t1Isubst,_t1Ity) =
                  t1_ _t1Oenv
          in  ( _lhsOenv,_lhsOsubst,_lhsOty)))
sem_Tm__Let :: Var ->
               T_Tm ->
               T_Tm ->
               T_Tm_
sem_Tm__Let x_ t1_ t2_ =
    (\ _lhsIenv ->
         (let _lhsOenv :: Environment
              _lhsOsubst :: Subst
              _lhsOty :: (SF.Ty)
              _t1Oenv :: Environment
              _t2Oenv :: Environment
              _t1Ienv :: Environment
              _t1Isubst :: Subst
              _t1Ity :: (SF.Ty)
              _t2Ienv :: Environment
              _t2Isubst :: Subst
              _t2Ity :: (SF.Ty)
              _lhsOenv =
                  ({-# LINE 34 "hm2systemf.ag" #-}
                   _t2Ienv
                   {-# LINE 296 "hm2systemf" #-}
                   )
              _lhsOsubst =
                  ({-# LINE 32 "hm2systemf.ag" #-}
                   _t2Isubst
                   {-# LINE 301 "hm2systemf" #-}
                   )
              _lhsOty =
                  ({-# LINE 31 "hm2systemf.ag" #-}
                   _t2Ity
                   {-# LINE 306 "hm2systemf" #-}
                   )
              _t1Oenv =
                  ({-# LINE 24 "hm2systemf.ag" #-}
                   _lhsIenv
                   {-# LINE 311 "hm2systemf" #-}
                   )
              _t2Oenv =
                  ({-# LINE 24 "hm2systemf.ag" #-}
                   _t1Ienv
                   {-# LINE 316 "hm2systemf" #-}
                   )
              ( _t1Ienv,_t1Isubst,_t1Ity) =
                  t1_ _t1Oenv
              ( _t2Ienv,_t2Isubst,_t2Ity) =
                  t2_ _t2Oenv
          in  ( _lhsOenv,_lhsOsubst,_lhsOty)))
sem_Tm__Var :: Var ->
               T_Tm_
sem_Tm__Var x_ =
    (\ _lhsIenv ->
         (let _lhsOty :: (SF.Ty)
              _lhsOsubst :: Subst
              _lhsOenv :: Environment
              _lhsOty =
                  ({-# LINE 48 "hm2systemf.ag" #-}
                   inst (lookup x_ _lhsIenv)
                   {-# LINE 333 "hm2systemf" #-}
                   )
              _lhsOsubst =
                  ({-# LINE 49 "hm2systemf.ag" #-}
                   Id
                   {-# LINE 338 "hm2systemf" #-}
                   )
              _lhsOenv =
                  ({-# LINE 34 "hm2systemf.ag" #-}
                   _lhsIenv
                   {-# LINE 343 "hm2systemf" #-}
                   )
          in  ( _lhsOenv,_lhsOsubst,_lhsOty)))