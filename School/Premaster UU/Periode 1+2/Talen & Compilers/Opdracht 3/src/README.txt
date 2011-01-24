
Beerend Lauwers
3720942

Notes
-----
This assignment was made together with Dennis and Rutger, especially tasks 3, 4 and 5.

TASK ONE
Lexer:
- Added ConstChar Char to Token datatype
- Added lexConstBool and lexConstChar string parsers
- Added these parsers to lexToken
- Added case isConst (ConstChar _) = True to sConst function
Code:
- cases ConstBool (maps to 0 and 1) and ConstChar (maps to ASCII values) added.

TASK TWO (This task is also indicated with comments in the code)
Parser:
- Created a function doPrecs, which takes a list of tuples of the form (String,ChainFunction) and the start of the chain to produce a parser with proper priorities.
- Added support function pOp (given a string, creates a parser for an Operator token containing that string)
- Added support function pOperList (creates a parser that can choose between a list of parsers for Operator tokens)
- pExpr now uses the doPrecs function instead

TASK THREE
Parser:
- Added ExprMethod Token [Expr] to Expr datatype
- Added parser for this datatype to pExprSimple:  ExprMethod <$> sLowerId <*> parenthesised ( many pExpr )
Code:
- Added Environment declaration: type Env = [(String,Int)]
- Added Environment to the code algebra
- Added definition for fExprMethod to code algebra
- Added function fExprMethod
- Changed algebra functions to pass around the Environment
- Changed fExprVar function to lookup values in the Environment
- Changed fMembMeth to insert arguments into SSM code
Algebra:
- Added fold definition for ExprMethod

TASK FOUR
Code:
- Added cleanUpFunction function that does cleaning up of a function or method call
- Added cleanUpFunction to fStatReturn
- Added [RET R3] to fStatReturn
- Added cleanUpFunction to fMembMeth

TASK FIVE
Code:
- Added datatype VariableType = Local | Argument to be able to distinguish between arguments and local variables
- Added type VarData = (Int,VariableType)
- Changed EnvironMent to type Env = [(String,VarData)]
- Changed all statement functions to return a tuple of (Code,Code), with the second member containing all local variables + arguments and the first member all the rest of the code
- Changed fMembMeth to calculate all local variables and the rest of the code recursively
- Changed fExprVar to accustom to new tuple return type, uses a lookup function that can detect undefined variables

TASK SIX (This task is also indicated with comments in the code)
Lexer:
- Added a lexer for whitespace except the \n character
- Added a lexer for single comments using the above lexer: (token "//") (lexWhiteSpaceWithoutNewline <* greedy (satisfy $ not.(=='\n')) ) (token "\n")
- Added a lexer for comment blocks: pack (token "/*") (many anySymbol) (token "*/"). Fun Fact: these comment blocks are nestable.
- Added a lexer for a single line that uses biased choice:
(const [] <$> lexWhiteSpace <* lexComment) <<|> ( (:[]) <$ lexWhiteSpace <*> lexToken <* lexWhiteSpace)
- Added a lexer for all lines: lexLines = concat <$> (greedy lexOneLine)
- changed definition of lexicalScanner to lexicalScanner = lexLines

TASK SEVEN
Lexer:
- Added Incrementor String to Token datatype
- Added list of Incrementors : incrementors = ["++","--"]
- Added this list of Incrementors to be lexed using lexEnum in lexToken: lexEnum Incrementor incrementors
- Added sIncrementor function that verifier if a Token is an Incrementor
Parser:
- Added new datatype Position = LHS | RHS to distinguish between left-side and right-side Incrementors (they produce different code)
- Added ExprIncr Expr Token Position to Expr datatype
- Added pExprIncr parser that can parse Incrementors
- Changed pExpr to use pExprIncr instead of pExprSimple (pExprIncr contains pExprSimple as an alternative) to prefent left-recusiveness of the grammar
Code:
- Added definition for fExprIncr to code algebra
- Added function fExprIncr
- Changed fExprOp to investigate the first element of an operator and look it up in a valid list of combined assigment operators.
- [EXTRA] Changed opCodes ! op code to use function getOp, which displays an error if the operator is unknown
Algebra:
- Added fold definition for ExprIncr