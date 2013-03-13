{-# LANGUAGE TypeOperators, NoMonomorphismRestriction #-}

import Contract hiding (foldr, foldr', insert', f)
import Data.List (permutations)

isSorted :: Ord a => [a] -> [a] -> Bool
isSorted xs ys = isNonDesc ys && isPerm
  where isPerm = ys `elem` permutations xs
        isNonDesc (x:x':xs)  = x <= x' && isNonDesc (x':xs)
        isNonDesc _          = True

sorted :: Ord a => [a] -> Contract [a]
sorted xs = prop (isSorted xs)

isort_c :: (Num a, Ord a) => [a] -> [a]
isort_c xs = app isort' 1 xs
  where  -- isort' :: Ord a => [a] :-> [a]
         isort' = assert "isort" ctrt_isort (fun (\ys -> _isort ys))
         -- _isort :: Ord aT => [aT] -> [aT]
         _isort = foldr_c ctrt_foldr (insert_c ctrt_insert) []
         {-ctrt_isort   = true <@> true >-> ord <@> true-}
         {-ctrt_foldr   = (true >-> ord <@> true >-> ord <@> true) >-> ord <@> true >-> true >-> ord <@> true-}
         {-ctrt_insert  = true >-> ord <@> true >-> ord <@> true-}
-- | It turns out that naively adding counter examples to the contracts
-- doesn't work as I would've hoped. However, we might be able to exploit
-- the fact that QuickCheck produces a _minimal_ counter example. In the
-- case of the artificial error below, we get as counter-example [0,1].
-- Since this example is minimal, we can assume that [1], [0], and [] will
-- pass just fine. We could just manually shrink the counter-example in the
-- recursive positions, allowing passes deeper in the recursion to pass,
-- while still identifying the location of the bug.
         ctrt_isort   = true <@> true >-> sorted [0,1]
         ctrt_foldr   = (true >-> true >-> sorted [0,1]) >-> true >-> true >-> sorted [0,1]
         ctrt_insert  = true >-> true >-> sorted [0,1]

{-prog = let insert_c = \ctrt -> \x -> \xs ->-}
              {-let _insert = \ctrt -> \x -> \lst ->-}
                              {-case lst of-}
                                {-[]      ->  [x]-}
                                {-(y:ys)  ->  let r = \ctrt -> x <= y-}
                                            {-in  case r () of-}
                                                  {-True   -> y : x : ys-}
                                                  {-False  -> y : insert_c ctrt x ys-}
              {-in  let insert' = \ctrt -> assert "insert" ctrt (fun (\x -> fun (\xs -> _insert ctrt x xs)))-}
                  {-in  app (app (insert' ctrt) 5 x) 6 xs-}
       {-in  insert_c-}

{-_prog' = let insert_c = \ctrt -> \rec -> \x -> \lst ->-}
                           {-case lst of-}
                             {-[]      ->  [x]-}
                             {-(y:ys)  ->  let r = \ctrt -> x <= y-}
                                         {-in  case r () of-}
                                               {-True   -> y : x : ys-}
                                               {-False  -> y : insert_c ctrt x ys-}
         {-in  insert_c-}

{-prog' = let insert_c = \ctrt -> \x -> \xs ->-}
               {-let _insert = \ctrt -> \x -> \lst ->-}
                               {-case lst of-}
                                 {-[]      ->  [x]-}
                                 {-(y:ys)  ->  let r = \ctrt -> x <= y-}
                                             {-in  case r () of-}
                                                   {-True   -> y : x : ys-}
                                                   {-False  -> y : insert_c ctrt x ys-}
              {--- in  let insert' = \ctrt -> assert "insert" ctrt (fun (\x -> fun (\xs -> _insert ctrt x xs)))-}
               {-in  app (app (    assert "insert" ctrt (fun (\x -> fun (\xs -> _insert ctrt x xs)))     ) 5 x) 6 xs-}
        {-in  insert_c-}

prog2 = let insert_c = \rec -> \x -> \lst ->
              case lst of
                []      ->  [x]
                (y:ys)  ->  let r = \ctrt -> x <= y
                            in  case r () of
                                  True   -> y : x : ys
                                  False  -> y : rec x ys
              -- in  let insert' = \ctrt -> assert "insert" ctrt (fun (\x -> fun (\xs -> _insert ctrt x xs)))
               -- in  app (app (    assert "insert" ctrt (fun (\x -> fun (\xs -> _insert ctrt x xs)))     ) 5 x) 6 xs
        in  let __ctrd_insert_c = \ctrt -> \x -> \xs ->
                  app (app (assert "insert" ctrt (fun (\x -> fun (\xs -> insert_c (__ctrd_insert_c ctrt) x xs)))) 5 x) 6 xs
            in  __ctrd_insert_c (true >-> true >-> true) -- 7 [3,5]

foldr_c :: Contract ((aT1 :-> (aT :-> aT)) :-> (aT :-> ([aT1] :-> aT)))
        -> (aT1 -> aT -> aT) -> aT -> [aT1] -> aT
foldr_c ctrt f b xs = app (app (app (foldr' ctrt) 2 (fun (\y -> fun (\ys -> f y ys)))) 3 b) 4 xs
  where  -- foldr' :: Contract ((aT1 :-> (aT :-> aT)) :-> (aT :-> ([aT1] :-> aT)))
         --        -> (aT1 :-> (aT :-> aT)) :-> (aT :-> ([aT1] :-> aT))
         foldr' ctrt = assert "foldr" ctrt
           (fun (\ f -> fun (\ e -> fun (\ x -> _foldr ctrt (\ a -> \ b -> app (app f foldloc1 a) foldloc2 b) e x))))
         -- _foldr :: Contract ((aT1 :-> (aT :-> aT)) :-> (aT :-> ([aT1] :-> aT)))
         --        -> (aT1 -> aT -> aT) -> aT -> [aT1] -> aT
         _foldr _     _  b []      = b
         _foldr ctrt  f  b (x:xs)  = f x (foldr_c ctrt f b xs)

insert_c :: Ord a => Contract (a :-> ([a] :-> [a])) -> a -> [a] -> [a]
insert_c ctrt x xs = app (app (insert' ctrt) 5 x) 6 xs
  where  -- insert' :: Ord a => Contract (a :-> ([a] :-> [a])) -> a :-> ([a] :-> [a])
         insert' ctrt = assert "insert" ctrt
           (fun (\x -> fun (\xs -> _insert ctrt x xs)))
         -- _insert :: Ord a => Contract (a :-> ([a] :-> [a])) -> a -> [a] -> [a]
         _insert _     x []                   = [x]
         _insert ctrt  x (y:ys)  | x <= y     = y : x : ys -- Introduced bug here: should be x : y
                                 | otherwise  = y : insert_c ctrt x ys


foldr_c' :: Contract ((aT1 :-> (aT :-> aT)) :-> (aT :-> ([aT1] :-> aT)))
        -> (aT1 -> aT -> aT)
        -> (aT1 -> aT -> aT) -> aT -> [aT1] -> aT
foldr_c' ctrt f' f b xs = app (app (app (foldr' ctrt) 2 (fun (\y -> fun (\ys -> f y ys)))) 3 b) 4 xs
  where  -- foldr' :: Contract ((aT1 :-> (aT :-> aT)) :-> (aT :-> ([aT1] :-> aT)))
         --        -> (aT1 :-> (aT :-> aT)) :-> (aT :-> ([aT1] :-> aT))
         foldr' ctrt = assert "foldr" ctrt
           (fun (\ f -> fun (\ e -> fun (\ x -> _foldr f' (\ a -> \ b -> app (app f foldloc1 a) foldloc2 b) e x))))
         -- _foldr :: Contract ((aT1 :-> (aT :-> aT)) :-> (aT :-> ([aT1] :-> aT)))
         --        -> (aT1 -> aT -> aT) -> aT -> [aT1] -> aT
         _foldr f' _  b []      = b
         _foldr f' f  b (x:xs)  = f x (_foldr f' f' b xs)

insert_c' :: Ord a => Contract (a :-> ([a] :-> [a])) -> a -> [a] -> [a]
insert_c' ctrt x xs = app (app (insert' ctrt) 5 x) 6 xs
  where  -- insert' :: Ord a => Contract (a :-> ([a] :-> [a])) -> a :-> ([a] :-> [a])
         insert' ctrt = assert "insert" ctrt
           (fun (\x -> fun (\xs -> _insert x xs)))
         -- _insert :: Ord a => Contract (a :-> ([a] :-> [a])) -> a -> [a] -> [a]

_insert :: Ord a => a -> [a] -> [a]
_insert x []                   = [x]
_insert x (y:ys)  | x <= y     = x : y : ys -- Introduced bug here: should be x : y
                  | otherwise  = y : _insert x ys

isort_c' :: (Num a, Ord a) => [a] -> [a]
isort_c' xs = app isort' 1 xs
  where  -- isort' :: Ord a => [a] :-> [a]
         isort' = assert "isort" ctrt_isort (fun (\ys -> _isort ys))
         -- _isort :: Ord aT => [aT] -> [aT]
         _isort = foldr_c' ctrt_foldr _insert (insert_c' ctrt_insert) []
         {-ctrt_isort   = true <@> true >-> ord <@> true-}
         {-ctrt_foldr   = (true >-> ord <@> true >-> ord <@> true) >-> ord <@> true >-> true >-> ord <@> true-}
         {-ctrt_insert  = true >-> ord <@> true >-> ord <@> true-}
-- | It turns out that naively adding counter examples to the contracts
-- doesn't work as I would've hoped. However, we might be able to exploit
-- the fact that QuickCheck produces a _minimal_ counter example. In the
-- case of the artificial error below, we get as counter-example [0,1].
-- Since this example is minimal, we can assume that [1], [0], and [] will
-- pass just fine. We could just manually shrink the counter-example in the
-- recursive positions, allowing passes deeper in the recursion to pass,
-- while still identifying the location of the bug.
         ctrt_isort   = true <@> true >-> sorted [0,1]
         ctrt_foldr   = (true >-> true >-> sorted [0,1]) >-> true >-> true >-> sorted [0,1]
         ctrt_insert  = true >-> true >-> sorted [0,1]
