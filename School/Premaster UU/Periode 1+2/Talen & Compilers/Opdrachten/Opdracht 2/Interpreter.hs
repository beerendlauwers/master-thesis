module Interpreter where

import Arrow
import Token
import Parser
import ParseLib.Abstract
import Control.Monad
import Data.List as L
import Data.Char
import qualified Data.Map as M

type Space = M.Map Pos Contents
type Size = Int
type Pos = (Int, Int)
data Contents = CEmpty | CLambda | CDebris | CAsteroid | CBoundary deriving (Show,Eq)

naturalNumbers = "start -> turn right, go, turn left, firstArg. turnAround -> turn right, turn right. return -> case front of Boundary -> nothing; _ -> go, return end. firstArg -> case left of Lambda -> go, firstArg, mark, go; _ -> turnAround, return, turn left, go, go, turn left, secondArg end. secondArg -> case left of Lambda -> go, secondArg, mark, go; _ -> turnAround, return, turn left, go, turn left end."
naturalSpace = fst $ head $ parse parseSpace "(4,14)\n\\\\\\\\\\..........\n...............\n\\\\\\\\\\\\\\........\n...............\n..............."
testArrowPrinter2 = putStrLn $ printArrow (0,0) HeadingRight naturalSpace

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

spaceTest = fst $ head $ parse parseSpace "(7,7)\n........\n....%...\n..%%%%..\n....%%%.\n...%%%..\n....%.%%\n....%%%%\n........"

-----
--7--
-----

testPrinter = putStrLn $ printSpace spaceTest
printSpace :: Space -> String
printSpace space = let ((maxX,maxY),_) = M.findMax space
                   in concatMap (\x -> rowToText x maxY) [0..maxX]
  where
    rowToText x y = concatMap toText (printRow x y) ++ "\n"
    toText x = simply $ lookup x contentsTable
    printRow len maxY = concatMap (\x -> simply $ M.lookup (len,x) space) [0..maxY]

testArrowPrinter = putStrLn $ printArrow (0,0) HeadingRight spaceTest
printArrow :: Pos -> Heading -> Space -> String
printArrow pos h space = let ((maxX,maxY),_) = M.findMax space
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
data Step = Done Space Pos Heading
            | Ok ArrowState
            | Fail String deriving (Show,Eq)

headings = [(HeadingUp,(1,0)),(HeadingDown,(-1,0)),(HeadingLeft,(0,-1)),(HeadingRight,(0,1))] 
directions = [((DirLeft,HeadingUp),HeadingLeft),((DirRight,HeadingUp),HeadingRight),
              ((DirLeft,HeadingDown),HeadingRight),((DirRight,HeadingDown),HeadingLeft),
              ((DirLeft,HeadingLeft),HeadingDown),((DirRight,HeadingLeft),HeadingUp),
              ((DirLeft,HeadingRight),HeadingUp),((DirRight,HeadingRight),HeadingDown)]
contentMapping = [(CEmpty,PatEmpty),(CLambda,PatLambda),(CDebris,PatDebris),(CBoundary,PatBoundary),(CAsteroid,PatAsteroid)]

generateProgram start input space = let env = toEnvironment input
                                        program = parseTest input
                                        commands = (head.simply) $ (lookup "start" program)
                                        state = ArrowState space start HeadingRight commands
                                    in (env,state)
                              
doSteps number (env,state) = let result = step env state
                             in if number == 0 
                                 then case result of
                                           (Ok newState) -> Just newState
                                           otherwise -> Nothing
                                 else case result of
                                           (Ok newState) -> doSteps (number-1) (env,newState)
                                           otherwise -> Nothing
                                           
testSteps x = doSteps x (generateProgram (3,5) goodInput spaceTest)

testStep = let (env,state) = generateProgram (3,5) goodInput spaceTest
           in step env state
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
  
  getHeading x = (head.simply) $ lookup x headings
  
  arrowIs h = let delta = getHeading h
              in if checkPosition (modify delta) == True
                       then Ok (ArrowState sp (modify delta) h cs)
                       else origStatePlus []
                         
  modify (x,y) = let (x1,y1) = pos in (x1+x,y1+y)
  checkPosition pos = case (inspectPosition pos) of
                           CBoundary -> False
                           CAsteroid -> False
                           otherwise -> True
  inspectPosition (x,y) = clamp $ M.lookup (x,y) sp
  clamp (Just x) = x
  clamp Nothing = CBoundary
  
  omNomNom = M.insert pos CEmpty sp
  
  markSpot = M.insert pos CLambda sp
  
  changeHeading x = case (lookup (x,h) directions) of
                            (Just dir) -> dir
                            otherwise  -> h -- Original direction
                            
  origStatePlus x = Ok (ArrowState sp pos h (x++cs))
  
  examineAlternatives content alts = searchAlternatives ((head.simply) $ lookup content contentMapping) alts
  
  searchAlternatives x alts = if lookup x alts == Nothing
                                then if lookup PatUnderscore alts == Nothing
                                       then Fail "No valid alternatives were found."
                                       else origStatePlus ((head.simply) $ lookup PatUnderscore alts)
                                else origStatePlus ((head.simply) $ lookup x alts)
                                
testInteractive = let (env,state) = generateProgram (3,5) goodInput spaceTest
                  in interactive env state
                  
testInteractive2 = let (env,state) = generateProgram (0,0) naturalNumbers naturalSpace
                   in interactive env state

interactive :: Environment -> ArrowState -> IO()
interactive env state = do result <- return (step env state)
                           case result of
                                (Done sp pos h) -> putStrLn $ printArrow pos h sp
                                (Ok (ArrowState sp pos h cs)) -> putStrLn $ printArrow pos h sp
                                (Fail x) -> putStrLn ("An error occurred: " ++ x)
                           newState <- case result of
                                         (Ok s) -> return (Just s)
                                         otherwise -> return Nothing
                           if newState == Nothing
                              then putStrLn "End of error"
                              else getInput newState

  where 
    getInput x = do putStrLn "Step again? (Y/N)"
                    answer <- getChar
                    case answer of
                         'Y' -> interactive env ((head.simply) x)
                         'N' -> putStrLn "Exiting driver."
                         'F' -> untilFinal env ((head.simply) x)
                         _ -> getInput x
                           
    untilFinal e x = do result <- return (step e x)
                        case result of
                             (Done sp pos h) -> putStrLn $ printArrow pos h sp
                             (Ok (ArrowState sp pos h cs)) -> putStrLn $ printArrow pos h sp
                             (Fail x) -> putStrLn ("An error occurred: " ++ x)
                        newState <- case result of
                                         (Ok s) -> return (Just s)
                                         otherwise -> return Nothing
                        if newState == Nothing
                           then putStrLn "End of Driver."
                           else untilFinal e ( (head.simply) newState)
                           
                                