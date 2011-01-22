module JavaLex where

import Data.Char
import Control.Monad
import ParseLib.Abstract
import Data.Char

data Token = POpen    | PClose        -- parentheses     ()
           | SOpen    | SClose        -- square brackets []
           | COpen    | CClose        -- curly braces    {}
           | Comma    | Semicolon
           | KeyIf    | KeyElse  
           | KeyWhile | KeyReturn 
           | KeyTry   | KeyCatch
           | KeyClass | KeyVoid
           | StdType   String         -- the 8 standard types
           | Operator  String         -- the 15 operators
           | UpperId   String         -- uppercase identifiers
           | LowerId   String         -- lowercase identifiers
           | ConstInt  Int
           | ConstChar Char
           | ConstBool Bool
           deriving (Eq, Show)

keyword :: String -> Parser Char String
keyword []                    = succeed ""
keyword xs@(x:_) | isLetter x = do
                                  ys <- greedy (satisfy isAlphaNum)
                                  guard (xs == ys)
                                  return ys
                 | otherwise  = token xs

greedyChoice :: [Parser s a] -> Parser s a
greedyChoice = foldr (<<|>) empty

terminals :: [(Token, String)]
terminals =
    [( POpen     , "("      )
    ,( PClose    , ")"      )
    ,( SOpen     , "["      )
    ,( SClose    , "]"      )
    ,( COpen     , "{"      )
    ,( CClose    , "}"      )
    ,( Comma     , ","      )
    ,( Semicolon , ";"      )
    ,( KeyIf     , "if"     )
    ,( KeyElse   , "else"   )
    ,( KeyWhile  , "while"  )
    ,( KeyReturn , "return" )
    ,( KeyTry    , "try"    )
    ,( KeyCatch  , "catch"  )
    ,( KeyClass  , "class"  )
    ,( KeyVoid   , "void"   )
    ]


lexWhiteSpace :: Parser Char String
--lexWhiteSpace = greedy (satisfy (\x -> isSpace x && (x /= '\n') ) )
lexWhiteSpace = greedy (satisfy isSpace)
lexWhiteSpaceWithoutNewline = greedy (satisfy (\x -> isSpace x && (x /= '\n') ) )

-- Doet nog altijd lastig
lexComment :: Parser Char String
lexComment = const "" <$> token "//" <* lexWhiteSpaceWithoutNewline <* greedy (satisfy $ not.(=='\n')) <* token "\n"

lexLowerId :: Parser Char Token
lexLowerId =  (\x xs -> LowerId (x:xs))
          <$> satisfy isLower
          <*> greedy (satisfy isAlphaNum)

lexUpperId :: Parser Char Token
lexUpperId =  (\x xs -> UpperId (x:xs))
          <$> satisfy isUpper
          <*> greedy (satisfy isAlphaNum)

lexConstInt :: Parser Char Token
lexConstInt = (ConstInt . read) <$> greedy1 (satisfy isDigit)

lexConstChar :: Parser Char Token
lexConstChar = ConstChar <$ symbol '\'' <*> satisfy isAlpha <* symbol '\''

lexConstBool :: Parser Char Token
lexConstBool = ConstBool True <$ token "true" <|> ConstBool False <$ token "false";

lexEnum :: (String -> Token) -> [String] -> Parser Char Token
lexEnum f xs = f <$> choice (map keyword xs)

lexTerminal :: Parser Char Token
lexTerminal = choice (map (\ (t,s) -> t <$ keyword s) terminals)

stdTypes :: [String]
stdTypes = ["int", "long", "double", "float",
            "byte", "short", "boolean", "char"]

operators :: [String]
operators = ["+", "-", "*", "/", "%", "&&", "||",
             "^", "<=", "<", ">=", ">", "==",
             "!=", "="]


lexToken :: Parser Char Token
lexToken = greedyChoice
             [ lexTerminal
             , lexEnum StdType stdTypes
             , lexEnum Operator operators
             , lexConstInt
             , lexConstBool
             , lexConstChar
             , lexLowerId
             , lexUpperId
             ]

lexicalScanner :: Parser Char [Token] 
--lexicalScanner = lexWhiteSpace *> greedy ( lexWhiteSpace *> lexComment `option` "" *> lexToken <* lexWhiteSpace <* lexComment `option` "" ) <* eof
lexicalScanner = lexWhiteSpace *> greedy (lexToken <* lexWhiteSpace) <* eof

lexicalScannerTest :: Parser Char [Token] 
lexicalScannerTest = lexWhiteSpace *> greedy ( lexComment *> lexToken <* lexWhiteSpace ) <* eof

lexOneLine :: Parser Char (Maybe Token)
--lexOneLine = (const Nothing <$> lexComment) `optional` (Just <$ lexWhiteSpace <*> lexToken <* lexWhiteSpace)
lexOneLine = (const Nothing <$> lexComment) <<|> (Just <$ lexWhiteSpace <*> lexToken <* lexWhiteSpace)   

--lexLines xs = let list = parse (greedy lexOneLine) xs
--                  filtered = filter (null.snd) list
--                  onlyTokens = filter (concat.toTokens.fst) filtered
--              in onlyTokens
              
toTokens (Just x) = [x]
toTokens Nothing = []

--lexLines :: Parser Char [Token]
--lexLines = filter (/=Nothing) <$> (greedy lexOneLine)

lexTokensOrComments = greedy (lexToken <* lexWhiteSpace) <* eof


--tests
test1 = parse lexicalScannerTest "//boolean testBoolean()\n//{\n\t//boolean b;\n\t//char c;\n\t//return true;\n//}\ntestenmaar"


sStdType :: Parser Token Token
sStdType = satisfy isStdType
       where isStdType (StdType _) = True
             isStdType _           = False

sUpperId :: Parser Token Token
sUpperId = satisfy isUpperId
       where isUpperId (UpperId _) = True
             isUpperId _           = False

sLowerId :: Parser Token Token
sLowerId = satisfy isLowerId
       where isLowerId (LowerId _) = True
             isLowerId _           = False

sConst :: Parser Token Token
sConst  = satisfy isConst
       where isConst (ConstInt  _) = True
             isConst (ConstChar _) = True
             isConst (ConstBool _) = True            
             isConst _             = False
             
sOperator :: Parser Token Token
sOperator = satisfy isOperator
       where isOperator (Operator _) = True
             isOperator _            = False
             

sSemi :: Parser Token Token
sSemi =  symbol Semicolon

