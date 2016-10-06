module PGN where

import ParseLib.Abstract
import Chess

import Data.Char
import Control.Monad

-- Exercise 7 (PGN files)

data PGN  = PGN [Game] deriving (Eq)

type Game = ([Tag], MoveText)
type Tag     = (TagName, String)
type TagName = String 
type Nag     = String

data MoveText  = MoveText Elements Termination deriving (Eq)

data Elements 
    = Cons Element Elements
    | Variation Elements Elements
    | Nil 
    deriving (Eq)

data Element = Element (Maybe (Int, Int)) Move (Maybe Nag) deriving (Eq)

data Termination = WhiteWon | BlackWon | Draw | Undecided
    deriving (Eq, Enum, Bounded)

instance Show Termination where
    show WhiteWon  = "1-0"
    show BlackWon  = "0-1"
    show Draw      = "1/2-1/2"
    show Undecided = "*"

{- In the code below, no lexer-parser distinction is made
   Although this might be slightly less elegant, it is
   easier to formulate, and allows for the full and 
   unchanges re-use of the parseMove-parser of the previous
   exercise -}   

 -- Exercise 8 (Parsing PGN files)
 
 -- Auxilary functions
spack        :: Eq a => a -> Parser a b -> a -> Parser a b
spack l p r  = pack (symbol l) p (symbol r)

swpack       :: Char -> Parser Char a -> Char -> Parser Char a
swpack l p r = whitespaced $ spack l (whitespaced p) r 
 
parens, whitespaced :: Parser Char a -> Parser Char a
whitespaced p = pack whitespace p whitespace
parens p      = whitespaced $ spack '(' (whitespaced p) ')'

wsymbol :: Char -> Parser Char Char
wsymbol = whitespaced . symbol

-- Whitespace parser, uses the comment parser of ex 12.
whitespace :: Parser Char ()
whitespace = () <$ greedy (satisfy isSpace) <|> comment
  
{- Parser for PGN datatype, makes use of the auxilary
   lexical symbols defined below -}      
parsePGN :: Parser Char PGN
parsePGN = PGN <$> many pGame where
    pGame        = many pTag <&> pMoveText  
    pTag         = swpack '[' (pSymbol <&> pString) ']'
    pMoveText    = MoveText <$> pElements <*> pTermination 

    pElements    =   Cons     <$> pElement <*> pElements
                <|> Variation <$> parens pElements <*> pElements
                <|> Nil       <$  whitespace

    -- Do note that the following three parsers contain lexical symbols
    -- and thusly are decorated with whitespace parsers
    pElement     = Element <$> optional pNumber <*> whitespaced pMove <*> optional pNag
    pNumber      = whitespace *> natural <&> (whitespaced $ length <$> greedy (wsymbol '.'))
    pTermination = whitespaced $ boundedParser show

-- Lexical symbols
pSymbol, pString, pQuoted :: Parser Char String
pSymbol  =  whitespaced $ (:) <$> satisfy isAlphaNum 
        <*> greedy (satisfy (\c -> isAlphaNum c || c `elem` "_+#=:-/"))
pString  =  whitespaced $ spack '"' (concat <$> greedy (pQuoted <|> ( (:[]) <$> pChar) )) '"' 
pQuoted  =  whitespaced $ (\x y -> [x,y]) <$> symbol '\\' <*> pChar 
        <|> token "\\\\" <|> token "\\\""

pNag     :: Parser Char Nag
pNag     =  whitespaced $ symbol '$' *> greedy (satisfy isDigit)

pChar :: Parser Char Char
pChar = satisfy (\c -> c /= '\\' && c /= '"') 

-- Bonus Exercise 12 (PGN Comments)
eol :: Parser Char ()
eol = () <$ symbol '\n'

comment  :: Parser Char ()
comment  = () <$ 
    (      symbol ';' <* greedy (satisfy (/= '\n')) <* (eol <|> eof)
       <|> symbol '{' <* greedy (satisfy (/= '}' )) <* symbol '}' )
       
-- Exercise 9 (Running the Parser on a PGN File)
readPGN :: FilePath -> IO PGN
readPGN = liftM (run parsePGN) . readFile

-- Exercise 10 (Printing PGN)
printPGN :: PGN -> String
printPGN = show

instance Show PGN where
    show (PGN games) = unlines $ map dispGame games where
        dispGame (tags, mText) = unlines (map dispTag tags) ++ "\n" ++ show mText 
        dispTag  (key, value)  = "[ " ++ key ++ " \"" ++ value ++ "\" ]"

instance Show MoveText where
    show (MoveText elts term) = show elts ++ " " ++ show term ++ "\n"

instance Show Elements where
    show (Cons el elts)  = show el ++ " " ++ show elts
    show (Variation l r) = "(\n" ++ show l ++ "\n)\n" ++ show r
    show Nil             = ""

instance Show Element where
    show (Element mNumber move mNag) 
      =  maybe "" (\(num, dots) -> show num ++ replicate dots '.' ++ " ") mNumber
      ++ show move
      ++ maybe "" ("$"++) mNag
      
-- Exercise 11 (Statistics on PGN)
gamesPlayed :: PGN -> Int
gamesPlayed (PGN games) = length games

countResults :: Termination -> PGN -> Int
countResults t (PGN games)    = length $ filter tWon games
   where tWon  (_, mText)     = tWon' mText
         tWon' (MoveText _ t') = t' == t 
         
blackWon = countResults BlackWon
whiteWon = countResults WhiteWon

-- Returns a list of tuples, each tuple represents the amount of pieces
-- that White and Black have left in the end.
pieceEventually :: PGN -> [ (Int, Int) ]
pieceEventually (PGN games)    = map capture games where
    capture (_, MoveText m _) = capture' m True
    -- Process the capture of piece throughout the match
    -- First argument is the game (Elements), second
    -- a bool where True -> White plays, False -> Black plays
    capture' Nil         _           = (16, 16)
    capture' (Cons move next) side   = 
        let
            Element _ move' _         = move
            Move _ _ c _ _ _          = move'
            update (w, b)  = if side then (w, change b) else (change w, b)
              where change = if c then pred else id
        in update $ capture' next (not side)
    capture' (Variation _ next) side = capture' next side