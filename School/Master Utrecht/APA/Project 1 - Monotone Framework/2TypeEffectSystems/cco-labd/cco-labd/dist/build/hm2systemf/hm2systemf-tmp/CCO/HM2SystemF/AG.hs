

-- UUAGC 0.9.40.2 (src\CCO\HM2SystemF\AG.ag)
module CCO.HM2SystemF.AG where

import CCO.HM (Tm (Tm), Tm_ (Var, Lam, App, Let))
import CCO.SystemF.AG (Ty(TyVar, Arr, Forall))
import qualified CCO.SystemF.AG as SF
import Data.List (union,(\\),nub,delete)
import Data.Maybe (maybe,fromJust)

{-# LINE 2 "src\\CCO\\HM2SystemF\\../HM/AG/Base.ag" #-}

import CCO.SourcePos
{-# LINE 16 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG.hs" #-}
{-# LINE 26 "src\\CCO\\HM2SystemF\\AG.ag" #-}

-- | Infinite list of identifiers for variable types.
identifiers = [l:n | n <- []:(map show [1..]), l <- ['a'..'z']]

-- | Counts the number of fresh variables that are necessary when instantiating
-- Ty for the Var constructor.
freshVar :: Env -> SF.TyVar -> Int
freshVar e v = maybe 1 countUQ (lookup v e)
  where
    -- Counts the number of universally quantified variables.
    countUQ :: Ty -> Int
    countUQ (Forall _ t) = 1 + countUQ t
    countUQ (TyVar _) 	 = 0
    countUQ (Arr t1 t2)  = countUQ t1 + countUQ t2
{-# LINE 32 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG.hs" #-}

{-# LINE 66 "src\\CCO\\HM2SystemF\\AG.ag" #-}

type Env = [(Var, Ty)]

-- | Computes free variables for type environments.
ftv :: Env -> [SF.Var]
ftv env = let coDom = map snd env
	  in (nub.concatMap ftvTy) coDom

-- | Free type variables for a given type.
ftvTy :: Ty -> [SF.Var]
ftvTy (TyVar a) = [a]
ftvTy (Arr t1 t2) = union (ftvTy t1) (ftvTy t2)
ftvTy (Forall a t) = delete a (ftvTy t)

-- | Generalizes over the type t on the environment e.
gen :: Env -> Ty -> Ty
gen e t = let fve = ftv e
      	  in  gen' fve t
  where
    gen' vs sf@(Arr t1 t2) = let fv = ftvTy t1
    	    	        	 nt = Arr t1 (gen' (vs++fv) t2)
    	    	       	     in  foldr Forall nt (fv \\ vs)
    gen' _  sf = sf
{-# LINE 58 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG.hs" #-}

{-# LINE 106 "src\\CCO\\HM2SystemF\\AG.ag" #-}

type TySubst = Ty -> Ty

-- | Variable instantiation.
inst :: [SF.TyVar] -> Ty -> Ty
inst (i:is) (Forall a t) = substitute a (TyVar i) (inst is t)
inst _	    (Forall _ _) = error "Not enough reserved identifiers for inst."
inst is     (Arr t1 t2)  = Arr t1 (inst is t2)	       	    
inst []	    t		 = t

-- | Simple variable type name substitution.
-- Takes care of variable type masking by Forall constructs.
substitute :: SF.TyVar -> Ty -> Ty -> Ty
substitute o n (TyVar a)    | a == o = n
substitute o n (Arr t1 t2)  	     = Arr (substitute o n t1) (substitute o n t2)
substitute o n (Forall a t) | a /= o = Forall a (substitute o n t)
substitute _ _ t	       	     = t

-- | Unifies both types acording to the type substitution algorithm.
unify :: Ty -> Ty -> TySubst
unify t1          t2        | t1 == t2             = id
unify (TyVar a)   ty 	    | notElem a (ftvTy ty) = substitute a ty
unify ty	  (TyVar a) | notElem a (ftvTy ty) = substitute a ty
unify (Arr t1 t2) (Arr t3 t4) = let s1 = unify t1 t3
				    s2 = unify (s1 t2) (s1 t4)
				in  s2 . s1
unify ty1 ty2  = error ("Trying to unify " ++ show ty1 ++ " with " ++ show ty2)
{-# LINE 88 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG.hs" #-}

{-# LINE 152 "src\\CCO\\HM2SystemF\\AG.ag" #-}

-- | Generates a list for type applications.
-- The relevant case here is the Forall var, which means it has been generalized before.
genAppTypes :: SF.Ty -> SF.Ty -> [[SF.Ty]]
genAppTypes _  (TyVar a)     = repeat []
genAppTypes _  (Arr t1 t2)   = repeat []
genAppTypes ts (Forall a t)  = genAppTypes' ts []
		where genAppTypes' (Forall a t) xs 	        = error ("Type should be inst. by now.")
		      genAppTypes' tv@(TyVar a) xs | elem tv xs = [[]]
						   | otherwise  = [[tv]]
		      genAppTypes' (Arr t1 t2)  xs 	        = let x  = map TyVar (ftvTy t1)
							 	      lx = union x xs
						  	          in (x \\ xs):(genAppTypes' t2 lx)
{-# LINE 104 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG.hs" #-}

{-# LINE 179 "src\\CCO\\HM2SystemF\\AG.ag" #-}

-- | Abstracts the types of a lambda.
-- We first gather all the types we have to apply a TyLam before building the
-- final type.
abstractType :: Ty -> [SF.Var] -> SF.Tm -> (SF.Tm, [SF.Var])
abstractType v scope sf = let vs = (fromTy v) \\ scope
	       	     	  in  (foldr SF.TyLam sf vs,scope++vs)
  where
    fromTy (TyVar a)    = [a]
    fromTy (Arr t1 t2)  = nub (fromTy t1 ++ fromTy t2)
    fromTy (Forall a t) = error "Universal quantification on a simple lambda!"
    	   -- The last case should never occur.

-- | Creates type applications for every needed type.
applyType :: [SF.Ty] -> SF.Tm -> SF.Tm 
applyType xs sf = foldl SF.TyApp sf (reverse xs)
{-# LINE 123 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG.hs" #-}

{-# LINE 10 "src\\CCO\\HM2SystemF\\../HM/AG/Base.ag" #-}

type Var = String    -- ^ Type of variables.
{-# LINE 128 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG.hs" #-}
-- Tm ----------------------------------------------------------
-- cata
sem_Tm :: Tm ->
          T_Tm
sem_Tm (Tm _pos _t) =
    (sem_Tm_Tm _pos (sem_Tm_ _t))
-- semantic domain
type T_Tm = Env ->
            TySubst ->
            ([String]) ->
            Int ->
            ([SF.Var]) ->
            ( ([[SF.Ty]]),([String]),(SF.Tm),TySubst,Ty)
data Inh_Tm = Inh_Tm {env_Inh_Tm :: Env,fSubst_Inh_Tm :: TySubst,idents_Inh_Tm :: ([String]),lamApp_Inh_Tm :: Int,tyScope_Inh_Tm :: ([SF.Var])}
data Syn_Tm = Syn_Tm {appTypes_Syn_Tm :: ([[SF.Ty]]),idents_Syn_Tm :: ([String]),sfrep_Syn_Tm :: (SF.Tm),subst_Syn_Tm :: TySubst,ty_Syn_Tm :: Ty}
wrap_Tm :: T_Tm ->
           Inh_Tm ->
           Syn_Tm
wrap_Tm sem (Inh_Tm _lhsIenv _lhsIfSubst _lhsIidents _lhsIlamApp _lhsItyScope) =
    (let ( _lhsOappTypes,_lhsOidents,_lhsOsfrep,_lhsOsubst,_lhsOty) = sem _lhsIenv _lhsIfSubst _lhsIidents _lhsIlamApp _lhsItyScope
     in  (Syn_Tm _lhsOappTypes _lhsOidents _lhsOsfrep _lhsOsubst _lhsOty))
sem_Tm_Tm :: SourcePos ->
             T_Tm_ ->
             T_Tm
sem_Tm_Tm pos_ t_ =
    (\ _lhsIenv
       _lhsIfSubst
       _lhsIidents
       _lhsIlamApp
       _lhsItyScope ->
         (let _lhsOappTypes :: ([[SF.Ty]])
              _lhsOidents :: ([String])
              _lhsOsfrep :: (SF.Tm)
              _lhsOsubst :: TySubst
              _lhsOty :: Ty
              _tOenv :: Env
              _tOfSubst :: TySubst
              _tOidents :: ([String])
              _tOlamApp :: Int
              _tOtyScope :: ([SF.Var])
              _tIappTypes :: ([[SF.Ty]])
              _tIidents :: ([String])
              _tIsfrep :: (SF.Tm)
              _tIsubst :: TySubst
              _tIty :: Ty
              _lhsOappTypes =
                  ({-# LINE 168 "src\\CCO\\HM2SystemF\\AG.ag" #-}
                   _tIappTypes
                   {-# LINE 177 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG" #-}
                   )
              _lhsOidents =
                  ({-# LINE 43 "src\\CCO\\HM2SystemF\\AG.ag" #-}
                   _tIidents
                   {-# LINE 182 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG" #-}
                   )
              _lhsOsfrep =
                  ({-# LINE 200 "src\\CCO\\HM2SystemF\\AG.ag" #-}
                   _tIsfrep
                   {-# LINE 187 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG" #-}
                   )
              _lhsOsubst =
                  ({-# LINE 138 "src\\CCO\\HM2SystemF\\AG.ag" #-}
                   _tIsubst
                   {-# LINE 192 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG" #-}
                   )
              _lhsOty =
                  ({-# LINE 136 "src\\CCO\\HM2SystemF\\AG.ag" #-}
                   _tIty
                   {-# LINE 197 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG" #-}
                   )
              _tOenv =
                  ({-# LINE 92 "src\\CCO\\HM2SystemF\\AG.ag" #-}
                   _lhsIenv
                   {-# LINE 202 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG" #-}
                   )
              _tOfSubst =
                  ({-# LINE 137 "src\\CCO\\HM2SystemF\\AG.ag" #-}
                   _lhsIfSubst
                   {-# LINE 207 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG" #-}
                   )
              _tOidents =
                  ({-# LINE 44 "src\\CCO\\HM2SystemF\\AG.ag" #-}
                   _lhsIidents
                   {-# LINE 212 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG" #-}
                   )
              _tOlamApp =
                  ({-# LINE 198 "src\\CCO\\HM2SystemF\\AG.ag" #-}
                   _lhsIlamApp
                   {-# LINE 217 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG" #-}
                   )
              _tOtyScope =
                  ({-# LINE 199 "src\\CCO\\HM2SystemF\\AG.ag" #-}
                   _lhsItyScope
                   {-# LINE 222 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG" #-}
                   )
              ( _tIappTypes,_tIidents,_tIsfrep,_tIsubst,_tIty) =
                  t_ _tOenv _tOfSubst _tOidents _tOlamApp _tOtyScope
          in  ( _lhsOappTypes,_lhsOidents,_lhsOsfrep,_lhsOsubst,_lhsOty)))
-- Tm_ ---------------------------------------------------------
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
type T_Tm_ = Env ->
             TySubst ->
             ([String]) ->
             Int ->
             ([SF.Var]) ->
             ( ([[SF.Ty]]),([String]),(SF.Tm),TySubst,Ty)
data Inh_Tm_ = Inh_Tm_ {env_Inh_Tm_ :: Env,fSubst_Inh_Tm_ :: TySubst,idents_Inh_Tm_ :: ([String]),lamApp_Inh_Tm_ :: Int,tyScope_Inh_Tm_ :: ([SF.Var])}
data Syn_Tm_ = Syn_Tm_ {appTypes_Syn_Tm_ :: ([[SF.Ty]]),idents_Syn_Tm_ :: ([String]),sfrep_Syn_Tm_ :: (SF.Tm),subst_Syn_Tm_ :: TySubst,ty_Syn_Tm_ :: Ty}
wrap_Tm_ :: T_Tm_ ->
            Inh_Tm_ ->
            Syn_Tm_
wrap_Tm_ sem (Inh_Tm_ _lhsIenv _lhsIfSubst _lhsIidents _lhsIlamApp _lhsItyScope) =
    (let ( _lhsOappTypes,_lhsOidents,_lhsOsfrep,_lhsOsubst,_lhsOty) = sem _lhsIenv _lhsIfSubst _lhsIidents _lhsIlamApp _lhsItyScope
     in  (Syn_Tm_ _lhsOappTypes _lhsOidents _lhsOsfrep _lhsOsubst _lhsOty))
sem_Tm__App :: T_Tm ->
               T_Tm ->
               T_Tm_
sem_Tm__App t1_ t2_ =
    (\ _lhsIenv
       _lhsIfSubst
       _lhsIidents
       _lhsIlamApp
       _lhsItyScope ->
         (let _lhsOidents :: ([String])
              _t1Oidents :: ([String])
              _t2Oidents :: ([String])
              _t1Oenv :: Env
              _t2Oenv :: Env
              _lhsOty :: Ty
              _lhsOsubst :: TySubst
              _lhsOappTypes :: ([[SF.Ty]])
              _lhsOsfrep :: (SF.Tm)
              _t2OlamApp :: Int
              _t1OlamApp :: Int
              _t1OfSubst :: TySubst
              _t1OtyScope :: ([SF.Var])
              _t2OfSubst :: TySubst
              _t2OtyScope :: ([SF.Var])
              _t1IappTypes :: ([[SF.Ty]])
              _t1Iidents :: ([String])
              _t1Isfrep :: (SF.Tm)
              _t1Isubst :: TySubst
              _t1Ity :: Ty
              _t2IappTypes :: ([[SF.Ty]])
              _t2Iidents :: ([String])
              _t2Isfrep :: (SF.Tm)
              _t2Isubst :: TySubst
              _t2Ity :: Ty
              _ident =
                  ({-# LINE 54 "src\\CCO\\HM2SystemF\\AG.ag" #-}
                   _lhsIidents !! 0
                   {-# LINE 291 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG" #-}
                   )
              _lhsOidents =
                  ({-# LINE 55 "src\\CCO\\HM2SystemF\\AG.ag" #-}
                   _t2Iidents
                   {-# LINE 296 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG" #-}
                   )
              _t1Oidents =
                  ({-# LINE 56 "src\\CCO\\HM2SystemF\\AG.ag" #-}
                   drop 1 _lhsIidents
                   {-# LINE 301 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG" #-}
                   )
              _t2Oidents =
                  ({-# LINE 57 "src\\CCO\\HM2SystemF\\AG.ag" #-}
                   _t1Iidents
                   {-# LINE 306 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG" #-}
                   )
              _t1Oenv =
                  ({-# LINE 95 "src\\CCO\\HM2SystemF\\AG.ag" #-}
                   _lhsIenv
                   {-# LINE 311 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG" #-}
                   )
              _t2Oenv =
                  ({-# LINE 96 "src\\CCO\\HM2SystemF\\AG.ag" #-}
                   map (\(x,y) -> (x,_t1Isubst y)) _lhsIenv
                   {-# LINE 316 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG" #-}
                   )
              _fresh =
                  ({-# LINE 145 "src\\CCO\\HM2SystemF\\AG.ag" #-}
                   TyVar _ident
                   {-# LINE 321 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG" #-}
                   )
              _sub3 =
                  ({-# LINE 146 "src\\CCO\\HM2SystemF\\AG.ag" #-}
                   unify (_t2Isubst _t1Ity) (Arr _t2Ity _fresh    )
                   {-# LINE 326 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG" #-}
                   )
              _lhsOty =
                  ({-# LINE 147 "src\\CCO\\HM2SystemF\\AG.ag" #-}
                   _sub3     _fresh
                   {-# LINE 331 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG" #-}
                   )
              _lhsOsubst =
                  ({-# LINE 148 "src\\CCO\\HM2SystemF\\AG.ag" #-}
                   _sub3     . _t2Isubst . _t1Isubst
                   {-# LINE 336 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG" #-}
                   )
              _lhsOappTypes =
                  ({-# LINE 172 "src\\CCO\\HM2SystemF\\AG.ag" #-}
                   drop 1 _t1IappTypes
                   {-# LINE 341 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG" #-}
                   )
              _lhsOsfrep =
                  ({-# LINE 209 "src\\CCO\\HM2SystemF\\AG.ag" #-}
                   SF.App (applyType (map _lhsIfSubst (head _t1IappTypes)) _t1Isfrep) _t2Isfrep
                   {-# LINE 346 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG" #-}
                   )
              _t2OlamApp =
                  ({-# LINE 210 "src\\CCO\\HM2SystemF\\AG.ag" #-}
                   0
                   {-# LINE 351 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG" #-}
                   )
              _t1OlamApp =
                  ({-# LINE 211 "src\\CCO\\HM2SystemF\\AG.ag" #-}
                   _lhsIlamApp + 1
                   {-# LINE 356 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG" #-}
                   )
              _t1OfSubst =
                  ({-# LINE 137 "src\\CCO\\HM2SystemF\\AG.ag" #-}
                   _lhsIfSubst
                   {-# LINE 361 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG" #-}
                   )
              _t1OtyScope =
                  ({-# LINE 199 "src\\CCO\\HM2SystemF\\AG.ag" #-}
                   _lhsItyScope
                   {-# LINE 366 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG" #-}
                   )
              _t2OfSubst =
                  ({-# LINE 137 "src\\CCO\\HM2SystemF\\AG.ag" #-}
                   _lhsIfSubst
                   {-# LINE 371 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG" #-}
                   )
              _t2OtyScope =
                  ({-# LINE 199 "src\\CCO\\HM2SystemF\\AG.ag" #-}
                   _lhsItyScope
                   {-# LINE 376 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG" #-}
                   )
              ( _t1IappTypes,_t1Iidents,_t1Isfrep,_t1Isubst,_t1Ity) =
                  t1_ _t1Oenv _t1OfSubst _t1Oidents _t1OlamApp _t1OtyScope
              ( _t2IappTypes,_t2Iidents,_t2Isfrep,_t2Isubst,_t2Ity) =
                  t2_ _t2Oenv _t2OfSubst _t2Oidents _t2OlamApp _t2OtyScope
          in  ( _lhsOappTypes,_lhsOidents,_lhsOsfrep,_lhsOsubst,_lhsOty)))
sem_Tm__Lam :: Var ->
               T_Tm ->
               T_Tm_
sem_Tm__Lam x_ t1_ =
    (\ _lhsIenv
       _lhsIfSubst
       _lhsIidents
       _lhsIlamApp
       _lhsItyScope ->
         (let _lhsOidents :: ([String])
              _t1Oidents :: ([String])
              _t1Oenv :: Env
              _lhsOty :: Ty
              _lhsOsubst :: TySubst
              _lhsOappTypes :: ([[SF.Ty]])
              _lhsOsfrep :: (SF.Tm)
              _t1OtyScope :: ([SF.Var])
              _t1OlamApp :: Int
              _t1OfSubst :: TySubst
              _t1IappTypes :: ([[SF.Ty]])
              _t1Iidents :: ([String])
              _t1Isfrep :: (SF.Tm)
              _t1Isubst :: TySubst
              _t1Ity :: Ty
              _ident =
                  ({-# LINE 51 "src\\CCO\\HM2SystemF\\AG.ag" #-}
                   _lhsIidents !! 0
                   {-# LINE 410 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG" #-}
                   )
              _lhsOidents =
                  ({-# LINE 52 "src\\CCO\\HM2SystemF\\AG.ag" #-}
                   _t1Iidents
                   {-# LINE 415 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG" #-}
                   )
              _t1Oidents =
                  ({-# LINE 53 "src\\CCO\\HM2SystemF\\AG.ag" #-}
                   drop 1 _lhsIidents
                   {-# LINE 420 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG" #-}
                   )
              _t1Oenv =
                  ({-# LINE 94 "src\\CCO\\HM2SystemF\\AG.ag" #-}
                   (x_,SF.TyVar _ident    ):(_lhsIenv)
                   {-# LINE 425 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG" #-}
                   )
              _typar =
                  ({-# LINE 142 "src\\CCO\\HM2SystemF\\AG.ag" #-}
                   _t1Isubst (TyVar _ident    )
                   {-# LINE 430 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG" #-}
                   )
              _lhsOty =
                  ({-# LINE 143 "src\\CCO\\HM2SystemF\\AG.ag" #-}
                   Arr _typar     _t1Ity
                   {-# LINE 435 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG" #-}
                   )
              _lhsOsubst =
                  ({-# LINE 144 "src\\CCO\\HM2SystemF\\AG.ag" #-}
                   _t1Isubst
                   {-# LINE 440 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG" #-}
                   )
              _lhsOappTypes =
                  ({-# LINE 171 "src\\CCO\\HM2SystemF\\AG.ag" #-}
                   repeat []
                   {-# LINE 445 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG" #-}
                   )
              _sfrep' =
                  ({-# LINE 203 "src\\CCO\\HM2SystemF\\AG.ag" #-}
                   SF.Lam x_ (_lhsIfSubst _typar    ) _t1Isfrep
                   {-# LINE 450 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG" #-}
                   )
              _absrep =
                  ({-# LINE 204 "src\\CCO\\HM2SystemF\\AG.ag" #-}
                   if 0 < _lhsIlamApp then (_sfrep'    ,_lhsItyScope)
                                      else abstractType (_lhsIfSubst _typar    ) _lhsItyScope _sfrep'
                   {-# LINE 456 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG" #-}
                   )
              _lhsOsfrep =
                  ({-# LINE 206 "src\\CCO\\HM2SystemF\\AG.ag" #-}
                   fst _absrep
                   {-# LINE 461 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG" #-}
                   )
              _t1OtyScope =
                  ({-# LINE 207 "src\\CCO\\HM2SystemF\\AG.ag" #-}
                   snd _absrep
                   {-# LINE 466 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG" #-}
                   )
              _t1OlamApp =
                  ({-# LINE 208 "src\\CCO\\HM2SystemF\\AG.ag" #-}
                   _lhsIlamApp - 1
                   {-# LINE 471 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG" #-}
                   )
              _t1OfSubst =
                  ({-# LINE 137 "src\\CCO\\HM2SystemF\\AG.ag" #-}
                   _lhsIfSubst
                   {-# LINE 476 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG" #-}
                   )
              ( _t1IappTypes,_t1Iidents,_t1Isfrep,_t1Isubst,_t1Ity) =
                  t1_ _t1Oenv _t1OfSubst _t1Oidents _t1OlamApp _t1OtyScope
          in  ( _lhsOappTypes,_lhsOidents,_lhsOsfrep,_lhsOsubst,_lhsOty)))
sem_Tm__Let :: Var ->
               T_Tm ->
               T_Tm ->
               T_Tm_
sem_Tm__Let x_ t1_ t2_ =
    (\ _lhsIenv
       _lhsIfSubst
       _lhsIidents
       _lhsIlamApp
       _lhsItyScope ->
         (let _lhsOidents :: ([String])
              _t1Oidents :: ([String])
              _t2Oidents :: ([String])
              _t1Oenv :: Env
              _t2Oenv :: Env
              _lhsOty :: Ty
              _lhsOsubst :: TySubst
              _lhsOappTypes :: ([[SF.Ty]])
              _lhsOsfrep :: (SF.Tm)
              _t1OlamApp :: Int
              _t2OlamApp :: Int
              _t1OfSubst :: TySubst
              _t1OtyScope :: ([SF.Var])
              _t2OfSubst :: TySubst
              _t2OtyScope :: ([SF.Var])
              _t1IappTypes :: ([[SF.Ty]])
              _t1Iidents :: ([String])
              _t1Isfrep :: (SF.Tm)
              _t1Isubst :: TySubst
              _t1Ity :: Ty
              _t2IappTypes :: ([[SF.Ty]])
              _t2Iidents :: ([String])
              _t2Isfrep :: (SF.Tm)
              _t2Isubst :: TySubst
              _t2Ity :: Ty
              _lhsOidents =
                  ({-# LINE 58 "src\\CCO\\HM2SystemF\\AG.ag" #-}
                   _t2Iidents
                   {-# LINE 519 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG" #-}
                   )
              _t1Oidents =
                  ({-# LINE 59 "src\\CCO\\HM2SystemF\\AG.ag" #-}
                   _lhsIidents
                   {-# LINE 524 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG" #-}
                   )
              _t2Oidents =
                  ({-# LINE 60 "src\\CCO\\HM2SystemF\\AG.ag" #-}
                   _t1Iidents
                   {-# LINE 529 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG" #-}
                   )
              _t1Oenv =
                  ({-# LINE 97 "src\\CCO\\HM2SystemF\\AG.ag" #-}
                   _lhsIenv
                   {-# LINE 534 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG" #-}
                   )
              _envT2 =
                  ({-# LINE 98 "src\\CCO\\HM2SystemF\\AG.ag" #-}
                   map (\(x,y) -> (x,_t1Isubst y)) _lhsIenv
                   {-# LINE 539 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG" #-}
                   )
              _genT2 =
                  ({-# LINE 99 "src\\CCO\\HM2SystemF\\AG.ag" #-}
                   gen _envT2     _t1Ity
                   {-# LINE 544 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG" #-}
                   )
              _t2Oenv =
                  ({-# LINE 100 "src\\CCO\\HM2SystemF\\AG.ag" #-}
                   (x_,_genT2    ):(_envT2    )
                   {-# LINE 549 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG" #-}
                   )
              _lhsOty =
                  ({-# LINE 149 "src\\CCO\\HM2SystemF\\AG.ag" #-}
                   _t2Ity
                   {-# LINE 554 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG" #-}
                   )
              _lhsOsubst =
                  ({-# LINE 150 "src\\CCO\\HM2SystemF\\AG.ag" #-}
                   _t2Isubst . _t1Isubst
                   {-# LINE 559 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG" #-}
                   )
              _lhsOappTypes =
                  ({-# LINE 173 "src\\CCO\\HM2SystemF\\AG.ag" #-}
                   []
                   {-# LINE 564 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG" #-}
                   )
              _lhsOsfrep =
                  ({-# LINE 212 "src\\CCO\\HM2SystemF\\AG.ag" #-}
                   SF.App (SF.Lam x_ (_lhsIfSubst _genT2    ) _t2Isfrep) _t1Isfrep
                   {-# LINE 569 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG" #-}
                   )
              _t1OlamApp =
                  ({-# LINE 213 "src\\CCO\\HM2SystemF\\AG.ag" #-}
                   0
                   {-# LINE 574 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG" #-}
                   )
              _t2OlamApp =
                  ({-# LINE 214 "src\\CCO\\HM2SystemF\\AG.ag" #-}
                   0
                   {-# LINE 579 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG" #-}
                   )
              _t1OfSubst =
                  ({-# LINE 137 "src\\CCO\\HM2SystemF\\AG.ag" #-}
                   _lhsIfSubst
                   {-# LINE 584 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG" #-}
                   )
              _t1OtyScope =
                  ({-# LINE 199 "src\\CCO\\HM2SystemF\\AG.ag" #-}
                   _lhsItyScope
                   {-# LINE 589 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG" #-}
                   )
              _t2OfSubst =
                  ({-# LINE 137 "src\\CCO\\HM2SystemF\\AG.ag" #-}
                   _lhsIfSubst
                   {-# LINE 594 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG" #-}
                   )
              _t2OtyScope =
                  ({-# LINE 199 "src\\CCO\\HM2SystemF\\AG.ag" #-}
                   _lhsItyScope
                   {-# LINE 599 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG" #-}
                   )
              ( _t1IappTypes,_t1Iidents,_t1Isfrep,_t1Isubst,_t1Ity) =
                  t1_ _t1Oenv _t1OfSubst _t1Oidents _t1OlamApp _t1OtyScope
              ( _t2IappTypes,_t2Iidents,_t2Isfrep,_t2Isubst,_t2Ity) =
                  t2_ _t2Oenv _t2OfSubst _t2Oidents _t2OlamApp _t2OtyScope
          in  ( _lhsOappTypes,_lhsOidents,_lhsOsfrep,_lhsOsubst,_lhsOty)))
sem_Tm__Var :: Var ->
               T_Tm_
sem_Tm__Var x_ =
    (\ _lhsIenv
       _lhsIfSubst
       _lhsIidents
       _lhsIlamApp
       _lhsItyScope ->
         (let _lhsOidents :: ([String])
              _lhsOsubst :: TySubst
              _lhsOappTypes :: ([[SF.Ty]])
              _lhsOsfrep :: (SF.Tm)
              _lhsOty :: Ty
              _nident =
                  ({-# LINE 48 "src\\CCO\\HM2SystemF\\AG.ag" #-}
                   freshVar _lhsIenv x_
                   {-# LINE 622 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG" #-}
                   )
              _ident =
                  ({-# LINE 49 "src\\CCO\\HM2SystemF\\AG.ag" #-}
                   take _nident     _lhsIidents
                   {-# LINE 627 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG" #-}
                   )
              _lhsOidents =
                  ({-# LINE 50 "src\\CCO\\HM2SystemF\\AG.ag" #-}
                   drop _nident     _lhsIidents
                   {-# LINE 632 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG" #-}
                   )
              _ty =
                  ({-# LINE 140 "src\\CCO\\HM2SystemF\\AG.ag" #-}
                   maybe (TyVar $ head _ident    ) (inst _ident    ) (lookup x_ _lhsIenv)
                   {-# LINE 637 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG" #-}
                   )
              _lhsOsubst =
                  ({-# LINE 141 "src\\CCO\\HM2SystemF\\AG.ag" #-}
                   id
                   {-# LINE 642 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG" #-}
                   )
              _lhsOappTypes =
                  ({-# LINE 170 "src\\CCO\\HM2SystemF\\AG.ag" #-}
                   maybe (repeat []) (genAppTypes _ty    ) (lookup x_ _lhsIenv)
                   {-# LINE 647 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG" #-}
                   )
              _lhsOsfrep =
                  ({-# LINE 202 "src\\CCO\\HM2SystemF\\AG.ag" #-}
                   SF.Var x_
                   {-# LINE 652 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG" #-}
                   )
              _lhsOty =
                  ({-# LINE 136 "src\\CCO\\HM2SystemF\\AG.ag" #-}
                   _ty
                   {-# LINE 657 "dist\\build\\hm2systemf\\hm2systemf-tmp\\CCO\\HM2SystemF\\AG" #-}
                   )
          in  ( _lhsOappTypes,_lhsOidents,_lhsOsfrep,_lhsOsubst,_lhsOty)))