module Main (main) where
import Parser


-- OneRule :: R -> P -> P
-- EndOfProgram :: P
data Program = OneRule Rule Program | EndOfProgram
-- ARule :: I -> C
data Rule = ARule Identifier Cmds
-- ACmd :: F -> C -> C
-- EndOfCommands :: C
data Cmds = ACmd Cmd Cmds | EndOfCommands
-- CmdGo, CmdTake, CmdMark, CmdNothing :: F
-- CmdTurn :: D -> F
-- CmdCase :: D -> A -> F
-- CmdIdent :: String -> F
data Cmd = CmdGo | CmdTake | CmdMark | CmdNothing | CmdTurn Direction | CmdCase Direction Alts | CmdIdent String
-- DirLeft, DirRight, DirFront :: D
data Direction = DirLeft | DirRight | DirFront
-- AnAlt :: B -> A -> A
-- EndOfAlternatives :: A
data Alts = AnAlt Alt Alts | EndOfAlternatives
-- Alt :: T -> C -> B
data Alt = Alt Pat Cmds
-- All :: T
data Pat = PatEmpty | PatLambda | PatDebris | PatAsteroid | PatBoundary | PatUnderscore
-- Identifier :: String -> I
data Identifier = Identifier String


    

type ArrowAlgebra p r i c f d a b t = ( ( r -> p -> p ), p, ( i -> c ), ( f -> c -> c ), c, f, f, f, f, ( d -> f ),
                                        ( d -> a -> f ), ( String -> f ), d, d, d, ( b -> a -> a ), a, ( t -> c -> b ),
                                        t, t, t, t, t, t, ( String -> i ) )

foldArrow :: ArrowAlgebra p r i c f d a b t -> p
foldArrow (pOneRule, pProgEnd, rRule, cOneCmd, cCmdEnd, cmdGo, cmdTake, cmdMark, cmdNothing, cmdTurn, cmdCase,
           cmdIdent, dirLeft, dirRight, dirFront, altOneAlt, altEnd, aAlt, pPattern, ident) = fProgram
where
  fProgram (OneRule x xs) = pOneRule (fRule x) (fProgram xs)
  fProgram (EndOfProgram) = pProgEnd
  fRule (ARule s cmds) = rRule (fIdentifier s) (fCommands cmds)
  fCommands (ACmd x xs) = cOneCmd (fCommand x) (fCommands xs)
  fCommands (EndOfCommands) = cCmdEnd
  fCommand (CmdTurn dir) = cmdTurn (fDirection dir)
  fCommand (CmdCase dir alts) = cmdCase (fDirection dir) (fAlternatives alts)
  fCommand (CmdIdent s) = cmdIdent s
  -- Omdat de rest van de Cmds meestal geen onderscheid vergen, kan je id als cmdCmd meegeven, anders een echte functie die cases evalueert
  fCommand cmd = cmdCmd cmd
  fDirection (DirLeft) = dirLeft
  fDirection (DirRight) = dirRight
  fDirection (DirFront) = dirFront
  fAlternatives (AnAlt x xs) = altOneAlt (fAlternative x) (fAlternatives xs)
  fAlternatives (EndOfAlternatives) = altEndµ
  -- Idem bij deze pPattern, deze vervangt alle fPats
  fAlternative (Alt pat cmds) = aAlt (pPattern pat) (fCommands cmds)
  fPat (PatEmpty) = pEmpty
  fPat (PatLambda) = pLambda
  fPat (PatDebris) = pDebris
  fPat (PatAsteroid) = pAsteroid
  fPat (PatBoundary) = pBoundary
  fPat (PatUnderscore) = pUnderscore
  fIdentifier (Identifier s) = ident s
  
  cmdCmd :: Cmd -> c
  cmdCmd cmd = 
  
getAllRules :: 