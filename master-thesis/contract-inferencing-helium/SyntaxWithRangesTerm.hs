{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE FlexibleContexts #-}

{-# LANGUAGE FunctionalDependencies #-}
{-# OPTIONS -fno-warn-name-shadowing #-}

module Domain.FP.SyntaxWithRangesTerm where

import Control.Monad
import Common.Environment
import Common.Rewriting.Term
import Common.View
import Data.Char
import GHC.Float
import Test.QuickCheck
import Data.Generics.Uniplate.Direct


-- | Symbols do not allow for capitals. We replace capitals by the corresponding
--   lower case letter with a preceding '-' character. A dash character is not 
--   allowed in constructor names.
constrToSym :: String -> Symbol
constrToSym = 
    newSymbol . foldr (\c cs -> if isUpper c then '-' : c : cs else c :cs) []

symToConstr :: Symbol -> String
symToConstr = 
    foldr (\c cs -> if c == '-' then capitalise cs else c:cs) [] . show
  where
    capitalise []     = []
    capitalise (x:xs) = toUpper x : xs

constrView :: View String Symbol
constrView = makeView (Just . constrToSym) symToConstr

genConstr :: Gen String
genConstr = liftM2 (:) capital (listOf (oneof [letter, capital, return '_']))
  where
    capital = choose ('A', 'Z')
    letter  = choose ('a', 'z')

testConstrView :: IO ()
testConstrView = quickCheck $ propSoundness (==) genConstr constrView

-- AG: I think some arity-generic programming would help here
fromCon1 :: (MonadPlus m, IsTerm a) 
         => (a -> b) -> Term -> m b
fromCon1 cons = liftM cons . fromTerm

fromCon2 :: (MonadPlus m, IsTerm a, IsTerm b) 
         => (a -> b -> c) -> Term -> Term -> m c
fromCon2 cons x y = liftM2 cons (fromTerm x) (fromTerm y)

fromCon3 :: (MonadPlus m, IsTerm a, IsTerm b, IsTerm c) 
         => (a -> b -> c -> d) -> Term -> Term -> Term -> m d
fromCon3 cons x y z = liftM3 cons (fromTerm x) (fromTerm y) (fromTerm z)

fromCon4 :: (MonadPlus m, IsTerm a, IsTerm b, IsTerm c, IsTerm d) 
         => (a -> b -> c -> d -> e) -> Term -> Term -> Term -> Term -> m e
fromCon4 cons x y z a = liftM4 cons (fromTerm x) (fromTerm y) (fromTerm z) (fromTerm a)

toCon :: String -> [Term] -> Term
toCon name = TCon (constrToSym name)

(.=) :: Symbol -> String -> Bool
sym .= str = symToConstr sym == str

-- | Term instances for syntax datatypes
instance IsTerm ModuleR where
  toTerm (ModuleR name body range) = toCon "ModuleR" [toTerm name, toTerm body, toTerm range]
  fromTerm term = 
      case term of
        TCon sym [n, b, r] | sym .= "ModuleR" -> fromCon3 ModuleR n b r
        _ -> fromTermError term
instance IsTerm BodyR where
  toTerm body  = 
      case body of
        BHoleR id r   -> toCon "BHoleR" [toTerm id, toTerm r]
        BodyR decls r -> toCon "BodyR"  [toTerm decls, toTerm r]
  fromTerm term =
      case term of
        TCon sym [id, r]    | sym .= "BHoleR" -> fromCon2 BHoleR id r
        TCon sym [decls, r] | sym .= "BodyR"  -> fromCon2 BodyR  decls r
        _ -> fromTermError term
instance IsTerm DeclR where
  toTerm decl = 
      case decl of
        DHoleR id r           -> toCon "DHoleR"     [toTerm id, toTerm r]
        DEmptyR r             -> toCon "DEmptyR"    [toTerm r]
        DFunBindsR funbinds r -> toCon "DFunBindsR" [toTerm funbinds, toTerm r]
        DPatBindR pat rhs r   -> toCon "DPatBindR"  [toTerm pat, toTerm rhs, toTerm r]
  fromTerm term = 
      case term of
        TCon sym [id, r]       | sym .= "DHoleR"     -> fromCon2 DHoleR id r
        TCon sym [r]         | sym .= "DEmptyR"    -> fromCon1 DEmptyR r
        TCon sym [funbinds, r] | sym .= "DFunBindsR" -> fromCon2 DFunBindsR funbinds r
        TCon sym [pat, rhs, r] | sym .= "DPatBindR"  -> fromCon3 DPatBindR pat rhs r
        _ -> fromTermError term
instance IsTerm ExprR where
  toTerm expr = case expr of
      HoleR id r           -> toCon "HoleR"     [toTerm id, toTerm r]
      FeedbackR msg expr r -> toCon "FeedbackR" [toTerm msg, toTerm expr, toTerm r]
      MustUseR  expr r     -> toCon "MustUseR"  [toTerm expr, toTerm r]
      CaseR expr alts r    -> toCon "CaseR"     [toTerm expr, toTerm alts, toTerm r]
      ConR name r          -> toCon "ConR"      [toTerm name, toTerm r]
      IfR c t e r          -> toCon "IfR"       [toTerm c, toTerm t, toTerm e, toTerm r]
      InfixAppR l op r ra  -> toCon "InfixAppR" [toTerm l, toTerm op, toTerm r, toTerm ra]
      LambdaR pats expr r  -> toCon "LambdaR"   [toTerm pats, toTerm expr, toTerm r]
      LetR decls expr r    -> toCon "LetR"      [toTerm decls, toTerm expr, toTerm r]
      LitR lit r           -> toCon "LitR"      [toTerm lit, toTerm r]
      AppR fun args r      -> toCon "AppR"      [toTerm fun, toTerm args, toTerm r]
      ParenR expr r        -> toCon "ParenR"    [toTerm expr, toTerm r]
      TupleR exprs r       -> toCon "TupleR"    [toTerm exprs, toTerm r]
      VarR name r          -> toCon "VarR"      [toTerm name, toTerm r]
      EnumR from t to r    -> toCon "EnumR"     [toTerm from, toTerm t, toTerm to, toTerm r]
      ListR exprs r        -> toCon "ListR"     [toTerm exprs, toTerm r]
      NegR expr r          -> toCon "NegR"      [toTerm expr, toTerm r]
  fromTerm term = 
      case term of
        TCon sym [id, r]          | sym .= "HoleR"     -> fromCon2 HoleR id r
        TCon sym [msg, expr, r]   | sym .= "FeedbackR" -> fromCon3 FeedbackR msg expr r
        TCon sym [expr, r]        | sym .= "MustUseR"  -> fromCon2 MustUseR expr r
        TCon sym [expr, alts, r]  | sym .= "CaseR"     -> fromCon3 CaseR expr alts r
        TCon sym [name, r]        | sym .= "ConR"      -> fromCon2 ConR name r
        TCon sym [c, t, e, r]     | sym .= "IfR"       -> fromCon4 IfR c t e r
        TCon sym [l, op, r, ra]   | sym .= "InfixAppR" -> fromCon4 InfixAppR l op r ra
        TCon sym [pats, expr, r]  | sym .= "LambdaR"   -> fromCon3 LambdaR pats expr r
        TCon sym [decls, expr, r] | sym .= "LetR"      -> fromCon3 LetR decls expr r
        TCon sym [lit, r]         | sym .= "LitR"      -> fromCon2 LitR lit r
        TCon sym [fun, args, r]   | sym .= "AppR"      -> fromCon3 AppR fun args r
        TCon sym [expr, r]        | sym .= "ParenR"    -> fromCon2 ParenR expr r
        TCon sym [exprs, r]       | sym .= "TupleR"    -> fromCon2 TupleR exprs r
        TCon sym [name, r]        | sym .= "VarR"      -> fromCon2 VarR name r
        TCon sym [from, t, to, r] | sym .= "EnumR"     -> fromCon4 EnumR from t to r
        TCon sym [exprs, r]       | sym .= "ListR"     -> fromCon2 ListR exprs r
        TCon sym [expr, r]        | sym .= "NegR"      -> fromCon2 NegR expr r
        _ -> fromTermError term
instance IsTerm MaybeExprR where
  toTerm mexpr = 
      case mexpr of
        NoExprR        -> toCon "NoExprR"   []
        JustExprR expr -> toCon "JustExprR" [toTerm expr]
  fromTerm term =
      case term of
        TCon sym []     | sym .= "NoExprR"   -> return NoExprR
        TCon sym [expr] | sym .= "JustExprR" -> fromCon1 JustExprR expr
        _ -> fromTermError term
instance IsTerm AltR where
  toTerm alt = 
      case alt of
        AHoleR id r       -> toCon "AHoleR"    [toTerm id, toTerm r]
        AltR fb pat rhs r -> toCon "AltR"      [toTerm fb, toTerm pat, toTerm rhs, toTerm r]
        AltEmptyR r       -> toCon "AltEmptyR" [toTerm r]
  fromTerm term =
      case term of
        TCon sym [id, r]           | sym .= "AHoleR"    -> fromCon2 AHoleR id r
        TCon sym [fb, pat, rhs, r] | sym .= "AltR"      -> fromCon4 AltR fb pat rhs r
        TCon sym [r]               | sym .= "AltEmptyR" -> fromCon1 AltEmptyR r
        _ -> fromTermError term
instance IsTerm FunBindR where
  toTerm funbind =
      case funbind of
        FBHoleR id r -> toCon "FBHoleR" [toTerm id, toTerm r]
        FunBindR fb name pats rhs r -> 
            toCon "FunBindR" [toTerm fb, toTerm name, toTerm pats, toTerm rhs, toTerm r]
  fromTerm term =
      case term of
        TCon sym [id, r] | sym .= "FBHoleR" -> fromCon2 FBHoleR id r
        TCon sym [fb, name, pats, rhs, r] | sym .= "FunBindR" ->
            liftM5 FunBindR (fromTerm fb) (fromTerm name) (fromTerm pats) (fromTerm rhs) (fromTerm r)
        _ -> fromTermError term
instance IsTerm GuardedExprR where
  toTerm (GExprR guard expr r) = toCon "GExprR" [toTerm guard, toTerm expr, toTerm r]
  fromTerm term =
      case term of
        TCon sym [guard, expr, r] | sym .= "GExprR" -> fromCon3 GExprR guard expr r
        _ -> fromTermError term
instance IsTerm LiteralR where
  toTerm lit = 
      case lit of
        LCharR val r   -> toCon "LCharR"   [toTerm val, toTerm r]
        LFloatR val r  -> toCon "LFloatR"  [toTerm $ float2Double val, toTerm r]
        LIntR val r    -> toCon "LIntR"    [toTerm val, toTerm r]
        LStringR val r -> toCon "LStringR" [toTerm val, toTerm r]
  fromTerm term@(TCon sym [val, r]) = 
      case symToConstr sym of
        "LCharR"   -> fromCon2 LCharR   val r
        "LFloatR"  -> fromCon2 (LFloatR . double2Float) val r
        "LIntR"    -> fromCon2 LIntR    val r 
        "LStringR" -> fromCon2 LStringR val r
        _         -> fromTermError term
  fromTerm term = fromTermError term
instance IsTerm NameR where
  toTerm name =
      case name of
        IdentR name r    -> toCon "IdentR"    [toTerm name, toTerm r]
        OperatorR name r -> toCon "OperatorR" [toTerm name, toTerm r]
        SpecialR name r  -> toCon "SpecialR"  [toTerm name, toTerm r]
  fromTerm term@(TCon sym [name, r]) = 
      case symToConstr sym of
        "IdentR"    -> fromCon2 IdentR    name r
        "OperatorR" -> fromCon2 OperatorR name r
        "SpecialR"  -> fromCon2 SpecialR  name r
        _          -> fromTermError term
  fromTerm term = fromTermError term
instance IsTerm MaybeNameR where
  toTerm mname = 
      case mname of
        NoNameR        -> toCon "NoNameR" []
        JustNameR name -> toCon "JustNameR" [toTerm name]
  fromTerm term = 
      case term of
        TCon sym [] | sym .= "NoNameR" -> return NoNameR
        TCon sym [name] | sym .= "JustNameR" -> fromCon1 JustNameR name
        _ -> fromTermError term
instance IsTerm PatR where
  toTerm pat =
      case pat of
        PHoleR id r            -> toCon "PHoleR"     [toTerm id, toTerm r]
        PConR name pats r      -> toCon "PConR"      [toTerm name, toTerm pats, toTerm r]
        PInfixConR l name r ra -> toCon "PInfixConR" [toTerm l, toTerm name, toTerm r, toTerm ra]
        PListR pats r          -> toCon "PListR"     [toTerm pats, toTerm r]
        PLitR lit r            -> toCon "PLitR"      [toTerm lit, toTerm r]
        PParenR pat r          -> toCon "PParenR"    [toTerm pat, toTerm r]
        PTupleR pats r         -> toCon "PTupleR"    [toTerm pats, toTerm r]
        PVarR name r           -> toCon "PVarR"      [toTerm name, toTerm r]
        PAsR name pat r        -> toCon "PAsR"       [toTerm name, toTerm pat, toTerm r]
        PWildcardR r           -> toCon "PWildcardR" [toTerm r]
  fromTerm term = 
      case term of
        TCon sym [id, r]          | sym .= "PHoleR"     -> fromCon2 PHoleR id r
        TCon sym [name, pats, r]  | sym .= "PConR"      -> fromCon3 PConR name pats r
        TCon sym [l, name, r, ra] | sym .= "PInfixConR" -> fromCon4 PInfixConR l name r ra
        TCon sym [pats, r]        | sym .= "PListR"     -> fromCon2 PListR pats r
        TCon sym [lit, r]         | sym .= "PLitR"      -> fromCon2 PLitR lit r
        TCon sym [pat, r]         | sym .= "PParenR"    -> fromCon2 PParenR pat r
        TCon sym [pats, r]        | sym .= "PTupleR"    -> fromCon2 PTupleR pats r
        TCon sym [name, r]        | sym .= "PVarR"      -> fromCon2 PVarR name r
        TCon sym [name, pat, r]   | sym .= "PAsR"       -> fromCon3 PAsR name pat r
        TCon sym [r]           | sym .= "PWildcardR" -> fromCon1 PWildcardR r
        _ -> fromTermError term
instance IsTerm RhsR where
  toTerm rhs =
      case rhs of
        RhsR expr where_ r    -> toCon "RhsR"  [toTerm expr, toTerm where_, toTerm r]
        GRhsR gexprs where_ r -> toCon "GRhsR" [toTerm gexprs, toTerm where_, toTerm r]
  fromTerm term = 
      case term of
        TCon sym [expr, where_, r]   | sym .= "RhsR"  -> fromCon3 RhsR expr where_ r
        TCon sym [gexprs, where_, r] | sym .= "GRhsR" -> fromCon3 GRhsR gexprs where_ r
        _ -> fromTermError term     

instance IsTerm RangeR where
  toTerm (RangeR start stop ) = toCon "RangeR" [toTerm start, toTerm stop]
  fromTerm term =
      case term of
        TCon sym [start, stop] | sym .= "RangeR" -> fromCon2 RangeR start stop
        _ -> fromTermError term

instance IsTerm PositionR where
  toTerm pos =
      case pos of
        PositionR file l c  -> toCon "PositionR"  [toTerm file, toTerm l, toTerm c]
        UnknownR            -> toCon "UnknownR"   []
  fromTerm term = 
      case term of
        TCon sym [file, l, c]   | sym .= "PositionR"  -> fromCon3 PositionR file l c
        TCon sym []             | sym .= "UnknownR"   -> return UnknownR
        _ -> fromTermError term

fromTermError :: MonadPlus m => Term -> m a
fromTermError term = fail $ "No fromTerm definition for: " ++ show term

{-
instance Reference NameR

-- | A convenient shorthand notation for Biplate constraints
class ( Biplate b ModuleR, Biplate b BodyR, Biplate b DeclR, Biplate b ExprR
      , Biplate b FunBindR, Biplate b AltR, Biplate b PatR 
      , Biplate b RhsR, BiPlate b RangeR, BiPlate b PositionR, Typeable b ) 
      => BiplateFor b
instance BiplateFor ModuleR where
instance BiplateFor DeclR   where
instance BiplateFor RhsR    where
instance BiplateFor PatR    where
instance BiplateFor ExprR   where  

instance Uniplate ModuleR where
         
        {-# INLINE uniplate #-}
        uniplate x = plate x

 
instance Uniplate BodyR where
         
        {-# INLINE uniplate #-}
        uniplate x = plate x

 
instance Uniplate DeclR where
         
        {-# INLINE uniplate #-}
        uniplate (DFunBindsR x1) = plate DFunBindsR ||+ x1
        uniplate (DPatBindR x1 x2) = plate (DPatBindR x1) |+ x2
        uniplate x = plate x

 
instance Uniplate FunBindR where
         
        {-# INLINE uniplate #-}
        uniplate (FunBindR x1 x2 x3 x4) = plate (FunBindR x1 x2 x3) |+ x4
        uniplate x = plate x

 
instance Uniplate PatR where
         
        {-# INLINE uniplate #-}
        uniplate (PAsR x1 x2) = plate (PAsR x1) |* x2
        uniplate (PConR x1 x2) = plate (PConR x1) ||* x2
        uniplate (PInfixConR x1 x2 x3) = plate PInfixConR |* x1 |- x2 |* x3
        uniplate (PListR x1) = plate PListR ||* x1
        uniplate (PParenR x1) = plate PParenR |* x1
        uniplate (PTupleR x1) = plate PTupleR ||* x1
        uniplate x = plate x

 
instance Uniplate RhsR where
         
        {-# INLINE uniplate #-}
        uniplate (GRhs x1 x2) = plate GRhs ||+ x1 ||+ x2
        uniplate (RhsR x1 x2) = plate RhsR |+ x1 ||+ x2

 
instance Uniplate ExprR where
         
        {-# INLINE uniplate #-}
        uniplate (AppR x1 x2) = plate AppR |* x1 ||* x2
        uniplate (CaseR x1 x2) = plate CaseR |* x1 ||+ x2
        uniplate (EnumR x1 x2 x3) = plate EnumR |* x1 |+ x2 |+ x3
        uniplate (FeedbackR x1 x2) = plate (FeedbackR x1) |* x2
        uniplate (IfR x1 x2 x3) = plate IfR |* x1 |* x2 |* x3
        uniplate (InfixAppR x1 x2 x3) = plate InfixAppR |+ x1 |* x2 |+ x3
        uniplate (LambdaR x1 x2) = plate (LambdaR x1) |* x2
        uniplate (LetR x1 x2) = plate LetR ||+ x1 |* x2
        uniplate (ListR x1) = plate ListR ||* x1
        uniplate (MustUseR x1) = plate MustUseR |* x1
        uniplate (NegR x1) = plate NegR |* x1
        uniplate (ParenR x1) = plate ParenR |* x1
        uniplate (TupleR x1) = plate TupleR ||* x1
        uniplate x = plate x

 
instance Uniplate MaybeExprR where
         
        {-# INLINE uniplate #-}
        uniplate (JustExprR x1) = plate JustExprR |+ x1
        uniplate x = plate x

 
instance Uniplate AltR where
         
        {-# INLINE uniplate #-}
        uniplate (AltR x1 x2 x3) = plate (AltR x1 x2) |+ x3
        uniplate x = plate x

 
instance Uniplate NameR where
         
        {-# INLINE uniplate #-}
        uniplate x = plate x

 
instance Uniplate MaybeName where
         
        {-# INLINE uniplate #-}
        uniplate x = plate x

 
instance Uniplate LiteralR where
         
        {-# INLINE uniplate #-}
        uniplate x = plate x

 
instance Uniplate GuardedExprR where
         
        {-# INLINE uniplate #-}
        uniplate (GExprR x1 x2) = plate GExprR |+ x1 |+ x2

instance Biplate ModuleR ModuleR where
         
        {-# INLINE biplate #-}
        biplate = plateSelf

 
instance Biplate ModuleR BodyR where
         
        {-# INLINE biplate #-}
        biplate (ModuleR x1 x2) = plate (ModuleR x1) |* x2

 
instance Biplate ModuleR DeclR where
         
        {-# INLINE biplate #-}
        biplate (ModuleR x1 x2) = plate (ModuleR x1) |+ x2

 
instance Biplate ModuleR FunBindR where
         
        {-# INLINE biplate #-}
        biplate (ModuleR x1 x2) = plate (ModuleR x1) |+ x2

 
instance Biplate ModuleR PatR where
         
        {-# INLINE biplate #-}
        biplate (ModuleR x1 x2) = plate (ModuleR x1) |+ x2

 
instance Biplate ModuleR RhsR where
         
        {-# INLINE biplate #-}
        biplate (ModuleR x1 x2) = plate (ModuleR x1) |+ x2

 
instance Biplate ModuleR ExprR where
         
        {-# INLINE biplate #-}
        biplate (ModuleR x1 x2) = plate (ModuleR x1) |+ x2

 
instance Biplate ModuleR MaybeExprR where
         
        {-# INLINE biplate #-}
        biplate (ModuleR x1 x2) = plate (ModuleR x1) |+ x2

 
instance Biplate ModuleR AltR where
         
        {-# INLINE biplate #-}
        biplate (ModuleR x1 x2) = plate (ModuleR x1) |+ x2

 
instance Biplate ModuleR NameR where
         
        {-# INLINE biplate #-}
        biplate (ModuleR x1 x2) = plate ModuleR |+ x1 |+ x2

 
instance Biplate ModuleR MaybeName where
         
        {-# INLINE biplate #-}
        biplate (ModuleR x1 x2) = plate ModuleR |* x1 |- x2

 
instance Biplate ModuleR LiteralR where
         
        {-# INLINE biplate #-}
        biplate (ModuleR x1 x2) = plate (ModuleR x1) |+ x2

 
instance Biplate ModuleR GuardedExprR where
         
        {-# INLINE biplate #-}
        biplate (ModuleR x1 x2) = plate (ModuleR x1) |+ x2

 
instance Biplate BodyR ModuleR where
         
        {-# INLINE biplate #-}
        biplate x = plate x

 
instance Biplate BodyR BodyR where
         
        {-# INLINE biplate #-}
        biplate = plateSelf

 
instance Biplate BodyR DeclR where
         
        {-# INLINE biplate #-}
        biplate (BodyR x1) = plate BodyR ||* x1
        biplate x = plate x

 
instance Biplate BodyR FunBindR where
         
        {-# INLINE biplate #-}
        biplate (BodyR x1) = plate BodyR ||+ x1
        biplate x = plate x

 
instance Biplate BodyR PatR where
         
        {-# INLINE biplate #-}
        biplate (BodyR x1) = plate BodyR ||+ x1
        biplate x = plate x

 
instance Biplate BodyR RhsR where
         
        {-# INLINE biplate #-}
        biplate (BodyR x1) = plate BodyR ||+ x1
        biplate x = plate x

 
instance Biplate BodyR ExprR where
         
        {-# INLINE biplate #-}
        biplate (BodyR x1) = plate BodyR ||+ x1
        biplate x = plate x

 
instance Biplate BodyR MaybeExprR where
         
        {-# INLINE biplate #-}
        biplate (BodyR x1) = plate BodyR ||+ x1
        biplate x = plate x

 
instance Biplate BodyR AltR where
         
        {-# INLINE biplate #-}
        biplate (BodyR x1) = plate BodyR ||+ x1
        biplate x = plate x

 
instance Biplate BodyR NameR where
         
        {-# INLINE biplate #-}
        biplate (BodyR x1) = plate BodyR ||+ x1
        biplate x = plate x

 
instance Biplate BodyR MaybeName where
         
        {-# INLINE biplate #-}
        biplate x = plate x

 
instance Biplate BodyR LiteralR where
         
        {-# INLINE biplate #-}
        biplate (BodyR x1) = plate BodyR ||+ x1
        biplate x = plate x

 
instance Biplate BodyR GuardedExprR where
         
        {-# INLINE biplate #-}
        biplate (BodyR x1) = plate BodyR ||+ x1
        biplate x = plate x

 
instance Biplate DeclR ModuleR where
         
        {-# INLINE biplate #-}
        biplate x = plate x

 
instance Biplate DeclR BodyR where
         
        {-# INLINE biplate #-}
        biplate x = plate x

 
instance Biplate DeclR DeclR where
         
        {-# INLINE biplate #-}
        biplate = plateSelf

 
instance Biplate DeclR FunBindR where
         
        {-# INLINE biplate #-}
        biplate (DFunBindsR x1) = plate DFunBindsR ||* x1
        biplate (DPatBindR x1 x2) = plate (DPatBindR x1) |+ x2
        biplate x = plate x

 
instance Biplate DeclR PatR where
         
        {-# INLINE biplate #-}
        biplate (DFunBindsR x1) = plate DFunBindsR ||+ x1
        biplate (DPatBindR x1 x2) = plate DPatBindR |* x1 |+ x2
        biplate x = plate x

 
instance Biplate DeclR RhsR where
         
        {-# INLINE biplate #-}
        biplate (DFunBindsR x1) = plate DFunBindsR ||+ x1
        biplate (DPatBindR x1 x2) = plate (DPatBindR x1) |* x2
        biplate x = plate x

 
instance Biplate DeclR ExprR where
         
        {-# INLINE biplate #-}
        biplate (DFunBindsR x1) = plate DFunBindsR ||+ x1
        biplate (DPatBindR x1 x2) = plate (DPatBindR x1) |+ x2
        biplate x = plate x

 
instance Biplate DeclR MaybeExprR where
         
        {-# INLINE biplate #-}
        biplate (DFunBindsR x1) = plate DFunBindsR ||+ x1
        biplate (DPatBindR x1 x2) = plate (DPatBindR x1) |+ x2
        biplate x = plate x

 
instance Biplate DeclR AltR where
         
        {-# INLINE biplate #-}
        biplate (DFunBindsR x1) = plate DFunBindsR ||+ x1
        biplate (DPatBindR x1 x2) = plate (DPatBindR x1) |+ x2
        biplate x = plate x

 
instance Biplate DeclR NameR where
         
        {-# INLINE biplate #-}
        biplate (DFunBindsR x1) = plate DFunBindsR ||+ x1
        biplate (DPatBindR x1 x2) = plate DPatBindR |+ x1 |+ x2
        biplate x = plate x

 
instance Biplate DeclR MaybeName where
         
        {-# INLINE biplate #-}
        biplate x = plate x

 
instance Biplate DeclR LiteralR where
         
        {-# INLINE biplate #-}
        biplate (DFunBindsR x1) = plate DFunBindsR ||+ x1
        biplate (DPatBindR x1 x2) = plate DPatBindR |+ x1 |+ x2
        biplate x = plate x

 
instance Biplate DeclR GuardedExprR where
         
        {-# INLINE biplate #-}
        biplate (DFunBindsR x1) = plate DFunBindsR ||+ x1
        biplate (DPatBindR x1 x2) = plate (DPatBindR x1) |+ x2
        biplate x = plate x

 
instance Biplate FunBindR ModuleR where
         
        {-# INLINE biplate #-}
        biplate x = plate x

 
instance Biplate FunBindR BodyR where
         
        {-# INLINE biplate #-}
        biplate x = plate x

 
instance Biplate FunBindR DeclR where
         
        {-# INLINE biplate #-}
        biplate (FunBindR x1 x2 x3 x4) = plate (FunBindR x1 x2 x3) |+ x4
        biplate x = plate x

 
instance Biplate FunBindR FunBindR where
         
        {-# INLINE biplate #-}
        biplate = plateSelf

 
instance Biplate FunBindR PatR where
         
        {-# INLINE biplate #-}
        biplate (FunBindR x1 x2 x3 x4) = plate (FunBindR x1 x2) ||* x3 |+ x4
        biplate x = plate x

 
instance Biplate FunBindR RhsR where
         
        {-# INLINE biplate #-}
        biplate (FunBindR x1 x2 x3 x4) = plate (FunBindR x1 x2 x3) |* x4
        biplate x = plate x

 
instance Biplate FunBindR ExprR where
         
        {-# INLINE biplate #-}
        biplate (FunBindR x1 x2 x3 x4) = plate (FunBindR x1 x2 x3) |+ x4
        biplate x = plate x

 
instance Biplate FunBindR MaybeExprR where
         
        {-# INLINE biplate #-}
        biplate (FunBindR x1 x2 x3 x4) = plate (FunBindR x1 x2 x3) |+ x4
        biplate x = plate x

 
instance Biplate FunBindR AltR where
         
        {-# INLINE biplate #-}
        biplate (FunBindR x1 x2 x3 x4) = plate (FunBindR x1 x2 x3) |+ x4
        biplate x = plate x

 
instance Biplate FunBindR NameR where
         
        {-# INLINE biplate #-}
        biplate (FunBindR x1 x2 x3 x4)
          = plate (FunBindR x1) |* x2 ||+ x3 |+ x4
        biplate x = plate x

 
instance Biplate FunBindR MaybeName where
         
        {-# INLINE biplate #-}
        biplate x = plate x

 
instance Biplate FunBindR LiteralR where
         
        {-# INLINE biplate #-}
        biplate (FunBindR x1 x2 x3 x4) = plate (FunBindR x1 x2) ||+ x3 |+ x4
        biplate x = plate x

 
instance Biplate FunBindR GuardedExprR where
         
        {-# INLINE biplate #-}
        biplate (FunBindR x1 x2 x3 x4) = plate (FunBindR x1 x2 x3) |+ x4
        biplate x = plate x

 
instance Biplate PatR ModuleR where
         
        {-# INLINE biplate #-}
        biplate x = plate x

 
instance Biplate PatR BodyR where
         
        {-# INLINE biplate #-}
        biplate x = plate x

 
instance Biplate PatR DeclR where
         
        {-# INLINE biplate #-}
        biplate x = plate x

 
instance Biplate PatR FunBindR where
         
        {-# INLINE biplate #-}
        biplate x = plate x

 
instance Biplate PatR PatR where
         
        {-# INLINE biplate #-}
        biplate = plateSelf

 
instance Biplate PatR RhsR where
         
        {-# INLINE biplate #-}
        biplate x = plate x

 
instance Biplate PatR ExprR where
         
        {-# INLINE biplate #-}
        biplate x = plate x

 
instance Biplate PatR MaybeExprR where
         
        {-# INLINE biplate #-}
        biplate x = plate x

 
instance Biplate PatR AltR where
         
        {-# INLINE biplate #-}
        biplate x = plate x

 
instance Biplate PatR NameR where
         
        {-# INLINE biplate #-}
        biplate (PAsR x1 x2) = plate PAsR |* x1 |+ x2
        biplate (PConR x1 x2) = plate PConR |* x1 ||+ x2
        biplate (PInfixConR x1 x2 x3) = plate PInfixConR |+ x1 |* x2 |+ x3
        biplate (PListR x1) = plate PListR ||+ x1
        biplate (PParenR x1) = plate PParenR |+ x1
        biplate (PTupleR x1) = plate PTupleR ||+ x1
        biplate (PVar x1) = plate PVar |* x1
        biplate x = plate x

 
instance Biplate PatR MaybeName where
         
        {-# INLINE biplate #-}
        biplate x = plate x

 
instance Biplate PatR LiteralR where
         
        {-# INLINE biplate #-}
        biplate (PAsR x1 x2) = plate (PAsR x1) |+ x2
        biplate (PConR x1 x2) = plate (PConR x1) ||+ x2
        biplate (PInfixConR x1 x2 x3) = plate PInfixConR |+ x1 |- x2 |+ x3
        biplate (PListR x1) = plate PListR ||+ x1
        biplate (PLitR x1) = plate PLitR |* x1
        biplate (PParenR x1) = plate PParenR |+ x1
        biplate (PTupleR x1) = plate PTupleR ||+ x1
        biplate x = plate x

 
instance Biplate PatR GuardedExprR where
         
        {-# INLINE biplate #-}
        biplate x = plate x

 
instance Biplate RhsR ModuleR where
         
        {-# INLINE biplate #-}
        biplate x = plate x

 
instance Biplate RhsR BodyR where
         
        {-# INLINE biplate #-}
        biplate x = plate x

 
instance Biplate RhsR DeclR where
         
        {-# INLINE biplate #-}
        biplate (GRhs x1 x2) = plate GRhs ||+ x1 ||* x2
        biplate (RhsR x1 x2) = plate RhsR |+ x1 ||* x2

 
instance Biplate RhsR FunBindR where
         
        {-# INLINE biplate #-}
        biplate (GRhs x1 x2) = plate GRhs ||+ x1 ||+ x2
        biplate (RhsR x1 x2) = plate RhsR |+ x1 ||+ x2

 
instance Biplate RhsR PatR where
         
        {-# INLINE biplate #-}
        biplate (GRhs x1 x2) = plate GRhs ||+ x1 ||+ x2
        biplate (RhsR x1 x2) = plate RhsR |+ x1 ||+ x2

 
instance Biplate RhsR RhsR where
         
        {-# INLINE biplate #-}
        biplate = plateSelf

 
instance Biplate RhsR ExprR where
         
        {-# INLINE biplate #-}
        biplate (GRhs x1 x2) = plate GRhs ||+ x1 ||+ x2
        biplate (RhsR x1 x2) = plate RhsR |* x1 ||+ x2

 
instance Biplate RhsR MaybeExprR where
         
        {-# INLINE biplate #-}
        biplate (GRhs x1 x2) = plate GRhs ||+ x1 ||+ x2
        biplate (RhsR x1 x2) = plate RhsR |+ x1 ||+ x2

 
instance Biplate RhsR AltR where
         
        {-# INLINE biplate #-}
        biplate (GRhs x1 x2) = plate GRhs ||+ x1 ||+ x2
        biplate (RhsR x1 x2) = plate RhsR |+ x1 ||+ x2

 
instance Biplate RhsR NameR where
         
        {-# INLINE biplate #-}
        biplate (GRhs x1 x2) = plate GRhs ||+ x1 ||+ x2
        biplate (RhsR x1 x2) = plate RhsR |+ x1 ||+ x2

 
instance Biplate RhsR MaybeName where
         
        {-# INLINE biplate #-}
        biplate x = plate x

 
instance Biplate RhsR LiteralR where
         
        {-# INLINE biplate #-}
        biplate (GRhs x1 x2) = plate GRhs ||+ x1 ||+ x2
        biplate (RhsR x1 x2) = plate RhsR |+ x1 ||+ x2

 
instance Biplate RhsR GuardedExprR where
         
        {-# INLINE biplate #-}
        biplate (GRhs x1 x2) = plate GRhs ||* x1 ||+ x2
        biplate (RhsR x1 x2) = plate RhsR |+ x1 ||+ x2

 
instance Biplate ExprR ModuleR where
         
        {-# INLINE biplate #-}
        biplate x = plate x

 
instance Biplate ExprR BodyR where
         
        {-# INLINE biplate #-}
        biplate x = plate x

 
instance Biplate ExprR DeclR where
         
        {-# INLINE biplate #-}
        biplate (AppR x1 x2) = plate AppR |+ x1 ||+ x2
        biplate (CaseR x1 x2) = plate CaseR |+ x1 ||+ x2
        biplate (EnumR x1 x2 x3) = plate EnumR |+ x1 |+ x2 |+ x3
        biplate (FeedbackR x1 x2) = plate (FeedbackR x1) |+ x2
        biplate (IfR x1 x2 x3) = plate IfR |+ x1 |+ x2 |+ x3
        biplate (InfixAppR x1 x2 x3) = plate InfixAppR |+ x1 |+ x2 |+ x3
        biplate (LambdaR x1 x2) = plate (LambdaR x1) |+ x2
        biplate (LetR x1 x2) = plate LetR ||* x1 |+ x2
        biplate (ListR x1) = plate ListR ||+ x1
        biplate (MustUseR x1) = plate MustUseR |+ x1
        biplate (NegR x1) = plate NegR |+ x1
        biplate (ParenR x1) = plate ParenR |+ x1
        biplate (TupleR x1) = plate TupleR ||+ x1
        biplate x = plate x

 
instance Biplate ExprR FunBindR where
         
        {-# INLINE biplate #-}
        biplate (AppR x1 x2) = plate AppR |+ x1 ||+ x2
        biplate (CaseR x1 x2) = plate CaseR |+ x1 ||+ x2
        biplate (EnumR x1 x2 x3) = plate EnumR |+ x1 |+ x2 |+ x3
        biplate (FeedbackR x1 x2) = plate (FeedbackR x1) |+ x2
        biplate (IfR x1 x2 x3) = plate IfR |+ x1 |+ x2 |+ x3
        biplate (InfixAppR x1 x2 x3) = plate InfixAppR |+ x1 |+ x2 |+ x3
        biplate (LambdaR x1 x2) = plate (LambdaR x1) |+ x2
        biplate (LetR x1 x2) = plate LetR ||+ x1 |+ x2
        biplate (ListR x1) = plate ListR ||+ x1
        biplate (MustUseR x1) = plate MustUseR |+ x1
        biplate (NegR x1) = plate NegR |+ x1
        biplate (ParenR x1) = plate ParenR |+ x1
        biplate (TupleR x1) = plate TupleR ||+ x1
        biplate x = plate x

 
instance Biplate ExprR PatR where
         
        {-# INLINE biplate #-}
        biplate (AppR x1 x2) = plate AppR |+ x1 ||+ x2
        biplate (CaseR x1 x2) = plate CaseR |+ x1 ||+ x2
        biplate (EnumR x1 x2 x3) = plate EnumR |+ x1 |+ x2 |+ x3
        biplate (FeedbackR x1 x2) = plate (FeedbackR x1) |+ x2
        biplate (IfR x1 x2 x3) = plate IfR |+ x1 |+ x2 |+ x3
        biplate (InfixAppR x1 x2 x3) = plate InfixAppR |+ x1 |+ x2 |+ x3
        biplate (LambdaR x1 x2) = plate LambdaR ||* x1 |+ x2
        biplate (LetR x1 x2) = plate LetR ||+ x1 |+ x2
        biplate (ListR x1) = plate ListR ||+ x1
        biplate (MustUseR x1) = plate MustUseR |+ x1
        biplate (NegR x1) = plate NegR |+ x1
        biplate (ParenR x1) = plate ParenR |+ x1
        biplate (TupleR x1) = plate TupleR ||+ x1
        biplate x = plate x

 
instance Biplate ExprR RhsR where
         
        {-# INLINE biplate #-}
        biplate (AppR x1 x2) = plate AppR |+ x1 ||+ x2
        biplate (CaseR x1 x2) = plate CaseR |+ x1 ||+ x2
        biplate (EnumR x1 x2 x3) = plate EnumR |+ x1 |+ x2 |+ x3
        biplate (FeedbackR x1 x2) = plate (FeedbackR x1) |+ x2
        biplate (IfR x1 x2 x3) = plate IfR |+ x1 |+ x2 |+ x3
        biplate (InfixAppR x1 x2 x3) = plate InfixAppR |+ x1 |+ x2 |+ x3
        biplate (LambdaR x1 x2) = plate (LambdaR x1) |+ x2
        biplate (LetR x1 x2) = plate LetR ||+ x1 |+ x2
        biplate (ListR x1) = plate ListR ||+ x1
        biplate (MustUseR x1) = plate MustUseR |+ x1
        biplate (NegR x1) = plate NegR |+ x1
        biplate (ParenR x1) = plate ParenR |+ x1
        biplate (TupleR x1) = plate TupleR ||+ x1
        biplate x = plate x

 
instance Biplate ExprR ExprR where
         
        {-# INLINE biplate #-}
        biplate = plateSelf

 
instance Biplate ExprR MaybeExprR where
         
        {-# INLINE biplate #-}
        biplate (AppR x1 x2) = plate AppR |+ x1 ||+ x2
        biplate (CaseR x1 x2) = plate CaseR |+ x1 ||+ x2
        biplate (EnumR x1 x2 x3) = plate EnumR |+ x1 |* x2 |* x3
        biplate (FeedbackR x1 x2) = plate (FeedbackR x1) |+ x2
        biplate (IfR x1 x2 x3) = plate IfR |+ x1 |+ x2 |+ x3
        biplate (InfixAppR x1 x2 x3) = plate InfixAppR |* x1 |+ x2 |* x3
        biplate (LambdaR x1 x2) = plate (LambdaR x1) |+ x2
        biplate (LetR x1 x2) = plate LetR ||+ x1 |+ x2
        biplate (ListR x1) = plate ListR ||+ x1
        biplate (MustUseR x1) = plate MustUseR |+ x1
        biplate (NegR x1) = plate NegR |+ x1
        biplate (ParenR x1) = plate ParenR |+ x1
        biplate (TupleR x1) = plate TupleR ||+ x1
        biplate x = plate x

 
instance Biplate ExprR AltR where
         
        {-# INLINE biplate #-}
        biplate (AppR x1 x2) = plate AppR |+ x1 ||+ x2
        biplate (CaseR x1 x2) = plate CaseR |+ x1 ||* x2
        biplate (EnumR x1 x2 x3) = plate EnumR |+ x1 |+ x2 |+ x3
        biplate (FeedbackR x1 x2) = plate (FeedbackR x1) |+ x2
        biplate (IfR x1 x2 x3) = plate IfR |+ x1 |+ x2 |+ x3
        biplate (InfixAppR x1 x2 x3) = plate InfixAppR |+ x1 |+ x2 |+ x3
        biplate (LambdaR x1 x2) = plate (LambdaR x1) |+ x2
        biplate (LetR x1 x2) = plate LetR ||+ x1 |+ x2
        biplate (ListR x1) = plate ListR ||+ x1
        biplate (MustUseR x1) = plate MustUseR |+ x1
        biplate (NegR x1) = plate NegR |+ x1
        biplate (ParenR x1) = plate ParenR |+ x1
        biplate (TupleR x1) = plate TupleR ||+ x1
        biplate x = plate x

 
instance Biplate ExprR NameR where
         
        {-# INLINE biplate #-}
        biplate (AppR x1 x2) = plate AppR |+ x1 ||+ x2
        biplate (CaseR x1 x2) = plate CaseR |+ x1 ||+ x2
        biplate (Con x1) = plate Con |* x1
        biplate (EnumR x1 x2 x3) = plate EnumR |+ x1 |+ x2 |+ x3
        biplate (FeedbackR x1 x2) = plate (FeedbackR x1) |+ x2
        biplate (IfR x1 x2 x3) = plate IfR |+ x1 |+ x2 |+ x3
        biplate (InfixAppR x1 x2 x3) = plate InfixAppR |+ x1 |+ x2 |+ x3
        biplate (LambdaR x1 x2) = plate LambdaR ||+ x1 |+ x2
        biplate (LetR x1 x2) = plate LetR ||+ x1 |+ x2
        biplate (ListR x1) = plate ListR ||+ x1
        biplate (MustUseR x1) = plate MustUseR |+ x1
        biplate (NegR x1) = plate NegR |+ x1
        biplate (ParenR x1) = plate ParenR |+ x1
        biplate (TupleR x1) = plate TupleR ||+ x1
        biplate (VarR x1) = plate VarR |* x1
        biplate x = plate x

 
instance Biplate ExprR MaybeName where
         
        {-# INLINE biplate #-}
        biplate x = plate x

 
instance Biplate ExprR LiteralR where
         
        {-# INLINE biplate #-}
        biplate (AppR x1 x2) = plate AppR |+ x1 ||+ x2
        biplate (CaseR x1 x2) = plate CaseR |+ x1 ||+ x2
        biplate (EnumR x1 x2 x3) = plate EnumR |+ x1 |+ x2 |+ x3
        biplate (FeedbackR x1 x2) = plate (FeedbackR x1) |+ x2
        biplate (IfR x1 x2 x3) = plate IfR |+ x1 |+ x2 |+ x3
        biplate (InfixAppR x1 x2 x3) = plate InfixAppR |+ x1 |+ x2 |+ x3
        biplate (LambdaR x1 x2) = plate LambdaR ||+ x1 |+ x2
        biplate (LetR x1 x2) = plate LetR ||+ x1 |+ x2
        biplate (ListR x1) = plate ListR ||+ x1
        biplate (Lit x1) = plate Lit |* x1
        biplate (MustUseR x1) = plate MustUseR |+ x1
        biplate (NegR x1) = plate NegR |+ x1
        biplate (ParenR x1) = plate ParenR |+ x1
        biplate (TupleR x1) = plate TupleR ||+ x1
        biplate x = plate x

 
instance Biplate ExprR GuardedExprR where
         
        {-# INLINE biplate #-}
        biplate (AppR x1 x2) = plate AppR |+ x1 ||+ x2
        biplate (CaseR x1 x2) = plate CaseR |+ x1 ||+ x2
        biplate (EnumR x1 x2 x3) = plate EnumR |+ x1 |+ x2 |+ x3
        biplate (FeedbackR x1 x2) = plate (FeedbackR x1) |+ x2
        biplate (IfR x1 x2 x3) = plate IfR |+ x1 |+ x2 |+ x3
        biplate (InfixAppR x1 x2 x3) = plate InfixAppR |+ x1 |+ x2 |+ x3
        biplate (LambdaR x1 x2) = plate (LambdaR x1) |+ x2
        biplate (LetR x1 x2) = plate LetR ||+ x1 |+ x2
        biplate (ListR x1) = plate ListR ||+ x1
        biplate (MustUseR x1) = plate MustUseR |+ x1
        biplate (NegR x1) = plate NegR |+ x1
        biplate (ParenR x1) = plate ParenR |+ x1
        biplate (TupleR x1) = plate TupleR ||+ x1
        biplate x = plate x

 
instance Biplate MaybeExprR ModuleR where
         
        {-# INLINE biplate #-}
        biplate x = plate x

 
instance Biplate MaybeExprR BodyR where
         
        {-# INLINE biplate #-}
        biplate x = plate x

 
instance Biplate MaybeExprR DeclR where
         
        {-# INLINE biplate #-}
        biplate (JustExprR x1) = plate JustExprR |+ x1
        biplate x = plate x

 
instance Biplate MaybeExprR FunBindR where
         
        {-# INLINE biplate #-}
        biplate (JustExprR x1) = plate JustExprR |+ x1
        biplate x = plate x

 
instance Biplate MaybeExprR PatR where
         
        {-# INLINE biplate #-}
        biplate (JustExprR x1) = plate JustExprR |+ x1
        biplate x = plate x

 
instance Biplate MaybeExprR RhsR where
         
        {-# INLINE biplate #-}
        biplate (JustExprR x1) = plate JustExprR |+ x1
        biplate x = plate x

 
instance Biplate MaybeExprR ExprR where
         
        {-# INLINE biplate #-}
        biplate (JustExprR x1) = plate JustExprR |* x1
        biplate x = plate x

 
instance Biplate MaybeExprR MaybeExprR where
         
        {-# INLINE biplate #-}
        biplate = plateSelf

 
instance Biplate MaybeExprR AltR where
         
        {-# INLINE biplate #-}
        biplate (JustExprR x1) = plate JustExprR |+ x1
        biplate x = plate x

 
instance Biplate MaybeExprR NameR where
         
        {-# INLINE biplate #-}
        biplate (JustExprR x1) = plate JustExprR |+ x1
        biplate x = plate x

 
instance Biplate MaybeExprR MaybeName where
         
        {-# INLINE biplate #-}
        biplate x = plate x

 
instance Biplate MaybeExprR LiteralR where
         
        {-# INLINE biplate #-}
        biplate (JustExprR x1) = plate JustExprR |+ x1
        biplate x = plate x

 
instance Biplate MaybeExprR GuardedExprR where
         
        {-# INLINE biplate #-}
        biplate (JustExprR x1) = plate JustExprR |+ x1
        biplate x = plate x

 
instance Biplate AltR ModuleR where
         
        {-# INLINE biplate #-}
        biplate x = plate x

 
instance Biplate AltR BodyR where
         
        {-# INLINE biplate #-}
        biplate x = plate x

 
instance Biplate AltR DeclR where
         
        {-# INLINE biplate #-}
        biplate (AltR x1 x2 x3) = plate (AltR x1 x2) |+ x3
        biplate x = plate x

 
instance Biplate AltR FunBindR where
         
        {-# INLINE biplate #-}
        biplate (AltR x1 x2 x3) = plate (AltR x1 x2) |+ x3
        biplate x = plate x

 
instance Biplate AltR PatR where
         
        {-# INLINE biplate #-}
        biplate (AltR x1 x2 x3) = plate (AltR x1) |* x2 |+ x3
        biplate x = plate x

 
instance Biplate AltR RhsR where
         
        {-# INLINE biplate #-}
        biplate (AltR x1 x2 x3) = plate (AltR x1 x2) |* x3
        biplate x = plate x

 
instance Biplate AltR ExprR where
         
        {-# INLINE biplate #-}
        biplate (AltR x1 x2 x3) = plate (AltR x1 x2) |+ x3
        biplate x = plate x

 
instance Biplate AltR MaybeExprR where
         
        {-# INLINE biplate #-}
        biplate (AltR x1 x2 x3) = plate (AltR x1 x2) |+ x3
        biplate x = plate x

 
instance Biplate AltR AltR where
         
        {-# INLINE biplate #-}
        biplate = plateSelf

 
instance Biplate AltR NameR where
         
        {-# INLINE biplate #-}
        biplate (AltR x1 x2 x3) = plate (AltR x1) |+ x2 |+ x3
        biplate x = plate x

 
instance Biplate AltR MaybeName where
         
        {-# INLINE biplate #-}
        biplate x = plate x

 
instance Biplate AltR LiteralR where
         
        {-# INLINE biplate #-}
        biplate (AltR x1 x2 x3) = plate (AltR x1) |+ x2 |+ x3
        biplate x = plate x

 
instance Biplate AltR GuardedExprR where
         
        {-# INLINE biplate #-}
        biplate (AltR x1 x2 x3) = plate (AltR x1 x2) |+ x3
        biplate x = plate x

 
instance Biplate NameR ModuleR where
         
        {-# INLINE biplate #-}
        biplate x = plate x

 
instance Biplate NameR BodyR where
         
        {-# INLINE biplate #-}
        biplate x = plate x

 
instance Biplate NameR DeclR where
         
        {-# INLINE biplate #-}
        biplate x = plate x

 
instance Biplate NameR FunBindR where
         
        {-# INLINE biplate #-}
        biplate x = plate x

 
instance Biplate NameR PatR where
         
        {-# INLINE biplate #-}
        biplate x = plate x

 
instance Biplate NameR RhsR where
         
        {-# INLINE biplate #-}
        biplate x = plate x

 
instance Biplate NameR ExprR where
         
        {-# INLINE biplate #-}
        biplate x = plate x

 
instance Biplate NameR MaybeExprR where
         
        {-# INLINE biplate #-}
        biplate x = plate x

 
instance Biplate NameR AltR where
         
        {-# INLINE biplate #-}
        biplate x = plate x

 
instance Biplate NameR NameR where
         
        {-# INLINE biplate #-}
        biplate = plateSelf

 
instance Biplate NameR MaybeName where
         
        {-# INLINE biplate #-}
        biplate x = plate x

 
instance Biplate NameR LiteralR where
         
        {-# INLINE biplate #-}
        biplate x = plate x

 
instance Biplate NameR GuardedExprR where
         
        {-# INLINE biplate #-}
        biplate x = plate x

 
instance Biplate MaybeName ModuleR where
         
        {-# INLINE biplate #-}
        biplate x = plate x

 
instance Biplate MaybeName BodyR where
         
        {-# INLINE biplate #-}
        biplate x = plate x

 
instance Biplate MaybeName DeclR where
         
        {-# INLINE biplate #-}
        biplate x = plate x

 
instance Biplate MaybeName FunBindR where
         
        {-# INLINE biplate #-}
        biplate x = plate x

 
instance Biplate MaybeName PatR where
         
        {-# INLINE biplate #-}
        biplate x = plate x

 
instance Biplate MaybeName RhsR where
         
        {-# INLINE biplate #-}
        biplate x = plate x

 
instance Biplate MaybeName ExprR where
         
        {-# INLINE biplate #-}
        biplate x = plate x

 
instance Biplate MaybeName MaybeExprR where
         
        {-# INLINE biplate #-}
        biplate x = plate x

 
instance Biplate MaybeName AltR where
         
        {-# INLINE biplate #-}
        biplate x = plate x

 
instance Biplate MaybeName NameR where
         
        {-# INLINE biplate #-}
        biplate (JustName x1) = plate JustName |* x1
        biplate x = plate x

 
instance Biplate MaybeName MaybeName where
         
        {-# INLINE biplate #-}
        biplate = plateSelf

 
instance Biplate MaybeName LiteralR where
         
        {-# INLINE biplate #-}
        biplate x = plate x

 
instance Biplate MaybeName GuardedExprR where
         
        {-# INLINE biplate #-}
        biplate x = plate x

 
instance Biplate LiteralR ModuleR where
         
        {-# INLINE biplate #-}
        biplate x = plate x

 
instance Biplate LiteralR BodyR where
         
        {-# INLINE biplate #-}
        biplate x = plate x

 
instance Biplate LiteralR DeclR where
         
        {-# INLINE biplate #-}
        biplate x = plate x

 
instance Biplate LiteralR FunBindR where
         
        {-# INLINE biplate #-}
        biplate x = plate x

 
instance Biplate LiteralR PatR where
         
        {-# INLINE biplate #-}
        biplate x = plate x

 
instance Biplate LiteralR RhsR where
         
        {-# INLINE biplate #-}
        biplate x = plate x

 
instance Biplate LiteralR ExprR where
         
        {-# INLINE biplate #-}
        biplate x = plate x

 
instance Biplate LiteralR MaybeExprR where
         
        {-# INLINE biplate #-}
        biplate x = plate x

 
instance Biplate LiteralR AltR where
         
        {-# INLINE biplate #-}
        biplate x = plate x

 
instance Biplate LiteralR NameR where
         
        {-# INLINE biplate #-}
        biplate x = plate x

 
instance Biplate LiteralR MaybeName where
         
        {-# INLINE biplate #-}
        biplate x = plate x

 
instance Biplate LiteralR LiteralR where
         
        {-# INLINE biplate #-}
        biplate = plateSelf

 
instance Biplate LiteralR GuardedExprR where
         
        {-# INLINE biplate #-}
        biplate x = plate x

 
instance Biplate GuardedExprR ModuleR where
         
        {-# INLINE biplate #-}
        biplate x = plate x

 
instance Biplate GuardedExprR BodyR where
         
        {-# INLINE biplate #-}
        biplate x = plate x

 
instance Biplate GuardedExprR DeclR where
         
        {-# INLINE biplate #-}
        biplate (GExprR x1 x2) = plate GExprR |+ x1 |+ x2

 
instance Biplate GuardedExprR FunBindR where
         
        {-# INLINE biplate #-}
        biplate (GExprR x1 x2) = plate GExprR |+ x1 |+ x2

 
instance Biplate GuardedExprR PatR where
         
        {-# INLINE biplate #-}
        biplate (GExprR x1 x2) = plate GExprR |+ x1 |+ x2

 
instance Biplate GuardedExprR RhsR where
         
        {-# INLINE biplate #-}
        biplate (GExprR x1 x2) = plate GExprR |+ x1 |+ x2

 
instance Biplate GuardedExprR ExprR where
         
        {-# INLINE biplate #-}
        biplate (GExprR x1 x2) = plate GExprR |* x1 |* x2

 
instance Biplate GuardedExprR MaybeExprR where
         
        {-# INLINE biplate #-}
        biplate (GExprR x1 x2) = plate GExprR |+ x1 |+ x2

 
instance Biplate GuardedExprR AltR where
         
        {-# INLINE biplate #-}
        biplate (GExprR x1 x2) = plate GExprR |+ x1 |+ x2

 
instance Biplate GuardedExprR NameR where
         
        {-# INLINE biplate #-}
        biplate (GExprR x1 x2) = plate GExprR |+ x1 |+ x2

 
instance Biplate GuardedExprR MaybeName where
         
        {-# INLINE biplate #-}
        biplate x = plate x

 
instance Biplate GuardedExprR LiteralR where
         
        {-# INLINE biplate #-}
        biplate (GExprR x1 x2) = plate GExprR |+ x1 |+ x2

 
instance Biplate GuardedExprR GuardedExprR where
         
        {-# INLINE biplate #-}
        biplate = plateSelf

-- | Deriving uniplate instances
-- ds = [ "ModuleR", "BodyR", "DeclR", "FunBindR", "PatR", "RhsR", "ExprR", "MaybeExprR", "AltR"
--      , "NameR", "MaybeName", "LiteralR", "GuardedExprR" ]
-- 
-- putStrLn $ "{-!\n" 
--          ++ unlines ["deriving instance UniplateDirect " ++ d | d <- ds] 
--          ++ unlines ["deriving instance UniplateDirect " ++ d ++ " " ++ d' | d <- ds, d' <- ds] 
--          ++ "!-}"

{-!
deriving instance UniplateDirect ModuleR
deriving instance UniplateDirect BodyR
deriving instance UniplateDirect DeclR
deriving instance UniplateDirect FunBindR
deriving instance UniplateDirect PatR
deriving instance UniplateDirect RhsR
deriving instance UniplateDirect ExprR
deriving instance UniplateDirect MaybeExprR
deriving instance UniplateDirect AltR
deriving instance UniplateDirect NameR
deriving instance UniplateDirect MaybeName
deriving instance UniplateDirect LiteralR
deriving instance UniplateDirect GuardedExprR
deriving instance UniplateDirect ModuleR ModuleR
deriving instance UniplateDirect ModuleR BodyR
deriving instance UniplateDirect ModuleR DeclR
deriving instance UniplateDirect ModuleR FunBindR
deriving instance UniplateDirect ModuleR PatR
deriving instance UniplateDirect ModuleR RhsR
deriving instance UniplateDirect ModuleR ExprR
deriving instance UniplateDirect ModuleR MaybeExprR
deriving instance UniplateDirect ModuleR AltR
deriving instance UniplateDirect ModuleR NameR
deriving instance UniplateDirect ModuleR MaybeName
deriving instance UniplateDirect ModuleR LiteralR
deriving instance UniplateDirect ModuleR GuardedExprR
deriving instance UniplateDirect BodyR ModuleR
deriving instance UniplateDirect BodyR BodyR
deriving instance UniplateDirect BodyR DeclR
deriving instance UniplateDirect BodyR FunBindR
deriving instance UniplateDirect BodyR PatR
deriving instance UniplateDirect BodyR RhsR
deriving instance UniplateDirect BodyR ExprR
deriving instance UniplateDirect BodyR MaybeExprR
deriving instance UniplateDirect BodyR AltR
deriving instance UniplateDirect BodyR NameR
deriving instance UniplateDirect BodyR MaybeName
deriving instance UniplateDirect BodyR LiteralR
deriving instance UniplateDirect BodyR GuardedExprR
deriving instance UniplateDirect DeclR ModuleR
deriving instance UniplateDirect DeclR BodyR
deriving instance UniplateDirect DeclR DeclR
deriving instance UniplateDirect DeclR FunBindR
deriving instance UniplateDirect DeclR PatR
deriving instance UniplateDirect DeclR RhsR
deriving instance UniplateDirect DeclR ExprR
deriving instance UniplateDirect DeclR MaybeExprR
deriving instance UniplateDirect DeclR AltR
deriving instance UniplateDirect DeclR NameR
deriving instance UniplateDirect DeclR MaybeName
deriving instance UniplateDirect DeclR LiteralR
deriving instance UniplateDirect DeclR GuardedExprR
deriving instance UniplateDirect FunBindR ModuleR
deriving instance UniplateDirect FunBindR BodyR
deriving instance UniplateDirect FunBindR DeclR
deriving instance UniplateDirect FunBindR FunBindR
deriving instance UniplateDirect FunBindR PatR
deriving instance UniplateDirect FunBindR RhsR
deriving instance UniplateDirect FunBindR ExprR
deriving instance UniplateDirect FunBindR MaybeExprR
deriving instance UniplateDirect FunBindR AltR
deriving instance UniplateDirect FunBindR NameR
deriving instance UniplateDirect FunBindR MaybeName
deriving instance UniplateDirect FunBindR LiteralR
deriving instance UniplateDirect FunBindR GuardedExprR
deriving instance UniplateDirect PatR ModuleR
deriving instance UniplateDirect PatR BodyR
deriving instance UniplateDirect PatR DeclR
deriving instance UniplateDirect PatR FunBindR
deriving instance UniplateDirect PatR PatR
deriving instance UniplateDirect PatR RhsR
deriving instance UniplateDirect PatR ExprR
deriving instance UniplateDirect PatR MaybeExprR
deriving instance UniplateDirect PatR AltR
deriving instance UniplateDirect PatR NameR
deriving instance UniplateDirect PatR MaybeName
deriving instance UniplateDirect PatR LiteralR
deriving instance UniplateDirect PatR GuardedExprR
deriving instance UniplateDirect RhsR ModuleR
deriving instance UniplateDirect RhsR BodyR
deriving instance UniplateDirect RhsR DeclR
deriving instance UniplateDirect RhsR FunBindR
deriving instance UniplateDirect RhsR PatR
deriving instance UniplateDirect RhsR RhsR
deriving instance UniplateDirect RhsR ExprR
deriving instance UniplateDirect RhsR MaybeExprR
deriving instance UniplateDirect RhsR AltR
deriving instance UniplateDirect RhsR NameR
deriving instance UniplateDirect RhsR MaybeName
deriving instance UniplateDirect RhsR LiteralR
deriving instance UniplateDirect RhsR GuardedExprR
deriving instance UniplateDirect ExprR ModuleR
deriving instance UniplateDirect ExprR BodyR
deriving instance UniplateDirect ExprR DeclR
deriving instance UniplateDirect ExprR FunBindR
deriving instance UniplateDirect ExprR PatR
deriving instance UniplateDirect ExprR RhsR
deriving instance UniplateDirect ExprR ExprR
deriving instance UniplateDirect ExprR MaybeExprR
deriving instance UniplateDirect ExprR AltR
deriving instance UniplateDirect ExprR NameR
deriving instance UniplateDirect ExprR MaybeName
deriving instance UniplateDirect ExprR LiteralR
deriving instance UniplateDirect ExprR GuardedExprR
deriving instance UniplateDirect MaybeExprR ModuleR
deriving instance UniplateDirect MaybeExprR BodyR
deriving instance UniplateDirect MaybeExprR DeclR
deriving instance UniplateDirect MaybeExprR FunBindR
deriving instance UniplateDirect MaybeExprR PatR
deriving instance UniplateDirect MaybeExprR RhsR
deriving instance UniplateDirect MaybeExprR ExprR
deriving instance UniplateDirect MaybeExprR MaybeExprR
deriving instance UniplateDirect MaybeExprR AltR
deriving instance UniplateDirect MaybeExprR NameR
deriving instance UniplateDirect MaybeExprR MaybeName
deriving instance UniplateDirect MaybeExprR LiteralR
deriving instance UniplateDirect MaybeExprR GuardedExprR
deriving instance UniplateDirect AltR ModuleR
deriving instance UniplateDirect AltR BodyR
deriving instance UniplateDirect AltR DeclR
deriving instance UniplateDirect AltR FunBindR
deriving instance UniplateDirect AltR PatR
deriving instance UniplateDirect AltR RhsR
deriving instance UniplateDirect AltR ExprR
deriving instance UniplateDirect AltR MaybeExprR
deriving instance UniplateDirect AltR AltR
deriving instance UniplateDirect AltR NameR
deriving instance UniplateDirect AltR MaybeName
deriving instance UniplateDirect AltR LiteralR
deriving instance UniplateDirect AltR GuardedExprR
deriving instance UniplateDirect NameR ModuleR
deriving instance UniplateDirect NameR BodyR
deriving instance UniplateDirect NameR DeclR
deriving instance UniplateDirect NameR FunBindR
deriving instance UniplateDirect NameR PatR
deriving instance UniplateDirect NameR RhsR
deriving instance UniplateDirect NameR ExprR
deriving instance UniplateDirect NameR MaybeExprR
deriving instance UniplateDirect NameR AltR
deriving instance UniplateDirect NameR NameR
deriving instance UniplateDirect NameR MaybeName
deriving instance UniplateDirect NameR LiteralR
deriving instance UniplateDirect NameR GuardedExprR
deriving instance UniplateDirect MaybeName ModuleR
deriving instance UniplateDirect MaybeName BodyR
deriving instance UniplateDirect MaybeName DeclR
deriving instance UniplateDirect MaybeName FunBindR
deriving instance UniplateDirect MaybeName PatR
deriving instance UniplateDirect MaybeName RhsR
deriving instance UniplateDirect MaybeName ExprR
deriving instance UniplateDirect MaybeName MaybeExprR
deriving instance UniplateDirect MaybeName AltR
deriving instance UniplateDirect MaybeName NameR
deriving instance UniplateDirect MaybeName MaybeName
deriving instance UniplateDirect MaybeName LiteralR
deriving instance UniplateDirect MaybeName GuardedExprR
deriving instance UniplateDirect LiteralR ModuleR
deriving instance UniplateDirect LiteralR BodyR
deriving instance UniplateDirect LiteralR DeclR
deriving instance UniplateDirect LiteralR FunBindR
deriving instance UniplateDirect LiteralR PatR
deriving instance UniplateDirect LiteralR RhsR
deriving instance UniplateDirect LiteralR ExprR
deriving instance UniplateDirect LiteralR MaybeExprR
deriving instance UniplateDirect LiteralR AltR
deriving instance UniplateDirect LiteralR NameR
deriving instance UniplateDirect LiteralR MaybeName
deriving instance UniplateDirect LiteralR LiteralR
deriving instance UniplateDirect LiteralR GuardedExprR
deriving instance UniplateDirect GuardedExprR ModuleR
deriving instance UniplateDirect GuardedExprR BodyR
deriving instance UniplateDirect GuardedExprR DeclR
deriving instance UniplateDirect GuardedExprR FunBindR
deriving instance UniplateDirect GuardedExprR PatR
deriving instance UniplateDirect GuardedExprR RhsR
deriving instance UniplateDirect GuardedExprR ExprR
deriving instance UniplateDirect GuardedExprR MaybeExprR
deriving instance UniplateDirect GuardedExprR AltR
deriving instance UniplateDirect GuardedExprR NameR
deriving instance UniplateDirect GuardedExprR MaybeName
deriving instance UniplateDirect GuardedExprR LiteralR
deriving instance UniplateDirect GuardedExprR GuardedExprR
!-}

-}

