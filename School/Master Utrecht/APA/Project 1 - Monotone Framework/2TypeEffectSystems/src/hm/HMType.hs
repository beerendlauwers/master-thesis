{-# LANGUAGE FlexibleInstances, OverlappingInstances, FlexibleContexts #-}
module HMType (
    -- * Converting
    hmtype
) where

import HMTyping
import qualified CCO.HM.AG as HM
import CCO.Feedback (Feedback,trace_)
import Data.List
import ConstraintSolver
import Dim.Datatypes
import qualified Data.Map as M
import CCO.SourcePos

dimEnv :: DimEnv
dimEnv = M.fromList [("x", (DimArrow (DimMult (DimBase $ Length $ Meter) (DimBase $ Length $ Meter)) (DimMult (DimBase $ Length $ Meter) (DimBase $ Length $ Meter)))),
                     ("y", (DimMult (DimBase $ Length $ Meter) (DimBase $ Length $ Meter))),
                     ("id", (DimArrow (DimPoly "P") (DimPoly "P"))),
                     ("m", (DimBase $ Length $ Meter)),
                     ("cm", (DimBase $ Length $ Centimeter)),
                     ("g", (DimBase $ Mass $ Gram)),
                     ("invert", DimArrow (DimPoly "P") (DimInverse (DimPoly "P"))),
                     ("lengthfunc", (DimArrow (DimMult (DimBase $ Length $ Foot) (DimBase $ Length $ Foot)) (DimMult (DimBase $ Length $ Foot) (DimBase $ Time $ TimeVar)))),
                     ("testfunc", (DimArrow (DimMult (DimBase $ Mass $ Kilogram) (DimMult (DimBase $ Length $ Foot) (DimBase $ Mass $ Gram))) (DimBase $ Time $ TimeVar))),
                     ("massfunc", DimArrow (DimBase $ Mass $ Kilogram) (DimBase $ Mass Kilogram)),
                     ("mult", DimArrow (DimPoly "P") (DimArrow (DimPoly "Q") (DimMult (DimPoly "P") (DimPoly "Q")))),
                     ("div", DimArrow (DimPoly "P") (DimArrow (DimPoly "Q") (DimMult (DimPoly "P") (DimInverse $ DimPoly "Q")))),
                     ("test", DimArrow (DimPoly "Q") (DimMult (DimPoly "P") (DimPoly "Q"))),
					 ("surface", DimArrow (DimBase $ Length $ Meter) (DimArrow (DimBase $ Length $ Meter) (DimMult (DimBase $ Length $ Meter) (DimBase $ Length $ Meter)))),
                     ("lengthgramfunc", (DimArrow (DimMult (DimBase $ Length $ Foot) (DimBase $ Mass $ Gram)) (DimBase $ Mass $ Gram))) ]

prettyPrintEnv :: DimEnv -> String
prettyPrintEnv m = foldr (\s1 s2 -> s1 ++ "\n" ++ s2) "" $ map (\(l,r) -> show l ++ " = " ++ show r) (M.toList m) 

ppConstraint :: AnnConstraint -> String
ppConstraint ((l,r),pos,tm) = "Inferred: " ++ show l ++ " = " ++ show r ++ "\nAt Term: " ++ show tm ++ "\nAt Position:" ++ show pos ++ "\n\n"

prettyPrintConstraints :: Constraints -> String
prettyPrintConstraints l = concat $ map ppConstraint l

prettyPrintErrorOrWarnings :: ErrorOrWarnings -> String
prettyPrintErrorOrWarnings (Left x) = x
prettyPrintErrorOrWarnings (Right xs) = concat xs

startingsrc :: SourcePos
startingsrc = SourcePos Stdin (Pos 0 0)

hmtype :: HM.Tm -> Feedback String --Feedback HM.Ty
hmtype t = do let syn = wrap_Tm (sem_Tm t) (Inh_Tm dimEnv [] (subst_Syn_Tm syn) identifiers startingsrc )
              let ty = (ty_Syn_Tm syn)
              let typeinfo = "Type: " ++ (show ty) ++ "\n"
              trace_ typeinfo
              let envinfo = "Given environment:\n" ++ (prettyPrintEnv dimEnv) ++ "\n"
              trace_ envinfo
              let constraintinfo = "Constraints:\n" ++ (prettyPrintConstraints $ normalizeConstraints $ constraints_Syn_Tm syn)
              trace_ constraintinfo
              let warningsanderrors = "Warnings and errors:\n" ++ (prettyPrintErrorOrWarnings $ solve $ constraints_Syn_Tm syn)
              trace_ warningsanderrors
              return ([])

normalizeConstraints :: Constraints -> Constraints 
normalizeConstraints (((t1@(DimBase _),t2@(DimVar _)),pos,tm):xs) = (((t2,t1),pos,tm):normalizeConstraints xs)
normalizeConstraints (x:xs) = (x:(normalizeConstraints xs))
normalizeConstraints [] = []