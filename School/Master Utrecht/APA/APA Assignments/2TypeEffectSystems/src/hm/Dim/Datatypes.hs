{-# LANGUAGE FlexibleInstances, OverlappingInstances #-}

module Dim.Datatypes(
  Dimension (DimArrow,DimBase,DimVar,DimPoly,DimInverse,DimMult),
  Base (Mass, Length, Time, ElectricCharge, AbsoluteTemperature),
  MassScale (Gram, Kilogram, Tonne, Ounce),
  LengthScale (Milimeter, Centimeter, Meter, Kilometer, Inch, Foot, Yard, Mile),
  TimeScale (TimeVar),
  ElectricScale (ElectricVar),
  TemperatureScale (TemperatureVar)
) where

import Dim.DimData
import CCO.Tree                   (Tree (fromTree, toTree))
import qualified CCO.Tree as T    (ATerm (App))
import CCO.Tree.Parser            (parseTree, app, arg)
import Control.Applicative        (Applicative ((<*>)), (<$>), pure)
import CCO.HM.AG
import CCO.SourcePos

instance Tree Dimension where
  fromTree (DimArrow a1 a2) = T.App "DimArrow" [fromTree a1, fromTree a2]
  fromTree (DimBase b)      = T.App "DimBase"  [fromTree b]
  fromTree (DimVar v)       = T.App "DimVar"   [fromTree v]
  fromTree (DimPoly v)      = T.App "DimPoly"   [fromTree v]
  fromTree (DimInverse a)   = T.App "DimInverse" [fromTree a]
  fromTree (DimMult a1 a2)  = T.App "DimMult" [fromTree a1, fromTree a2]
  
  toTree = parseTree [app "DimArrow" (DimArrow <$> arg <*> arg),
                      app "DimBase" (DimBase <$> arg),
                      app "DimVar" (DimVar <$> arg),
                      app "DimPoly" (DimPoly <$> arg),
                      app "DimInverse" (DimInverse <$> arg),
                      app "DimMult" (DimMult <$> arg <*> arg)]

  
instance Tree Base where
  fromTree (Mass s) = T.App "Mass" [fromTree s]
  fromTree (Length s) = T.App "Length" [fromTree s]
  fromTree (Time s) = T.App "Time" [fromTree s]
  fromTree (ElectricCharge s) = T.App "ElectricCharge" [fromTree s]
  fromTree (AbsoluteTemperature s) = T.App "AbsoluteTemperature" [fromTree s]
  toTree = parseTree [app "Mass" (Mass <$> arg),
                      app "Length" (Length <$> arg),
					  app "Time" (Time <$> arg),
					  app "ElectricCharge" (ElectricCharge <$> arg),
					  app "AbsoluteTemperatures" (AbsoluteTemperature <$> arg)]
  
instance Tree MassScale where
  fromTree (Gram) = T.App "Gram" []
  fromTree (Kilogram) = T.App "Kilogram" []
  fromTree (Tonne) = T.App "Tonne" []
  fromTree (Ounce) = T.App "Ounce" []
  toTree = parseTree [app "Gram" (pure Gram),
                      app "Kilogram" (pure Kilogram),
                      app "Tonne" (pure Tonne),
                      app "Ounce" (pure Ounce)]

instance Tree LengthScale where
  fromTree (Milimeter) = T.App "Milimeter" []
  fromTree (Centimeter) = T.App "Centimeter" []
  fromTree (Meter) = T.App "Meter" []
  fromTree (Kilometer) = T.App "Kilometer" []
  fromTree (Inch) = T.App "Inch" []
  fromTree (Foot) = T.App "Foot" []
  fromTree (Yard) = T.App "Yard" []
  fromTree (Mile) = T.App "Mile" []
  toTree = parseTree [app "Milimeter" (pure Milimeter),
                      app "Centimeter" (pure Centimeter),
                      app "Meter" (pure Meter),
                      app "Kilometer" (pure Kilometer),
                      app "Inch" (pure Inch),
                      app "Foot" (pure Foot),
                      app "Yard" (pure Yard),
                      app "Mile" (pure Mile)]

instance Tree TimeScale where
  fromTree (TimeVar) = T.App "TimeVar" []
  toTree = parseTree [app "TimeVar" (pure TimeVar)]

instance Tree ElectricScale where
  fromTree (ElectricVar) = T.App "ElectricVar" []
  toTree = parseTree [app "ElectricVar" (pure ElectricVar)]

instance Tree TemperatureScale where
  fromTree (TemperatureVar) = T.App "TemperatureVar" []
  toTree = parseTree [app "TemperatureVar" (pure TemperatureVar)]
  
instance Show Dimension where
 show (DimArrow a b) = "("++(show a) ++ " -> "++(show b)++")"
 show (DimVar v) = v
 show (DimBase b) = show b
 show (DimPoly v) = v
 show (DimInverse a) = "(" ++ show a ++ ")^-1"
 show (DimMult a b) = show a ++ "*" ++ show b
 
instance Show Base where
  show (Mass s) = (show s)++"@Mass"
  show (Length s) = (show s)++"@Length"
  show (Time s) = (show s)++"@Time"
  show (ElectricCharge s) = (show s)++"@ElectricCharge"
  
instance Show Tm_ where
  show (Var x) = x
  show (Lam x t) = "(\\" ++ x ++ ". " ++ show t ++ ")"
  show (App f x) = "(" ++ show f ++ " " ++ show x ++ ")"
  show (Let x t1 t2) = "Let " ++ x ++ " := " ++ show t1 ++ " in " ++ show t2 ++ " ni"
  
instance Show Tm where
  show (Tm pos t) = show t
  
  