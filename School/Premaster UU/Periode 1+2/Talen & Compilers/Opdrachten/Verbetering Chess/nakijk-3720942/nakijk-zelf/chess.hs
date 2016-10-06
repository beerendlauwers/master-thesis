module Chess where

import ParseLib.Abstract
import Data.List
import Data.Char

main :: IO ()
main = do putStrLn "Filenaam? (q om te stoppen)"
          antwoord <- getLine
          case antwoord of
                        "q" -> return ()
                        x -> do result <- readPGN x
                                putStrLn (show result)
                                main

-------------------------------
-- CODE VOOR 1 ZET TE PARSEN --
-------------------------------

-- Data types
data Move = Move Piece Disambiguation Capture Square Promotion Check | O_O_O | O_O deriving (Show, Eq)
data Disambiguation = AFile File | ARank Rank | ASquare Square | NoDisamb deriving (Show, Eq)
data Piece = N | B | R | Q | K | P deriving (Show, Eq)
data Promotion = PromoteTo Piece | NoPromotion deriving (Show, Eq)
data Capture = Capture | NoCapture deriving (Show, Eq)
data Check = Mate | Checkmate | NoCheck deriving (Show, Eq)
data Square = Position File Rank deriving (Show, Eq)
data File = LocA | LocB | LocC | LocD | LocE | LocF | LocG | LocH deriving (Show, Eq)
data Rank = Zero | One | Two | Three | Four | Five | Six | Seven | Eight deriving (Show, Eq)

-- HULPFUNCTIES

-- Krijgt een lijstje van tuples (datatype,character) binnen en maakt er een parser van de volgende vorm van:
-- const datatype <$> symbol character <|> const datatype <$> symbol character <|> enz.
-- Op het einde wordt een laatste functie meegegeven die het rijtje afsluit.
manySymbol ((datatype,chr):xs) last = const datatype <$> symbol chr <|> manySymbol xs last
manySymbol [] last = last

-- Idem maar dan voor strings in plaats van chars.
manySymbol1 ((datatype,text):xs) last = const datatype <$> token text <|> manySymbol1 xs last
manySymbol1 [] last = last

tuple x y = (x,y)

-- Leest een enkele char en maakt er een string van
readChar x = (:[]) <$> satisfy x

parseMove :: Parser Char Move
parseMove = Move <$> parsePiece <*> 
                     parseDisamb <*> 
					 parseCapture <*> 
					 parseSquare <*> 
					 parsePromotion <*> 
					 parseCheck 
			<|> parseCastling
			
parseCastling = const O_O_O <$> token "O-O-O" <|> const O_O <$> token "O-O" :: Parser Char Move

parsePiece = manySymbol [(N,'N'),(B,'B'),(R,'R'),(Q,'Q'),(K,'K')] (succeed P) :: Parser Char Piece

parseDisamb = AFile <$> parseFile <|> ARank <$> parseRank <|> ASquare <$> parseSquare <|> succeed NoDisamb :: Parser Char Disambiguation

parseCapture = manySymbol [(Capture,'x')] (succeed NoCapture) :: Parser Char Capture

parseSquare = Position <$> parseFile <*> parseRank :: Parser Char Square

-- Dit soort lijstjes zijn handig voor de printfuncties
files = [(LocA,'a'),(LocB,'b'),(LocC,'c'),(LocD,'d'),(LocE,'e'),(LocF,'f'),(LocG,'g'),(LocH,'h')]
parseFile = manySymbol files failp :: Parser Char File

ranks = [(Zero,'0'),(One,'1'),(Two,'2'),(Three,'3'),(Four,'4'),(Five,'5'),(Six,'6'),(Seven,'7'),(Eight,'8')]
parseRank = manySymbol ranks failp :: Parser Char Rank

parsePromotion = PromoteTo <$ symbol '=' <*> parsePiece <|> succeed NoPromotion :: Parser Char Promotion

checks = [(Mate,'+'),(Checkmate,'#')] 
parseCheck = manySymbol checks (succeed NoCheck) :: Parser Char Check
															   
printMove :: Move -> String
printMove (Move pie dis cap sq pro ch) = printPiece pie ++ 
                                         printDisamb dis ++ 
										 printCapture cap ++
										 printSquare sq ++
										 printPromotion pro ++
										 printCheck ch
										 
printPiece P = ""
printPiece x = show x

printDisamb NoDisamb = ""
printDisamb (AFile x) = printFile x
printDisamb (ARank x) = printRank x
printDisamb (ASquare x) = printSquare x

printSquare (Position f r) = printFile f ++ printRank r
			  
printCapture NoCapture = ""
printCapture _ = "x" 
			   
printPromotion (PromoteTo x) = "=" ++ printPiece x
printPromotion _ = ""

printOut (Just x) = x:[]

printCheck NoCheck = ""
printCheck x = printOut (lookup x checks)
printFile x = printOut (lookup x files)  
printRank x = printOut (lookup x ranks)			

-------------------------------
-- CODE VOOR PROMOTION CHECK --
-------------------------------

promotionCheck :: Move -> Bool
promotionCheck (Move piece _ _ (Position f r) (PromoteTo x) _) = if piece == P && (r == One || r == Eight) then True else False
promotionCheck _ = True

---------------------------------
-- CODE OM PGN FILES TE PARSEN --
---------------------------------

run :: (Eq a) => Parser a b -> [a] -> b
run p input = let result = filter (\(_,rest) -> rest == []) (parse p input)
			  in if length result == 0 then error "Incorrect parse!"
			                           else fst (head result)
									   
-- Data types
type PGN = [Game]
data Game = GameContent Tags MoveText deriving (Show, Eq)
type Tags = Maybe [Tag]
type Tag = (Symbol, ChessString)
data MoveText = MoveContent Elements Termination deriving (Show, Eq)
data Elements = SingleElement Element Elements | Variation Element Elements | EndOfElements deriving (Show, Eq)
data Element = Element Number Move Nag  deriving (Show, Eq)
data Termination = OneZero | ZeroOne | Draw | Inconclusive deriving (Show, Eq)
type Number = Maybe (Int, Dots)
type Dots = Int

type Symbol = String
type ChessString = String
type Nag = Maybe Int
type Quoted = String
type Digit = Int
type Letter = Char
type Character = String

parsePGN :: Parser Char PGN
parsePGN = id <$> many parseGame

parseGame = GameContent <$> parseTags <*> parseMoveText :: Parser Char Game

parseTags = optional (greedy parseTag) :: Parser Char Tags
parseTag =  bracketed ( tuple <$> parseSymbol <*> parseString ) :: Parser Char Tag

parseSymbol = (++) <$> (parseLetter <|> parseDigit) <*> option parseRestSymbols "" :: Parser Char Symbol
parseRestSymbols = (++) <$> choice ([parseLetter,parseDigit] ++ map (token.(:[])) "_+#=:-/") <*> option parseRestSymbols "" :: Parser Char Symbol

parseDigit = show <$> natural :: Parser Char String
parseLetter = (:[]) <$> (satisfy isAlpha)

parseString = concat <$> quoted (many parseChessCharacter) :: Parser Char String
quoted p = pack (symbol '"') p (symbol '"')

terminators = [(OneZero,"1-0"),(ZeroOne,"0-1"),(Draw,"1/2-1/2"),(Inconclusive,"*")]
parseTermination = manySymbol1 terminators failp :: Parser Char Termination

parseElements :: Parser Char Elements
parseElements = SingleElement <$> parseElement <*> parseElements <|>
				Variation <$> (parenthesised parseElement) <*> parseElements <|>
				succeed EndOfElements

parseElement = Element <$> parseNumber <*> parseMove <*> parseNag :: Parser Char Element
parseNumber = optional ( tuple <$> natural <*> parseDots ) :: Parser Char Number
parseDots = length <$> greedy1 (symbol '.') :: Parser Char Dots
parseNag = optional (symbol '$' *> natural) :: Parser Char Nag

parseMoveText = MoveContent <$> parseElements <*> parseTermination :: Parser Char MoveText

parseChessCharacter = parseQuoted <|> parseCharacter :: Parser Char Character
parseCharacter = (:[]) <$> satisfy (\x -> x /= '\\' && x /= '"') :: Parser Char Character
parseQuoted = (++) <$> token "\\" <*> parseCharacter <|> token "\\\\" <|> token "\\" :: Parser Char Quoted

-----------------------------------
-- CODE OM PGN FILES IN TE LEZEN --
-----------------------------------
             
parseWhitespace :: Parser Char String
parseWhitespace = (++) <$> ( readTag <|> readAny <|> ignoreSpace ) <*> option parseWhitespace ""

ignoreSpace = const "" <$> (satisfy isSpace)
readAny = readChar (not.isSpace)

readTag = ( (\lb sym val rb -> lb ++ sym ++ val ++ rb) <$> readLeftBracket <*> parseSymbol <* ignoreManySpaces <*> readValue <*> readRightBracket )
readLeftBracket = readChar (=='[') 
readRightBracket = readChar (==']')
ignoreManySpaces = many (satisfy isSpace)

readValue = (\x y z -> x++y++z) <$> readQuote <*> (concat <$> many (parseChessCharacter <|> readSpace)) <*> readQuote
readQuote = readChar (=='\"')
readSpace = readChar isSpace

readPGN :: FilePath -> IO PGN
readPGN fp = do file <- readFile fp
                let cleanedFile = run parseWhitespace file
                return (run parsePGN cleanedFile)
			 
printPGN pgn = concat $ map printGame pgn
printGame (GameContent tags mt) = printTags tags ++ "\n" ++ printMoveText mt

printTags (Just tags) = concat $ map printTag tags
						where printTag (sym,str) = '\n' : '[' : sym ++ " " ++ show str ++ "]"
printTags _ = ""

printMoveText (MoveContent elems term) = printElements elems ++ printTermination term

printElements elems = case elems of
                          (SingleElement x xs) -> printElemensts' x xs
                          (Variation x xs) -> '(' : printElemensts' x xs ++ ")"
                          EndOfElements -> ""
                      where printElemensts' x xs = printElement x ++ printElements xs
                            printElement (Element nr mov nag) = '\n' : printNumber nr ++ printMove mov ++ printNag nag

printNumber (Just (nr,dots)) = show nr ++ replicate dots '.'
printNumber _ = ""

printNag (Just x) = ' ' : '$' : show x
printNag _ = ""

simply (Just x) = x
printTermination x = '\n' : simply (lookup x terminators)

--------------------------------------
-- CODE OM PGN FILES TE ONDERZOEKEN --
--------------------------------------

type Answers = (Int, (Float,Float), [(Int,Int)])
investigatePGN :: PGN -> Answers
investigatePGN pgn = (checkGameCount pgn, checkWinners pgn, [(16,16)])

checkGameCount :: PGN -> Int
checkGameCount pgn = length pgn

checkWinners :: PGN -> (Float,Float)
checkWinners pgn = countWinners (map checkWinner pgn) (0.0,0.0)
                   where checkWinner (GameContent _ (MoveContent _ t)) = checkTermination t
                         checkTermination x = case x of 
                                                   OneZero -> (1.0,0.0)
                                                   ZeroOne -> (0.0,1.0)
                                                   Draw -> (0.5,0.5)
                                                   _ -> (0.0,0.0)
                         countWinners ((x,y):xs) (tx,ty) = countWinners xs (tx+x,ty+y)
                         countWinners [] (tx,ty) = (tx,ty)

-- Niet af kunnen werken, spijtig :(
-- checkPieces :: Game -> (Int, Int)
-- checkPieces (GameContent _ (MoveContent elems _)) = countPieces (checkPieces' elems) (16,16)
                  -- where checkPieces' (SingleElement x xs) = checkElement x - checkElement xs
                        -- checkPieces' (Variation x xs) = checkElement x - checkElement xs
                        -- checkPieces' _ = (0,0)
                        -- checkElement (Element _ (Move _ _ cap _ _ _) _) = checkCapture cap
                        -- checkCapture x | x == Capture = (
                      
