import Debug.Trace
import Data.MultiSet (MultiSet)
import qualified Data.MultiSet as MS
import Problem

combs :: Int -> Group -> [Group]
combs 0 ms = [MS.empty]
combs (n + 1) ms | ms == MS.empty = []
                 | otherwise = map (\set -> MS.insert firstElem set) (combs n restElems) ++ combs (n + 1) restElems
                               where firstElem = MS.findMin ms
                                     restElems = MS.difference ms (MS.singleton firstElem)
                                     
remdup :: MultiSet a -> MultiSet a
remdup ms = MS.fromSet (MS.toSet ms)

isIn :: (Ord a) => a -> MultiSet a -> Bool
isIn x ms = MS.member x ms

data RoseTree a = RoseLeaf | RoseNode a [RoseTree a]

instance Show (RoseTree a) where
	show (RoseLeaf) = "Leaf"
	show (RoseNode x (y:ys)) = "Node\n" ++ showTree y ys
	
showTree x [] = " " ++ (show x)
showTree x (y:ys) = " " ++ (show x) ++ (showTree y ys)

initialr :: River 
initialr = River { links = config, rechts = MS.empty, schip = Links }

desired :: River
desired = River { links = MS.empty, rechts = config, schip = Rechts }

isSolution :: River -> Bool
isSolution a = if a == desired then True else False

admissible :: River -> Bool
admissible (River li re sch) = admissible' li && admissible' re

hasFather = isIn Father
hasDaughter = isIn Daughter
hasSon = isIn Son
hasMother = isIn Mother
hasThief = isIn Thief
hasCop = isIn Cop

admissible' :: Group -> Bool
admissible' set =
                 let
                  son = hasSon set
                  dau = hasDaughter set
                  fat = hasFather set
                  mot = hasMother set
                  cop = hasCop set
                  thi = hasThief set
                 in if (( thi && not cop && MS.size set > 1) ||
                        ( fat && dau && not mot ) ||
                        ( mot && son && not fat )) then False else True


                                                      
admissibleRivers :: River -> [River]
admissibleRivers riv = admissibleRivers' riv (goodRafts riv)
                       where goodRafts x = filter raftadmissible (generateRafts x)
					   
raftadmissible :: Group -> Bool
raftadmissible set = if (( hasFather set && hasDaughter set) ||
                        (  hasMother set && hasSon set) ||
                        (  hasThief set && (not . hasCop) set ) ) then False else True

selectDrivers :: Group -> Group
selectDrivers ms =  MS.filter (\n -> n == Cop || n == Father || n == Mother) ms

generateRafts :: River -> [Group]
generateRafts (River li re sch) = if sch == Links then genRafts li else genRafts re
                                  where genRafts ms = genRaft ms ++ drivercombos ms
                                        genRaft ms = [ MS.insert x (MS.singleton y) | x <- MS.toList (drivers ms), y <- MS.toList (MS.difference (remdup ms) (drivers ms)) ]
                                        drivercombos ms = combs 2 (drivers ms) ++ (map MS.singleton (MS.toList (drivers ms) ) )
                                        drivers ms = selectDrivers ms

admissibleRivers' :: River -> [Group] -> [River] 
admissibleRivers' riv [] = []
admissibleRivers' (River links rechts sch) (x:xs) = if sch == Links
                                              then if links `zonder_X_en_X_met` rechts
                                                    then River { links = (links MS.\\ x), rechts = MS.union x rechts, schip = Rechts } : rest
                                                    else rest
                                              else if rechts `zonder_X_en_X_met` links
                                                    then River { links = MS.union x links, rechts = (rechts MS.\\ x), schip = Links } : rest
                                                    else rest
                                             where zonder_X_en_X_met s1 s2 = s1 `zonder` x && s2 `samenmet` x
                                                   zonder side x = admissible' (side MS.\\ x)
                                                   samenmet side x = admissible' (MS.union x side)
                                                   rest = admissibleRivers' (River links rechts sch) xs

		   
generateTree :: [River] -> River -> RoseTree River
generateTree prev x = RoseNode x (generateNode' prev (successors' prev x) )

generateNode' :: [River] -> [River] -> [RoseTree River]
generateNode' prev [] = [RoseLeaf]
generateNode' prev (x:xs) = RoseNode x [(generateTree (x:prev) x)] : generateNode' (x:prev) xs


searchTree :: Eq a => RoseTree a -> a -> Bool
searchTree (RoseLeaf) search = False
searchTree (RoseNode x (y:ys)) search = if x == search
                                        then True
										else True `elem` (searchTree' y ys search)

searchTree' :: Eq a => RoseTree a -> [RoseTree a] -> a -> [Bool]
searchTree' (RoseLeaf) [] search = [False]
searchTree' (RoseNode x (y:ys)) [] search = searchTree' y ys search
searchTree' (RoseNode x (y:ys)) (z:zs) search = if x == search
                                                 then [True]
												 else if True `elem` (searchTree' y ys search)
												       then [True]
													   else (searchTree' z zs search)

zoeken :: [River] -> [River] -> Bool
zoeken [] [] = trace ("Nope!") False
zoeken vorige [] = zoeken vorige (tail vorige) -- Ga 1 niveau omhoog!
zoeken vorige (x:xs) = if isSolution x
                          then True
						  else
                           let result = successors' (x:vorige) x
                           in if result == [] 
							   then zoeken (x:vorige) xs
						       else zoeken (x:vorige) result -- B. zoeken in resultaat, MET prevState van result

							   
successors' :: [River] -> River -> [River]
successors' prevStates riv = filter (\n -> not (n `elem` prevStates) ) (admissibleRivers riv)