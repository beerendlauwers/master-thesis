

-- UUAGC 0.9.40.2 (HMTyping.ag)
module HMTyping where

import Data.List (union,(\\),nub,delete)
import CCO.HM.AG hiding (TyVarName,VarType,TyScheme)
import Dim.Datatypes
import qualified Data.Map as M
import Data.Maybe
import Data.List
import CCO.SourcePos

{-# LINE 2 ".\\CCO/HM/AG/Base.ag" #-}

import CCO.SourcePos
{-# LINE 18 "HMTyping.hs" #-}
{-# LINE 16 "HMTyping.ag" #-}

------------------------------
-- | Fresh Variable Generation
------------------------------

identifiers :: [String]
identifiers = [l:n | n <- []:(map show [1..]), l <- ['a'..'z']]

-- | Counts the number of fresh variables that are necessary when instantiating
-- Ty for the Var constructor.
freshVarsNeeded :: Env -> VarType -> Int
freshVarsNeeded e v = maybe 1 countUQ (lookup v e)

-- | Counts the number of universally quantified variables.
countUQ :: Ty -> Int
countUQ (Forall _ t)  = 1 + countUQ t
countUQ (Arrow t1 t2) = countUQ t1 + countUQ t2
countUQ _ 	          = 0
{-# LINE 38 "HMTyping.hs" #-}

{-# LINE 63 "HMTyping.ag" #-}

----------------
-- | Environment
----------------

type Env = [(VarType, Ty)]

-- | Computes free variables for type environments.
ftv :: Env -> [VarType]
ftv env = let types = map snd env
	      in (nub.concatMap ftvTy) types

ftvTy :: Ty -> [VarType]
ftvTy (TypeVar a) = [a]
ftvTy (Arrow t1 t2) = union (ftvTy t1) (ftvTy t2)
ftvTy (Forall a t) = delete a (ftvTy t)

-- | Generalizes over the type t on the environment e.
gen :: Env -> Ty -> TyScheme
gen e t = let freevars = ftv e
      	  in gen' freevars t

-- | Given a type, creates a nested Forall'd version of the type. 
gen' :: [VarType] -> Ty -> TyScheme 
gen' freevars (Arrow t1 t2) = let freevarsT1 = ftvTy t1
    	    	                  newType = Arrow t1 (gen' (freevars++freevarsT1) t2)
    	    	              in  foldr Forall newType (freevarsT1 \\ freevars)      -- (freevarsT1 \\ freevars) = ftv(T) \\ ftv(env)
                                                                                     -- Folding = Forall x (Forall y (Forall z etc),
                                                                                     -- until we get Forall x (Forall y (Forall z newType)
gen' _  sf = sf
{-# LINE 71 "HMTyping.hs" #-}

{-# LINE 106 "HMTyping.ag" #-}

--------------------
-- | Type Generation
--------------------

-- | A Type substitution.
type TySubst = Ty -> Ty


-- | Variable instantiation.
inst :: [VarType] -> Ty -> Ty
inst (i:is) (Forall a t) = substitute a (TypeVar i) (inst is t)
inst _	    (Forall _ _) = error "Not enough reserved identifiers available for inst."
inst is     (Arrow t1 t2)  = Arrow t1 (inst is t2)	       	    
inst []	    t		 = t

-- | Simple variable type name substitution.
-- Takes care of variable type masking by Forall constructs.
substitute :: VarType -> Ty -> Ty -> Ty
substitute o n (TypeVar a)    | a == o = n
substitute o n (Arrow t1 t2)  	       = Arrow (substitute o n t1) (substitute o n t2)
substitute o n (Forall a t)   | a /= o = Forall a (substitute o n t)
substitute _ _ t	       	           = t

-- | Unifies both types.
unify :: Ty -> Ty -> TySubst
unify t1          t2        | t1 == t2             = id
unify (TypeVar a) ty        | notElem a (ftvTy ty) = substitute a ty
unify ty	     (TypeVar a)| notElem a (ftvTy ty) = substitute a ty
unify (Arrow t1 t2) (Arrow t3 t4)                  = let s1 = unify t1 t3
				                                     in  s1
unify ty1 ty2  = error ("Could not unify " ++ show ty1 ++ " with " ++ show ty2)
{-# LINE 106 "HMTyping.hs" #-}

{-# LINE 10 ".\\CCO/HM/AG/Base.ag" #-}

type TyVarName = String    -- ^ Type of type variables. 
type VarType = String          -- ^ Type of variables.
type TyScheme = Ty
{-# LINE 113 "HMTyping.hs" #-}

{-# LINE 13 ".\\DimensionTyping.ag" #-}


-- Environment for mapping function names and variable names to dimensions.
type DimEnv = M.Map String Dimension

-- The basic constraint; it says two given Dimensions are equal 
type Constraint = (Dimension, Dimension)
-- Rich Constraint, annotated with its source position and the actual term.
type AnnConstraint = (Constraint, SourcePos, Tm)
-- This is a list of equalities between constraints
type Constraints = [AnnConstraint] 
{-# LINE 127 "HMTyping.hs" #-}

{-# LINE 28 ".\\DimensionTyping.ag" #-}

fetchFirstConstraint :: Dimension -> Dimension
fetchFirstConstraint (DimVar x) = DimVar x
fetchFirstConstraint (DimArrow l r) = l -- Should always grow to the right, so l should be a DimVar.

fetchSecondConstraint :: Dimension -> Dimension
fetchSecondConstraint (DimVar x) = DimVar x
fetchSecondConstraint (DimArrow l r) = r
fetchSecondConstraint x = error $ "Expected a DimArrow, but got the following: " ++ show x ++ "\nProbable cause: incorrect application."
{-# LINE 139 "HMTyping.hs" #-}

{-# LINE 85 ".\\DimensionTyping.ag" #-}


getFromEnv :: String -> DimEnv -> Dimension
getFromEnv s d = let result = M.lookup s d
                 in case result of
                     Just x  -> x
                     Nothing -> error $ "Could not find a dimension signature for the function \"" ++ s ++ "\"."

isDimPoly :: Dimension -> Bool
isDimPoly (DimPoly _) = True
isDimPoly (DimArrow a b) = or [isDimPoly a,isDimPoly b]
isDimPoly (DimInverse a) = isDimPoly a
isDimPoly (DimMult a b) = or [isDimPoly a,isDimPoly b]
isDimPoly _ = False



substitutePoly :: Dimension -> [(String,String)] -> Dimension
substitutePoly (DimPoly v) list = maybe (DimPoly v) DimVar (lookup v list)
substitutePoly (DimArrow a b) l = DimArrow (substitutePoly a l) (substitutePoly b l)
substitutePoly (DimInverse a) l = DimInverse (substitutePoly a l)
substitutePoly (DimMult a b) l = DimMult (substitutePoly a l) (substitutePoly b l)
substitutePoly x _ = x

countPoly :: Dimension -> Int
countPoly = length.getPoly

getPoly :: Dimension -> [String]
getPoly (DimArrow a b) = union (getPoly a) (getPoly b)
getPoly (DimPoly v) = [v]
getPoly (DimInverse a) = getPoly a
getPoly (DimMult a b) = union (getPoly a) (getPoly b)
getPoly x = []
{-# LINE 175 "HMTyping.hs" #-}
-- Base --------------------------------------------------------
-- cata
sem_Base :: Base ->
            T_Base
sem_Base (AbsoluteTemperature _s) =
    (sem_Base_AbsoluteTemperature (sem_TemperatureScale _s))
sem_Base (ElectricCharge _s) =
    (sem_Base_ElectricCharge (sem_ElectricScale _s))
sem_Base (Length _s) =
    (sem_Base_Length (sem_LengthScale _s))
sem_Base (Mass _s) =
    (sem_Base_Mass (sem_MassScale _s))
sem_Base (Time _s) =
    (sem_Base_Time (sem_TimeScale _s))
-- semantic domain
type T_Base = ( )
data Inh_Base = Inh_Base {}
data Syn_Base = Syn_Base {}
wrap_Base :: T_Base ->
             Inh_Base ->
             Syn_Base
wrap_Base sem (Inh_Base) =
    (let ( ) = sem
     in  (Syn_Base))
sem_Base_AbsoluteTemperature :: T_TemperatureScale ->
                                T_Base
sem_Base_AbsoluteTemperature s_ =
    (let
     in  ( ))
sem_Base_ElectricCharge :: T_ElectricScale ->
                           T_Base
sem_Base_ElectricCharge s_ =
    (let
     in  ( ))
sem_Base_Length :: T_LengthScale ->
                   T_Base
sem_Base_Length s_ =
    (let
     in  ( ))
sem_Base_Mass :: T_MassScale ->
                 T_Base
sem_Base_Mass s_ =
    (let
     in  ( ))
sem_Base_Time :: T_TimeScale ->
                 T_Base
sem_Base_Time s_ =
    (let
     in  ( ))
-- Dimension ---------------------------------------------------
-- cata
sem_Dimension :: Dimension ->
                 T_Dimension
sem_Dimension (DimArrow _a1 _a2) =
    (sem_Dimension_DimArrow (sem_Dimension _a1) (sem_Dimension _a2))
sem_Dimension (DimBase _b) =
    (sem_Dimension_DimBase (sem_Base _b))
sem_Dimension (DimInverse _a) =
    (sem_Dimension_DimInverse (sem_Dimension _a))
sem_Dimension (DimMult _a1 _a2) =
    (sem_Dimension_DimMult (sem_Dimension _a1) (sem_Dimension _a2))
sem_Dimension (DimPoly _v) =
    (sem_Dimension_DimPoly _v)
sem_Dimension (DimVar _v) =
    (sem_Dimension_DimVar _v)
-- semantic domain
type T_Dimension = ( )
data Inh_Dimension = Inh_Dimension {}
data Syn_Dimension = Syn_Dimension {}
wrap_Dimension :: T_Dimension ->
                  Inh_Dimension ->
                  Syn_Dimension
wrap_Dimension sem (Inh_Dimension) =
    (let ( ) = sem
     in  (Syn_Dimension))
sem_Dimension_DimArrow :: T_Dimension ->
                          T_Dimension ->
                          T_Dimension
sem_Dimension_DimArrow a1_ a2_ =
    (let
     in  ( ))
sem_Dimension_DimBase :: T_Base ->
                         T_Dimension
sem_Dimension_DimBase b_ =
    (let
     in  ( ))
sem_Dimension_DimInverse :: T_Dimension ->
                            T_Dimension
sem_Dimension_DimInverse a_ =
    (let
     in  ( ))
sem_Dimension_DimMult :: T_Dimension ->
                         T_Dimension ->
                         T_Dimension
sem_Dimension_DimMult a1_ a2_ =
    (let
     in  ( ))
sem_Dimension_DimPoly :: String ->
                         T_Dimension
sem_Dimension_DimPoly v_ =
    (let
     in  ( ))
sem_Dimension_DimVar :: String ->
                        T_Dimension
sem_Dimension_DimVar v_ =
    (let
     in  ( ))
-- ElectricScale -----------------------------------------------
-- cata
sem_ElectricScale :: ElectricScale ->
                     T_ElectricScale
sem_ElectricScale (ElectricVar) =
    (sem_ElectricScale_ElectricVar)
-- semantic domain
type T_ElectricScale = ( )
data Inh_ElectricScale = Inh_ElectricScale {}
data Syn_ElectricScale = Syn_ElectricScale {}
wrap_ElectricScale :: T_ElectricScale ->
                      Inh_ElectricScale ->
                      Syn_ElectricScale
wrap_ElectricScale sem (Inh_ElectricScale) =
    (let ( ) = sem
     in  (Syn_ElectricScale))
sem_ElectricScale_ElectricVar :: T_ElectricScale
sem_ElectricScale_ElectricVar =
    (let
     in  ( ))
-- LengthScale -------------------------------------------------
-- cata
sem_LengthScale :: LengthScale ->
                   T_LengthScale
sem_LengthScale (Centimeter) =
    (sem_LengthScale_Centimeter)
sem_LengthScale (Foot) =
    (sem_LengthScale_Foot)
sem_LengthScale (Inch) =
    (sem_LengthScale_Inch)
sem_LengthScale (Kilometer) =
    (sem_LengthScale_Kilometer)
sem_LengthScale (Meter) =
    (sem_LengthScale_Meter)
sem_LengthScale (Mile) =
    (sem_LengthScale_Mile)
sem_LengthScale (Milimeter) =
    (sem_LengthScale_Milimeter)
sem_LengthScale (Yard) =
    (sem_LengthScale_Yard)
-- semantic domain
type T_LengthScale = ( )
data Inh_LengthScale = Inh_LengthScale {}
data Syn_LengthScale = Syn_LengthScale {}
wrap_LengthScale :: T_LengthScale ->
                    Inh_LengthScale ->
                    Syn_LengthScale
wrap_LengthScale sem (Inh_LengthScale) =
    (let ( ) = sem
     in  (Syn_LengthScale))
sem_LengthScale_Centimeter :: T_LengthScale
sem_LengthScale_Centimeter =
    (let
     in  ( ))
sem_LengthScale_Foot :: T_LengthScale
sem_LengthScale_Foot =
    (let
     in  ( ))
sem_LengthScale_Inch :: T_LengthScale
sem_LengthScale_Inch =
    (let
     in  ( ))
sem_LengthScale_Kilometer :: T_LengthScale
sem_LengthScale_Kilometer =
    (let
     in  ( ))
sem_LengthScale_Meter :: T_LengthScale
sem_LengthScale_Meter =
    (let
     in  ( ))
sem_LengthScale_Mile :: T_LengthScale
sem_LengthScale_Mile =
    (let
     in  ( ))
sem_LengthScale_Milimeter :: T_LengthScale
sem_LengthScale_Milimeter =
    (let
     in  ( ))
sem_LengthScale_Yard :: T_LengthScale
sem_LengthScale_Yard =
    (let
     in  ( ))
-- MassScale ---------------------------------------------------
-- cata
sem_MassScale :: MassScale ->
                 T_MassScale
sem_MassScale (Gram) =
    (sem_MassScale_Gram)
sem_MassScale (Kilogram) =
    (sem_MassScale_Kilogram)
sem_MassScale (Ounce) =
    (sem_MassScale_Ounce)
sem_MassScale (Tonne) =
    (sem_MassScale_Tonne)
-- semantic domain
type T_MassScale = ( )
data Inh_MassScale = Inh_MassScale {}
data Syn_MassScale = Syn_MassScale {}
wrap_MassScale :: T_MassScale ->
                  Inh_MassScale ->
                  Syn_MassScale
wrap_MassScale sem (Inh_MassScale) =
    (let ( ) = sem
     in  (Syn_MassScale))
sem_MassScale_Gram :: T_MassScale
sem_MassScale_Gram =
    (let
     in  ( ))
sem_MassScale_Kilogram :: T_MassScale
sem_MassScale_Kilogram =
    (let
     in  ( ))
sem_MassScale_Ounce :: T_MassScale
sem_MassScale_Ounce =
    (let
     in  ( ))
sem_MassScale_Tonne :: T_MassScale
sem_MassScale_Tonne =
    (let
     in  ( ))
-- TemperatureScale --------------------------------------------
-- cata
sem_TemperatureScale :: TemperatureScale ->
                        T_TemperatureScale
sem_TemperatureScale (TemperatureVar) =
    (sem_TemperatureScale_TemperatureVar)
-- semantic domain
type T_TemperatureScale = ( )
data Inh_TemperatureScale = Inh_TemperatureScale {}
data Syn_TemperatureScale = Syn_TemperatureScale {}
wrap_TemperatureScale :: T_TemperatureScale ->
                         Inh_TemperatureScale ->
                         Syn_TemperatureScale
wrap_TemperatureScale sem (Inh_TemperatureScale) =
    (let ( ) = sem
     in  (Syn_TemperatureScale))
sem_TemperatureScale_TemperatureVar :: T_TemperatureScale
sem_TemperatureScale_TemperatureVar =
    (let
     in  ( ))
-- TimeScale ---------------------------------------------------
-- cata
sem_TimeScale :: TimeScale ->
                 T_TimeScale
sem_TimeScale (TimeVar) =
    (sem_TimeScale_TimeVar)
-- semantic domain
type T_TimeScale = ( )
data Inh_TimeScale = Inh_TimeScale {}
data Syn_TimeScale = Syn_TimeScale {}
wrap_TimeScale :: T_TimeScale ->
                  Inh_TimeScale ->
                  Syn_TimeScale
wrap_TimeScale sem (Inh_TimeScale) =
    (let ( ) = sem
     in  (Syn_TimeScale))
sem_TimeScale_TimeVar :: T_TimeScale
sem_TimeScale_TimeVar =
    (let
     in  ( ))
-- Tm ----------------------------------------------------------
-- cata
sem_Tm :: Tm ->
          T_Tm
sem_Tm (Tm _pos _t) =
    (sem_Tm_Tm _pos (sem_Tm_ _t))
-- semantic domain
type T_Tm = ( DimEnv ) ->
            Env ->
            TySubst ->
            ([String]) ->
            ( SourcePos ) ->
            ( ( Tm ),( Dimension ),( Constraints ),([String]),TySubst,Ty)
data Inh_Tm = Inh_Tm {dimenv_Inh_Tm :: ( DimEnv ),env_Inh_Tm :: Env,finalSubst_Inh_Tm :: TySubst,idents_Inh_Tm :: ([String]),position_Inh_Tm :: ( SourcePos )}
data Syn_Tm = Syn_Tm {actualterm_Syn_Tm :: ( Tm ),constraint_Syn_Tm :: ( Dimension ),constraints_Syn_Tm :: ( Constraints ),idents_Syn_Tm :: ([String]),subst_Syn_Tm :: TySubst,ty_Syn_Tm :: Ty}
wrap_Tm :: T_Tm ->
           Inh_Tm ->
           Syn_Tm
wrap_Tm sem (Inh_Tm _lhsIdimenv _lhsIenv _lhsIfinalSubst _lhsIidents _lhsIposition) =
    (let ( _lhsOactualterm,_lhsOconstraint,_lhsOconstraints,_lhsOidents,_lhsOsubst,_lhsOty) = sem _lhsIdimenv _lhsIenv _lhsIfinalSubst _lhsIidents _lhsIposition
     in  (Syn_Tm _lhsOactualterm _lhsOconstraint _lhsOconstraints _lhsOidents _lhsOsubst _lhsOty))
sem_Tm_Tm :: SourcePos ->
             T_Tm_ ->
             T_Tm
sem_Tm_Tm pos_ t_ =
    (\ _lhsIdimenv
       _lhsIenv
       _lhsIfinalSubst
       _lhsIidents
       _lhsIposition ->
         (let _tOposition :: ( SourcePos )
              _lhsOactualterm :: ( Tm )
              _lhsOconstraint :: ( Dimension )
              _lhsOconstraints :: ( Constraints )
              _lhsOidents :: ([String])
              _lhsOsubst :: TySubst
              _lhsOty :: Ty
              _tOdimenv :: ( DimEnv )
              _tOenv :: Env
              _tOfinalSubst :: TySubst
              _tOidents :: ([String])
              _tIactualterm :: ( Tm )
              _tIconstraint :: ( Dimension )
              _tIconstraints :: ( Constraints )
              _tIidents :: ([String])
              _tIsubst :: TySubst
              _tIty :: Ty
              _tOposition =
                  ({-# LINE 46 ".\\DimensionTyping.ag" #-}
                   pos_
                   {-# LINE 493 "HMTyping.hs" #-}
                   )
              _lhsOactualterm =
                  ({-# LINE 75 ".\\DimensionTyping.ag" #-}
                   _tIactualterm
                   {-# LINE 498 "HMTyping.hs" #-}
                   )
              _lhsOconstraint =
                  ({-# LINE 49 ".\\DimensionTyping.ag" #-}
                   _tIconstraint
                   {-# LINE 503 "HMTyping.hs" #-}
                   )
              _lhsOconstraints =
                  ({-# LINE 40 ".\\DimensionTyping.ag" #-}
                   _tIconstraints
                   {-# LINE 508 "HMTyping.hs" #-}
                   )
              _lhsOidents =
                  ({-# LINE 37 "HMTyping.ag" #-}
                   _tIidents
                   {-# LINE 513 "HMTyping.hs" #-}
                   )
              _lhsOsubst =
                  ({-# LINE 143 "HMTyping.ag" #-}
                   _tIsubst
                   {-# LINE 518 "HMTyping.hs" #-}
                   )
              _lhsOty =
                  ({-# LINE 141 "HMTyping.ag" #-}
                   _tIty
                   {-# LINE 523 "HMTyping.hs" #-}
                   )
              _tOdimenv =
                  ({-# LINE 43 ".\\DimensionTyping.ag" #-}
                   _lhsIdimenv
                   {-# LINE 528 "HMTyping.hs" #-}
                   )
              _tOenv =
                  ({-# LINE 96 "HMTyping.ag" #-}
                   _lhsIenv
                   {-# LINE 533 "HMTyping.hs" #-}
                   )
              _tOfinalSubst =
                  ({-# LINE 142 "HMTyping.ag" #-}
                   _lhsIfinalSubst
                   {-# LINE 538 "HMTyping.hs" #-}
                   )
              _tOidents =
                  ({-# LINE 38 "HMTyping.ag" #-}
                   _lhsIidents
                   {-# LINE 543 "HMTyping.hs" #-}
                   )
              ( _tIactualterm,_tIconstraint,_tIconstraints,_tIidents,_tIsubst,_tIty) =
                  t_ _tOdimenv _tOenv _tOfinalSubst _tOidents _tOposition
          in  ( _lhsOactualterm,_lhsOconstraint,_lhsOconstraints,_lhsOidents,_lhsOsubst,_lhsOty)))
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
type T_Tm_ = ( DimEnv ) ->
             Env ->
             TySubst ->
             ([String]) ->
             ( SourcePos ) ->
             ( ( Tm ),( Dimension ),( Constraints ),([String]),TySubst,Ty)
data Inh_Tm_ = Inh_Tm_ {dimenv_Inh_Tm_ :: ( DimEnv ),env_Inh_Tm_ :: Env,finalSubst_Inh_Tm_ :: TySubst,idents_Inh_Tm_ :: ([String]),position_Inh_Tm_ :: ( SourcePos )}
data Syn_Tm_ = Syn_Tm_ {actualterm_Syn_Tm_ :: ( Tm ),constraint_Syn_Tm_ :: ( Dimension ),constraints_Syn_Tm_ :: ( Constraints ),idents_Syn_Tm_ :: ([String]),subst_Syn_Tm_ :: TySubst,ty_Syn_Tm_ :: Ty}
wrap_Tm_ :: T_Tm_ ->
            Inh_Tm_ ->
            Syn_Tm_
wrap_Tm_ sem (Inh_Tm_ _lhsIdimenv _lhsIenv _lhsIfinalSubst _lhsIidents _lhsIposition) =
    (let ( _lhsOactualterm,_lhsOconstraint,_lhsOconstraints,_lhsOidents,_lhsOsubst,_lhsOty) = sem _lhsIdimenv _lhsIenv _lhsIfinalSubst _lhsIidents _lhsIposition
     in  (Syn_Tm_ _lhsOactualterm _lhsOconstraint _lhsOconstraints _lhsOidents _lhsOsubst _lhsOty))
sem_Tm__App :: T_Tm ->
               T_Tm ->
               T_Tm_
sem_Tm__App t1_ t2_ =
    (\ _lhsIdimenv
       _lhsIenv
       _lhsIfinalSubst
       _lhsIidents
       _lhsIposition ->
         (let _t1Oidents :: ([String])
              _t2Oidents :: ([String])
              _lhsOidents :: ([String])
              _t1Oenv :: Env
              _t2Oenv :: Env
              _lhsOty :: Ty
              _lhsOsubst :: TySubst
              _lhsOconstraints :: ( Constraints )
              _lhsOconstraint :: ( Dimension )
              _lhsOactualterm :: ( Tm )
              _t1Odimenv :: ( DimEnv )
              _t1OfinalSubst :: TySubst
              _t1Oposition :: ( SourcePos )
              _t2Odimenv :: ( DimEnv )
              _t2OfinalSubst :: TySubst
              _t2Oposition :: ( SourcePos )
              _t1Iactualterm :: ( Tm )
              _t1Iconstraint :: ( Dimension )
              _t1Iconstraints :: ( Constraints )
              _t1Iidents :: ([String])
              _t1Isubst :: TySubst
              _t1Ity :: Ty
              _t2Iactualterm :: ( Tm )
              _t2Iconstraint :: ( Dimension )
              _t2Iconstraints :: ( Constraints )
              _t2Iidents :: ([String])
              _t2Isubst :: TySubst
              _t2Ity :: Ty
              _freshident =
                  ({-# LINE 49 "HMTyping.ag" #-}
                   head _lhsIidents
                   {-# LINE 615 "HMTyping.hs" #-}
                   )
              _t1Oidents =
                  ({-# LINE 50 "HMTyping.ag" #-}
                   drop (2 + _paramcount    ) _lhsIidents
                   {-# LINE 620 "HMTyping.hs" #-}
                   )
              _t2Oidents =
                  ({-# LINE 51 "HMTyping.ag" #-}
                   _t1Iidents
                   {-# LINE 625 "HMTyping.hs" #-}
                   )
              _lhsOidents =
                  ({-# LINE 52 "HMTyping.ag" #-}
                   _t2Iidents
                   {-# LINE 630 "HMTyping.hs" #-}
                   )
              _freshfuncident =
                  ({-# LINE 54 "HMTyping.ag" #-}
                   head $ drop 1 _lhsIidents
                   {-# LINE 635 "HMTyping.hs" #-}
                   )
              _paramcount =
                  ({-# LINE 55 "HMTyping.ag" #-}
                   countPoly _t2Iconstraint
                   {-# LINE 640 "HMTyping.hs" #-}
                   )
              _freshparamidents =
                  ({-# LINE 56 "HMTyping.ag" #-}
                   take _paramcount     $ drop 2 _lhsIidents
                   {-# LINE 645 "HMTyping.hs" #-}
                   )
              _t1Oenv =
                  ({-# LINE 99 "HMTyping.ag" #-}
                   _lhsIenv
                   {-# LINE 650 "HMTyping.hs" #-}
                   )
              _t2Oenv =
                  ({-# LINE 100 "HMTyping.ag" #-}
                   map (\(x,y) -> (x,_t1Isubst y)) _lhsIenv
                   {-# LINE 655 "HMTyping.hs" #-}
                   )
              _fresh =
                  ({-# LINE 150 "HMTyping.ag" #-}
                   TypeVar _freshident
                   {-# LINE 660 "HMTyping.hs" #-}
                   )
              _sub3 =
                  ({-# LINE 151 "HMTyping.ag" #-}
                   unify (_t2Isubst _t1Ity) (Arrow _t2Ity _fresh    )
                   {-# LINE 665 "HMTyping.hs" #-}
                   )
              _lhsOty =
                  ({-# LINE 152 "HMTyping.ag" #-}
                   _sub3     _fresh
                   {-# LINE 670 "HMTyping.hs" #-}
                   )
              _lhsOsubst =
                  ({-# LINE 153 "HMTyping.ag" #-}
                   _sub3     . _t2Isubst . _t1Isubst
                   {-# LINE 675 "HMTyping.hs" #-}
                   )
              _lhsOconstraints =
                  ({-# LINE 55 ".\\DimensionTyping.ag" #-}
                   ((fetchFirstConstraint _nonpolyt1constraint    ,_nonpolyt2constraint    ), _lhsIposition, _t    )        : (_t1Iconstraints ++ _t2Iconstraints)
                   {-# LINE 680 "HMTyping.hs" #-}
                   )
              _lhsOconstraint =
                  ({-# LINE 56 ".\\DimensionTyping.ag" #-}
                   fetchSecondConstraint _nonpolyt1constraint
                   {-# LINE 685 "HMTyping.hs" #-}
                   )
              _t =
                  ({-# LINE 57 ".\\DimensionTyping.ag" #-}
                   Tm (_lhsIposition) (App _t1Iactualterm _t2Iactualterm)
                   {-# LINE 690 "HMTyping.hs" #-}
                   )
              _nonpolyt1constraint =
                  ({-# LINE 58 ".\\DimensionTyping.ag" #-}
                   substitutePoly _t1Iconstraint [(show $fetchFirstConstraint _t1Iconstraint,_freshfuncident    )]
                   {-# LINE 695 "HMTyping.hs" #-}
                   )
              _nonpolyt2constraint =
                  ({-# LINE 59 ".\\DimensionTyping.ag" #-}
                   substitutePoly _t2Iconstraint _substitutions
                   {-# LINE 700 "HMTyping.hs" #-}
                   )
              _substitutions =
                  ({-# LINE 60 ".\\DimensionTyping.ag" #-}
                   zip (getPoly _t2Iconstraint) (_freshparamidents    )
                   {-# LINE 705 "HMTyping.hs" #-}
                   )
              _lhsOactualterm =
                  ({-# LINE 78 ".\\DimensionTyping.ag" #-}
                   Tm (_lhsIposition) (App _t1Iactualterm _t2Iactualterm)
                   {-# LINE 710 "HMTyping.hs" #-}
                   )
              _t1Odimenv =
                  ({-# LINE 43 ".\\DimensionTyping.ag" #-}
                   _lhsIdimenv
                   {-# LINE 715 "HMTyping.hs" #-}
                   )
              _t1OfinalSubst =
                  ({-# LINE 142 "HMTyping.ag" #-}
                   _lhsIfinalSubst
                   {-# LINE 720 "HMTyping.hs" #-}
                   )
              _t1Oposition =
                  ({-# LINE 44 ".\\DimensionTyping.ag" #-}
                   _lhsIposition
                   {-# LINE 725 "HMTyping.hs" #-}
                   )
              _t2Odimenv =
                  ({-# LINE 43 ".\\DimensionTyping.ag" #-}
                   _lhsIdimenv
                   {-# LINE 730 "HMTyping.hs" #-}
                   )
              _t2OfinalSubst =
                  ({-# LINE 142 "HMTyping.ag" #-}
                   _lhsIfinalSubst
                   {-# LINE 735 "HMTyping.hs" #-}
                   )
              _t2Oposition =
                  ({-# LINE 44 ".\\DimensionTyping.ag" #-}
                   _lhsIposition
                   {-# LINE 740 "HMTyping.hs" #-}
                   )
              ( _t1Iactualterm,_t1Iconstraint,_t1Iconstraints,_t1Iidents,_t1Isubst,_t1Ity) =
                  t1_ _t1Odimenv _t1Oenv _t1OfinalSubst _t1Oidents _t1Oposition
              ( _t2Iactualterm,_t2Iconstraint,_t2Iconstraints,_t2Iidents,_t2Isubst,_t2Ity) =
                  t2_ _t2Odimenv _t2Oenv _t2OfinalSubst _t2Oidents _t2Oposition
          in  ( _lhsOactualterm,_lhsOconstraint,_lhsOconstraints,_lhsOidents,_lhsOsubst,_lhsOty)))
sem_Tm__Lam :: VarType ->
               T_Tm ->
               T_Tm_
sem_Tm__Lam x_ t1_ =
    (\ _lhsIdimenv
       _lhsIenv
       _lhsIfinalSubst
       _lhsIidents
       _lhsIposition ->
         (let _t1Oidents :: ([String])
              _lhsOidents :: ([String])
              _t1Oenv :: Env
              _lhsOty :: Ty
              _lhsOsubst :: TySubst
              _t1Odimenv :: ( DimEnv )
              _lhsOconstraints :: ( Constraints )
              _lhsOconstraint :: ( Dimension )
              _lhsOactualterm :: ( Tm )
              _t1OfinalSubst :: TySubst
              _t1Oposition :: ( SourcePos )
              _t1Iactualterm :: ( Tm )
              _t1Iconstraint :: ( Dimension )
              _t1Iconstraints :: ( Constraints )
              _t1Iidents :: ([String])
              _t1Isubst :: TySubst
              _t1Ity :: Ty
              _freshident =
                  ({-# LINE 45 "HMTyping.ag" #-}
                   head _lhsIidents
                   {-# LINE 776 "HMTyping.hs" #-}
                   )
              _t1Oidents =
                  ({-# LINE 46 "HMTyping.ag" #-}
                   drop 1 _lhsIidents
                   {-# LINE 781 "HMTyping.hs" #-}
                   )
              _lhsOidents =
                  ({-# LINE 47 "HMTyping.ag" #-}
                   _t1Iidents
                   {-# LINE 786 "HMTyping.hs" #-}
                   )
              _t1Oenv =
                  ({-# LINE 98 "HMTyping.ag" #-}
                   (x_,TypeVar _freshident    ):(_lhsIenv)
                   {-# LINE 791 "HMTyping.hs" #-}
                   )
              _typar =
                  ({-# LINE 147 "HMTyping.ag" #-}
                   _t1Isubst (TypeVar _freshident    )
                   {-# LINE 796 "HMTyping.hs" #-}
                   )
              _lhsOty =
                  ({-# LINE 148 "HMTyping.ag" #-}
                   Arrow _typar     _t1Ity
                   {-# LINE 801 "HMTyping.hs" #-}
                   )
              _lhsOsubst =
                  ({-# LINE 149 "HMTyping.ag" #-}
                   _t1Isubst
                   {-# LINE 806 "HMTyping.hs" #-}
                   )
              _t1Odimenv =
                  ({-# LINE 62 ".\\DimensionTyping.ag" #-}
                   M.insert x_ (DimVar _freshident    ) _lhsIdimenv
                   {-# LINE 811 "HMTyping.hs" #-}
                   )
              _lhsOconstraints =
                  ({-# LINE 63 ".\\DimensionTyping.ag" #-}
                   _t1Iconstraints
                   {-# LINE 816 "HMTyping.hs" #-}
                   )
              _lhsOconstraint =
                  ({-# LINE 64 ".\\DimensionTyping.ag" #-}
                   DimArrow (DimVar _freshident    ) _t1Iconstraint
                   {-# LINE 821 "HMTyping.hs" #-}
                   )
              _lhsOactualterm =
                  ({-# LINE 79 ".\\DimensionTyping.ag" #-}
                   Tm (_lhsIposition) (Lam x_ _t1Iactualterm)
                   {-# LINE 826 "HMTyping.hs" #-}
                   )
              _t1OfinalSubst =
                  ({-# LINE 142 "HMTyping.ag" #-}
                   _lhsIfinalSubst
                   {-# LINE 831 "HMTyping.hs" #-}
                   )
              _t1Oposition =
                  ({-# LINE 44 ".\\DimensionTyping.ag" #-}
                   _lhsIposition
                   {-# LINE 836 "HMTyping.hs" #-}
                   )
              ( _t1Iactualterm,_t1Iconstraint,_t1Iconstraints,_t1Iidents,_t1Isubst,_t1Ity) =
                  t1_ _t1Odimenv _t1Oenv _t1OfinalSubst _t1Oidents _t1Oposition
          in  ( _lhsOactualterm,_lhsOconstraint,_lhsOconstraints,_lhsOidents,_lhsOsubst,_lhsOty)))
sem_Tm__Let :: VarType ->
               T_Tm ->
               T_Tm ->
               T_Tm_
sem_Tm__Let x_ t1_ t2_ =
    (\ _lhsIdimenv
       _lhsIenv
       _lhsIfinalSubst
       _lhsIidents
       _lhsIposition ->
         (let _t1Oidents :: ([String])
              _t2Oidents :: ([String])
              _lhsOidents :: ([String])
              _t1Oenv :: Env
              _t2Oenv :: Env
              _lhsOty :: Ty
              _lhsOsubst :: TySubst
              _t2Odimenv :: ( DimEnv )
              _lhsOconstraint :: ( Dimension )
              _lhsOconstraints :: ( Constraints )
              _lhsOactualterm :: ( Tm )
              _t1Odimenv :: ( DimEnv )
              _t1OfinalSubst :: TySubst
              _t1Oposition :: ( SourcePos )
              _t2OfinalSubst :: TySubst
              _t2Oposition :: ( SourcePos )
              _t1Iactualterm :: ( Tm )
              _t1Iconstraint :: ( Dimension )
              _t1Iconstraints :: ( Constraints )
              _t1Iidents :: ([String])
              _t1Isubst :: TySubst
              _t1Ity :: Ty
              _t2Iactualterm :: ( Tm )
              _t2Iconstraint :: ( Dimension )
              _t2Iconstraints :: ( Constraints )
              _t2Iidents :: ([String])
              _t2Isubst :: TySubst
              _t2Ity :: Ty
              _t1Oidents =
                  ({-# LINE 58 "HMTyping.ag" #-}
                   _lhsIidents
                   {-# LINE 882 "HMTyping.hs" #-}
                   )
              _t2Oidents =
                  ({-# LINE 59 "HMTyping.ag" #-}
                   _t1Iidents
                   {-# LINE 887 "HMTyping.hs" #-}
                   )
              _lhsOidents =
                  ({-# LINE 60 "HMTyping.ag" #-}
                   _t2Iidents
                   {-# LINE 892 "HMTyping.hs" #-}
                   )
              _t1Oenv =
                  ({-# LINE 101 "HMTyping.ag" #-}
                   _lhsIenv
                   {-# LINE 897 "HMTyping.hs" #-}
                   )
              _envT2 =
                  ({-# LINE 102 "HMTyping.ag" #-}
                   map (\(x,y) -> (x,_t1Isubst y)) _lhsIenv
                   {-# LINE 902 "HMTyping.hs" #-}
                   )
              _genT2 =
                  ({-# LINE 103 "HMTyping.ag" #-}
                   gen _envT2     _t1Ity
                   {-# LINE 907 "HMTyping.hs" #-}
                   )
              _t2Oenv =
                  ({-# LINE 104 "HMTyping.ag" #-}
                   (x_,_genT2    ):(_envT2    )
                   {-# LINE 912 "HMTyping.hs" #-}
                   )
              _lhsOty =
                  ({-# LINE 154 "HMTyping.ag" #-}
                   _t2Ity
                   {-# LINE 917 "HMTyping.hs" #-}
                   )
              _lhsOsubst =
                  ({-# LINE 155 "HMTyping.ag" #-}
                   _t2Isubst . _t1Isubst
                   {-# LINE 922 "HMTyping.hs" #-}
                   )
              _t2Odimenv =
                  ({-# LINE 66 ".\\DimensionTyping.ag" #-}
                   M.insert x_ (_t1Iconstraint) _lhsIdimenv
                   {-# LINE 927 "HMTyping.hs" #-}
                   )
              _lhsOconstraint =
                  ({-# LINE 67 ".\\DimensionTyping.ag" #-}
                   _t2Iconstraint
                   {-# LINE 932 "HMTyping.hs" #-}
                   )
              _constraintfromenv =
                  ({-# LINE 68 ".\\DimensionTyping.ag" #-}
                   getFromEnv x_ _lhsIdimenv
                   {-# LINE 937 "HMTyping.hs" #-}
                   )
              _constraintequality =
                  ({-# LINE 69 ".\\DimensionTyping.ag" #-}
                   if isDimPoly _constraintfromenv     then [] else [((_constraintfromenv    , _t1Iconstraint), _lhsIposition, _t    )]
                   {-# LINE 942 "HMTyping.hs" #-}
                   )
              _lhsOconstraints =
                  ({-# LINE 70 ".\\DimensionTyping.ag" #-}
                   _constraintequality     ++ _t1Iconstraints ++ _t2Iconstraints
                   {-# LINE 947 "HMTyping.hs" #-}
                   )
              _t =
                  ({-# LINE 71 ".\\DimensionTyping.ag" #-}
                   Tm (_lhsIposition) (Let x_ _t1Iactualterm _t2Iactualterm)
                   {-# LINE 952 "HMTyping.hs" #-}
                   )
              _lhsOactualterm =
                  ({-# LINE 80 ".\\DimensionTyping.ag" #-}
                   Tm (_lhsIposition) (Let x_ _t1Iactualterm _t2Iactualterm)
                   {-# LINE 957 "HMTyping.hs" #-}
                   )
              _t1Odimenv =
                  ({-# LINE 43 ".\\DimensionTyping.ag" #-}
                   _lhsIdimenv
                   {-# LINE 962 "HMTyping.hs" #-}
                   )
              _t1OfinalSubst =
                  ({-# LINE 142 "HMTyping.ag" #-}
                   _lhsIfinalSubst
                   {-# LINE 967 "HMTyping.hs" #-}
                   )
              _t1Oposition =
                  ({-# LINE 44 ".\\DimensionTyping.ag" #-}
                   _lhsIposition
                   {-# LINE 972 "HMTyping.hs" #-}
                   )
              _t2OfinalSubst =
                  ({-# LINE 142 "HMTyping.ag" #-}
                   _lhsIfinalSubst
                   {-# LINE 977 "HMTyping.hs" #-}
                   )
              _t2Oposition =
                  ({-# LINE 44 ".\\DimensionTyping.ag" #-}
                   _lhsIposition
                   {-# LINE 982 "HMTyping.hs" #-}
                   )
              ( _t1Iactualterm,_t1Iconstraint,_t1Iconstraints,_t1Iidents,_t1Isubst,_t1Ity) =
                  t1_ _t1Odimenv _t1Oenv _t1OfinalSubst _t1Oidents _t1Oposition
              ( _t2Iactualterm,_t2Iconstraint,_t2Iconstraints,_t2Iidents,_t2Isubst,_t2Ity) =
                  t2_ _t2Odimenv _t2Oenv _t2OfinalSubst _t2Oidents _t2Oposition
          in  ( _lhsOactualterm,_lhsOconstraint,_lhsOconstraints,_lhsOidents,_lhsOsubst,_lhsOty)))
sem_Tm__Var :: VarType ->
               T_Tm_
sem_Tm__Var x_ =
    (\ _lhsIdimenv
       _lhsIenv
       _lhsIfinalSubst
       _lhsIidents
       _lhsIposition ->
         (let _lhsOidents :: ([String])
              _lhsOsubst :: TySubst
              _lhsOconstraint :: ( Dimension )
              _lhsOconstraints :: ( Constraints )
              _lhsOactualterm :: ( Tm )
              _lhsOty :: Ty
              _amount =
                  ({-# LINE 42 "HMTyping.ag" #-}
                   freshVarsNeeded _lhsIenv x_
                   {-# LINE 1006 "HMTyping.hs" #-}
                   )
              _freshidents =
                  ({-# LINE 43 "HMTyping.ag" #-}
                   take _amount     _lhsIidents
                   {-# LINE 1011 "HMTyping.hs" #-}
                   )
              _lhsOidents =
                  ({-# LINE 44 "HMTyping.ag" #-}
                   drop _amount     _lhsIidents
                   {-# LINE 1016 "HMTyping.hs" #-}
                   )
              _ty =
                  ({-# LINE 145 "HMTyping.ag" #-}
                   maybe (TypeVar $ head _freshidents    ) (inst _freshidents    ) (lookup x_ _lhsIenv)
                   {-# LINE 1021 "HMTyping.hs" #-}
                   )
              _lhsOsubst =
                  ({-# LINE 146 "HMTyping.ag" #-}
                   id
                   {-# LINE 1026 "HMTyping.hs" #-}
                   )
              _constraint =
                  ({-# LINE 51 ".\\DimensionTyping.ag" #-}
                   maybe (DimVar $ head _freshidents    ) id (M.lookup x_ _lhsIdimenv)
                   {-# LINE 1031 "HMTyping.hs" #-}
                   )
              _lhsOconstraint =
                  ({-# LINE 52 ".\\DimensionTyping.ag" #-}
                   _constraint
                   {-# LINE 1036 "HMTyping.hs" #-}
                   )
              _lhsOconstraints =
                  ({-# LINE 53 ".\\DimensionTyping.ag" #-}
                   []
                   {-# LINE 1041 "HMTyping.hs" #-}
                   )
              _lhsOactualterm =
                  ({-# LINE 77 ".\\DimensionTyping.ag" #-}
                   Tm (_lhsIposition) (Var x_)
                   {-# LINE 1046 "HMTyping.hs" #-}
                   )
              _lhsOty =
                  ({-# LINE 141 "HMTyping.ag" #-}
                   _ty
                   {-# LINE 1051 "HMTyping.hs" #-}
                   )
          in  ( _lhsOactualterm,_lhsOconstraint,_lhsOconstraints,_lhsOidents,_lhsOsubst,_lhsOty)))
-- Ty ----------------------------------------------------------
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