module JavaCode where

import Prelude hiding (LT, GT, EQ)
import Data.Map as M
import JavaLex
import JavaGram
import JavaAlgebra
import SSM
import Data.Char

data ValueOrAddress = Value | Address
  deriving Show

codeAlgebra :: JavaAlgebra Code 
                           Code 
                           Code 
                           (ValueOrAddress -> Code)

codeAlgebra = ( (fClas)
              , (fMembDecl,fMembMeth)
              , (fStatDecl,fStatExpr,fStatIf,fStatWhile,fStatReturn,fStatBlock)
              , (fExprCon,fExprVar,fExprOp,fExprInc) 
              )
 where
 fClas       c ms     = [Bsr "main", HALT] ++ concat ms

 fMembDecl   d        = []
 fMembMeth   t m ps s = case m of
                          LowerId x -> [LABEL x] ++ s ++ [RET]
                        
 fStatDecl   d        = []
 fStatExpr   e        = e Value ++ [pop]
 fStatIf     e s1 s2  = let c  = e Value
                            n1 = codeSize s1
                            n2 = codeSize s2
                        in  c ++ [BRF (n1 + 2)] ++ s1 ++ [BRA n2] ++ s2
 fStatWhile  e s1     = let c = e Value
                            n = codeSize s1
                            k = codeSize c
                        in  [BRA n] ++ s1 ++ c ++ [BRT (-(n + k + 2))] 
 fStatReturn e        = e Value ++ [pop] ++ [RET]
 fStatBlock  ss       = concat ss
 
 fExprCon    c        va = case c of
                             ConstInt n -> [LDC n]
                             ConstBool b -> let boolean = if b == True then 1 else 0
                                            in [LDC boolean]
                             ConstChar x -> [LDC (ord x)]
 fExprVar    v        va = case v of
                             LowerId x -> let loc = 37
                                          in  case va of
                                                Value    ->  [LDL  loc]
                                                Address  ->  [LDLA loc] 
 fExprOp     o e1 e2  va = case o of
                             Operator "=" -> e2 Value ++ [LDS 0] ++ e1 Address  ++ [STA 0]
                             Operator op  -> e1 Value ++ e2 Value ++ getOpCode op

 fExprInc    op var   va = getOpCode op ++ fExprVar var

getOpCode :: Token -> Code
getOpCode op = let inOpCodes = op `member` opCodes
                   inOpLists = op `member` opLists
               in if inOpCodes == True
                   then [opCodes ! op]
                   else if inOpLists == True
                         then opLists ! op
                         else error "Opcode not found!"
                             
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
    
opLists :: Map String [Instr]
opLists
 = fromList
      [ ( "++", [LDC 1, ADD] )
      ]
