module SAN where

import ParseLib.Abstract
import Char

{- 
Question 1: Data Structures
Basic one-to-one translation of the grammar, other solutions are possible. 
 *Pieces could also be represented by their corresponding characters.
 *File and Rank could be expressed explicitly using different cases.
-}
data Move = Move Piece DisAmbi Capture Square Promotion Check
          | QCastle
          | KCastle
          deriving (Eq)

data Piece = Rook
           | Bishop
           | Queen
           | King
           | Knight
           | Pawn
           deriving (Eq)

data DisAmbi = FileDisAmbi File
             | RankDisAmbi Rank
             | SquareDisAmbi Square
             | NoDisAmbi
             deriving (Eq)

data Capture = Cap | NoCap deriving Eq

data Square = Square File Rank
              deriving (Eq)

data Promotion = Promotion Piece
               | NoPromotion
               deriving (Eq)

data Check = Check
           | CheckMate
           | NoCheck
           deriving (Eq)

type Rank = Int
type File = Char

{-
Question 2: Parsing SAN
This is again a very straightforward translation of the grammar to a parser.
As semantic functions we use the datatype defined in Question 1.
-}
parseMove::Parser Char Move
parseMove = Move    <$> parsePiece <*> parseDisAmbi <*> parseCapture <*> parseSquare <*> parsePromotion <*> parseCheck
        <|> QCastle <$ token "O-O-O"
        <|> KCastle <$ token "O-O"


parsePiece::Parser Char Piece
parsePiece = Rook   <$ symbol 'R'
         <|> Bishop <$ symbol 'B'
         <|> Knight <$ symbol 'N'
         <|> King   <$ symbol 'K'
         <|> Queen  <$ symbol 'Q'
         <|> succeed Pawn

parseDisAmbi::Parser Char DisAmbi
parseDisAmbi = SquareDisAmbi <$> parseSquare
           <|> FileDisAmbi   <$> parseFile
           <|> RankDisAmbi   <$> parseRank
           <|> succeed NoDisAmbi

parseCapture::Parser Char Capture
parseCapture = Cap <$ symbol 'x'
            <|> succeed NoCap

parseSquare::Parser Char Square
parseSquare = Square <$> parseFile <*> parseRank

parsePromotion::Parser Char Promotion
parsePromotion = Promotion <$ symbol '=' <*> parsePiece
             <|> succeed NoPromotion

parseCheck::Parser Char Check
parseCheck = Check <$ symbol '+'
          <|> CheckMate <$ symbol '#'
          <|> succeed NoCheck

parseFile::Parser Char File
parseFile = satisfy (\x -> ord x > 96 && ord x < 105)

parseRank::Parser Char Rank
parseRank = digitToInt <$> satisfy (\x -> ord x > 47 && ord x < 57)

{-
Question 3: run
-}
run::Parser a b -> [a] -> b
run p i = case filter (null.snd) (parse p i) of
             [] -> error "No full parse results"
             (x:_) -> fst x

{-
Question 4: printMove
We define printMove by first creating instances for Show, this is convenient when
working with GHCI.
-}
instance Show Move where
         show (Move piece da cap sq prom chk) = show piece++show da ++ show cap++show sq++show prom++show chk
         show QCastle = "O-O-O"
         show KCastle = "O-O"

instance Show Piece where
         show Rook = "R"
         show Bishop = "B"
         show Knight = "N"
         show King = "K"
         show Queen = "Q"
         show Pawn = ""

instance Show DisAmbi where
         show (SquareDisAmbi sq) = show sq
         show (FileDisAmbi f) =[f]
         show (RankDisAmbi r) = show r
         show NoDisAmbi = ""

instance Show Capture where
         show Cap = "x"
         show NoCap = ""

instance Show Square where
         show (Square f r) = f:show r

instance Show Promotion where
         show (Promotion piece) = '=':show piece
         show NoPromotion = ""

instance Show Check where
         show Check = "+"
         show CheckMate = "#"
         show NoCheck = ""

printMove::Move->String
printMove=show

{-
Question 5: Tests
-}

doTest :: String -> String
doTest = printMove . run parseMove

goodTest = map doTest ["e4","Nf3xg5+","d7xe8=Q","Qa8=N"]
failTest = doTest "Nf3xp5+"

{-
Question 6: PromotionCheck
Make sure all cases are handled correctly, this is tricky when using a catch-all pattern
-}
promotionCheck::Move -> Bool
promotionCheck QCastle = True
promotionCheck KCastle = True
promotionCheck (Move _ _ _ _ NoPromotion _) = True
promotionCheck (Move Pawn _ _ (Square _ 8) (Promotion _) _) = True
promotionCheck (Move Pawn _ _ (Square _ 1) (Promotion _) _) = True
promotionCheck _ = False
