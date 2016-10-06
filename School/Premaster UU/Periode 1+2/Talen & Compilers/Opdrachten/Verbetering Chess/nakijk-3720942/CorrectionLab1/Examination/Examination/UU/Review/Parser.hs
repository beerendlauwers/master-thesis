module Examination.UU.Review.Parser where

import ParseLib.Abstract
import Examination.UU.Review.AST
import Examination.UU.Assignment.Parser

import Data.Char
import Data.List
import qualified Data.Map as Map

-- |* Whitespace parsers

-- | Parses all whitespace (including newline)
whitespace :: Parser Char String
whitespace = greedy $ satisfy isSpace

-- | Parses whitespace surrounding another parser
whitespaced :: Parser Char a -> Parser Char a
whitespaced p = pack whitespace p whitespace

-- | Parses whitespace without newlines
whitespace_nl :: Parser Char String
whitespace_nl = greedy $ satisfy (\x -> x == ' ' || x == '\t')

whitespaced_nl :: Parser Char a -> Parser Char a
whitespaced_nl p = pack whitespace_nl p whitespace_nl

-- | Parses at least 1 newline and all whitespace in between
newline   :: Parser Char String 
newline   = greedy1 (whitespace_nl *> symbol '\n') <* whitespace_nl

-- | Parses until the end of a line
untilEnd  :: Parser Char String
untilEnd  = greedy $ satisfy (/= '\n')

-- | Parses standard field types
parseField :: String -> Parser Char String
parseField t = takeWhile (not.isSpace) <$> token t *> whitespace *> symbol ':' *> whitespace *> untilEnd

pModality  :: Parser Char Modality
pModality  = whitespaced_nl $
        Positive <$ symbol '+'
   <|>  Negative <$ symbol '-'
   <|>  Neutral  <$ symbol '~'

pRemark :: Parser Char Remark
pRemark = whitespaced $ 
   Remark <$> pModality <*> untilEnd <*> pRemarkContent

pRemarkContent :: Parser Char [RemarkContent]
pRemarkContent = many $ pCode <|> pComment

pCode :: Parser Char RemarkContent
pCode = Code . intercalate "\n" <$> (many1 $ newline *> symbol '>' *> untilEnd)

pComment :: Parser Char RemarkContent
pComment = Comment . intercalate "\n" <$> (many1 $ newline *> symbol '%' *> untilEnd)

pQGrade :: Parser Char (String, QGrade)
pQGrade = whitespaced $       
    (\i g r -> (i, QGrade g r))
        <$ token "Question" 
        <* whitespace <*> pQuestionId
        <* whitespace <*  symbol ':' 
        <* whitespace <*> natural 
        <* whitespace <*> many pRemark

pQGrades :: Parser Char QGrades
pQGrades = Map.fromList <$> many pQGrade

pReview :: Parser Char Review
pReview = whitespaced $
        Review <$> pQGrades
        --parseField "Assignment" <* whitespace
--    <*> parseField "Reviewer"  <* whitespace
--    <*> parseField "Reviewee"  <* whitespace
     
    
parseFile = parse (pReview <* eof)
