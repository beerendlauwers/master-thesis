
Beerend Lauwers
3720942

Notes
-----
This assignment was made together with Dennis and Rutger, especially tasks 3, 4 and 5.

TASK ONE
Lexer:
- Added ConstChar Char to Token datatype [LINE 22]
- Added lexConstBool and lexConstChar string parsers [LINES 101-105]
- Added these parsers to lexToken [LINES 132-133]
- Added case isConst (ConstChar _) = True to sConst function [LINE 159]
Code:
- cases ConstBool (maps to 0 and 1) and ConstChar (maps to ASCII values) added. [LINES 83-85]

TASK TWO (This task is also indicated with comments in the code)
Parser:
- Created a function doPrecs, which takes a list of tuples of the form (String,ChainFunction) 
  and the start of the chain to produce a parser with proper priorities. [LINES 73-75]
- Added list of tuples of the form (String,ChainFunction) [LINES 77-84]
- Added support function pOp (given a string, creates a parser for an Operator token containing that string) [LINE 70]
- Added support function pOperList (creates a parser that can choose between a list of parsers for Operator tokens) [LINE 71]
- pExpr now uses the doPrecs function instead [LINE 68]

TASK THREE
Parser:
- Added ExprMethod Token [Expr] to Expr datatype [LINE 27]
- Added parser for this datatype to pExprSimple:  ExprMethod <$> sLowerId <*> parenthesised ( many pExpr ) [LINE 46]
Code:
- Added Environment declaration: type Env = [(String,Int)] [LINE 13]
- Added Environment to the code algebra
- Added definition for fExprMethod to code algebra [LINE 27]
- Added function fExprMethod [LINES 101-102]
- Added type EnvVars = Env -> (Code, [String]) 
- Changed code algebra type to use EnvVars for declarations
- Changed algebra functions to pass around the Environment
- Changed fExprVar function to lookup values in the Environment [LINE 87]
- Changed fMembMeth to insert arguments into SSM code [LINE 48]
- Added function getVarName that gets the name of a declaration [LINE 33]
Algebra:
- Added fold definition for ExprMethod [LINES 22 AND 42]

TASK FOUR
Code:
- Added cleanUpFunction function that does cleaning up of a function or method call [LINE 34]
- Added cleanUpFunction to fStatReturn [LINE 74]
- Added [RET R3] to fStatReturn [LINE 74]
- Added cleanUpFunction to fMembMeth [LINE 48]

TASK FIVE
Code:
- Added datatype VariableType = Local | Argument to be able to distinguish between arguments and local variables [LINE 11]
- Added type VarData = (Int,VariableType) [LINE 12]
- Changed EnvironMent to type Env = [(String,VarData)] [LINE 13] 
- Changed all statement functions to return a tuple of (Code,Code), with the second member containing all local variables
  + arguments and the first member all the rest of the code
- Changed fMembMeth to calculate all local variables and the rest of the code recursively [LINES 38-47]
- Changed fExprVar to accustom to new tuple return type, uses a lookup function that can detect undefined variables [LINES 87 AND 114-166]

TASK SIX (This task is also indicated with comments in the code)
Lexer:
- Added a lexer for whitespace except the \n character
- Added a lexer for single comments using the above lexer: 
  (token "//") (lexWhiteSpaceWithoutNewline <* greedy (satisfy $ not.(=='\n')) ) (token "\n")
- Added a lexer for comment blocks: 
  pack (token "/*") (many anySymbol) (token "*/"). Fun Fact: these comment blocks are nestable.
- Added a lexer for a single line that uses biased choice:
  (const [] <$> lexWhiteSpace <* lexComment) <<|> ( (:[]) <$ lexWhiteSpace <*> lexToken <* lexWhiteSpace)
- Added a lexer for all lines: lexLines = concat <$> (greedy lexOneLine)
- changed definition of lexicalScanner to lexicalScanner = lexLines [LINE 139]

TASK SEVEN (This task is also indicated with comments in the code)
Lexer:
- Added Incrementor String to Token datatype [LINE 18]
- Added list of Incrementors : incrementors = ["++","--"] [LINES 122-123]
- Added this list of Incrementors to be lexed using lexEnum in lexToken: lexEnum Incrementor incrementors [LINE 128]
- Added sIncrementor function that verifier if a Token is an Incrementor [LINES 168-171]
Parser:
- Added new datatype Position = LHS | RHS to distinguish between left-side and right-side Incrementors (they produce different code) [LINE 22]
- Added ExprIncr Expr Token Position to Expr datatype [LINE 28]
- Added pExprIncr parser that can parse Incrementors [LINES 54-57]
- Changed pExpr to use pExprIncr instead of pExprSimple (pExprIncr contains pExprSimple as an alternative) 
  to prevent left-recusiveness of the grammar [LINE 68]
Code:
- Added definition for fExprIncr to code algebra [LINE 27]
- Added function fExprIncr [LINES 104-110]
- Changed fExprOp to investigate the first element of an operator and look it up in a valid list of combined assigment operators. [LINES 93-97]
- [EXTRA] Changed opCodes ! op code to use function getOp, which displays an error if the operator is unknown [LINS 118-121]
Algebra:
- Added fold definition for ExprIncr [LINES 23 AND 43]