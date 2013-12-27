{-# LANGUAGE GADTs  #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE TypeOperators #-}

module Probleem where

import Contract -- typed-contracts
import Data.Bifunctor

-- Datatype dat we gebruiken in onze ASTs.
data CContract
  = CArr CContract CContract
  | CProp String
  | CFunctor CContract CContract
  | CBifunctor CContract CContract CContract
  | CVar String
  | CQuant CContract CContract deriving (Eq, Ord)

data Subst = SId | SComp Subst Subst | SSubst CContract CContract deriving (Eq)

infixr 4 +->
(+->) :: CContract -> CContract -> Subst
(+->) = SSubst

-- Deze worden reeds gebruikt in typed-contracts, dus we maken ze net iets anders om duidelijk te maken dat het om andere functies gaat.
infixr 6 `co`
co :: Subst -> Subst -> Subst
co = SComp

infixr 4 ->->-
(->->-) :: CContract -> CContract -> CContract
(->->-) = CArr

infixr 4 -<@>-
(-<@>-) :: CContract -> CContract -> CContract
(-<@>-) = CFunctor

infixr 4 -<@@>-
(-<@@>-) :: CContract -> (CContract, CContract) -> CContract
o -<@@>- (il,ir) = CBifunctor o il ir

-- Enkele properties
ctrue = CProp "ctrue"
cord  = CProp "cord"
cnum  = CProp "cnum"
cchar = CProp "cchar"

-- Enkele variabelen, worden omgezet naar een contract dat altijd slaagt ('true' contract)
m13 = CVar "m13" 
m14 = CVar "m14" 
v17 = CVar "v17" 
v20 = CVar "v20" 
v5 = CVar "v5" 

-- Enkele functies die in de gegenereerde code zitten
generatePositionData :: Maybe (Int,Int) -> String
generatePositionData (Just (l,c)) = "at line number " ++ show l ++ ", column number " ++ show c 
generatePositionData Nothing      = "at an unknown position"

class Substitutable a where
  subst :: Subst -> a -> a
instance Substitutable CContract where
  subst SId             c           = c
  subst (SComp s1 s2)   c           = subst s1 (subst s2 c)
  subst (SSubst v c')   c | v == c  = c'
  subst s qc@(CQuant qv cs) = subst s cs
  subst s@(SSubst v _) (CQuant qv cs)
    | v == qv                       = CQuant qv cs
    | otherwise                     = CQuant qv (subst s cs)

  subst s  (CArr c1 c2)             = subst s c1 ->->- subst s c2
  subst s  (CFunctor co ci)         = CFunctor (subst s co) (subst s ci)
  subst s  (CBifunctor co ci1 ci2)  = CBifunctor (subst s co)
                                           (subst s ci1) (subst s ci2)
  subst _  c                        = c


-- Output van:
-- *Domain.FP.CodeGeneration.CodeGeneration> showGeneratedCode "f x = [x]\nz = (f 2, f 'a')" [] (DM.fromList [("z",ctrue <@@> (ctrue <@> cnum, ctrue <@> cchar))])
f x =
    [x]
__final_f substs x =
    [x]
__contracted_f substs ctrt posinfo = 
    assertPos "At the application of the function 'f'" (generatePositionData posinfo) ctrt funs
    where
        funs =
            (fun (\ __x01 -> __final_f substs __x01))
__app_f substs ctrt posinfo (posa
                            ,a) =
    (appParam (__contracted_f substs ctrt posinfo) (show a ++ generatePositionData posa) a)
z =
    ((__app_f (SId `co` (v5 +-> m13) `co` (m14 +-> cchar) `co` SId `co` (m13 +-> cnum) `co` (v17 +-> ctrue) `co` (v20 +-> ctrue)) (subst (SId `co` (v5 +-> m13) `co` (m14 +-> cchar) `co` SId `co` (m13 +-> cnum) `co` (v17 +-> ctrue) `co` (v20 +-> ctrue)) (v5 ->->- (v17 -<@>- v5))) (Just (2
                                                                                                                                                                                                                                                                      ,6))) (Nothing,2)
    ,(__app_f (SId `co` (v5 +-> m14) `co` (m14 +-> cchar) `co` SId `co` (m13 +-> cnum) `co` (v17 +-> ctrue) `co` (v20 +-> ctrue)) (subst (SId `co` (v5 +-> m14) `co` (m14 +-> cchar) `co` SId `co` (m13 +-> cnum) `co` (v17 +-> ctrue) `co` (v20 +-> ctrue)) (v5 ->->- (v17 -<@>- v5))) (Just (2
                                                                                                                                                                                                                                                                      ,11))) (Nothing,'a'))

{-
Als u deze module tracht te laden, zal u zien dat er een conversie tussen de twee contracttypes nodig is.
Dit is omdat het type van assertPos een Contract (aT :-> [aT]) verwacht, en geen CContract.
Bij de conversie zijn vooral de volgende conversies van belang:

Omzetten van niet-property contractvariabelen:
CVar x -> Prop (\ _ -> True)

Omzettten van property contractvariabelen. Deze kunnen we opzoeken in een environment:

CProp x -> lookup x propertyEnv
 where propertEnv = fromList [("cord",ord)]
 ord = Prop (\ x -> ordered x)
 ordered                 ::  (Ord aT) => [aT] -> Bool
 ordered []              =   True
 ordered [_]             =   True
 ordered (a1 : a2 : as)  =   a1 <= a2 && ordered (a2 : as)

Probleem is dat deze properties verschillende types zullen hebben! Ik dacht dat ik dit kon oplossen door de type parameter te verbergen, zoals in PropertyEnv te zien is hieronder.
-}

{-
Een naïeve conversiefunctie is de volgende:

type PropertyEnv = forall aT. DM.Map String (Contract aT)

convertContract :: forall aT. PropertyEnv -> CContract -> (Contract aT)
convertContract e (CArr c1 c2) = (convertContract e c1) >-> (convertContract e c2)
convertContract e (CProp s)  = fromJust (lookup s env)
convertContract e (CVar s _)   = Prop (\ _ -> True)
convertContract e (CFunctor o i) = (convertContract e o) <@> (convertContract e i) 
convertContract e (CBifunctor o il ir) = (convertContract e o) <@@> (convertContract e il, convertContract e ir)

Echter, omdat convertContract bij elke pattern match een ander contract teruggeeft, typecheckt dit niet.
-}

{-
Mijn volgende idee was typeclasses:

class ConvertContract aT where
 convert :: CContract -> (Contract aT)

instance ConvertContract aT where
 convert (CVar s _) = Prop (\ _ -> True)
 convert (CProp s) = fromJust $ lookup s testEnv

instance ConvertContract (aT :-> bT) where
 convert (CArr c1 c2) = (convert c1) >-> (convert c2)

instance Bifunctor f => ConvertContract (f aT bT) where
 convert (CBifunctor o il ir) = (convert o) <@@> (convert il,convert ir)

instance Functor f => ConvertContract (f aT) where
 convert (CFunctor o i) = (convert o) <@> (convert i) 

testEnv :: PropertyEnv
--testEnv = DM.fromList [("isBiggerThan_prop", CTRT.PropInfo (\x -> fromEnum x > 5 ) (\p -> "the number must be larger than five."))]
testEnv = DM.empty

Dit lijkt te werken als we testEnv even buiten beschouwing laten, en als we een expliciet type meegeven:

*Domain.FP.CodeGeneration.CodeGeneration> :t (convert (v5 ->->- (v17 -<@>- v5))) :: (Contract (aT :-> [aT]))
(convert (v5 ->->- (v17 -<@>- v5))) :: (Contract (aT :-> [aT]))
  :: Contract (aT :-> [aT])

Echter, of de correcte instanties worden gekozen weet ik niet.
Zelfs als dit perfect zou werken, is er nog steeds het probleem van de property environment:
Verschillende properties zullen verschillende types hebben, en het property environment gaat hier moeite mee hebben,
net zoals je in een lijst van Contract aT geen contract van (aT :-> bT) kan plaatsen.
Daarbovenop hebben sommige properties typeclass prerequisites die niet zullen gelden voor alle properties in de environment.
-}

{-
-- Hoe loste Jurriën dit allemaal op? --
Relatief simpel, hij printte gewoon de code zonder conversie. Hij hoefde immers geen conversie uit te voeren omdat hij
geen subsituties moest toepassen gedurende runtime; deze gebeurden allemaal statisch.
Na zijn substituties toe te hebben gepast, verving hij de overgebleven variabelen met ctrue (waar ctrue = Prop (\ _ -> True)).
De 'CProp's waren zelfs nog simpeler: de string is de naam van de property-functie. Geprint in de gegenereerde code, is er helemaal geen conversie nodig!

-- Waarom kan ik niet zoiets doen? --
Omdat ik gedurende runtime substituties moet toepassen. Ik doe dit om gecontracteerde polymorfe functies polymorf te houden.
Daarnaast kan het ook zijn dat een functie recursief is of andere functies aanroept: 
de generale contracten van deze functies moeten dan ook worden geüpdatet met de substituties.

Jurriën had een enkele globale set van substituties. Hierdoor offerde hij polymorfisme op, maar ontweek het conversieprobleem
door statisch de contracten te bepalen en deze in de gegenereerde code te plaatsen.

-- Welke oplossingen zijn er? --
Legio, maar ze vergen waarschijnlijk allemaal heel veel werk, of ze houden in dat ik functionaliteit inboet.

De simpelste oplossing is een enkele globale set van substituties behouden. Dit betekent dat een functiedefinitie zoals
z = (f 2, f 'a') slechts een correct contract zal genereren voor één van de applicaties van f.
Dit is zeer spijtig, maar een optie. Mijn enige resultaten zullen dan zijn dat ik contractinferentie voor de Helium AST heb en typed-contracts heb aangepast voor rijkere feedback. En het codegeneratiesysteem, natuurlijk.

Een andere oplossing is om geen GADT te gebruiken in typed-contracts die gebruik maakt van type parameters.
Ik weet niet of dit het probleem zal oplossen van de verschillende typeclass prerequisites in het property environment.

Alsnog een optie is iets zoals Template Haskell gebruiken om rond de conversie te geraken.
Ik denk dan met name aan de conversie van (CProp s) naar een echte property door de string 's' in het contract
te plaatsen gedurende runtime. Klinkt wel nogal onaangenaam.

Nog een optie (die het meeste werk zou vergen), is voor elke functie-applicatie een unieke set van de gecontracteerde
functies te genereren. Voor elke functie-applicatie zou dan een __app_, __contracted_ en __final_ worden gegenereerd
die in scope is gelimiteerde tot die ene functie-applicatie. Maar wat als die functie nog andere functies aanroept?
Dan moeten ook hun gecontracteerde versies worden geplaatst in die scope!
Met andere woorden, de gehele dependency chain van de gebruikte functies zou in de scope van die ene functie-applicatie
moeten worden geplaatst. Omdat we dan ons niet meer hoeven druk te maken over de polymorfie van de functies,
kunnen we de finale contracten statisch genereren en deze in de code te plaatsen.
Het nadeel is natuurlijk dat er zéér veel dubbele code zal worden gegenereerd voor zelfs triviale stukjes code. 

Indien er een oplossing kan worden gevonden voor de conversie van properties, denk ik dat het wel haalbaar is
om het huidige systeem te behouden.
Een specifieke type-annotatie voor een Contract (aT :-> [aT]), bijvoorbeeld, kan ik afleiden vanuit het originele
type van de toegepaste functie door gewoon -> te vervangen door :-> en in de code te printen, deze is immers ook polymorf.
Maar dan moet die typeclass die ik heb geschreven wel correct werken!

Als u verder nog ideeën heeft, hoor ik ze zeer graag, want ik zit een beetje vast. Ik kan gelukkig in ieder geval
verder werken aan mijn thesistext, zodat ik binnen enkele weken kan presenteren!
-}
