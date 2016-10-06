module Chess where

import ParseLib.Abstract
import Data.Char
-- I've implemented bonus 12

--
-- Data types
--

-- Move data types 
data Move = Move Piece Disambiguation Capture Square Promotion Check | QueenCastleMove | CastleMove
    deriving (Show, Eq)
data Piece = Piece Char | NoPiece
    deriving (Show, Eq)
data Disambiguation = FileDis File | RankDis Rank | SquareDis Square | NoDis
    deriving (Show, Eq)
type Capture = Bool
data Square = Square File Rank
    deriving (Show, Eq)
data Promotion = Prom Piece | NoProm
    deriving (Show, Eq)
data Check = Check Char | NoCheck
    deriving (Show, Eq)
type File = Char
type Rank = Int

-- Game data types
data PGN = PGN [Game]
    deriving (Show, Eq)
data Game = Game [Tag] MoveText
    deriving (Show, Eq)
data Tag = Tag Name Value
    deriving (Show, Eq)
type Name = String
type Value = String
data MoveText = MoveText [Element] Termination
    deriving (Show, Eq)
data Element = Element (Maybe Number) Move (Maybe NAG) | Variation [Element]
    deriving (Show, Eq)
data Number = Number Natural Dots
    deriving (Show, Eq)
type Natural = Int
type Dots = Int
type NAG = String
data Termination = WhiteWonTerm | BlackWonTerm | DrawTerm | UnknownTerm
    deriving (Show, Eq)

--
-- General helper functions
--

-- Joins a list with a delimiter
join :: [a] -> [[a]] -> [a]
join del = foldr f []
    where
        f x [] = x
        f x y  = x ++ del ++ y

--
-- Parser helper functions
--

-- Parses any of the list tokens
anyOf :: (Eq a) => [a] -> Parser a a
anyOf = choice . map symbol

-- Parses one or more spaces greedily
spaces :: Parser Char String
spaces = greedy1 (satisfy isSpace)

-- Runs a parser and returns a result without reststring if available,
-- otherwise, it fails with an error
run :: Parser a b -> [a] -> b
run p s = solution $ parse p s
    where
        -- Returns solution without reststring or throws an error
        solution []          = error "Parsing failed!"
        solution ((r, []):_) = r
        solution (_:xs)      = solution xs

--
-- Move functions
--

-- Parses a move
parseMove :: Parser Char Move
parseMove = Move <$> parsePiece <*> parseDisambiguation <*> parseCapture
                 <*> parseSquare <*> parsePromotion <*> parseCheck
            <|>
            QueenCastleMove <$ token "O-O-O"
            <|>
            CastleMove <$ token "O-O"
    where
        -- Parses a piece
        parsePiece :: Parser Char Piece
        parsePiece = Piece <$> anyOf "NBRQK"
                     <|>
                     NoPiece <$ epsilon

        -- Parses a disambiguation
        parseDisambiguation :: Parser Char Disambiguation
        parseDisambiguation = FileDis <$> parseFile
                              <|>
                              RankDis <$> parseRank
                              <|>
                              SquareDis <$> parseSquare
                              <|>
                              NoDis <$ epsilon

        -- Parses a capture
        parseCapture :: Parser Char Capture
        parseCapture = True <$ symbol 'x'
                       <|>
                       False <$ epsilon

        -- Parses a square
        parseSquare :: Parser Char Square
        parseSquare = Square <$> parseFile <*> parseRank

        -- Parses a promotion
        parsePromotion :: Parser Char Promotion
        parsePromotion = Prom <$> (symbol '=' *> parsePiece)
                         <|>
                         NoProm <$ epsilon 

        -- Parses a check
        parseCheck :: Parser Char Check
        parseCheck = Check <$> anyOf "+#"
                     <|>
                     NoCheck <$ epsilon
        
        -- Parses a file
        parseFile :: Parser Char File
        parseFile = anyOf "abcdefgh"

        -- Parses a rank
        parseRank :: Parser Char Rank
        parseRank = digitToInt <$> anyOf "12345678"

-- Prints a move
printMove :: Move -> String
printMove (Move pi d ca s pr ch) = printPiece pi ++ printDisambiguation d ++ printCapture ca ++
                                   printSquare s ++ printPromotion pr ++ printCheck ch
    where
        -- Printing helper functions
        -- Uses the visitor pattern
        printPiece (Piece c) = [c]
        printPiece _         = ""
        
        printDisambiguation d =
            case d of
                FileDis   f -> printFile f
                RankDis   r -> printRank r
                SquareDis s -> printSquare s
                NoDis       -> ""
        
        printCapture b = if b then "x" else ""
        
        printSquare (Square f r) = printFile f ++ printRank r
        
        printPromotion (Prom p) = '=' : printPiece p
        printPromotion _        = ""
        
        printCheck (Check c) = [c]
        printCheck _         = ""
        
        printFile c = [c]
        printRank   = show
printMove QueenCastleMove = "O-O-O"
printMove CastleMove      = "O-O"

-- Checks whether a promotion of a move is valid
promotionCheck :: Move -> Bool
promotionCheck m =
    case m of
        -- Castle moves and no promotion moves are okay
        QueenCastleMove                            -> True
        CastleMove                                 -> True
        (Move _       _ _ _            NoProm   _) -> True
        
        -- Promotion moves are okay if they are done by a pawn
        -- and their target rank is 1 or 8
        (Move NoPiece _ _ (Square _ r) (Prom _) _) -> r `elem` [1, 8]
        
        -- Other moves are wrong
        _ -> False

doTest :: String -> String
doTest = printMove . run parseMove

goodTest = map doTest ["e4","Nf3xg5+","d7xe8=Q","Qa8=N"]
failTest = doTest "Nf3xp5+"
        
--
-- PGN functions
--

-- Parses a PGN Game
parsePGN :: Parser Char PGN
parsePGN = PGN <$> (del *> many parseGame)
    where
        -- Parses a game
        parseGame :: Parser Char Game
        parseGame = Game <$> many parseTag <*> parseMoveText
        
        -- Parses a tag
        parseTag :: Parser Char Tag
        parseTag = Tag <$> (symbol '[' *> del *> parseName) <*> (parseValue <* symbol ']' <* del)
        
        -- Parses a name
        parseName :: Parser Char Name
        parseName = ((:) <$> parseAlNum <*> many (parseAlNum <|> anyOf "_+#=:-/")) <* del
            where
                parseAlNum = satisfy isAlphaNum

        -- Parses a value (string)
        parseValue :: Parser Char Value
        parseValue =
            -- Note that greedy is used here to speed up things a bit
            (symbol '"' *> greedy (parseEscaped <|> parseOther) <* symbol '"') <* del
                where
                    -- A string consists of escaped printable characters
                    parseEscaped = symbol '\\' *> satisfy isPrint
                    
                    -- And other printable characters, not including \ and "
                    parseOther = satisfy $ \x -> isPrint x && (x `notElem` "\\\"")
        
        -- Parses a movetext
        parseMoveText :: Parser Char MoveText
        parseMoveText = MoveText <$> many parseElement <*> parseTermination
        
        -- Parses an element, which can also be a variation of elements
        parseElement :: Parser Char Element
        parseElement = Element <$>
                           optional parseNumber
                           <*>
                           parseMove <* del
                           <*>
                           optional parseNAG
                       <|>
                       Variation <$> (symbol '(' *> del *> many parseElement <* symbol ')' <* del)
        
        -- Parses a number
        parseNumber :: Parser Char Number
        parseNumber = Number <$> parseNatural <*> parseDots
        
        -- Parses a natural number
        parseNatural :: Parser Char Natural
        parseNatural = natural <* del
        
        -- Parses dots
        parseDots :: Parser Char Dots
        parseDots = length <$> many (symbol '.' <* del)

        -- Parses a NAG
        parseNAG :: Parser Char NAG
        parseNAG = symbol '$' *> many (satisfy isDigit) <* del
        
        -- Parses a termination
        parseTermination :: Parser Char Termination
        parseTermination = WhiteWonTerm <$ token "1-0" <* del
                           <|>
                           BlackWonTerm <$ token "0-1" <* del
                           <|>
                           DrawTerm <$ token "1/2-1/2" <* del
                           <|>
                           UnknownTerm <$ symbol '*' <* del
        
        -- Parses optional token delimiter
        del :: Parser Char [String]
        del = many $ spaces <|> parseComment
        
        -- Parses a comment
        parseComment :: Parser Char String
        parseComment =
            -- The single line comment greedily eats everything that is not a line ending
            symbol ';' *> greedy (satisfy $ flip notElem "\r\n")
            <|>
            -- Multiline comment parsing, nested comments are not allowed
            symbol '{' *> greedy (satisfy (/= '}')) <* symbol '}'

-- Reads a PGN file and tries to parse it
readPGN :: FilePath -> IO PGN
readPGN path = do
    content <- readFile path
    return $ run parsePGN content

-- Prints a PGN file
printPGN :: PGN -> String
printPGN (PGN gs) = join "\n\n" $ map printGame gs
    where
        -- Printing helper functions
        -- Uses the visitor pattern
        printGame (Game [] m) = tail $ printMoveText m
        printGame (Game ts m) = join "\n" (map printTag ts) ++ "\n\n" ++ tail (printMoveText m)
        
        printTag (Tag n v) = '[' : n ++ ' ' : show v ++ "]"
        
        printMoveText (MoveText [] t) = '\n' : printTermination t
        printMoveText (MoveText es t) = concatMap printElement es ++ "\n" ++ printTermination t
        
        -- Note that variations are shown on a single line (tail)
        printElement (Element nr m nag) = printNumber nr ++ printMove m ++ printNAG nag
        printElement (Variation es)     = "\n(" ++ unwords (map (tail . printElement) es) ++ ")"
        
        printNumber (Just (Number n d)) = '\n' : show n ++ replicate d '.' ++ " "
        printNumber Nothing             = " "
        
        printNAG (Just s) = " $" ++ s
        printNAG Nothing  = ""
        
        printTermination t = case t of
            WhiteWonTerm -> "1-0"
            BlackWonTerm -> "0-1"
            DrawTerm     -> "1/2-1/2"
            UnknownTerm  -> "*"

--
-- Semantic functions
--

-- Gets the amount of games played
nrOfGamesPlayed :: PGN -> Int
nrOfGamesPlayed (PGN gs) = length gs

-- Gets the amount of black wins
nrOfBlackWins :: PGN -> Int
nrOfBlackWins = nrOfTerminations BlackWonTerm

-- Gets the amount of white wins
nrOfWhiteWins :: PGN -> Int
nrOfWhiteWins = nrOfTerminations WhiteWonTerm

-- Generalised a termination count
nrOfTerminations :: Termination -> PGN -> Int
nrOfTerminations t (PGN gs) = sum $ map f gs
    where
        f (Game _ (MoveText _ t')) = if t' == t then 1 else 0

main = do pgn <- readPGN "Mate.pgn"
          putStrLn (show (getElements (firstOf pgn)))
          
firstOf :: PGN -> Game
firstOf (PGN (x:y:xs)) = x

getElements (Game _ (MoveText es _)) = concatMap capturesFromElement es
        
-- Calculates number of pieces left of both players
nrOfPiecesLeft :: Game -> (Int, Int)
nrOfPiecesLeft (Game _ (MoveText es _)) =
    -- Concat list of captures and start with 16 pieces and a white move
    countPieces (16, 16) True $ concatMap capturesFromElement es

            -- Converts a game element to a list of captures
capturesFromElement (Element _ (Move _ _ c _ _ _) _) = [c]
capturesFromElement _                                = []
            
            -- This function walk through captures, and
            -- counts the pieces of both players in a tuple
            -- wm boolean indicates whether it is white his turn
countPieces (w, b) wm (True:cs) = countPieces (if wm then (w, b - 1) else (w - 1, b)) (not wm) cs
countPieces c      wm (_:cs)    = countPieces c (not wm) cs
countPieces c      wm []        = c
