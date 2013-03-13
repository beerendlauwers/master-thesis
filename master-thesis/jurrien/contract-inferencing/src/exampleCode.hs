{-# Language TypeOperators #-}  
import Contract
import qualified Data.List as DL

c11 = true
c18 = true
c13 = true
c71 = true
c58 = true
c54 = true
c22 = true

-- ORIGINAL
{-
test_wrong = 
 let __ctrt_insert = \ctrt -> \z -> \zs -> apply (assert "insert" ctrt) (app (app (fun (insert (__ctrt_insert ctrt))) z) zs)
 in True
-}

isSorted :: Ord a => [a] -> Bool
isSorted ys = isNondesc ys
  where  isNondesc (z:z':zs)  = z <= z' && isNondesc (z':zs)
         isNondesc _          = True

test_small =
 let __ctrt_insert = \ctrt -> \z -> \zs -> app (fun (assert "insert" ctrt)) 0 (app (fun insert) 1 z zs)
 in __ctrt_insert true 2 [1,3]

{-
test_small2 =
 let __ctrt_insert = \ctrt -> \z -> \zs -> app (fun (assert "insert" ctrt)) 0 (app (fun ((app (fun insert) 1 z))) zs )
 in __ctrt_insert true 2 [1,3]
-}

correct :: Ord a => Contract (a :-> ([a] :-> [a])) -> a -> [a] -> [a]
correct = \ctrt -> \z -> \zs -> app( app (apply (fun (assert "t" ctrt)) undefined (fun (\x -> fun (\y -> insert x y)))) 0 z) 1 zs

correct' :: Ord a => a -> [a] -> [a]
correct' = correct (true >-> (prop isSorted) >-> (prop isSorted))

{-
test = 
 let isort = \__rec_isort -> \us -> let insert = \__rec_insert -> \z -> \zs -> case zs of
                                                                                [] -> z : []
                                                                                (z' : zs') -> let rel = \__rec_rel -> z <= z'
                                                                                              in let __ctrt_rel = \ctrt -> apply (assert "rel" ctrt) (fun (rel (__ctrt_rel ctrt)))
                                                                                                 in case (__ctrt_rel c22) of
                                                                                                      True -> z : z' : zs'
                                                                                                      False -> z' : __rec_insert z zs'
                                   in let __ctrt_insert = \ctrt -> \z -> \zs -> apply (assert "insert" ctrt) (app (app (fun (insert (__ctrt_insert ctrt))) z) zs)
                                      in let efoldr = \__rec_efoldr -> \f -> \b -> \xs -> case xs of
                                                                                            [] -> b
                                                                                            (x : ys) -> f x (__rec_efoldr f b ys)
                                         in let __ctrt_efoldr = \ctrt -> \f -> \b -> \xs -> apply (assert "efoldr" ctrt) (app (app (app (fun (efoldr (__ctrt_efoldr ctrt))) f) b) xs)
                                            in __ctrt_efoldr ((>->) ((>->) c58 ((>->) c71 c71)) ((>->) c71 ((>->) ((<@>) c54 c58) c71))) (__ctrt_insert ((>->) c18 ((>->) ((<@>) c11 c18) ((<@>) c13 c18)))) [] us
 in let __ctrt_isort = \ctrt -> \us -> apply (assert "isort" ctrt) (app (fun (isort (__ctrt_isort ctrt))) us)
    in __ctrt_isort ((>->) ((<@>) true true) ((<@>) ord true))
-}
