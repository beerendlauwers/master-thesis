module JavaAlgebra where

import JavaLex
import JavaGram

type JavaAlgebra clas memb stat expr
  = (  ( Token -> [memb]                 -> clas
       )
    ,  ( Decl                            -> memb
       , Type -> Token -> [Decl] -> stat -> memb
       )
    ,  ( Decl                            -> stat
       , expr                            -> stat
       , expr -> stat -> stat            -> stat
       , expr -> stat                    -> stat
       , expr                            -> stat
       , [stat]                          -> stat
       )
    ,  ( Token                           -> expr
       , Token                           -> expr
       , Token -> expr -> expr           -> expr
       , Token -> [expr]                 -> expr
       , expr -> Token -> Position       -> expr
       )
    )


foldJava :: JavaAlgebra clas memb stat expr -> Class -> clas
foldJava ((c1),(m1,m2),(s1,s2,s3,s4,s5,s6),(e1,e2,e3,e4,e5)) = fClas
 where fClas (Class      c ms)     = c1 c (map fMemb ms)
       fMemb (MemberD    d)        = m1 d
       fMemb (MemberM    t m ps s) = m2 t m ps (fStat s)
       fStat (StatDecl   d)        = s1 d
       fStat (StatExpr   e)        = s2 (fExpr e)
       fStat (StatIf     e s1 s2)  = s3 (fExpr e) (fStat s1) (fStat s2)
       fStat (StatWhile  e s1)     = s4 (fExpr e) (fStat s1)
       fStat (StatReturn e)        = s5 (fExpr e)
       fStat (StatBlock  ss)       = s6 (map fStat ss)
       fExpr (ExprConst  con)      = e1 con
       fExpr (ExprVar    var)      = e2 var
       fExpr (ExprOper   op e1 e2) = e3 op (fExpr e1) (fExpr e2)
       fExpr (ExprMethod name vars)= e4 name (map fExpr vars)
       fExpr (ExprIncr   var inc p)= e5 (fExpr var) inc p
