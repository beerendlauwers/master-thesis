{-# LANGUAGE NoMonomorphismRestriction, TypeOperators #-}

module QuickcheckExamples where

import Contract hiding (ord, insert) -- typed-contracts
import Data.Bifunctor

generatePositionData :: Maybe (Int,Int) -> String
generatePositionData (Just (l,c)) = "at line number " ++ show l ++ ", column number " ++ show c 
generatePositionData Nothing      = "at an unknown position"

ord = PropInfo (\ x -> ordered x) (\p -> mkErrorMsg p "the list elements must be in ascending order.") 

mkErrorMsg p text =  posInfoText p ++  "does not fulfill the following property: "++   text

posInfoText (pos,arity) | pos < arity  = "The " ++ showPos (pos+1) ++ " supplied argument of this function "
                        | pos == arity = "The result of this function "
                        | (pos,arity) == (-1,-1) = "An unknown position "


showPos p | p == 1 = "first"
          | p == 2 = "second"
          | p == 3 = "third"
          | p == 4 = "fourth"
          | p == 5 = "fifth"
          | p == 6 = "sixth"
          | otherwise = show p

-- mylength code
v19 = true
v18 = true
v14 = true
v21 = true
m16 = true



-- QC contract:
-- prop_Main = \xs -> whenFail (putStrLn "Not the right result") (length (xs :: [Int]) == mylength xs)
prop_main = PropInfo (\val -> length [0] == val) (\p -> "Not the right result")
mylength [] =
    0
mylength (x : xs) =
    (__app_mylength ((v19 <@> v14) >-> prop_main) (Just (2
                                                  ,19))) ((Just (2,28)),xs)
__final_mylength [] =
    0
__final_mylength (x : xs) =
    (__app_mylength ((v19 <@> v14) >-> prop_main) (Just (2
                                                  ,19))) ((Just (2,28)),xs)
__contracted_mylength ctrt posinfo =
    assertPos "At the application of the function 'mylength'" (generatePositionData posinfo) ctrt funs
    where
      funs = (fun (\ __x01 -> __final_mylength __x01))
__app_mylength ctrt posinfo (posa,a) =
    (appParam (__contracted_mylength ctrt posinfo) (show a ++ generatePositionData posa) a)

-- myreverse code
-- QC contract:
-- prop_Model = \xs -> whenFail (putMsg "You have not sorted correctly") (myreverse xs == reverse xs)
prop_Elems = PropInfo (\xs -> (and $ map ((flip elem) xs) ([1,0]) )) 
 (\p -> mkErrorMsg p "Input and output list do not contain the same elements.")
              
prop_Model = PropInfo (\xs -> ([1,0] == reverse xs)) 
 (\p -> mkErrorMsg p "You have not sorted correctly.")

prop_Main = prop_Elems & prop_Model

myreverse_ctrt  = (true <@> true) >-> prop_Main

myreverse [] =
    []
myreverse [x,y] =
    [x,y]
myreverse xs =
    undefined
__final_myreverse [] =
    []
__final_myreverse [x,y] =
    [x,y]
__final_myreverse xs =
    undefined
__contracted_myreverse ctrt posinfo =
    assertPos "At the application of the function 'myreverse'" (generatePositionData posinfo) ctrt funs
    where
        funs = (fun (\ __x01 -> __final_myreverse __x01))
__app_myreverse ctrt posinfo (posa,a) =
    (appParam (__contracted_myreverse ctrt posinfo) (show a ++ generatePositionData posa) a)

myreverse_test = __app_myreverse (true >-> prop_Model) (Just (0,0)) ((Just (1,1)),[1,0])

-- repli code
-- repli [] y = []\nrepli (x : xs) y |z == 0 = repli xs z\n                 |otherwise = [x] ++ repli (x : xs) z\n                 where\n                      z = y - 1

-- showGeneratedCode "repli [] y = []\nrepli (x : xs) y |z == 0 = repli xs z\n                 |otherwise = [x] ++ repli (x : xs) z\n                 where\n                      z = y - 1" [] (DM.fromList [])


-- QC contract:
-- type=[a] -> Int -> [a]
-- prop_Main = \xs n -> n > 0 ==> concatMap (replicate n) xs == repli xs n
prop_integer = PropInfo (\n -> n > 0) (\p -> mkErrorMsg p "Value must be a natural number")
prop_result  = PropInfo (\xs -> concatMap (replicate 1) xs == [0]) (\p -> mkErrorMsg p "Incorrect result")

final_contract = ((true <@> true) >-> (prop_integer >-> (prop_result <@> true)))
-- raw contract: (v70 <@> v65) >-> (m74 >-> (v70 <@> v65)

{-
(v999 +-> v65) `o` (v70 +-> prop_result) `o` SId `o` SId `o` (m77 +-> m74) `o` SId `o` SId `o` (v0 +-> m77) `o` SId `o` SId `o` SId `o` (m77 +-> prop_integer) `o` SId `o` SId `o` (v65 +-> true) `o` (v998 +-> v72) `o` SId `o` SId `o` (v65 +-> true) `o` SId `o` (v999 +-> true) `o` (v76 +-> prop_result) `o` SId `o` (m77 +-> prop_integer) `o` SId `o` SId `o` (v65 +-> true) `o` (v998 +-> v76) `o` SId `o` SId `o` (v75 +-> v72) `o` SId `o` SId `o` SId `o` SId `o` SId `o` SId `o` (v0 +-> v65) `o` (v75 +-> v89) `o` (v91 +-> v65) `o` (v90 +-> v89) `o` SId

-}

v89 = true
m74 = true
v70 = true
v65 = true
v77 = true

__final_plusplus a b = a ++ b

__contracted_plusplus ctrt posinfo =
    assertPos "At the application of the function '++'" (generatePositionData posinfo) ctrt funs
    where
        funs =
            (fun (\ __x01 -> (fun (\ __x02 -> __final_plusplus __x01 __x02))))

__app_plusplus ctrt posinfo (posa,a) (posb,b) = (appParam (appParam (__contracted_plusplus ctrt posinfo) (show a ++ generatePositionData posa) a) (show b ++ generatePositionData posb) b)

__contracted_eqeq ctrt posinfo =
    assertPos "At the application of the function '=='" (generatePositionData posinfo) ctrt funs
    where
        funs =
            (fun (\ __x01 -> (fun (\ __x02 -> __final_eqeq __x01 __x02))))

__final_eqeq a b = a == b

__app_eqeq ctrt posinfo (posa,a) (posb,b) = (appParam (appParam (__contracted_eqeq ctrt posinfo) (show a ++ generatePositionData posa) a) (show b ++ generatePositionData posb) b)

__app_colon ctrt posinfo (posa,a) (posb,b) = (appParam (appParam (__contracted_colon ctrt posinfo) (show a ++ generatePositionData posa) a) (show b ++ generatePositionData posb) b)

__contracted_colon ctrt posinfo = 
    assertPos "At the application of the function ':'" (generatePositionData posinfo) ctrt funs
    where
        funs =
            (fun (\ __x01 -> (fun (\ __x02 -> __final_colon __x01 __x02))))

__final_colon a b = a : b

__app_minus ctrt posinfo (posa,a) (posb,b)  = (appParam (appParam (__contracted_minus ctrt posinfo) (show a ++ generatePositionData posa) a) (show b ++ generatePositionData posb) b)

__contracted_minus ctrt posinfo = 
    assertPos "At the application of the function '-'" (generatePositionData posinfo) ctrt funs
    where
        funs =
            (fun (\ __x01 -> (fun (\ __x02 -> __final_minus __x01 __x02))))

__final_minus a b = a - b


__final_repli [] y =
    []
__final_repli (x : xs) y 
    | (((__app_eqeq true (Just (2
                                                     ,21)))) ((Just (2,19))
                                                             ,(z))) ((Just (2
                                                                           ,24))
                                                                    ,(0)) = ((__app_repli ((prop_result <@> true) >-> (prop_integer >-> (prop_result <@> true))) (Just (2
                                                                                                                                                                       ,28))) ((Just (2
                                                                                                                                                                                     ,34))
                                                                                                                                                                              ,xs)) ((Just (2
                                                                                                                                                                                           ,37))
                                                                                                                                                                                    ,z)
    | otherwise = (((__app_plusplus ((true <@> true) >-> ((prop_result <@> true) >-> (true <@> true))) (Just (3
                                                                                                                     ,35)))) ((Just (3
                                                                                                                                    ,31))
                                                                                                                             ,([x]))) ((Just (3
                                                                                                                                             ,38))
                                                                                                                                      ,(((__app_repli ((prop_result <@> true) >-> (prop_integer >-> (prop_result <@> true))) (Just (3
                                                                                                                                                                                                                                   ,38))) ((Just (3
                                                                                                                                                                                                                                                 ,44))
                                                                                                                                                                                                                                          ,((((__app_colon (true >-> ((true <@> true) >-> (prop_result <@> true))) (Just (3
                                                                                                                                                                                                                                                                                                                         ,47)))) ((Just (3
                                                                                                                                                                                                                                                                                                                                        ,45))
                                                                                                                                                                                                                                                                                                                                 ,(x))) ((Just (3
                                                                                                                                                                                                                                                                                                                                               ,49))
                                                                                                                                                                                                                                                                                                                                        ,(xs))))) ((Just (3
                                                                                                                                                                                                                                                                                                                                                         ,53))
                                                                                                                                                                                                                                                                                                                                                  ,z)))
    where
        z =
            (((__app_minus true (Just (5
                                                            ,29)))) ((Just (5
                                                                           ,27))
                                                                    ,(y))) ((Just (5
                                                                                  ,31))
                                                                           ,(1))
__contracted_repli ctrt posinfo =
    assertPos "At the application of the function 'repli'" (generatePositionData posinfo) ctrt funs
    where
        funs =
            (fun (\ __x31 -> (fun (\ __x32 -> __final_repli __x31 __x32))))
__app_repli ctrt posinfo (posa
                         ,a) (posb,b) =
    (appParam (appParam (__contracted_repli ctrt posinfo) (show a ++ generatePositionData posa) a) (show b ++ generatePositionData posb) b)





{-

repli (x : xs) y 
    | (((___==___ (true >-> (true >-> m74)) (Just (2,20)))) (((Just (2,18)),z))) (0) = ((__app_repli ((prop_result <@> true) >-> (prop_integer >-> (prop_result <@> true))) (Just (2,27))) ((Just (2,33)),xs)) ((Just (2,36)),z)
    | otherwise = (((___++___ ((v89 <@> true) >-> ((prop_result <@> true) >-> (v77 <@> true))) (Just (3
                                                                                                     ,36)))) ([((Just (3,33)),x)])) (((__app_repli ((prop_result <@> true) >-> (prop_integer >-> (prop_result <@> true))) (Just (3,39))) ((((___:___ (true >-> ((v89 <@> true) >-> (prop_result <@> true))) (Just (3,48)))) (((Just (3,46)),x))) (((Just (3,50)),xs)))) ((Just (3,54)),z))
    where
        z =
            (((___-___ (true >-> (true >-> true)) (Just (5
                                                        ,29)))) (((Just (5,27))
                                                                 ,y))) (1)


-}

-- Insertion sort

-- Wrong code
insert z zs = case zs of
                [] -> [z]
                (z':zs') -> let rel = z <= z'
                            in case rel of
                                True -> z' : z : zs'
                                False -> z' : insert z zs'
efoldr f b xs = case xs of
                  [] -> b
                  (y:ys) -> f y (efoldr f b ys)
isort us = efoldr insert [] us


-- Generated code
__contracted_lteq ctrt posinfo =
    assertPos "At the application of the function '<='" (generatePositionData posinfo) ctrt funs
    where
        funs =
            (fun (\ __x01 -> (fun (\ __x02 -> __final_lteq __x01 __x02))))

__final_lteq a b = a >= b

__app_lteq ctrt posinfo (posa,a) (posb,b) = (appParam (appParam (__contracted_lteq ctrt posinfo) (show a ++ generatePositionData posa) a) (show b ++ generatePositionData posb) b)

{-
-- Incorrect version of insert
__final_insert z zs =
    case zs of
        []
          ->
              [z]
        (z' : zs')
          ->
              let
                  rel =
                      (((__app_lteq (true >-> (true >-> true)) (Just (3
                                                                     ,41)))) ((Just (3
                                                                                    ,39))
                                                                             ,(z))) ((Just (3
                                                                                           ,44))
                                                                                    ,(z')) in
                  case rel of
                      True
                        ->
                            (((__app_colon (true >-> ((true <@> true) >-> (true <@> true))) (Just (5
                                                                                                  ,44)))) ((Just (5
                                                                                                                 ,41))
                                                                                                          ,(z'))) ((Just (5
                                                                                                                         ,46))
                                                                                                                  ,((((__app_colon (true >-> ((true <@> true) >-> (true <@> true))) (Just (5
                                                                                                                                                                                          ,48)))) ((Just (5
                                                                                                                                                                                                         ,46))
                                                                                                                                                                                                  ,(z))) ((Just (5
                                                                                                                                                                                                                ,50))
                                                                                                                                                                                                         ,(zs'))))
                      False
                        ->
                            (((__app_colon (true >-> ((true <@> true) >-> (ord <@> true))) (Just (6
                                                                                                 ,45)))) ((Just (6
                                                                                                                ,42))
                                                                                                         ,(z'))) ((Just (6
                                                                                                                        ,47))
                                                                                                                 ,(((__app_insert (true >-> ((ord <@> true) >-> (ord <@> true))) (Just (6
                                                                                                                                                                                       ,47))) ((Just (6
                                                                                                                                                                                                     ,54))
                                                                                                                                                                                              ,z)) ((Just (6
                                                                                                                                                                                                          ,56))
                                                                                                                                                                                                   ,zs')))
                  
              
    


-}
-- Correct version of insert
__final_insert z zs =
    case zs of
        []
          ->
              [z]
        (z' : zs')
          ->
              let
                  rel =
                      (((__app_lteq (true >-> (true >-> true)) (Just (3
                                                                     ,41)))) ((Just (3
                                                                                    ,39))
                                                                             ,(z))) ((Just (3
                                                                                           ,44))
                                                                                    ,(z')) in
                  case rel of
                      True
                        ->
                            (((__app_colon (true >-> ((true <@> true) >-> (true <@> true))) (Just (5
                                                                                                  ,43)))) ((Just (5
                                                                                                                 ,41))
                                                                                                          ,(z))) ((Just (5
                                                                                                                        ,45))
                                                                                                                 ,((((__app_colon (true >-> ((true <@> true) >-> (true <@> true))) (Just (5
                                                                                                                                                                                         ,48)))) ((Just (5
                                                                                                                                                                                                        ,45))
                                                                                                                                                                                                 ,(z'))) ((Just (5
                                                                                                                                                                                                                ,50))
                                                                                                                                                                                                         ,(zs'))))
                      False
                        ->
                            (((__app_colon (true >-> ((true <@> true) >-> (ord <@> true))) (Just (6
                                                                                                 ,45)))) ((Just (6
                                                                                                                ,42))
                                                                                                         ,(z'))) ((Just (6
                                                                                                                        ,47))
                                                                                                                 ,(((__app_insert (true >-> ((ord <@> true) >-> (ord <@> true))) (Just (6
                                                                                                                                                                                       ,47))) ((Just (6
                                                                                                                                                                                                     ,54))
                                                                                                                                                                                              ,z)) ((Just (6
                                                                                                                                                                                                          ,56))
                                                                                                                                                                                                   ,zs')))
                  
              
    

__contracted_insert ctrt posinfo =
    assertPos "At the application of the function 'insert'" (generatePositionData posinfo) ctrt funs
    where
        funs =
            (fun (\ __x01 -> (fun (\ __x02 -> __final_insert __x01 __x02))))
__app_insert ctrt posinfo (posa
                          ,a) (posb,b) =
    (appParam (appParam (__contracted_insert ctrt posinfo) (show a ++ generatePositionData posa) a) (show b ++ generatePositionData posb) b)
__final_efoldr __ctrtf f b xs =
    case xs of
        []
          ->
              b
        (y : ys)
          ->
              (f y) ((((__app_efoldr ((true >-> ((ord <@> true) >-> (ord <@> true))) >-> ((ord <@> true) >-> ((true <@> true) >-> (ord <@> true)))) (Just (9
                                                                                                                                                          ,34))) ((Just (9
                                                                                                                                                                        ,41))
                                                                                                                                                                 ,__ctrtf)) ((Just (9
                                                                                                                                                                                   ,43))
                                                                                                                                                                            ,b)) ((Just (9
                                                                                                                                                                                        ,45))
                                                                                                                                                                                 ,ys))
    
__contracted_efoldr ctrt posinfo =
    assertPos "At the application of the higher-order function 'efoldr'" (generatePositionData posinfo) ctrt funs
    where
        funs =
            (fun (\ __x181 -> (fun (\ __x182 -> (fun (\ __x183 -> __final_efoldr __x181 (\ a0 b0 -> (appParam (appParam __x181 (concat ["the application of the higher-order function 'efoldr' "
                                                                                                                                       ,(generatePositionData posinfo)
                                                                                                                                       ,". efoldr has a function as its first argument."
                                                                                                                                       ," The first argument of that function"
                                                                                                                                       ,", namely "
                                                                                                                                       ,show a0]) a0) (concat ["the application of the higher-order function 'efoldr' "
                                                                                                                                                              ,(generatePositionData posinfo)
                                                                                                                                                              ,". efoldr has a function as its first argument."
                                                                                                                                                              ," The second argument of that function"
                                                                                                                                                              ,", namely "
                                                                                                                                                              ,show b0]) b0)) __x182 __x183))))))
__app_efoldr ctrt posinfo (posa
                          ,a) (posb,b) (posc,c) =
    (appParam (appParam (appParam (__contracted_efoldr ctrt posinfo) (show a ++ generatePositionData posa) a) (show b ++ generatePositionData posb) b) (show c ++ generatePositionData posc) c)
__final_isort us =
    (((__app_efoldr ((true >-> ((ord <@> true) >-> (ord <@> true))) >-> ((ord <@> true) >-> ((true <@> true) >-> (ord <@> true)))) (Just (10
                                                                                                                                         ,12))) ((Just (10
                                                                                                                                                       ,19))
                                                                                                                                                ,(__contracted_insert (true >-> ((ord <@> true) >-> (ord <@> true))) (Just (10
                                                                                                                                                                                                                           ,19))))) ((Just (10
                                                                                                                                                                                                                                           ,26))
                                                                                                                                                                                                                                    ,[])) ((Just (10
                                                                                                                                                                                                                                                 ,29))
                                                                                                                                                                                                                                          ,us)
__contracted_isort ctrt posinfo =
    assertPos "At the application of the function 'isort'" (generatePositionData posinfo) ctrt funs
    where
        funs =
            (fun (\ __x281 -> __final_isort __x281))
__app_isort ctrt posinfo (posa
                         ,a) =
    (appParam (__contracted_isort ctrt posinfo) (show a ++ generatePositionData posa) a)
{-

__final_insert z zs =
    case zs of
        []
          ->
              [z]
        (z' : zs')
          ->
              let
                  rel =
                      (((__app_lteq (true >-> (true >-> true)) (Just (3
                                                                     ,41)))) ((Just (3
                                                                                    ,39))
                                                                             ,(z))) ((Just (3
                                                                                           ,44))
                                                                                    ,(z')) in
                  case rel of
                      True
                        ->
                            (((__app_colon (true >-> ((true <@> true) >-> (true <@> true))) (Just (5
                                                                                                  ,43)))) ((Just (5
                                                                                                                 ,41))
                                                                                                          ,(z))) ((Just (5
                                                                                                                        ,45))
                                                                                                                 ,((((__app_colon (true >-> ((true <@> true) >-> (true <@> true))) (Just (5
                                                                                                                                                                                         ,48)))) ((Just (5
                                                                                                                                                                                                        ,45))
                                                                                                                                                                                                 ,(z'))) ((Just (5
                                                                                                                                                                                                                ,50))
                                                                                                                                                                                                         ,(zs'))))
                      False
                        ->
                            (((__app_colon (true >-> ((true <@> true) >-> (true <@> true))) (Just (6
                                                                                                 ,45)))) ((Just (6
                                                                                                                ,42))
                                                                                                         ,(z'))) ((Just (6
                                                                                                                        ,47))
                                                                                                                 ,(((__app_insert (true >-> ((true <@> true) >-> (true <@> true))) (Just (6
                                                                                                                                                                                       ,47))) ((Just (6
                                                                                                                                                                                                     ,54))
                                                                                                                                                                                              ,z)) ((Just (6
                                                                                                                                                                                                          ,56))
                                                                                                                                                                                                   ,zs')))
                  
              
    
__contracted_insert ctrt posinfo =
    assertPos "At the application of the function 'insert'" (generatePositionData posinfo) ctrt funs
    where
        funs =
            (fun (\ __x01 -> (fun (\ __x02 -> __final_insert __x01 __x02))))
__app_insert ctrt posinfo (posa
                          ,a) (posb,b) =
    (appParam (appParam (__contracted_insert ctrt posinfo) (show a ++ generatePositionData posa) a) (show b ++ generatePositionData posb) b)

__final_efoldr ctrtf f b xs =
    case xs of
        []
          ->
              b
        (y : ys)
          ->
              (f y) ((((__app_efoldr true (Just (9
                                                                                                                                                          ,34))) ((Just (9
                                                                                                                                                                        ,41))
                                                                                                                                                                 ,(ctrtf))) ((Just (9
                                                                                                                                                                                   ,43))
                                                                                                                                                                            ,b)) ((Just (9
                                                                                                                                                                                        ,45))
                                                                                                                                                                                 ,ys))
    
__contracted_efoldr ctrt posinfo =
    assertPos "At the application of the higher-order function 'efoldr'" (generatePositionData posinfo) ctrt funs
    where
        funs =
            (fun (\ __x181 -> (fun (\ __x182 -> (fun (\ __x183 -> __final_efoldr __x181 (\ a0 b0 -> (appParam (appParam __x181 (concat ["the application of the higher-order function 'efoldr' "
                                                                                                                                       ,(generatePositionData posinfo)
                                                                                                                                       ,". efoldr has a function as its first argument."
                                                                                                                                       ," The first argument of that function"
                                                                                                                                       ,", namely "
                                                                                                                                       ,show a0]) a0) (concat ["the application of the higher-order function 'efoldr' "
                                                                                                                                                              ,(generatePositionData posinfo)
                                                                                                                                                              ,". efoldr has a function as its first argument."
                                                                                                                                                              ," The second argument of that function"
                                                                                                                                                              ,", namely "
                                                                                                                                                              ,show b0]) b0)) __x182 __x183))))))
__app_efoldr ctrt posinfo (posa
                          ,a) (posb,b) (posc,c) =
    (appParam (appParam (appParam (__contracted_efoldr ctrt posinfo) (show a ++ generatePositionData posa) a) (show b ++ generatePositionData posb) b) (show c ++ generatePositionData posc) c)

__final_isort us =
    (((__app_efoldr true (Just (10
                                                                                                                                         ,12))) ((Just (10
                                                                                                                                                       ,19))
                                                                                                                                                ,__contracted_insert (true >-> ((true <@> true) >-> true)) Nothing)) ((Just (10
                                                                                                                                                                              ,26))
                                                                                                                                                                       ,[])) ((Just (10
                                                                                                                                                                                    ,29))
                                                                                                                                                                             ,us)
__contracted_isort ctrt posinfo =
    assertPos "At the application of the function 'isort'" (generatePositionData posinfo) ctrt funs
    where
        funs =
            (fun (\ __x281 -> __final_isort __x281))
__app_isort ctrt posinfo (posa
                         ,a) =
    (appParam (__contracted_isort ctrt posinfo) (show a ++ generatePositionData posa) a)

-}

instance Show (a :-> b) where
 show x = "function"

