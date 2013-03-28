
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
