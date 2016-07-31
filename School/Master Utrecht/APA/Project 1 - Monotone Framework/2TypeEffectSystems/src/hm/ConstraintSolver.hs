module ConstraintSolver where

import Data.List (union,(\\),nub,delete,find,sort)
import CCO.HM.AG hiding (TyVarName,VarType,TyScheme)
import Dim.Datatypes
import qualified Data.Map as M
import Data.Maybe
import CCO.SourcePos
import HMTyping

type ErrorOrWarnings = Either Error Warnings
type Error = String
type Warnings = [String]

flattenArrows :: Constraints -> Constraints
flattenArrows ((c,pos,tm):r) = case c of
                                 (DimArrow x y,DimArrow a b) -> let xs = flattenArrows [((x,a),pos,tm)]
                                                                    ys = flattenArrows [((y,b),pos,tm)]
                                                                in (if((x,a) == (y,b)) then xs else xs ++ ys ) ++ flattenArrows r
                                 _ -> (c,pos,tm) : flattenArrows (r)
flattenArrows [] = []

solve :: Constraints -> ErrorOrWarnings
solve (x:xs) = solve' (flattenArrows (x:xs)) []
solve [] = Left "ERROR: Empty Constraint set, nothing to solve!"
 
solve' :: Constraints -> Warnings -> ErrorOrWarnings
solve' [] ws = Right ws
solve' [c] ws = valid c ws -- check if c is a valid constraint on its own.
solve' cs ws = case rewrite cs ws of
                   ((_), Left e) -> Left e -- return an error immediately
                   ((cs'), Right ws') -> solve' cs' ws' -- we need to go deeper.

-- Checking the last Constraint if it is a good conclusion of the solving.
valid :: AnnConstraint -> Warnings -> ErrorOrWarnings
valid (((DimVar v1), (DimVar v2)), pos, tm) w = Right w                    -- a == b
valid c@(((DimBase b1), (DimBase b2)), pos, tm) w = validBases b1 b2 c w -- base == base (only coercions allowed!)
valid (((DimVar v), (DimBase b)), pos, tm) w = Right (["Undefined variable " ++ (show v) ++ " with base " ++ (show b) ++ "\nAt Term: " ++ show tm ++ "\nAt Position: " ++ show pos ++ "\n"])  -- ok, for now
valid ((b@(DimBase _), v@(DimVar _)), pos, tm) w = valid ((v,b), pos, tm) w -- reroute; one above
valid c@(((DimMult _ _), (DimMult _ _)), pos, tm) w = validMult c w
valid (((DimInverse a), v@(DimInverse  b)), pos, tm) w = valid ((a,b), pos, tm) w
valid ((x,y), pos, tm) w = Left $ coerceError x y pos tm

-- Checking whether bases are coercable. 
validBases :: Base -> Base -> AnnConstraint -> Warnings -> ErrorOrWarnings
validBases (AbsoluteTemperature ts) (AbsoluteTemperature ts') (c,pos,tm) w = Right $ [coerceWarning (coerce ts ts') pos tm] ++ w
validBases (ElectricCharge es) (ElectricCharge es') (c,pos,tm)  w = Right $ [coerceWarning (coerce es es') pos tm] ++ w
validBases (Length ls) (Length ls') (c,pos,tm) w = Right $ [coerceWarning (coerce ls ls') pos tm] ++ w
validBases (Mass ms) (Mass ms') (c,pos,tm) w = Right $ [coerceWarning (coerce ms ms') pos tm] ++ w
validBases (Time ts) (Time ts') (c,pos,tm) w = Right $ [coerceWarning (coerce ts ts') pos tm] ++ w
validBases b1 b2 (c,pos,tm) w = Left $ coerceError b1 b2 pos tm

coerceWarning :: String -> SourcePos -> Tm -> String
coerceWarning (s:ss) pos tm = "\n" ++ (s:ss) ++ "\nAt Term: " ++ show tm ++ "\nAt Position: " ++ show pos ++ "\n"
coerceWarning [] _ _ = []

coerceError :: (Show a, Show b) => a -> b -> SourcePos -> Tm -> String
coerceError a b pos tm = "ERROR: Cannot coerce from "++(show a)++" to "++(show b)++" when doing dimensionality check.\nAt Term: " ++ show tm ++ "\nAt Position: " ++ show pos ++ "\n"

class Coerce a where
  coerce :: a -> a -> String
  
instance Coerce MassScale where
  coerce x y | x == y = emptyWarn
  coerce x y | x /= y = writeWarning x y
  
instance Coerce LengthScale where
  coerce x y | x == y = emptyWarn
  coerce x y | x /= y = writeWarning x y

instance Coerce TemperatureScale where
  coerce x y | x == y = emptyWarn
  coerce x y | x /= y = writeWarning x y

instance Coerce ElectricScale where
  coerce x y | x == y = emptyWarn
  coerce x y | x /= y = writeWarning x y

instance Coerce TimeScale where
  coerce x y | x == y = emptyWarn
  coerce x y | x /= y = writeWarning x y

writeWarning :: (Show a) => a -> a -> String
writeWarning x y = "Must use coercion between "++(show x)++" and "++(show y)++" for dimensionality check."

emptyWarn :: String
emptyWarn = [] -- All is well

-- Mult stuff
instance (Num a, Num b, Num c, Num d, Num e) => Num (a,b,c,d,e) where
  (+) (a,b,c,d,e) (a',b',c',d',e') = (a+a',b+b',c+c',d+d',e+e')
  (*) (a,b,c,d,e) (a',b',c',d',e') = (a*a',b*b',c*c',d*d',e*e')
  negate (a,b,c,d,e) = (-a,-b,-c,-d,-e) 
  signum x = error "signum not implemented"
  abs x = error "abs not implemented"
  fromInteger x = error "fromInteger not implemented"

type BaseCount = (Int,Int,Int,Int,Int)

getBasecount :: Dimension -> BaseCount
getBasecount (DimMult a b) = getBasecount a + getBasecount b
getBasecount (DimBase b) = getBasecount' b
getBasecount (DimVar v) = (0,0,0,0,0)
getBasecount (DimInverse (DimBase b)) = negate $ getBasecount' b

getBasecount' :: Base -> BaseCount
getBasecount' (Mass s) = (1,0,0,0,0)
getBasecount' (Length s) = (0,1,0,0,0)
getBasecount' (Time s) = (0,0,1,0,0)
getBasecount' (ElectricCharge s) = (0,0,0,1,0)
getBasecount' (AbsoluteTemperature s) = (0,0,0,0,1)
  
getBases :: Dimension -> [Base]
getBases (DimMult a b) = getBases a ++ getBases b
getBases (DimBase b) = [b]
getBases (DimVar v) = []
getBases (DimInverse a) = getBases a

onlyBases :: Dimension -> Bool
onlyBases (DimMult a b) = and [onlyBases a,onlyBases b]
onlyBases (DimBase b) = True
onlyBases (DimInverse a) = onlyBases a
onlyBases _ = False

validMult :: AnnConstraint -> Warnings -> ErrorOrWarnings
validMult t@((m1@(DimMult a b), m2@(DimMult c d)), pos, tm) ws = 
 let b1 = reduceDimension $ simplifyInverse m1
     b2 = reduceDimension $ simplifyInverse m2
     bc1 = getBasecount b1
     bc2 = getBasecount b2
     bs1 = sort $ getBases b1
     bs2 = sort $ getBases b2
     l   = zip bs1 bs2
 in if bc1 == bc2 
     then foldr foldCoerce (Right []) $ map doCoerce l
     else Left $ coerceError b1 b2 pos tm
  where
   doCoerce (a,b) = validBases a b t ws
   foldCoerce (Right x) (Right y) = Right (x++y)
   foldCoerce (Left x) _ = Left x
   foldCoerce _ (Left x) = Left x
validMult ((m1@(DimMult a b), m2), pos, tm) ws = Left $ coerceError m1 m2 pos tm
validMult ((b1@(DimBase a), m@(DimMult b c)), pos, tm) ws = let b2 = reduceDimension $ simplifyInverse m
                                                            in if (length $ getBases b2) == 1
                                                               then valid ((b1,b2),pos,tm) ws
                                                               else Left $ coerceError b1 b2 pos tm

containsDimMult :: AnnConstraint -> Bool
containsDimMult (((DimMult _ _), _), _, _) = True
containsDimMult ((_, (DimMult _ _)), _, _) = True
containsDimMult _ = False

simplifyInverse :: Dimension -> Dimension
simplifyInverse (DimInverse (DimMult a b)) = simplifyInverse (DimMult (DimInverse a) (DimInverse b))
simplifyInverse (DimInverse (DimBase x))   = DimInverse (DimBase x)
simplifyInverse (DimMult a b) = DimMult (simplifyInverse a) (simplifyInverse b)
simplifyInverse (DimBase x) = DimBase x
simplifyInverse (DimInverse (DimInverse x)) = simplifyInverse x
simplifyInverse x = x

simplifyConstraint :: AnnConstraint -> AnnConstraint
simplifyConstraint ((lhs,rhs),pos,tm) = ((reduceDimension $ simplifyInverse lhs,reduceDimension $ simplifyInverse rhs),pos,tm)

reduceDimension :: Dimension -> Dimension
reduceDimension dim = let dims = getDimensions dim
                      in reconstructMult dims $ reduceDimension' dims
 where
  reconstructMult :: [Dimension] -> [Dimension] -> Dimension
  reconstructMult w (x:xs) = foldr DimMult x xs
  reconstructMult w [] = error $ "Dimensionless constants currently unsupported.\n" ++ show w
  reduceDimension' :: [Dimension] -> [Dimension]
  reduceDimension' (x:xs) = case findInverse x xs of
                                       Just i  -> reduceDimension' (delete i xs) -- Remove both x and its inverse from the list
                                       Nothing -> x : reduceDimension' xs -- Keep x, keep searching in tail
  reduceDimension' [] = []
  findInverse :: Dimension -> [Dimension] -> Maybe Dimension
  findInverse (DimBase x) xs = find (== (DimInverse (DimBase x))) xs
  findInverse (DimInverse (DimBase x)) xs = find (== (DimBase x)) xs
  findInverse x _ = Nothing
  getDimensions :: Dimension -> [Dimension]
  getDimensions (DimMult a b) = getDimensions a ++ getDimensions b
  getDimensions (DimVar v) = [DimVar v]
  getDimensions (DimBase x) = [DimBase x]
  getDimensions (DimInverse x) = [DimInverse x]

-- Rewriting one constraint onto other constraints
-- again, all arrows are flattened.
rewrite :: Constraints -> Warnings -> (Constraints, ErrorOrWarnings) 
rewrite (c@(((DimBase b), (DimBase b')), pos, tm):xs) ws = let result = validBases b b' c ws
                                                           in (xs, result)
-- Swap around
rewrite (((t1@(DimVar v), t2@(DimBase b)), pos, tm):xs) ws = rewrite (((t2,t1),pos,tm):xs) ws
rewrite (((t1@(DimMult a b), t2@(DimVar v)), pos, tm):xs) ws = rewrite (((t2,t1),pos,tm):xs) ws
rewrite (((t1@(DimInverse v), t2@(DimVar v')), pos, tm):xs) ws = rewrite (((t2,t1),pos,tm):xs) ws
rewrite (((t1@(DimInverse v), t2@(DimBase v')), pos, tm):xs) ws = rewrite (((t2,t1),pos,tm):xs) ws
rewrite (((t1@(DimMult a c), t2@(DimBase b)), pos, tm):xs) ws = rewrite (((t2,t1),pos,tm):xs) ws
rewrite l@(t@(((DimMult a b), (DimMult c d)), pos, tm):xs) ws = let solvable = and $ map onlyBases [a,b,c,d]
                                                                in if solvable 
                                                                   then let result = validMult t ws
                                                                        in (xs, result)
                                                                   else let allMults = and $ map containsDimMult l 
                                                                        in if allMults
                                                                           then error $ "Cyclical DimMult, couldn't solve!\n" ++ show l
                                                                           else rewrite (xs ++ [simplifyConstraint t]) ws -- Push it downwards to solve later
-- Actual rewriting
rewrite ((((DimBase b), (DimVar v)), pos, tm):xs) ws  = rewrite (map (replaceVar v (DimBase b)) xs) ws
rewrite ((((DimVar v), (DimVar v')), pos, tm):xs) ws  = rewrite (map (replaceVar v (DimVar v')) xs) ws
rewrite ((((DimBase b), (DimInverse (DimVar v))), pos, tm):xs) ws  = rewrite (map (replaceVar v (DimInverse (DimBase b))) xs) ws
rewrite ((((DimVar v), (DimInverse v')), pos, tm):xs) ws  = rewrite (map (replaceVar v (DimInverse v')) xs) ws
rewrite ((((DimVar v), (DimMult a b)), pos, tm):xs) ws  = rewrite (map (replaceVar v (DimMult a b)) xs) ws
rewrite (t@(((DimMult a b), y), pos, tm):xs) ws = let result = validMult t ws
                                                  in (xs, result)
rewrite ((((DimInverse v), (DimInverse v')), pos, tm):xs) ws  = rewrite (((v,v'),pos,tm):xs) ws
rewrite l@(t@((t1@(DimBase b), t2@(DimMult a c)), pos, tm):xs) ws = let solvable = and $ map onlyBases [a,c]
                                                                     in if solvable 
                                                                         then let result = validMult t ws
                                                                              in (xs, result)
                                                                         else let allMults = and $ map containsDimMult l 
                                                                              in if allMults
                                                                                 then (xs,Left $ coerceError t1 t2 pos tm)
                                                                                 else rewrite (xs ++ [simplifyConstraint t]) ws -- Push it downwards to solve later
rewrite x ws = error $ show x -- (x,Right ws)

replaceVar :: String -> Dimension -> AnnConstraint -> AnnConstraint
replaceVar match replace ((t1, t2),s,t) = (((rt match replace t1), (rt match replace t2)),s,t)
 where rt m r o = case o of
              DimVar v -> if v==m then r else o
              DimMult a b -> DimMult (rt m r a) (rt m r b)
              DimInverse a -> DimInverse (rt m r a)
              _ -> o	
			  