module PGN(module SAN,module PGN) where

import SAN
import ParseLib.Abstract
import Data.Char
import Data.Word

{-
Question 7: PGN datatype
Again a fairly straightforward translation from the grammar
The grammar for elements is transformed into a list-structure, but this is of course optional
-}
newtype PGN   = PGN [Game] deriving Eq
data Game     = Game Tags MoveText deriving Eq
type Name     = String
type Value    = String
data Tag      = Tag Name Value deriving Eq
type Tags     = [Tag]
data MoveText = MoveText Elements Termination deriving Eq
type Elements = [Element]
data Element  = Element Number Move NAG
              | Variation Elements
              deriving Eq
type Number   = Maybe Integer
type NAG      = Maybe [Int]
data Termination = WhiteWins | BlackWins | Draw | NoEnd deriving Eq

{-
Question 8: PGN Parser
The solution given below is one without a lexer. 
For handling whitespace we parse all whitespace surrounding the lexical syntax. 
Other policies are of course possible.
-}
--Whitespace parsers
parseWhite::Parser Char String
parseWhite = greedy (satisfy isSpace)

--Parses whitespace surrounding another parser
whiteSpaced :: Parser Char a -> Parser Char a
whiteSpaced a = pack parseWhite a parseWhite


--Lexical syntax parsers
parseChar::Parser Char Char
parseChar = satisfy (\x -> not ( x == '\"' || x == '"') && isPrint x)

parseLetter::Parser Char Char
parseLetter = satisfy isLetter

parseQuoted::Parser Char Char
parseQuoted = symbol '\\' *> satisfy isPrint

parseNatural::Parser Char Integer
parseNatural = read <$> greedy1 digit

parseNAG::Parser Char NAG
parseNAG = whiteSpaced $ optional (symbol '$' *> greedy newdigit)

parseString::Parser Char String
parseString = whiteSpaced $ pack (symbol '"') (greedy (parseQuoted <|> parseChar)) (symbol '"')

parseSymbol::Parser Char String
parseSymbol = whiteSpaced $
        (:) 
        <$> (parseLetter <|> digit) 
        <*> greedy (satisfy (\x -> any (\y -> y x) ([isLetter, isDigit] ++ map (==) "'+#=:-/")))

--Grammar parsers

parseDots::Parser Char String
parseDots = greedy (satisfy (=='.'))

parseTermination::Parser Char Termination
parseTermination = whiteSpaced $
                   WhiteWins <$ token "1-0"
               <|> BlackWins <$ token "0-1"
               <|> Draw      <$ token "1/2-1/2"
               <|> NoEnd     <$ token "*"

parseNumber::Parser Char Number
parseNumber = whiteSpaced $ optional $ parseNatural <* parseWhite <* parseDots

parseElement::Parser Char Element
parseElement = Element   <$> parseNumber <*> parseMove <*> parseNAG
           <|> Variation <$> pack (whiteSpaced (symbol '(')) parseElements (whiteSpaced (symbol ')'))

parseElements::Parser Char Elements
parseElements = greedy parseElement

parseMoveText::Parser Char MoveText
parseMoveText = MoveText <$> parseElements <*> parseTermination

parseTag::Parser Char Tag
parseTag = pack (whiteSpaced (symbol '[')) (Tag <$> parseSymbol <*> parseString) (whiteSpaced (symbol ']'))

parseTags::Parser Char Tags
parseTags = greedy parseTag

parseGame::Parser Char Game
parseGame = Game <$> parseTags <*> parseMoveText

parseGames::Parser Char [Game]
parseGames = greedy parseGame

parsePGN::Parser Char PGN
parsePGN = PGN <$> parseGames

{-
Question 10: printPGN
We again use show instances for printing, the only tricky part is the escaping of
the strings in the output.
-}
instance Show Game where
    show (Game tags text) = concatMap show tags++show text

instance Show Tag where
    show (Tag name val) = "\n["++name++" \""++showVal val++"\"]"
        where --Add escaping again
              valChar '\\' = "\\\\"
              valChar '\"' = "\\\""
              valChar x = [x] 
              showVal = concatMap valChar

instance Show MoveText where
    show (MoveText elements term) = concatMap show elements++show term

instance Show Element where
    show (Element num mov nag) = 
                  let numAdd = maybe " " (\v -> "\n"++show v++". ") num
                      nagAdd = maybe " " (\v -> " $"++concatMap show v) nag
                  in numAdd ++ show mov ++ nagAdd
    show (Variation elements) = "(" ++ concatMap (\ele -> show ele ++ "\n") elements ++ ")"

instance Show Termination where
    show WhiteWins = "\n1-0"
    show BlackWins = "\n0-1"
    show Draw = "\n1/2-1/2"
    show NoEnd = "\n*"

instance Show PGN where
    show (PGN gms) = concatMap show gms

printPGN::PGN->String
printPGN = show

{-
Question 9: readPGN
This is easily defined using the run function from question 3.
-}
readPGN :: FilePath -> IO PGN
readPGN path = 
    do f <- readFile path
       return $ run parsePGN f

--Test whether parsing after printing works       
main = do pgn <- readPGN "Mate.pgn"
          print (run parsePGN . printPGN $ pgn)

{-
Question 11: querying functions
-}
gamesPlayed::PGN -> Int
gamesPlayed (PGN p) = length p

whiteWins::PGN -> Int
whiteWins (PGN p) = length $ filter wWin p
    where wWin (Game _ (MoveText _ WhiteWins)) = True
          wWin _ = False
          
blackWins::PGN -> Int
blackWins (PGN p) = length $ filter wWin p
    where wWin (Game _ (MoveText _ BlackWins)) = True
          wWin _ = False          

--Count the number of pieces with which white/black ended a game
endPieces :: Game -> (Int , Int)
endPieces (Game _ (MoveText eles _)) = snd $ foldl addMove (True, (16,16)) eles
  where addMove :: (Bool, (Int, Int)) -> Element -> (Bool, (Int , Int))
        addMove c              (Variation _)                      = c
        addMove (False, (w,b)) (Element _ (Move _ _ Cap _ _ _) _) = (True , (w-1,b))
        addMove (True , (w,b)) (Element _ (Move _ _ Cap _ _ _) _) = (False, (w  ,b-1))
        addMove (p    , v    ) _                                  = (not p, v)
        
allEndPieces::PGN -> [(Int,Int)]
allEndPieces (PGN gs) = map endPieces gs        
