import Data.MultiSet (MultiSet)
import qualified Data.MultiSet as MS

combs :: Int -> MultiSet Person -> [MultiSet Person]
combs 0 ms = [MS.empty]
combs (n + 1) ms | ms == MS.empty = []
                 | otherwise = map (\set -> MS.insert firstElem set) (combs n restElems) ++ combs (n + 1) restElems
                               where firstElem = MS.findMin ms
                                     restElems = MS.difference ms (MS.singleton firstElem)
                                     
remdup :: MultiSet a -> MultiSet a
remdup ms = MS.fromSet (MS.toSet ms)

data Position = Links | Rechts deriving (Eq)
data Person = Father | Mother | Son | Daughter | Cop | Thief deriving (Eq, Ord, Show)

data River = River { links :: MultiSet Person, rechts :: MultiSet Person, schip :: Position } deriving (Eq)

instance Show River where
    show (River links rechts schip) = "\n" ++ "Links: " ++ show links ++ "\n" ++ "Rechts: " ++ show rechts ++ "\n"

config = MS.insert Thief( MS.insert Cop (MS.insertMany Daughter 2 ( MS.insertMany Son 2 ( (MS.insert Mother (MS.singleton Father) ) ) ) ) )

initial :: River 
initial = River { links = config, rechts = MS.empty, schip = Links }

desired :: River
desired = River { links = MS.empty, rechts = config, schip = Rechts }

isSolution :: River -> Bool
isSolution a = if a == desired then True else False

admissible :: River -> Bool
admissible (River li re sch) = admissible' li && admissible' re

admissible' :: MultiSet Person -> Bool
admissible' loc =
                 let
                  son = (MS.occur Son loc > 0)
                  dau = (MS.occur Daughter loc > 0)
                  fat = (MS.occur Father loc > 0)
                  mot = (MS.occur Mother loc > 0)
                  cop = (MS.occur Cop loc > 0)
                  thi = (MS.occur Thief loc > 0)
                 in if (( thi && not cop && MS.size loc > 1) ||
                        ( fat && dau && not mot ) ||
                        ( mot && son && not fat )) then False else True

isIn :: MultiSet Person -> Person -> Bool
isIn ms x = MS.member x ms
                                                      
raftadmissible :: MultiSet Person -> Bool
raftadmissible ms = if ((isIn ms Father && isIn ms Daughter) ||
                        (isIn ms Mother && isIn ms Son) ||
                        (isIn ms Thief && not (isIn ms Cop) ) ) then False else True

selectDrivers :: MultiSet Person -> MultiSet Person
selectDrivers ms =  MS.filter (\n -> n == Cop || n == Father || n == Mother) ms

--successors :: River -> [River]
--successors riv = filter admissible successors' riv

generateRafts :: River -> [MultiSet Person]
generateRafts (River li re sch) = if sch == Links then genRaft li ++ drivercombos li else genRaft re ++ drivercombos re
                                  where genRaft ms = [ MS.insert x (MS.singleton y) | x <- MS.toList (drivers ms), y <- MS.toList (MS.difference (remdup ms) (drivers ms)) ]
                                        drivercombos ms = combs 2 (drivers ms) ++ (map MS.singleton (MS.toList (drivers ms) ) )
                                        drivers ms = selectDrivers ms

goodRafts x = filter raftadmissible (generateRafts x) 

admissibleRivers :: River -> [River]
admissibleRivers riv = admissibleRivers' riv (goodRafts riv)

admissibleRivers' :: River -> [MultiSet Person] -> [River] 
admissibleRivers' (River li re sch) [] = []
admissibleRivers' (River li re sch) (x:xs) = if sch == Links
                                              then if admissible' (li MS.\\ x)
                                                    then River { links = (li MS.\\ x), rechts = MS.union x re, schip = Rechts } : admissibleRivers' (River li re sch) xs
                                                    else admissibleRivers' (River li re sch) xs
                                              else if admissible' (re MS.\\ x)
                                                    then River { links = MS.union x li, rechts = (re MS.\\ x), schip = Links } : admissibleRivers' (River li re sch) xs
                                                    else admissibleRivers' (River li re sch) xs
                                        
                                        

init1li = MS.insertMany Daughter 2 ( MS.insertMany Son 2 ( (MS.insert Mother (MS.singleton Father) ) ) )
init1re = MS.insert Thief( MS.insert Cop MS.empty)
--successors' :: River -> [River]
--successors' (River li re sch) =

testlol = MS.intersection config testen

testen = MS.insert Thief( MS.insert Cop (MS.insertMany Daughter 2 ( MS.insertMany Son 2 MS.empty ) ) )

testriver = River { links = testen, rechts = MS.insert Mother (MS.singleton Father), schip = Rechts }

badtestriver = River { links = MS.insert Thief( MS.insertMany Daughter 2 ( MS.insertMany Son 2 MS.empty ) ), rechts = MS.insert Mother (MS.singleton Father), schip = Rechts }