-- Beerend Lauwers
-- 3720942
-- Implemented bonuses: 12, 13.1-3, 14
-- Contains lots of test functions to play around with.

module Arrow where
import Token
import Parser
import ParseLib.Abstract
import Control.Monad
import Data.List as L
import Data.Char
import qualified Data.Map as M

-----
--4--
-----
-- In chapter 2.2, it is written that Happy is more efficient at parsing left-recursive rules
-- as they result in a constant stack-space parser, and "right-recursive rules require stack space
-- proportional to the length of the list being parsed". When a rule is left-recursive, the
-- corresponding list is in reversed order.
-- (Our) parser combinators are unable to process left-recursive rules, going into an infinite
-- loop instead.

-----
--5--
-----

-- Some test functions.
parseTest = parseArrow.lexArrow
goodInput = "start -> take, case front of  Debris -> go, start, turn right, turn right, go, turn right, turn right; _ -> nothing end, turn right, s2. s2 -> take, case front of Debris -> go, start, turn right, turn right, go, turn right, turn right; _ -> nothing end, turn right, s3. s3 -> take, case front of Debris -> go, start, turn right, turn right, go, turn right, turn right; _ -> nothing end, turn right, s4. s4 -> take, case front of Debris -> go, start, turn right, turn right, go, turn right, turn right; _ -> nothing end, turn right."
badInputStart = "begin -> take, case front of  Debris -> go, start, turn right, turn right, go, turn right, turn right; _ -> nothing end, turn right, s2. s2 -> take, case front of Debris -> go, start, turn right, turn right, go, turn right, turn right; _ -> nothing end, turn right, s3. s3 -> take, case front of Debris -> go, start, turn right, turn right, go, turn right, turn right; _ -> nothing end, turn right, s4. s4 -> take, case front of Debris -> go, start, turn right, turn right, go, turn right, turn right; _ -> nothing end, turn right."
badInputUndefRule = "start -> take, case front of  Debris -> go, start, turn right, turn right, go, turn right, turn right; _ -> nothing end, turn right, goToS2. s2 -> take, case front of Debris -> go, start, turn right, turn right, go, turn right, turn right; _ -> nothing end, turn right, s3. s3 -> take, case front of Debris -> go, start, turn right, turn right, go, turn right, turn right; _ -> nothing end, turn right, s4. s4 -> take, case front of Debris -> go, start, turn right, turn right, go, turn right, turn right; _ -> nothing end, turn right."
badInputDoubleRule = "start -> take, case front of  Debris -> go, start, turn right, turn right, go, turn right, turn right; _ -> nothing end, turn right, s2. s2 -> take, case front of Debris -> go, start, turn right, turn right, go, turn right, turn right; _ -> nothing end, turn right, s3. s3 -> take, case front of Debris -> go, start, turn right, turn right, go, turn right, turn right; _ -> nothing end, turn right, s4. s4 -> take, case front of Debris -> go, start, turn right, turn right, go, turn right, turn right; _ -> nothing end, turn right. s2 -> nothing."
badInputCase = "start -> take, case front of  Debris -> go, start, turn right, turn right, go, turn right, turn right; Asteroid -> nothing end, turn right, s2. s2 -> take, case front of Debris -> go, start, turn right, turn right, go, turn right, turn right; _ -> nothing end, turn right, s3. s3 -> take, case front of Debris -> go, start, turn right, turn right, go, turn right, turn right; _ -> nothing end, turn right, s4. s4 -> take, case front of Debris -> go, start, turn right, turn right, go, turn right, turn right; _ -> nothing end, turn right."
testRuleAlgebra = foldArrow rAlgebra (parseTest goodInput)
testCaseAlgebra = foldArrow cAlgebra (parseTest goodInput)
testSuite = map (check.parseTest) [goodInput,badInputStart,badInputUndefRule,badInputDoubleRule,badInputCase]

type ArrowAlgebra p r c d a x = ( ([r] -> p), (String -> [c] -> r), (Cmd -> c), (d -> c), (d -> [a] -> c), (String -> c),
                        (Direction -> d), (x -> [c] -> a), (Pat -> x) )

foldArrow :: ArrowAlgebra p r c d a x -> Program -> p
foldArrow (program, rule, cmdSimple, cmdTurn, cmdCase, cmdIdent,
           direction, alternative, pattern) = fProgram
 where
  fProgram list = program (map fRule list)
  fRule (s,cmds) = rule s (fCommands cmds)
  fCommands list = map fCommand list
  fCommand (CmdTurn dir) = cmdTurn (fDirection dir)
  fCommand (CmdCase dir alts) = cmdCase (fDirection dir) (map fAlternative alts)
  fCommand (CmdIdent s) = cmdIdent s
  fCommand cmd = cmdSimple cmd
  fDirection dir = direction dir
  fAlternative (pat,cmds) = alternative (pattern pat) (fCommands cmds)

-----
--6--
-----

check :: Program -> Bool
check p = let allRules = foldArrow rAlgebra p
              doubles = noDoubles p
              start = searchRules p "start"
              undefs = checkForUndefinedRules p allRules
              allCases = foldArrow cAlgebra p
              casesOK = and $ map (checkCase False) allCases
          in and [doubles,start,undefs,casesOK]
          
noDoubles :: Program -> Bool
noDoubles list@((s,r):xs) = if length (filter (\(x,_) -> x == s) list) > 1 
                             then False
                             else noDoubles xs
noDoubles [] = True

searchRules :: Program -> String -> Bool
searchRules list ident = let result = lookup ident list
                         in case result of
                                  (Just x) -> True
                                  Nothing  -> False
                            
checkForUndefinedRules :: Program -> [String] -> Bool
checkForUndefinedRules p list = and $ map (searchRules p) list

checkCase :: Bool -> (String,[Pat]) -> Bool
checkCase containsAllCatch (_,list) = checkCase' containsAllCatch list
 where
  checkCase' allCatch (x:xs) = if x == PatUnderscore
                                then checkCase' True xs
                                else checkCase' allCatch xs
  checkCase' allCatch [] = allCatch


-- Code for the rule Algebra          
addCommas x | x /= [] = x ++ ","
            | otherwise = x
listWithCommas _ = concatMap addCommas
rRule s xs = addCommas s ++ listWithCommas 0 xs

-- These functions clean up the original output a bit

-- Trims strings that are bigger than 1 to their first character
shorten list = map (\x -> if length x > 1 then head x : [] else x) list

split list@(l:ls) = let (x,(y:ys)) = span (/=',') list in x : split ys
split [] = []

-- This algebra creates a list of all the rules in the entire algebra.
rAlgebra = (nub.split.concat.shorten.group.concat, rRule, const [], const [],
            listWithCommas, id, id, listWithCommas, id )

-- This algebra creates a list of tuples (one tuple for each rule)
cAlgebra = (filter (\(_,list) -> if list == [] then False else True), (\s list -> (s, concat list)), const [], const [],
            (\_ x -> x), const [], id, const, id)
            

-- Begin of code for assignment 7
type Space = M.Map Pos Contents
type Size = Int
type Pos = (Int, Int)
data Contents = CEmpty | CLambda | CDebris | CAsteroid | CBoundary deriving (Show,Eq)

-- Some test data.
naturalNumbers = "start -> turn right, go, turn left, firstArg. turnAround -> turn right, turn right. return -> case front of Boundary -> nothing; _ -> go, return end. firstArg -> case left of Lambda -> go, firstArg, mark, go; _ -> turnAround, return, turn left, go, go, turn left, secondArg end. secondArg -> case left of Lambda -> go, secondArg, mark, go; _ -> turnAround, return, turn left, go, turn left end."
naturalSpace = fst $ head $ parse parseSpace "(4,14)\n\\\\\\\\\\..........\n...............\n\\\\\\\\\\\\\\........\n...............\n..............."
spaceTest = fst $ head $ parse parseSpace "(7,7)\n........\n....%...\n..%%%%..\n....%%%.\n...%%%..\n....%.%%\n....%%%%\n........"


simply (Just x) = [x]
simply Nothing = []

spaces = many (satisfy isSpace)

parseSpace :: Parser Char Space
parseSpace =
 do
  (mr, mc) <- parenthesised
              ( (,) <$> natural <* symbol ',' <*> natural) <* spaces
  -- read mr + 1 rows of mc + 1 characters
  css <- replicateM (mr + 1) (replicateM (mc + 1) contents)
  -- convert from a list of lists to a finite map representation
  return $ M.fromList $ concat $
          zipWith (\r cs ->
          zipWith (\c d  -> ((r,c),d)) [0..] cs) [0..] css
        
contents :: Parser Char Contents
contents = choice (L.map (\(f,c) -> f <$ symbol c) contentsTable) <* spaces
contentsTable :: [(Contents, Char)]
contentsTable = [(CEmpty, '.'), (CLambda, '\\'), (CDebris, '%'), (CAsteroid, 'O'), (CBoundary, '#')]
arrowTable = [(HeadingUp,'^'),(HeadingDown,'v'),(HeadingLeft,'<'),(HeadingRight,'>')]

-----
--7--
-----

-- Some test functions.
testArrowPrinter = putStrLn $ printSpace (0,0) HeadingRight spaceTest
testArrowPrinter2 = putStrLn $ printSpace (0,0) HeadingRight naturalSpace

-- Also prints the arrow itself!
printSpace :: Pos -> Heading -> Space -> String
printSpace pos h space = let ((maxX,maxY),_) = M.findMax space
                         in concatMap (\x -> rowToText x maxY) [0..maxX]
  where
    rowToText x y = printRow x y ++ "\n"
    toText x = simply $ lookup x contentsTable
    printRow len maxY = concatMap (\x -> checkContent len x) [0..maxY]
    
    checkContent x y = if (x,y) == pos then simply $ lookup h arrowTable
                                       else (toText.head.simply) $ M.lookup (x,y) space
    
    
-----
--8--
-----

-- Some test functions.
testEnvironment = toEnvironment goodInput
testEnvironment2 = toEnvironment naturalNumbers

type Environment = M.Map String Cmds
toEnvironment :: String -> Environment
toEnvironment s = let prog = parseArrow $ lexArrow s
                  in if check prog == True
                      then M.fromList prog
                      else error "This program is not valid."
                      
-----
--9--
-----
type Stack = Cmds
data ArrowState = ArrowState Space Pos Heading Stack deriving (Show,Eq)
data Heading = HeadingUp | HeadingDown | HeadingLeft | HeadingRight deriving (Show,Eq)
data Step = Done Space Pos Heading | Ok ArrowState | Fail String deriving (Show,Eq)

-- Maps a heading to a position difference from Arrow's position 
-- (For example: if he's heading up, he'll try and go to a lower row in the matrix)
headings = [(HeadingUp,(-1,0)),(HeadingDown,(1,0)),(HeadingLeft,(0,-1)),(HeadingRight,(0,1))]

-- Maps a desired direction and a current heading to a new heading.
directions = [((DirLeft,HeadingUp),HeadingLeft),((DirRight,HeadingUp),HeadingRight),
              ((DirLeft,HeadingDown),HeadingRight),((DirRight,HeadingDown),HeadingLeft),
              ((DirLeft,HeadingLeft),HeadingDown),((DirRight,HeadingLeft),HeadingUp),
              ((DirLeft,HeadingRight),HeadingUp),((DirRight,HeadingRight),HeadingDown)]
contentMapping = [(CEmpty,PatEmpty),(CLambda,PatLambda),(CDebris,PatDebris),(CBoundary,PatBoundary),(CAsteroid,PatAsteroid)]
                            
step :: Environment -> ArrowState -> Step
step env old@(ArrowState sp pos h []) = Done sp pos h
step env old@(ArrowState sp pos h (c:cs)) = examineCommand c
 where 
  examineCommand CmdGo = arrowIs h
  examineCommand CmdTake = Ok (ArrowState omNomNom pos h cs)
  examineCommand CmdMark = Ok (ArrowState markSpot pos h cs)
  examineCommand (CmdTurn x) = Ok (ArrowState sp pos (changeHeading x) cs)
  examineCommand (CmdCase dir alts) = let delta = getHeading (changeHeading dir)
                                      in examineAlternatives (inspectPosition $ modify delta) alts
  examineCommand CmdNothing = origStatePlus []
  examineCommand (CmdIdent x) = let result = M.lookup x env
                                in if result == Nothing
                                     then Fail ("The rule " ++ x ++ " was not found!")
                                     else origStatePlus ((head.simply) result)

  arrowIs h = let delta = getHeading h
              in if checkPosition (modify delta) == True
                       then Ok (ArrowState sp (modify delta) h cs)
                       else origStatePlus []
                         
  getHeading x = (head.simply) $ lookup x headings
  modify (x,y) = let (x1,y1) = pos in (x1+x,y1+y)
  checkPosition pos = case (inspectPosition pos) of
                           CBoundary -> False
                           CAsteroid -> False
                           otherwise -> True
  inspectPosition (x,y) = clamp $ M.lookup (x,y) sp
  clamp (Just x) = x
  clamp Nothing = CBoundary
  
  omNomNom = M.insert pos CEmpty sp -- Take
  
  markSpot = M.insert pos CLambda sp -- Mark
  
  changeHeading x = case (lookup (x,h) directions) of
                            (Just dir) -> dir
                            otherwise  -> h -- Original direction
                            
  origStatePlus x = Ok (ArrowState sp pos h (x++cs)) -- Add a list of commands to current list
  
  -- Given a Content, maps it to a Pat data type and then looks up that type in the provided alts list.
  -- Also tries the wildcard.
  examineAlternatives content alts = searchAlternatives ((head.simply) $ lookup content contentMapping) alts
  
  searchAlternatives x alts = if lookup x alts == Nothing
                                then if lookup PatUnderscore alts == Nothing
                                       then Fail "No valid alternatives were found."
                                       else origStatePlus ((head.simply) $ lookup PatUnderscore alts)
                                else origStatePlus ((head.simply) $ lookup x alts)


------
--10--
------
testMidRecursive = testInteractive "start -> turn right, start, turn right." spaceTest (0,0)
testTailRecursive = testInteractive "start -> turn right, start." spaceTest (0,0)
-- If you run the above functions and simulate a few steps (disable cutoff and image for a better overview),
-- you will notice that the first function's command stack will continue to grow, as the rules behind the
-- recursive rule will never be executed.
-- The other function's command stack will remain at a size between the full command stack of the "start" rule
-- and 1 (after which the last rule refers to "start" again and the whole cycle begins again). 

------
--11--
------

-- Test functions.
testInteractive input space pos = let (env,state) = generateProgram pos HeadingRight input space
                                  in interactive (AD env state 0 constructConfig)
-- Make sure to set image to off and stack cutoff to 0 when using these
testDebris = testInteractive goodInput spaceTest (3,5)
testNatural = testInteractive naturalNumbers naturalSpace (0,0)
                   
constructConfig = (Con 0 makeConfig (M.fromList []))
 where makeConfig = M.fromList [("image",(SetImage True)),("cutoff",(Cutoff 5)),("size",(PrintStack True))]

generateProgram :: Pos -> Heading -> String -> Space -> (Environment,ArrowState)
generateProgram start heading input space = let env = toEnvironment input
                                                program = parseTest input
                                                commands = (head.simply) $ (lookup "start" program)
                                                state = ArrowState space start heading commands
                                            in (env,state)

-- This code parses commands in the form of ":set CONFIG VALUE"
parseSet :: Parser Char ConfigItem
parseSet = noSpaces (token ":set") *> noSpaces parseConfigItem
 where
  parseConfigItem = parseSetImage <|> parseCutoff <|> parsePrintStack
  parsePrintStack = PrintStack <$ token "size" <*> noSpaces parseBoolean
  parseCutoff = Cutoff <$ token "cutoff" <*> noSpaces natural
  parseSetImage = SetImage <$ token "image" <*> noSpaces parseBoolean
  parseBoolean = const True <$> token "on" <|> const False <$> token "off"
  noSpaces x = spaces *> x <* spaces

-- Data types for the interactive driver.
data ArrowData = AD Environment ArrowState StepsLeft Configuration deriving (Show,Eq)
data Configuration = Con CurrentStep (M.Map String ConfigItem) (M.Map Int ArrowData) deriving (Show,Eq)
data ConfigItem = SetImage ShowImage | Cutoff Int | PrintStack Bool deriving (Show,Eq)
type StepsLeft = Int
type CurrentStep = Int
type ShowImage = Bool

-- This interactive driver can do the following:
-- Simulate 1 or more steps without user confirmation (bonus 13.2)
-- Display stack contents and stack size (bonus 13.1)
-- Continue simulation until an error occurs or a Done Step occurs
-- Set several configuration values.
-- Go back in execution.  (bonus 13.3)
-- Display some very silly references to a 1985 movie
interactive :: ArrowData -> IO()
interactive ad@(AD _ _ steps _) = if steps > 0 
                                     then doSingleStep ad
                                     else getInput ad

                                     
getParse p x = return $ filter (\(_,list) -> if list == [] then True else False) (parse p x)
toNatural x = getParse natural x
toSet x = getParse parseSet x
toNegativeInt x = getParse (negate <$ token "-" <*> natural) x


inputText = "\nOptions:\n1. Enter number of steps to simulate\n2. Press F to simulate until done\n3. Use :set command to set variables (type 'help' for usage)\n4. type 'stack' to view current stack and 'size' to view current stack size\n5. type 'image' to view image of current state.\n6. Press Q to quit."
helpText = "\nCommand usage:\n:set CONFIG VALUE\n\nList of commands:\nimage [on|off]\ncutoff [natural]\nsize [on|off]"

-- Requests input from the user.
getInput old@(AD env state steps con@(Con cur conf history)) = 
  do putStrLn inputText
     putStr "\n>>> "
     answer <- getLine
     parsedNegativeInt <- toNegativeInt answer
     parsedNatural <- toNatural answer
     parsedSet <- toSet answer
     if parsedNegativeInt /= []
        then backToTheFuture (cur+((fst.head) parsedNegativeInt)) old
        else if parsedNatural /= []
             then interactive (AD env state ((fst.head) parsedNatural) con)
             else if parsedSet /= []
                  then case (fst.head) parsedSet of
                            (SetImage b) -> updateConfig old "image" (SetImage b) "showImage"
                            (Cutoff x)   -> updateConfig old "cutoff" (Cutoff x) "stack cutoff length"
                            (PrintStack b) -> updateConfig old "size" (PrintStack b) "printing of stack size"                            
                  else case answer of
                            "help" -> do putStrLn helpText
                                         getInput old
                            "stack" -> do let cutoff = getCutoff conf
                                          if cutoff > 0 then do printStackContents state cutoff
                                                                getInput old
                                                        else do printStackContents state 5
                                                                getInput old
                            "image" -> case state of
                                           (ArrowState sp pos h _) -> do printImage sp pos h True
                                                                         getInput old
                            "size"  -> do printStackSize state True
                                          getInput old
                            "Q" -> putStrLn "Exiting driver."
                            "F" -> untilFinal old
                            _ ->   do putStrLn "Invalid input."
                                      getInput old

-- Given ArrowData, a key, value and some text to print out, updates the Configuration data
-- and requests new input from the user.
updateConfig (AD env state steps (Con cur conf history)) key value text = 
  do let newConfig = setConfig key value conf
     putStrLn ("Set " ++ text ++ " to " ++ showConfig value)
     getInput (AD env state steps (Con cur newConfig history))
  where showConfig (SetImage b) = show b
        showConfig (Cutoff x) = show x
        showConfig (PrintStack b) = show b
                            
getConfig key list = (head.simply) $ M.lookup key list
getCutoff list = case getConfig "cutoff" list of
                      (Cutoff x) -> x
getPrintStack list = case getConfig "size" list of
                          (PrintStack b) -> b
setConfig key value list = M.insert key value list 
                          
-- Does a step and monadizes it.
doStep env state = return $ step env state

-- Code for printing various information.
printStackSize (ArrowState _ _ _ cmds) p = if p == True then putStrLn ("Total stack size: " ++ (show.length) cmds) else return ()

printStackContents (ArrowState _ _ _ cmds) cutoff = 
 if cutoff > 0 then do putStrLn "Current stack: "
                       printStack cmds cutoff cutoff 
               else return ()
   where printStack (x:xs) c sh = if c > 0 
                                  then do putStrLn (show (sh-c+1) ++ ": " ++ show x)
                                          printStack xs (c-1) sh
                                  else return ()
         printStack [] _ _ = return ()

printResult :: Step -> ArrowData -> IO()
printResult (Done sp pos h) _ = printImage sp pos h True
printResult (Ok (ArrowState sp pos h _)) (AD _ _ _ (Con _ conf _)) = printImage sp pos h (getImage conf)
  where getImage list = case getConfig "image" list of
                             (SetImage b) -> b
printResult (Fail x) _ = putStrLn ("An error occurred: " ++ x)
printImage sp pos h img = if img == True then putStrLn $ printSpace pos h sp else return ()

-- Used to determine what action to undertake in the function below
analyseResult :: Step -> IO (String,(Maybe ArrowState))
analyseResult (Ok s) = return ("OK",Just s)
analyseResult (Done _ _ _) = return ("End of Driver.",Nothing)
analyseResult (Fail x) = return (x,Nothing)

-- Given ArrowData, simulates a step and prints relevant data.
-- Returns a tuple of information and a new (possible) ArrowState.
simulateStep :: ArrowData -> IO (String,(Maybe ArrowState))
simulateStep old@(AD env state steps con@(Con cur conf history)) = 
  do result <- doStep env state
     printStackContents state (getCutoff conf)
     printStackSize state (getPrintStack conf)
     putStrLn ("\nSimulating step " ++ show cur ++ ".")
     printResult result old
     analyseResult result
     
-- Executes a single step, and saves the new history so you can go back later.
doSingleStep old@(AD env state steps con@(Con cur conf history)) = 
  do (rType,newState) <- simulateStep old
     if newState == Nothing
        then putStrLn rType
        else do let newHistory = M.insert cur old history
                interactive (AD env ((head.simply) newState) (steps-1) (Con (cur+1) conf newHistory))
        
-- Continues execution of a state until an error or Done is encountered.
untilFinal old@(AD env state steps con@(Con cur conf history)) = 
  do (rType,newState) <- simulateStep old
     if newState == Nothing
        then putStrLn rType
        else untilFinal (AD env ((head.simply) newState) steps (Con (cur+1) conf history))

-- Goes back to a previous state. Here be drapuns    
backToTheFuture year old@(AD env state steps con@(Con cur conf history)) =
  if year < 0
   then do putStrLn "You have to go back... TO THE FUTURE!"
           getInput old
   else do let (AD env1 state1 steps1 (Con cur1 conf1 history1)) = (head.simply) $ M.lookup year history
           let backInTime = (AD env1 state1 0 (Con cur1 conf history1))
           putStrLn ("Going back to " ++ show (1985 + year))
           eightyEightMPH backInTime 
  where eightyEightMPH = interactive

------
--12--
------

main :: IO()
main = do putStrLn "Filename of program?"
          answerProg <- getLine
          putStrLn "Filename of space?"
          answerSpace <- getLine
          programText <- readFile answerProg
          spaceText <- readFile answerSpace
          heading <- readHeading
          position <- readPosition
          let space = fst $ head $ parse parseSpace spaceText
          let (env,state) = generateProgram position heading programText space
          interactive (AD env state 0 constructConfig)
          

readPosition :: IO Pos
readPosition = do putStrLn "Position of Arrow? (x,y)"
                  answer <- getLine
                  parsedAnswer <- return $ parse parseAnswer answer
                  case parsedAnswer of
                       [x] -> return $ fst $ head $ parsedAnswer
                       [] -> do putStrLn "Invalid position."
                                readPosition
                  
parseAnswer = parenthesised ( (,) <$> natural <* token "," <*> natural )
          
readHeading :: IO Heading
readHeading = do putStrLn "Heading? [up|down|left|right]"
                 answer <- getLine
                 case answer of
                      "up" -> return HeadingUp
                      "down" -> return HeadingDown
                      "left" -> return HeadingLeft
                      "right" -> return HeadingRight
                      _ -> do putStrLn "Invalid heading."
                              readHeading
  
------
--14--
------

-- Some test functions.
makeBatch pos heading input space = let (env,state) = generateProgram pos heading input space
                                    in batch env state
testBatch = makeBatch (3,5) HeadingRight goodInput spaceTest
testBatch2 = makeBatch (0,0) HeadingRight naturalNumbers naturalSpace

showFinalImage (x,y,z) = putStrLn $ printSpace y z x
showFinal = showFinalImage testBatch
showFinal2 = showFinalImage testBatch2

-- Executes a program until an error or a Done Step is encountered.
batch :: Environment -> ArrowState -> (Space,Pos,Heading)
batch env state =
 let result = step env state
 in case result of
        (Ok new@(ArrowState sp pos h _)) -> batch env new 
        (Done sp pos h) -> (sp,pos,h)
        (Fail x) -> error x