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
lexWhiteSpace = greedy (satisfy isSpace)

-- Task 6: Discard Java Comments

lexWhiteSpaceWithoutNewline :: Parser Char String
lexWhiteSpaceWithoutNewline = greedy (satisfy (\x -> isSpace x && (x /= '\n') ) )

lexSingleComment :: Parser Char String
lexSingleComment = pack (token "//") (lexWhiteSpaceWithoutNewline <* greedy (satisfy $ not.(=='\n')) ) (token "\n")

lexCommentBlock :: Parser Char String
lexCommentBlock = pack (token "/*") (many anySymbol) (token "*/")

lexComment = const [] <$> (lexCommentBlock <<|> lexSingleComment)

-- This is given to the lexicalScanner function
lexLines = concat <$> (greedy lexOneLine)

-- End Of Task 6

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
operators = ["+=","-=","+", "-", "*", "/", "%", "&&", "||",
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
lexicalScanner = lexLines

lexOneLine :: Parser Char [Token]
lexOneLine = (const [] <$> lexWhiteSpace <* lexComment) <<|> ( (:[]) <$ lexWhiteSpace <*> lexToken <* lexWhiteSpace)


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

