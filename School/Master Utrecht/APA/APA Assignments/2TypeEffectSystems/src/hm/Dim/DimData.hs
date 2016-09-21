

-- UUAGC 0.9.40.2 (Dim/DimData.ag)
module Dim.DimData where

-- Base --------------------------------------------------------
data Base = AbsoluteTemperature (TemperatureScale)
          | Division (Base) (Base)
          | ElectricCharge (ElectricScale)
          | Length (LengthScale)
          | Mass (MassScale)
          | Product (Base) (Base)
          | Time (TimeScale)
          deriving ( Eq,Ord)
-- Dimension ---------------------------------------------------
data Dimension = DimArrow (Dimension) (Dimension)
               | DimBase (Base)
               | DimInverse (Dimension)
               | DimMult (Dimension) (Dimension)
               | DimPoly (String)
               | DimVar (String)
               deriving ( Eq,Ord)
-- ElectricScale -----------------------------------------------
data ElectricScale = ElectricVar
                   deriving ( Eq,Ord,Show)
-- LengthScale -------------------------------------------------
data LengthScale = Centimeter
                 | Foot
                 | Inch
                 | Kilometer
                 | Meter
                 | Mile
                 | Milimeter
                 | Yard
                 deriving ( Eq,Ord,Show)
-- MassScale ---------------------------------------------------
data MassScale = Gram
               | Kilogram
               | Ounce
               | Tonne
               deriving ( Eq,Ord,Show)
-- TemperatureScale --------------------------------------------
data TemperatureScale = TemperatureVar
                      deriving ( Eq,Ord,Show)
-- TimeScale ---------------------------------------------------
data TimeScale = TimeVar
               deriving ( Eq,Ord,Show)