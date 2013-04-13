
module Domain.FP.ContractInferencing.SyntaxTransformations where

import Domain.FP.SyntaxWithRanges
import qualified Data.Generics.Uniplate as U

-- Transform lambdas of the form \x y z to \x -> \y -> \z
-- for easier contract inferencing.
expandLambdas :: ExprR -> ExprR
expandLambdas (LambdaR (x:xs) body range) = LambdaR [x] (expandLambdas $ LambdaR xs body range) range
expandLambdas (LambdaR [] body _ = body

transformLambdas = U.transform f
  where f (LambdaR x b r) = expandLambdas (LambdaR x b r)
        f x = x

-- Transform apps of the form f x y z to ((f x) y) z
-- for easier contract inferencing.
expandApps :: ExprR -> ExprR
expandApps (AppR f [x] r)    = AppR f [x] r
expandApps (AppR f (x:xs) r) = AppR (expandApps $ ParenR (AppR f (dropFromTail 1 (x:xs)) r) r) [(last xs)] r
expandApps (ParenR x r)      = ParenR (expandApps x) r

dropFromTail :: Int -> [a] -> [a]
dropFromTail n xs = 
 let l = zip xs [0..]
     cutoff = (length l) - n
     f (x,i) | i >= cutoff = []
             | i < cutoff = [x]
 in concatMap f l

transformApps = U.transform f
  where f (AppR f p r) = expandApps (AppR f p r)
        f x = x

-- Transform multiple let definitions into nested lets
-- for easier contract inferencing.
expandLets (LetR (x:xs) e r) = LetR [x] (expandLets $ LetR xs e r) r
expandLets (LetR [] e _) = e

transformLets = U.transform f
  where f (LetR dl e r) = expandLets (LetR dl e r)
        f x = x

--Simplifies function definitions into lambda definitions.
transformFunctions :: Domain.FP.Syntax.Decl -> Domain.FP.Syntax.Decl
transformFunctions (DFunBinds decls) = 
 let allPats = collectPatterns decls
     collectPatterns = map (\(FunBind _ _ ps _) -> ps)
     collectRhs = map (\(FunBind _ _ _ rhs) -> rhs)
     allRhs = collectRhs decls
     differentPats = filter (\x -> length x == 1) allPats
     allVars = ["p" ++ show i | i <- [1..length (head allPats)]]
     allMatches = map (\x -> Var $ Ident x) allVars
     allPatVars = map (\x -> PVar $ Ident x) allVars
     funcIdentifier = PVar $ (\(FunBind _ f _ _) -> f) (head decls)
 in DPatBind funcIdentifier (Rhs (Paren $ Lambda allPatVars (constructCase allMatches (zip [1..] allPats) (zip [1..] allRhs))) [])

-- TODO: Preprocess patterns so they're all the same.
-- Currently, x and y are different patterns...
constructCase :: [Expr] -> [(Int,Pats)] -> [(Int,Rhs)] -> Expr
constructCase [m] pats rhs =  
 let alts = map (\(n,[p]) -> (n,p)) pats
     altExprs = map (\(n,pat) -> Alt Nothing pat (fromJust $ lookup n rhs)) alts 
 in Case m altExprs
constructCase (m:ms) pats rhs = 
 let alts = head $ map nub $ transpose (map snd pats)
     nextVals = groupBy (\(_,x) (_,y) -> head x == head y) pats
     valsByAlt = concatMap (map  ( \(n,(x:xs)) -> (x,(n,xs)) )) nextVals
     selectValsByAlt alt = map snd $ filter (\(x,_) -> x == alt) valsByAlt 
     --valsByAlt = concatMap (\(x:xs) -> zip x xs) $ map (map nub) (map transpose $ map snd nextVals)
     altExprs = map (\pat -> Alt Nothing pat (Rhs (constructCase ms (selectValsByAlt pat) rhs) [])) alts
 in Case m altExprs
