module PGN(module SAN,module PGN) where

import SAN
import ParseLib.Simple
import Data.Char
import Data.Word

vb = "[Game \"Scholar's Mate\"]\n1. e4 e5 2. Bc4 Nc6 3. Qh5 Nf6 4. Qxf7# 1-0\n[Game \"Fool's Mate\"]\n1. f4 e6 2. g4 Qh4# 0-1"
vb2 = "1. e4 e5 2. Bc4 Nc6 3. Qh5 Nf6 4. Qxf7# 1-0"

{-
Question 7: PGN datatype
Again a fairly straightforward translation from the grammar
The grammar for elements is transformed into a list-structure, but this is of course optional
-}
newtype PGN = PGN [Game]

data Game = Game Tags MoveText deriving Eq

newtype Tag = Tag (String, String) deriving Eq
type Tags = [Tag]

data MoveText = MoveText Elements Termination deriving Eq

type Elements = [Element]

data Element = Element Number Move NAG
             | Variation Elements
	     deriving Eq

type Number = Word
type NAG = [Word]

data Termination = WhiteWins | BlackWins | Draw | NoEnd deriving Eq

{-
Question 8: PGN Parser
This solution splits the parsing of PGN into a lexing phase (recognize simple tokens and whitespace)
and a parsing phase (recognize overal structure).
-}
--Lexer

--Token definitions for the lexer, to be used as input for the parser
data Token = TSymbol String 
	   | TString String
	   | TNAG NAG
	   | TDots
	   | TWhiteWins | TBlackWins | TDraw | TNoEnd
	   | TParOpen | TParClose | TBrackOpen | TBrackClose
	   deriving (Eq, Show)

terminals = [(TParOpen, "("),
	     (TParClose, ")"),
	     (TBrackOpen, "["),
	     (TBrackClose, "]"),
	     (TWhiteWins, "1-0"),
	     (TBlackWins, "0-1"),
	     (TDraw, "1/2-1/2"),
	     (TNoEnd, "*")]
	  	  
lexTerminal :: Parser Char Token
lexTerminal = choice (map f terminals)
    where f (t,s) = t <$ token s

lexWhite::Parser Char String
lexWhite = greedy (satisfy isSpace)

lexChar::Parser Char Char
lexChar = satisfy (\x -> not ( x == '\"' || x == '"') && isPrint x)

lexLetter::Parser Char Char
lexLetter = satisfy isLetter

lexQuoted::Parser Char Char
lexQuoted = symbol '\\' *> satisfy isPrint

lexNAG::Parser Char Token
lexNAG = TNAG <$> (symbol '$' *> many (fromIntegral<$>newdigit))

lexString::Parser Char Token
lexString = TString <$> pack (symbol '"') (many (lexQuoted <|> lexChar)) (symbol '"')

lexSymbol::Parser Char Token
lexSymbol = TSymbol <$> ((:) <$> (lexLetter <|> digit) 
		<*> many (satisfy (\x -> any (\y -> y x) ([isLetter, isDigit] ++ map (==) "'+#=:-/"))))

lexDots::Parser Char Token
lexDots = TDots <$ many1 (satisfy (=='.'))

lexToken::Parser Char Token
lexToken = choice [lexTerminal,
		   lexSymbol,
		   lexNAG,
		   lexString,
		   lexDots]

lexPGN::Parser Char [Token]
lexPGN = lexWhite *> many (lexToken <* lexWhite)

--Parser

symbolParsable::Parser Char b -> Token -> Bool
symbolParsable p (TSymbol x) = fullParse p x
symbolParsable _ _ = False

parseMove2::Parser Token Move
parseMove2 = (\(TSymbol x) -> run parseMove x) <$> satisfy (symbolParsable parseMove)
		
parseNAG::Parser Token NAG
parseNAG = (\(TNAG x) -> x) <$> satisfy isNAG <|> succeed []
		where isNAG (TNAG _) = True
		      isNAG _ = False
 
parseString::Parser Token String
parseString = (\(TString x) -> x) <$> satisfy isString
		where isString (TString _) = True
		      isString _ = False

parseSymbol::Parser Token String
parseSymbol = (\(TSymbol x) -> x) <$> satisfy isSymbol
		where isSymbol (TSymbol _) = True
		      isSymbol _ = False

parseNumber::Parser Token Number
parseNumber = (\(TSymbol x) -> run (fromIntegral<$>natural) x) <$> satisfy (symbolParsable (many1 digit)) <* (symbol TDots <|> succeed undefined) <|> succeed 0

parseTermination::Parser Token Termination
parseTermination = (WhiteWins <$ symbol TWhiteWins)
		<|>(BlackWins <$ symbol TBlackWins)
		<|>(Draw <$ symbol TDraw)
		<|>(NoEnd <$ symbol TNoEnd)

parseElement::Parser Token Element
parseElement = (Element <$> parseNumber <*> parseMove2 <*> parseNAG)
	    <|>(Variation <$> pack (symbol TParOpen) parseElements (symbol TParClose))

parseElements::Parser Token Elements
parseElements = many parseElement

parseMoveText::Parser Token MoveText
parseMoveText = MoveText <$> parseElements <*> parseTermination

parseTag::Parser Token Tag
parseTag = Tag <$> pack (symbol TBrackOpen) ((\x y -> (x,y)) <$> parseSymbol <*> parseString) (symbol TBrackClose)

parseTags::Parser Token Tags
parseTags = many parseTag

parseGame::Parser Token Game
parseGame = Game <$> parseTags <*> parseMoveText

parseGames::Parser Token PGN
parseGames = PGN <$> many parseGame

parsePGN::Parser Char PGN
parsePGN v = let tokens = fst $ head $ lexPGN v 
	         pgn = fst $ head $ parseGames tokens
	     in [(pgn,"")]

--Print

instance Show Game where
	show (Game tags text) = concatMap show tags++show text

instance Show Tag where
	show (Tag (name, val)) = "\n["++name++" \""++showVal val++"\"]"
		where   valChar '\\' = "\\\\"
			valChar '\"' = "\\\""
			valChar x = [x]	
			showVal = concatMap valChar

instance Show MoveText where
	show (MoveText elements term) = concatMap show elements++show term

instance Show Element where
	show (Element num mov nag) = let numAdd = if num == 0 then " " else "\n"++show num++". "
					 nagAdd = if nag == [] then "" else " $" ++ concatMap show nag 
				     in numAdd++show mov++nagAdd
	show (Variation elements) = "("++concatMap (\ele -> show ele ++ "\n") elements++")"

instance Show Termination where
	show WhiteWins = "\n1-0"
	show BlackWins = "\n0-1"
	show Draw = "\n1/2-1/2"
	show NoEnd = "\n*"

instance Show PGN where
	show (PGN gms) = concatMap show gms

printPGN::PGN->String
printPGN = show

readPGN::FilePath -> IO PGN
readPGN path = do f <- readFile path
                  return (fst (head (parsePGN f)))

main = do pgn <- readPGN "Mate.pgn"
	  putStrLn (printPGN pgn)
