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
type Env = [(String,VarData)] -- [(Variabelenaam, (Plaats t.o.v. MP, Type))]
type EnvVars = Env -> (Code, [String])

--type Env = Map String VarData -- Mapt een variabelenaam naar zijn data


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
 cleanUpFunction n = let minusN = negate n  -- Gekregen van Rutger
                     in [ UNLINK, STS minusN, AJS (minusN+1), RET]
 fMembMeth   t m ps s = case m of
                          LowerId x -> let argumentLength = length ps
                                           offsetBy val = 0 + (3 - argumentLength + val)
                                           toData decl pos = (getVarName decl, (offsetBy pos, Argument))
                                           argList = zipWith toData ps [1..argumentLength] -- Maak lijst van argumenten
                                           --argMap = map (\(k,v) -> map insert k v) argList -- Steek ze in een map
                                           toLocal name pos = (name, (pos, Local))
                                           localsList list = zipWith toLocal list [1..localsLength]
                                           (body, localVars) = s $ (localsList localVars) ++ argList
                                           localsLength = length localVars
                                        in [LABEL x, LINK localsLength, LDR MP] ++ body ++ cleanUpFunction argumentLength
                        
 fStatDecl   d        env = ([], [getVarName d]) -- Geen code, wel lokale variabele gedeclareerd
 
 fStatExpr   e        env = (e Value env ++ [pop], []) -- 1 stukje code, geen declaratie
 
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

 fStatBlock  ss      env = foldl merge ([],[]) $ map (\f -> f env) ss -- Gekregen van Rutger
                           where merge (a,b) (c,d) = (a++c,b++d)
 
 fExprCon    c        va env = case c of
                                ConstInt n -> [LDC n]
                                ConstBool b -> let boolean = if b == True then 1 else 0
                                               in [LDC boolean]
                                ConstChar x -> [LDC (ord x)]
 fExprVar    v        va env = case v of
                                LowerId x -> let (pos,vartype) = env ? x
                                             in  case va of
                                                  Value    ->  [LDL  pos]
                                                  Address  ->  [LDLA pos] 
 fExprOp     o e1 e2  va env = case o of
                                Operator "=" -> e2 Value env ++ [LDS 0] ++ e1 Address env  ++ [STA 0]
                                Operator (x:"=") -> let isAssignOp = elem x assignOps
                                                        actualOp = [x]
                                                    in if isAssignOp == True
                                                        then e2 Value env ++ e1 Value env ++ [opCodes ! actualOp] ++ [LDS 0] ++ e1 Address env ++ [STA 0]
                                                        else otherOps (x:"=")
                                Operator op  -> otherOps op
                                where otherOps op = e1 Value env ++ e2 Value env ++ [opCodes ! op]
                             
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

simply :: Maybe a -> a
simply (Just x) = x
simply Nothing = error "Item not found!"

(?) :: Eq a => [(a,b)] -> a -> b
((a,b):ts) ? x | x==a      = b
               | otherwise = ts ? x
      
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

 
