module Chess where

import ParseLib.Abstract

-- Basic types (Question 1)

data Move = Move Piece Disambiguation Capture Square Promotion Check
          | QueensideCastling
          | KingsideCastling
          deriving Eq

-- King, Queen, Rook, kNight, Biship, Pawn
data Piece = K | Q | R | N | B | P 
    deriving (Show, Enum, Bounded, Eq, Ord)

data PDisambiguation = File File
                     | Rank Rank
                     | Square Square
                     deriving Eq

data Check = Check | Checkmate | NoCheck
    deriving (Eq, Enum, Bounded)

type Disambiguation = Maybe PDisambiguation

data File = Fa | Fb | Fc | Fd | Fe | Ff | Fg | Fh 
    deriving (Eq, Show, Enum, Bounded)

data Rank = R1 | R2 | R3 | R4 | R5 | R6 | R7 | R8 
    deriving (Eq, Show, Enum, Bounded)

type Promotion = Maybe Piece
type Capture   = Bool
type Square    = (File, Rank)

-- Auxilary functions
enumAll :: (Bounded a, Enum a) => [a]
enumAll = enumFromTo minBound maxBound

boundedParser      :: (Bounded a, Enum a, Eq b) => (a -> [b]) -> Parser b a
boundedParser disp = choice [ x <$ token (disp x)  | x <- enumAll ] 

rSymbol     :: Eq a => a -> b -> Parser a b
rSymbol a b = b <$ symbol a

(<&>)   :: Parser a b -> Parser a c -> Parser a (b, c)
p <&> q =  (,) <$> p <*> q
 
infixl 4 <&>
 
-- Show only the second letter
dispRF :: Show a => a -> String
dispRF = (:[]) . head . tail . show

dispPiece :: Piece -> String
dispPiece P = ""
dispPiece x = show x

-- Exercise 2
-- The prefix p- for parsers is nice, but parse is a bit long
parseMove = pMove 

pMove :: Parser Char Move
pMove =  Move <$> pPiece <*> pDisambiguation <*> pCapture <*> pSquare <*> pPromotion <*> pCheck
     <|> QueensideCastling <$ token "O-O-O"
     <|> KingsideCastling  <$ token "O-O"
    where
        -- Disambiguation parser
        -- Note that there are two different implementations of pDisp
        -- used in this function, due to the two relevant instances.
        pDisambiguation =  optional $ 
                   File   <$> pDisp 
               <|> Rank   <$> pDisp
               <|> Square <$> pSquare

        pDisp      :: (Enum a, Bounded a, Show a) => Parser Char a
        pDisp      = boundedParser dispRF
        
        pPiece     = boundedParser dispPiece
        pSquare    = (,) <$> pDisp <*> pDisp
        pCapture   = rSymbol 'x' True <|> succeed False
        pPromotion = optional (symbol '=' *> pPiece) 
        pCheck     = boundedParser show

-- Exercise 3 (Executing a Parser)
run   :: Parser a b -> [a] -> b
run p = fst . ehead . filter (null . snd) . parse p where
  ehead xs = if null xs then error "Could not complete parse" else head xs

runMove :: String -> Move
runMove = run pMove

-- Exercise 4 (Printer)
printMove :: Move -> String
printMove = show

instance Show Move where
    show QueensideCastling              = "O-O-O"
    show KingsideCastling               = "O-O"
    show (Move piece dis cap sq pro ch) =
              dispPiece piece                           -- piece
           ++ dispMaybe dis                             -- disambiguation
           ++ (if cap then "x" else "")                 -- capture
           ++ dispRF (fst sq) ++ dispRF (snd sq)        -- square
           ++ maybe "" (\p -> "=" ++ dispPiece p) pro   -- promotion
           ++ show ch
        where 

instance Show PDisambiguation where
    show (File file)     = dispRF file
    show (Rank rank)     = dispRF rank
    show (Square square) = dispRF (fst square) ++ dispRF (snd square)

dispMaybe :: Show a => Maybe a -> String
dispMaybe = maybe "" show    

instance Show Check where
    show NoCheck   = ""
    show Check     = "+"
    show Checkmate = "#"
    
-- Exercise 6 (Promotions)
promotionCheck :: Move -> Bool
promotionCheck (Move piece _ _ (_, rank) promotion _)
  = maybe True (const $ piece == P && (rank == R1 || rank == R8)) promotion
promotionCheck _ 
  = True