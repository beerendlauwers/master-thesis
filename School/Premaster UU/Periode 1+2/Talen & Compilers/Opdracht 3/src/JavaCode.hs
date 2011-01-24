module JavaCode where

import Prelude hiding (LT, GT, EQ)
import Data.Map as M hiding (map,filter,lookup)
import JavaLex
import JavaGram
import JavaAlgebra
import SSM
import Data.Char

data VariableType = Local | Argument deriving (Show,Eq)
type VarData = (Int,VariableType)
type Env = [(String,VarData)]
type EnvVars = Env -> (Code, [String])

data ValueOrAddress = Value | Address
  deriving Show

codeAlgebra :: JavaAlgebra Code 
                           Code 
                           EnvVars 
                           (ValueOrAddress -> Env -> Code)

codeAlgebra = ( (fClas)
              , (fMembDecl,fMembMeth)
              , (fStatDecl,fStatExpr,fStatIf,fStatWhile,fStatReturn,fStatBlock)
              , (fExprCon,fExprVar,fExprOp,fExprMethod,fExprIncr) 
              )
 where
 fClas       c ms     = [Bsr "main", HALT] ++ concat ms

 fMembDecl   d        = []
 getVarName (Decl _ (LowerId name) ) = name
 cleanUpFunction n = let minusN = negate n
                     in [ UNLINK, STS minusN, AJS (minusN+1), RET]
 fMembMeth   t m ps s = case m of
                          LowerId x -> let -- Construct arguments
                                           argumentLength = length ps
                                           offsetBy val = 0 + (3 - argumentLength + val)
                                           toData decl pos = (getVarName decl, (offsetBy pos, Argument))
                                           argList = zipWith toData ps [1..argumentLength]
                                           
                                           -- Construct locals
                                           toLocal name pos = (name, (pos, Local))
                                           localsList list = zipWith toLocal list [1..localsLength]
                                           (body, localVars) = s $ (localsList localVars) ++ argList
                                           localsLength = length localVars
                                        in [LABEL x, LINK localsLength, LDR MP] ++ body ++ cleanUpFunction argumentLength
                        
 fStatDecl   d        env = ([], [getVarName d])
 
 fStatExpr   e        env = (e Value env ++ [pop], [])
 
 fStatIf     e s1 s2  env = let c  = e Value env
                                (thenCode,thenVars) = s1 env
                                (elseCode,elseVars) = s2 env
                                n1 = codeSize thenCode
                                n2 = codeSize elseCode
                                allCode = c ++ [BRF (n1 + 2)] ++ thenCode ++ [BRA n2] ++ elseCode
                                allVars = thenVars ++ elseVars
                            in (allCode,allVars)
                            
 fStatWhile  e s1     env = let c = e Value env
                                (loopCode,loopVars) = s1 env
                                n = codeSize loopCode
                                k = codeSize c
                                allCode = [BRA n] ++ loopCode ++ c ++ [BRT (-(n + k + 2))] 
                            in (allCode,loopVars)
                            
 fStatReturn e        env = let isArgument x = case x of
                                                (_,(_,Argument)) -> True
                                                otherwise        -> False
                                argumentLength = length $ filter isArgument env
                                allCode = e Value env ++ [STR R3] ++ cleanUpFunction argumentLength
                            in (allCode, [])

 -- Got this function from Rutger.
 fStatBlock  ss      env = foldl merge ([],[]) $ map (\f -> f env) ss
                           where merge (a,b) (c,d) = (a++c,b++d)
 
 fExprCon    c        va env = case c of
                                ConstInt n -> [LDC n]
                                ConstBool b -> let boolean = if b == True then 1 else 0
                                               in [LDC boolean]
                                ConstChar x -> [LDC (ord x)]
 fExprVar    v        va env = case v of
                                LowerId x -> let (pos,vartype) = simply x $ lookup x env
                                             in  case va of
                                                  Value    ->  [LDL  pos]
                                                  Address  ->  [LDLA pos] 
 fExprOp     o e1 e2  va env = case o of
                                Operator "=" -> e2 Value env ++ [LDS 0] ++ e1 Address env  ++ [STA 0]
                                Operator (x:"=") -> let isAssignOp = elem x assignOps
                                                        actualOp = [x]
                                                    in if isAssignOp == True
                                                        then e2 Value env ++ e1 Value env ++ [getOp actualOp] ++ [LDS 0] ++ e1 Address env ++ [STA 0]
                                                        else otherOps (x:"=")
                                Operator op  -> otherOps op
                                where otherOps op = e1 Value env ++ e2 Value env ++ [getOp op]
                             
 fExprMethod na vars  va env = case na of
                                LowerId name -> concat [x va env | x <- vars] ++ [LDL 0, Bsr name, LDR R3]
                                
 fExprIncr var inc p  va env = let actualVar = var Value env
                                   opCode = case inc of Incrementor x -> x
                                   action = [opCodes ! [head opCode] ]
                                   extraCommand = case p of
                                                   LHS -> []
                                                   RHS -> [LDS 0]
                               in actualVar ++ [LDC 1] ++ extraCommand ++ action ++ var Address env ++ [STA 0]

assignOps = ['+','-','/','*','%','$']

simply :: String -> Maybe a -> a
simply _ (Just x) = x
simply search Nothing = error ("The variable " ++ search ++ " was not found in the environment!")

getOp :: String -> Instr
getOp op = if op `member` opCodes
            then opCodes ! op
            else error ("The operator " ++ op ++ " is not defined!")
      
opCodes :: Map String Instr
opCodes
 = fromList
     [ ( "+" , ADD )
     , ( "-" , SUB )
     , ( "*" , MUL )
     , ( "/" , DIV )
     , ( "%" , MOD )
     , ( "<=", LE  ) 
     , ( ">=", GE  )
     , ( "<" , LT  )
     , ( ">" , GT  )
     , ( "==", EQ  )
     , ( "!=", NE  )
     , ( "&&", AND )
     , ( "||", OR  )
     , ( "^" , XOR )
     ]

 
