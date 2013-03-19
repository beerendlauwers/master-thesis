{-# Language TypeOperators, NoMonomorphismRestriction #-}

import Contract
import Data.List as DL


rectest2 = let efoldr = (\__rec_efoldr -> \f -> \b -> \xs -> case xs of
                                                             [] -> b
                                                             (y : ys) -> f y (( (\f -> \b -> \xs -> app (app (app __rec_efoldr 0 (fun (\a -> (fun (\b -> f a b))))) 1 b) 2 xs) ) f b ys))
           in let __ctrt_efoldr = (\ctrt -> assert "efoldr" ctrt (fun (\f -> fun (\b -> fun (\xs -> efoldr (__ctrt_efoldr ctrt) (\f1 -> \f2 -> app (app f 1 f1) 2 f2)  b xs)))))
              in __ctrt_efoldr ((true >-> ord >-> ord) >-> ord >-> true >-> ord) -- :: Ord bT => (aT :-> ([bT] :-> [bT])) :-> ([bT] :-> ([aT] :-> [bT]))


parameter_f :: (aT :-> (bT :-> bT)) -> aT -> bT -> bT
parameter_f f = (\f1 -> \f2 -> app (app f 1 f1) 2 f2) 

parameter_f_applied :: Ord aT => aT -> [aT] -> [aT]
parameter_f_applied = parameter_f insert'

{-
test_rec_efoldr = 
 let __rec_efoldr = \f -> \b -> \ys -> (( (\f1 -> \b1 -> \xs1 -> app (app (app __rec_efoldr 0 (fun (\a -> (fun (\b -> f1 a b))))) 1 b1) 2 xs1) ) f b ys)
 in __rec_efoldr
-}

foldr_contracted :: Contract ((aT :-> (bT :-> bT)) :-> (bT :-> ([aT] :-> bT))) -> (aT :-> (bT :-> bT)) :-> (bT :-> ([aT] :-> bT))
foldr_contracted = \ctrt -> assert "foldr" ctrt (fun (\f -> fun (\x -> fun (\xs -> DL.foldr (\ a -> \ b -> app (app f 0 a) 1 b) x xs))))

foldr_contracted_applied :: Ord bT => (aT :-> ([bT] :-> [bT])) :-> ([bT] :-> ([aT] :-> [bT]))
foldr_contracted_applied = foldr_contracted ((true >-> ord >-> ord) >-> ord >-> true >-> ord)
