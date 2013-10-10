{-# LANGUAGE TypeOperators, NoMonomorphismRestriction #-}

import Contract hiding (foldr, foldr', insert', f)
import Data.List (permutations)
import Data.Char (isAlpha, isAlphaNum)
import TypeOf

-- Gecontracteerde gegenereerde voorbeeldcode
a5 = true
a4 = true

__contracted_f ctrt = assert "f" ctrt funs
  where funs = fun (\x -> __example_f x)
__app_f ctrt (posx,x) = app (__contracted_f ctrt) posx x
__example_f x = __app_g (a5 >-> (isSingleton <@> a5)) (0,x)

__contracted_g ctrt = assert "g" ctrt funs
  where funs = fun (\x -> __example_g x)
__app_g ctrt (posx,x) = app (__contracted_g ctrt) posx x
__example_g x = []

__example_z = ( __app_f (isChar_prop >-> (isSingleton <@> isChar_prop)) (1,'2'), __app_f (isNat_prop >-> (isSingleton <@> isNat_prop)) (2,5) )

-- Hoe werkt dit voor functies die een functie teruggeven???
n x y z = x (x y z)
__contracted_n ctrt = assert "n" ctrt funs
  where funs = fun (\x -> fun (\y -> fun (\z -> __final_n (\x1 y1 -> app (app x 1 x1) 2 y1) y z)))
__app_n ctrt x y z = app( app( app (__contracted_n ctrt) 3 x) 4 y) 5 z
__final_n x y z = x (x y z) -- Correct????
use_n = n (+) 1 2
use_n_ctrt = __app_n true (ctrt_plus true) 1 2
ctrt_plus ctrt = assert "(+)" ctrt (fun (\x -> fun (\y -> (+) x y)))

use_n_2 = (n (+) 1 2) 3
use_n_2_ctrt = (__app_n true (ctrt_plus true) 1 2) 3

-- Voorbeeld hoe g eigenlijk ook de string representatie van argumenten moet meekrijgen voor waardevolle feedback.
__appr_f ctrt (x,posx) = appParam (__contractedr_f ctrt [posx]) posx x
__contractedr_f ctrt posinfo = assert "f" ctrt funs
  where funs = fun (\x -> __exampler_f ctrt (x,head posinfo))
__exampler_f ctrt (x,posx) = __appr_g (a5 >-> (isSingleton <@> a5)) (x,posx)

__contractedr_g ctrt posinfo = assert "g" ctrt funs
  where funs = fun (\x -> __exampler_g ctrt (x,head posinfo) )
__appr_g ctrt (x,posx) = appParam (__contractedr_g ctrt [posx]) posx x
__exampler_g ctrt (x,posinfo) = [x]

__exampler_z = ( __appr_f (isChar_prop >-> (isSingleton <@> isChar_prop)) ('2',"Position 1"), __appr_f (isNat_prop >-> (isSingleton <@> isNat_prop)) (5,"Position 2") )

-- Hoe werkt dit voor HO functies?
__app_a ctrt (f,posf) (x,posx) = appParam (appParam (__contracted_a ctrt [posf,posx]) posf f) posx x
__contracted_a ctrt posinfo = assertPos "the application of the higher-order function 'a'" "at Line Number 1, Column Number 1" ctrt funs
  where funs = fun (\f -> fun (\x -> __final_a ctrt ((\(z,posz) -> (appParam f ("The first argument of the function " ++ head posinfo ++ " (defined at line number 1, column number 5), namely " ++ posz) z)),head posinfo) (x, head $ tail posinfo) ) )
__final_a ctrt (f,posf) (x,posx) = f (x,posx)

__example_ho_z = __app_a ((isBiggerThan_prop >-> true) >-> true) (__ctrt_const1 (isBiggerThan_prop >-> true),"(\\y -> const y [])") (5,"5")


__ctrt_const1 ctrt = assertPos "const1" "(1,5)" ctrt (fun (\y -> __final_const y []))

-- Note: Doesn't have the entire string-passing thing here
__finalr_const x y = x

__contractedr_const ctrt = assertPos "const" "(2,5)" ctrt funs
 where funs = fun (\x -> fun (\y -> __finalr_const x y))

__app_constr ctrt (posx,x) (posy,y) = appParam (appParam (__contractedr_const ctrt) posx x) posy y


-- Nog een voorbeeld
plusone :: [Int] -> [Int]
plusone = map (+1)

-- example_map lijkt de 'normale' functie-applicatie-versie
-- van map, maar is eigenlijk wel gecontracteerd!
-- Als we later misschien subtituties meegeven, zullen we ook hier dit moeten doen. 

__contracted_plusone ctrt = assert "plusone" ctrt funs
  where funs = fun (\x -> __example_map (__contracted_f true) x)
        __contracted_f ctrt = assert "(+1)" ctrt funs
          where funs = fun (\x -> (+1) x)

-- Eerst wordt het contract van de parameter x gecheckt.
-- Hierna callen we de rest van de gecontracteerde definitie,
-- dewelke gedefinieerd is in __contracted_plusone.
__app_plusone ctrt (posx,x) = app (__contracted_plusone ctrt) posx x

__example_plusone x = __app_plusone true (7,x)

-- Map is higher-order: dit wordt gereflecteerd in de funs definitie.
__contracted_map ctrt = assert "map" ctrt funs
  where funs = fun (\f -> fun (\xs -> map (\a -> app f 5 a) xs))

__app_map ctrt (posf,f) (posx,x) = app (app (__contracted_map ctrt) posf f) posx x

__example_map f x = __app_map (true) (3,f) (4,x)

--Nog een voorbeeld, insertion sort
isort = foldr insert []

__example_insert x xs = __app_insert true (8,x) (9,xs)
__app_insert ctrt (posx,x) (posxs,xs) = app (app (__contracted_insert ctrt) posx x) posxs xs
__contracted_insert ctrt = assert "insert" ctrt funs
  where funs = fun (\x -> fun (\xs -> insert x xs))

__example_foldr f b xs = __app_foldr true (10,f) (11,b) (12,xs)
__app_foldr ctrt (posf,f) (posb,b) (posxs,xs) = app (app ( app (__contracted_foldr ctrt) posf f) posb b) posxs xs
__contracted_foldr ctrt = assert "foldr" ctrt funs
  where funs = fun (\f -> fun (\b -> fun (\xs -> foldr (\a b -> app (app f 13 a) 14 b) b xs)))

__example_isort x = __app_isort true (15,x)
__app_isort ctrt (posx,x) = app (__contracted_isort ctrt) posx x
__contracted_isort ctrt = assert "isort" ctrt funs
  where funs = fun (\x -> __isort x)
        __isort = __example_foldr (__contracted_insert true) []


fsum_original = foldr (+) 0 

fsum = __entry_fsum

-- Idee: higher-order contracted functies worden in de where-clause gedefinieerd.
-- Op die manier kunnen we reeds ingevulde argumenten ook contracteren.
__entry_fsum = __example_foldr (__contracted_f true) 0
  where __contracted_f ctrt = assert "(+)" ctrt funs 
          where funs = fun (\x -> fun (\y -> (+) x y))

__example_fsum x = __app_fsum true (17,x)
__app_fsum ctrt (posx,x) = app (__contracted_fsum ctrt) posx x
__contracted_fsum ctrt = assert "fsum" ctrt funs
  where funs = fun (\x -> fsum x)

flist = foldr f nil
  where f = (:)
        nil = []


__entry_flist = __example_foldr (__contracted_f true) []
  where  __contracted_f ctrt = assert "(:)" ctrt funs
          where funs = fun (\x -> fun (\y -> (:) x y))
         __app_f ctrt (posx,x) (posy,y) = app (app (__contracted_f ctrt) posx x) posy y
         __example_f x y = __app_f true (18,x) (19,y)
         __contracted_nil ctrt = assert "nil" ctrt funs
           where funs = []
         __app_nil ctrt = __contracted_f ctrt
         __example_nil = __app_nil true
      


-- Voorbeeld met lambda functie
__original_lambda = (\x -> plusone [x]) 

lambda = __entry_lambda

__entry_lambda x = __example_plusone [x]

__example_lambda x = __app_lambda true (16,x)
__app_lambda ctrt (posx,x) = app (__contracted_lambda ctrt) posx x
__contracted_lambda ctrt = assert "lambda" ctrt funs
  where funs = fun (\x -> __entry_lambda x)


-- CONCLUSIES:
-- Bij de originele functions moet je de functie definitie herschrijven.

-- een higher-order functie call moet worden vervangen met de
-- __example_ versie, en de higher-order parameter vervangen met de
-- __contracted_ versie.

-- Voor alle functies met een echte functie identifier worden de
-- __example, __app en __contracted versies gegenereerd.

-- Voor anonieme functies en parameters definiëren we lokale definities in de
-- where clause. Hier kunnen we ze contracteren. 

-- Idee: wat als we de gecontracteerde definities van functies in de where-clause zetten van 
-- een entry function?

twoisort{-pos = 0-} = foldr{-pos = 1-} insert{-pos = 2-} []{-pos = 3-}

-- Kind of error we want: Contract violation in function "insert" when asserting parameter "x". This function was used in the higher-order function "foldr" at position 1-3. Violated contract: isChar ACTUALVAR.

{-

> appParam :: (at :-> bT) -> String -> String -> aT -> bT
> appParam f s p x = apply f (makeloc (DefWithParam s p)) x

__app_insert true (positioninfox,x) (positioninfoxs,xs)

__app_insert ctrt (posx,x) (posxs,xs) = appParam (appParam (__contracted_insert ctrt) "insert" (show posx)) "insert" (show posxs)

-- Stays the same.

-}

-- Idea: add position parameter to __contracted version:

-- __contracted_insert ctrt pos = assertPos "insert" (makeStringPos pos) ctrt funs
-- __contracted_foldr ctrt pos = assertPos "foldr" (makeStringPos pos) ctrt funs

-- app (__contracted_isort ctrt posisort) posx x

-- isort (0) = foldr (1) insert (2) [] (3)
-- convert foldr application:
-- (\x -> __app_foldr GENERATED_CONTRACT 1 (2,insert) (3,[]) (noPos,x)
-- app (app (app (__contracted_foldr CTRT 1) 2 insert) 3 []) noPos xs
-- __app_foldr ctrt pos (posf,f) (posb,b) (posxs,xs) = 
--  app (app (app (__contracted_foldr ctrt pos) posf f) posb b) posxs xs
-- __contracted foldr ctrt pos = assertPos "foldr" pos ctrt funs ...

-- convert insert:
-- (__contracted_insert CTRT 2)
-- NOTE: we need to tell every argument if it's higher order or not.
-- Need to do the following here:
-- After lambda creation, collect all param names: "insert", "[]" and "x".
-- We can tell the AST nodes of insert and [] that they're HO or not.
-- For x, we can't do that (don't need to, then).
-- Generate code: 
--   If the parameter has been applied already:
--   if HO: replace with __contracted version, add contract and position info.
--   otherwise, normal.
--   If the parameter has not been applied already:
--   if HO: add contract and position info.
--   otherwise, normal.

-- convert []: no conversion necessary.

-- RESULT:
-- isort = (\x -> __app_foldr CTRT 1 (2,__contracted_insert CTRT 2) (3,[]) (noPos,x)

-- Steps to convert an entry function:
-- 1) Identify function applications.
-- 2) Collect position information, zip up with parameters. (posx,1) (posy,2) etc
-- 3) Not-yet-applied parameters don't have position information. We could say something like
--    "checking parameter 3" or someting instead of giving the actual position.
-- 3) Check type of function being applied. Perhaps it's partial. We need this info for step 4.
-- 4) Make a lambda that captures any remaining variables.
-- 5) Get name of function being applied: FUNNAME.
-- 6) Construct an __app_FUNNAME: __app_FUNNAME @loc.ctrt_FUNNAME @loc.pos_FUNNAME @loc.parameters
-- 7) Replace original call with __app_FUNNAME.

-- Extra stuff for lambdas:
-- isort = (\f b -> foldr f b) (foldr insert [])
-- 1) Rename any lambdas, put them in where-clause: __lam1 = (\f b -> foldr f b)
-- 2) Continue as usual.
-- idfoldr = foldr (\x xs -> x : xs) []
-- 1) Rename lambda: __lam1 = (\x xs -> x : xs)
-- 2) Continue as usual.

-- test =
--  let f = (\x xs -> x : xs)
--  in foldr f []
-- Seems like we don't need to change anything here?


-- Conversion test for partially applied functions:
-- isort = foldr insert []
-- becomes

-- __final_isort :: (POSINFO,ARGUMENT) -> [a]
-- __final_isort = __app_foldr CTRT POS (POS,__contracted_insert CTRT POS) (POS,[])
-- Would we still need to add lambdas here? Seems unnecessary


-- isort = foldr insert []
-- isort [5,4,8,0]
-- Becomes: __app_isort (_,_,[5,4,8,0])
-- __app_isort ctrt posinfo (stra,posa,a) = appParam (__contracted_isort ctrt posinfo) posa a
-- __contracted_isort ctrt posinfo = assert "isort" ctrt funs
--  where funs = fun (\xs -> __final_isort xs)
-- __final_isort = __app_foldr ctrt pos (_,__contracted_insert ctrt pos) (_,[])
-- NEED TO CAPTURE VARIABLES HERE!!!

--f :: x -> y -> (y -> z) -> z
--g :: x -> y -> z
--((__app_f x) (__app_g x y)::z (__contracted_g x)::y->z )::z
--
--g is fully applied in first instance, so it becomes app.
--g is partially applied in second instance, so it becomes contracted.

-- Steps in process:
-- 1) Replace any lambdas in function application (= function + arguments) with references, place lambdas in where clause
-- 2) Replace all arguments in function application with appropriate versions (either __app or __contracted)
-- 3) Use new function application in __final version of functions, so we complete the cycle.
-- 4) __final version of a function is referenced in __contracted version. This means that recursive calls are contracted as well, as well as calls to other functions.

-- An example to clear up how the __app and __contracted versions should work:
__final_const x y = x

__contracted_const ctrt = assert "const" ctrt funs
 where funs = fun (\x -> fun (\y -> __final_const x y))

__app_const ctrt (posx,x) (posy,y) = app (app (__contracted_const ctrt) posx x) posy y




-- Extra information generation:
-- Inside higher-order __contracted versions, we could use a different 'app'
-- that says something like "The following property does not hold on parameter 1: blablabla"
-- We'll have to add another constructor to the Contract GADT for this, something like
-- PropExtra that has a property and a String representing the property.

-- Test of extra information generation idea:
__contracted_map_extra ctrt argtext = assertPos "At the application of the higher-order function 'map'" "at Line Number 1, Column Number 1" ctrt funs
  where funs = fun (\f -> fun (\xs -> map (\a -> appParam f (head argtext) a) xs))
  -- Het argument waarop de functie wordt toegepast voldoet niet aan de volgende eigenschap.

__app_map_extra ctrt (strf,posf,f) (strx,posx,x) = appParam (appParam (__contracted_map_extra ctrt [strf,strx]) (strf++posf) f) (strx++posx) x

__map_extra_test = __app_map_extra ((true >-> isNat_prop) >-> true) ("(\\x -> (+1) x)"," at Line Number 1, Column Number 22",fun (\x -> (+1) x)) ("[-3,2,3]"," at Line Number 1, Column Number 30",[-3,2,3])

__map_extra_test_2 = __app_map_extra ((isNat_prop >-> true) >-> true) ("(\\x -> (+1) x)"," at Line Number 1, Column Number 22",fun (\x -> (+1) x)) ("[-3,2,3]"," at Line Number 1, Column Number 30",[3,2,-3])

--mapc = assert "map" ((isNat_prop >-> true) >-> true) 

__map_extra_test_3 = __app_map_extra ((true >-> true) >-> true >-> (true <@> isNat_prop))  ("(\\x -> (+1) x)"," at Line Number 1, Column Number 22",fun (\x -> (+1) x)) ("[-3,2,3]", " at Line Number 1, Column Number 30",[-3,2,3])

-- Perhaps we could also infer from the contract extra information to display to the user?
-- For example, the isNat_prop will just say that "the number must be a natural".
-- Does the first parameter have to be a natural? Does the result have to be a natural?
-- Need to think about how we can extract this from a contract.
-- As a result, we could get something like this:
--  Error: `(\x -> (+1) x) at Line Number 1, Column Number 22': The result of the function must be a natural.

-- If we can give the "length" of a contract to the error generation code,
-- We can do all these kinds of things.
-- In case of a value, we could generate an error like "This value must be a natural."
-- In case of function parameters, we could generate an error like "Parameter X of this function must be a natural."
-- In case of higher-order functions... ?

-- Remember that many functions will not be fully applied like this; we could display
-- something like "Parameter X of function Y is a {function | result | value}, and" ++
-- "parameter Z of this function" or "this value" or "the result of this function" ++
-- "must be a natural."
-- NOTE: this may not be necessary if we get fully applied functions in the AST, as one would expect for QuickCheck to work.



-- Next up: Making contracts more specific.
-- Each AST node will have two lists of substitutions at their disposal:
-- 1. Substitutions that replace polymorphic contract variables.
-- These substitutions are used to get to a "final" version of a contract.
-- These substitutions are applied before the rest of the code generation.
-- 2. Substitutions that replace polymorphic contract variables with monomorphic ones.
-- These substitutions are only available to the AST node and its children.
-- These are applied (or could be) in a dynamic fashion, in other words, at runtime.

-- Exploration test:
-- isort = foldr insert []
-- isort = (\x -> __app_foldr CTRT 1 (2,__contracted_insert CTRT 2) (3,[]) (noPos,x))
-- Add in locSubst:
-- __contracted_insert gets yet another parameter: locSubst.
-- __app_foldr also get another parameter, which is passed to __contracted_foldr.
-- In short: at the AST node, we can pass the correct locSubst to the __contracted version of any function applications.
-- Higher-order functions pass along the locSubst to their higher-order parameters.
-- However, we need to pass it to EVERY __contracted version that is called!
-- Quick example:
-- isort = __entry_isort []
-- __entry_isort substs = (\x -> __app_foldr substs CTRT 1 (2,__contracted_insert substs CTRT 2) (3,[]) (noPos,x))
--
--__contracted_f substs ctrt = assert "f" ctrt funs
--  where funs = fun (\x -> f substs x)
--
--__app_f substs ctrt (posx,x) = app (__contracted_f substs ctrt) posx x
--
--__contracted_g substs ctrt = assert "g" ctrt funs
--  where funs = fun (\x -> g substs x)
--
--__app_g ctrt (posx,x) = app (__contracted_g ctrt) posx x
--
--f substs x = __app_g substs (a5 >-> (a4 <@> a5)) (posx,x)
--g substs x = [x]
--z substs = ( __app_f substs (IsChar >-> (True <@> IsChar)) (pos2,'2'), __app_f substs (IsNum >-> (True <@> IsNum)) (pos5,5) ) 
-- __orig_z = z []

-- This is still doable.

__twoexample_isort x = __twoapp_isort true (0,x)
__twoapp_isort ctrt (posx,x) = app (__twocontracted_isort ctrt) posx x
__twocontracted_isort ctrt = assert "isort" ctrt funs
  where funs = fun (\x -> __isort x)
        __isort = (\f b xs -> __app_foldr true (10,f) (11,b) (12,xs)) (__contracted_insert true) []
        __example_insert x xs = __app_insert true (8,x) (9,xs)
        __app_insert ctrt (posx,x) (posxs,xs) = app (app (__contracted_insert ctrt) posx x) posxs xs
        __contracted_insert ctrt = assert "insert" ctrt funs
         where funs = fun (\x -> fun (\xs -> insert x xs))    
        __example_foldr f b xs = __app_foldr true (10,f) (11,b) (12,xs)
        __app_foldr ctrt (posf,f) (posb,b) (posxs,xs) = app (app ( app (__contracted_foldr ctrt) posf f) posb b) posxs xs
        __contracted_foldr ctrt = assert "foldr" ctrt funs
         where funs = fun (\f -> fun (\b -> fun (\xs -> foldr (\a b -> app (app f 13 a) 14 b) b xs)))

isBiggerThan_prop :: Enum a => Contract a
isBiggerThan_prop = PropInfo (\x -> fromEnum x > 5 ) (\p -> mkErrorMsg p "the number must be larger than five.")

isChar_prop :: Contract Char
isChar_prop = Prop (\x -> isAlphaNum x)

isInt_prop = Prop (\x -> x == fromInteger (round x))

isNat_prop = PropInfo (\x -> let n = fromEnum x
                             in x == n && n >= 0) (\p -> mkErrorMsg p "the number must always be a natural number.")

isSingleton = Prop (\xs -> length xs == 1)

mkErrorMsg p text = {- posInfoText p ++ -} {-"it does not fullfil the following property: "++ -}  text

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

silly_text f x = g n
 where g x = f x
       n = x


__contracted_s ctrt posinfo = 
 assertPos "At the application of the higher-order function 's'" (generatePositionData posinfo) ctrt funs
  where funs = (fun (\ __x21 -> (fun (\ __x22 -> __final_s (\ a0 -> (appParam __x21 (concat ["the application of the higher-order function 'g' ",(generatePositionData posinfo),". g has a function as its first argument."," The first argument of that function ",", namely ",show a0]) a0)) __x22))))

__app_s ctrt posinfo (posa,a) (posb,b) = 
 appParam (appParam (__contracted_s ctrt posinfo) (show a ++ generatePositionData posa) a) (show b ++ generatePositionData posb) b

__final_s f x = f x         

generatePositionData :: Maybe (Int,Int) -> String
generatePositionData (Just (l,c)) = "at line number " ++ show l ++ ", column number " ++ show c 
generatePositionData Nothing      = "at an unknown position"

__contracted_id ctrt posinfo argstrings =
 assertPos "At the application of the function 'id'" (generatePositionData posinfo) ctrt funs
  where funs = (fun (\x -> __final_id (x,argstrings !! 0)))
__final_id (x,posx) = x
__app_id ctrt posinfo (strx,posx,x) = appParam (__contracted_id ctrt posinfo [strx]) (strx ++ generatePositionData posx) x

example_s = __app_s true (Just (1,1)) (Just (1,5),__contracted_id (isNat_prop >-> true) (Just (2,3)) []) (Just (1,3), -5)


__contracted_r ctrt posinfo =
 assertPos "At the application of the higher-order function 'r'" (generatePositionData posinfo) ctrt funs
  where funs = (fun (\ __x21 -> (fun (\ __x22 -> __final_r (\ a0 -> (appParam __x21 (concat ["the application of the higher-order function 'r' ", (generatePositionData posinfo), ". The first argument of the function ",show __x21,", namely ",show a0]) a0)) __x22))))

__final_r f x = f x

__app_r
  :: (Show aT, Show bT) => Contract ((aT :-> bT) :-> aT :-> bT)
     -> Maybe (Int, Int)
     -> (Maybe (Int, Int), aT :-> bT)
     -> (Maybe (Int, Int), aT)
     -> bT
__app_r ctrt posinfo (posa,a) (posb,b) = 
 (appParam (appParam (__contracted_r ctrt posinfo) (show a ++ generatePositionData posa) a) (show b ++ generatePositionData posb) b)


example_r = __app_r true (Just (1,1)) (Just (1,5),__contracted_id (isNat_prop >-> true) (Just (2,3)) []) (Just (1,3), -5)

instance Show (aT :-> bT) where
	showsPrec _ a = showString "<function>"

-- In GHC, we could use the following for a Show instance.
--th_example = $(getStaticType '__final_r)

-- Random test.
blabla x | x == True = True
         | x == blabla x = False

-- (__app_foldr true (Just (2,5))) ((Just (2,11)),__contracted_const) [] 

-- Exercises.hs references "quickCheckTest = makeQuickCheckTest cfg modelCode", but this is commented out.
-- Property.hs defines makeQuickCheckTest, providing access to prop_main. However, this code does not seem updated yet
-- to use the Config record data type. This Config data type has a field 'properties' which holds all the properties.
-- We should be able to extract the properties from there, but we may have to rewrite the config system a bit so we can easily access the error messages. Currently, all things prefixed with prop_ are added to the code that is used for Quickcheck.
-- It shouldn't be hard to allow other prefixes as well so we can have something like:

-- ORIGINAL:
-- prop_Main = \xs -> whenFail (putStrLn "You have the incorrect answer") (palindrome (xs :: [Char]) == (reverse xs == xs))

-- MODIFIED (this would not be automated):
-- prop_Main = \xs -> whenFail (putStrLn error_Main) (property_Main xs)
-- error_Main = "You have the incorrect answer"
-- property_Main = \xs -> (palindrome (xs :: [Char]) == (reverse xs == xs))

-- prop_Main_Ctrt = Prop (\b -> b == (reverse xs == xs))

-- \res orig -> isOrdered res & isPerm res orig

-- Any QuickCheck properties of the form x .&&. y .&&. z may also have to be rewritten,
-- Or perhaps we need a way to generate both the QuickCheck property and the Contract from a slightly more abstracted definition.
-- For example x .&&&. y .&&&. z would generate both:
-- 1) x .&&. y .&&. z (QC Property)
-- 2) x  & y & z (And'ed Contract)


-- We could then use this info as follows:
-- prop_Main_Info = PropInfo property_Main (\p -> mkErrorMsg p error_Main)

-- Because QuickCheck can only say things about the result, we can generate a contract as such:
-- (PARAMETERS) >-> prop_Main_Info
-- (Remember, we have access to the type information of the function.)
-- Or, if we need a contract that also checks parameters, we can just reference prop_Main_Info.


-- Now, what if we have multiple inputs?
-- Example:
-- prop_Main = \xs i -> length xs > 0 && i >= 0 ==> prop_Length xs i .&&. prop_Elem xs i .&&. prop_Merge xs i

-- Hmm, we may need dependent contracts for this...
-- When a contracted function is applied to its arguments, every piece of the contract gets its argument and nothing more, except
-- if you use dependent functions.

-- Perhaps something like:
--Contract ([a] -> [a])
--is_permutation = true >>-> \i -> prop (\o -> null (o\\i)) 



-- Quick tests for something irrelevant
qtest f x y | __lam1 x y = f x
 where __lam1 = (\x y -> x == True)

qtest2 x =
    (__lam1)
    where
        __lam1 =
            \ y -> z x y
        z x y =
            ((__lam3) x) y
            where
                __lam3 =
                    \ n -> n

z x y =
    x y




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
           (fun (\x -> fun (\xs -> _badinsert x xs)))
         -- _insert :: Ord a => Contract (a :-> ([a] :-> [a])) -> a -> [a] -> [a]

_insert :: Ord a => a -> [a] -> [a]
_insert x []                   = [x]
_insert x (y:ys)  | x <= y     = x : y : ys
                  | otherwise  = y : _insert x ys

_badinsert :: Ord a => a -> [a] -> [a]
_badinsert x []                   = [x]
_badinsert x (y:ys)  | x > y     = x : y : ys -- Introduced bug here: x > y
                     | otherwise  = y : _badinsert x ys

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
