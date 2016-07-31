module Problem where

import Data.MultiSet (MultiSet)
import qualified Data.MultiSet as MS

class Eq a => Problem a where
	initial :: a
	successors :: a -> [a]

data Position = Links | Rechts deriving (Eq, Show)
data Person = Father | Mother | Son | Daughter | Cop | Thief deriving (Eq, Ord, Show)
type Group = MultiSet Person
data River = River { links :: MultiSet Person, rechts :: MultiSet Person, schip :: Position } deriving (Eq)

instance Show River where
    show (River links rechts schip) = "R" --"\n" ++ "Links: " ++ show links ++ "\n" ++ "Rechts: " ++ show rechts ++ "\n" ++ "Positie: " ++ show schip ++ "\n"

config = MS.insert Thief( MS.insert Cop (MS.insertMany Daughter 2 ( MS.insertMany Son 2 ( (MS.insert Mother (MS.singleton Father) ) ) ) ) )
config2 = MS.insert Thief( MS.insert Cop (MS.insertMany Daughter 2 ( MS.insertMany Son 2 MS.empty ) ) )
	

instance Problem River where
    initial = River { links = config, rechts = MS.empty, schip = Links }
    successors x = [x]
	

-- data Trace a = Traced a [a]

-- instance (Problem a) => Problem (Trace a) where
	-- initial = desired
	-- successors x = [x]