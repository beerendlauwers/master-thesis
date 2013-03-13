{-# LINE 88 "InferringContracts.lhs" #-}
  {-#  LANGUAGE NoMonomorphismRestriction  #-}
 
  module InferringContracts where
 
  import Blame
  import Contract
  import Data.List
  import Loc
  import Test.QuickCheck
 
  prop_Encode :: [Int] -> Bool
  propSort :: [Int] -> Bool
{-# LINE 205 "InferringContracts.lhs" #-}
  sort = Contract.foldr InferringContracts.insert []
 
  insert x []                   =  [x]
  insert x (y:ys)  | x <= y     =  x:y:ys
                   | otherwise  =  y:InferringContracts.insert x ys
{-# LINE 217 "InferringContracts.lhs" #-}
  sort' = Contract.foldr InferringContracts.insert' []
 
  insert' x []                  =  [x]
  insert' x (y:ys)  | x <= y     =  y:x:ys
                    | otherwise  =  y:InferringContracts.insert' x ys
{-# LINE 229 "InferringContracts.lhs" #-}
  propSort xs         =  isNonDesc (sort' xs)
{-# LINE 232 "InferringContracts.lhs" #-}
  isNonDesc (x:y:xs)  =  x <= y && isNonDesc (y:xs)
  isNonDesc _         =  True
{-# LINE 240 "InferringContracts.lhs" #-}
  main = do quickCheck propSort
{-# LINE 275 "InferringContracts.lhs" #-}
  sortc = assert "sort" 
    (list true >-> (Prop(\  zs ->  isNonDesc zs)))
    (fun(\  xs ->  (sort' xs)))
{-# LINE 285 "InferringContracts.lhs" #-}
  blameSort = app (sortc) (0) [0,1]
{-# LINE 314 "InferringContracts.lhs" #-}
  insertc = assert "insert" 
    (true >-> Prop(\  xs ->  isNonDesc xs) >-> Prop(\  xs ->  isNonDesc xs))
    (fun(\  x ->  (fun(\  xs ->  (InferringContracts.insert' x xs)))))
{-# LINE 331 "InferringContracts.lhs" #-}
  foldrc ca cb = assert "fold"
    ((ca >-> cb >-> cb)  >-> cb      >-> list ca >-> cb)
    (fun (\f             -> fun (\e  -> fun (\xs -> 
       Data.List.foldr (\a -> \b -> (app (app f foldloc1 a) foldloc2 b)) e xs))))
{-# LINE 352 "InferringContracts.lhs" #-}
  blameSort2 = app (sort3) (0) [0,1]
{-# LINE 356 "InferringContracts.lhs" #-}
  sort3 = app (app (foldrc true true) foldloc1 insertc) foldloc2 []
{-# LINE 446 "InferringContracts.lhs" #-}
  sortContract = Function  (list true)(\xs-> (Prop(\  zs ->  isSorted xs zs)))
 
  isSorted xs ys = isNonDesc ys && ys `elem` permutations xs
{-# LINE 498 "InferringContracts.lhs" #-}
  encode = merge . map (\z -> (1, z))
 
  merge []                  =  []
  merge [(a,x)]             =  [(a,x)]
  merge ((a,x):(b,y):rest)  =  if x==y
                               then merge ((a+b,x):rest)
                               else (a,x):merge ((b,y):rest)
 
  prop_Encode xs =  let  ys = encode' xs
                    in   decode ys == xs && noDups (map snd ys)
{-# LINE 540 "InferringContracts.lhs" #-}
  encode' = merge' . map (\z -> (1, z))
 
  merge' []                  =  []
  merge' [(a,x)]             =  [(a,x)]
  merge' ((a,x):(b,y):rest)  =  if x==y
                                then (a+b,x): merge' rest
                                else (a,x): merge' ((b,y):rest)
{-# LINE 555 "InferringContracts.lhs" #-}
  decode []          =  []
  decode ((n,y):ys)  =  replicate n y ++ decode ys
 
  noDups []        =  True
  noDups [x]       =  True
  noDups (x:y:xs)  =  x/=y && noDups (y:xs)
{-# LINE 583 "InferringContracts.lhs" #-}
  encode2 = assert "encode" 
    (Function  (list true)(\xs-> (Prop(\  zs ->  decode zs == xs && noDups (map snd zs)))))
    (fun(\  xs ->  (encode' xs)))
