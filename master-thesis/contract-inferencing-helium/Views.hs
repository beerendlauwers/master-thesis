{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FlexibleInstances, NoMonomorphismRestriction #-}
{-# LANGUAGE FlexibleContexts, FunctionalDependencies #-}
-----------------------------------------------------------------------------
-- Copyright 2011, Open Universiteit Nederland. This file is distributed 
-- under the terms of the GNU General Public License. For more information, 
-- see the file "LICENSE.txt", which is included in the distribution.
-----------------------------------------------------------------------------
-- |
-- Maintainer  :  alex.gerdes@ou.nl
-- Stability   :  provisional
-- Portability :  unknown
-- 
-----------------------------------------------------------------------------

module Domain.FP.Views (
      -- * Views
      heliumView, heliumWithRangesView -- , ghcView
      -- * Conversion functions
   ,  toHelium, fromHelium, inHelium
   ,  toHeliumWithRanges, fromHeliumWithRanges, inHeliumWithRanges
      -- * Casting type class
   ,  Cast
   ) where

import Common.Library hiding (from, to)
import Data.Char (readLitChar)
import Domain.FP.Helium hiding (Module, Body, Name, Literal, MaybeName)
import Domain.FP.HeliumInstances ()
import qualified Domain.FP.Helium as Helium
import Domain.FP.Syntax
import Domain.FP.SyntaxWithRanges
--import qualified Language.Haskell.Syntax as GHC


-- | Convert bewteen Helium and own abstract syntax
heliumView ::Cast a b => View a b
heliumView = makeView (Just . fromHelium) toHelium

fromHelium :: Cast a b => a -> b
fromHelium =  from

toHelium :: Cast a b => b -> a
toHelium = to

inHelium :: Cast a b => (a -> a) -> b -> b
inHelium f = from . f . to


class Cast a b where
   from :: a -> b
   to   :: b -> a

-- instance Cast Helium.Module Module where
--    from m = 
--       case m of
--          Module_Module _ n _ (Body_Hole _ i)    -> Module (from n) []
--          Module_Module _ n _ (Body_Body _ _ ds) -> Module (from n) (map from ds)
--    
--    to m = 
--       case m of 
--          Module n ds ->
--             Module_Module noRange (to n) MaybeExports_Nothing
--                (Body_Body noRange [] $ map to ds)
instance Cast Helium.Module Module where
   from m = 
      case m of
         Module_Module _ n _ b -> Module (from n) (from b)
   
   to m = 
      case m of 
         Module n b ->
            Module_Module noRange (to n) MaybeExports_Nothing (to b)

instance Cast Helium.Body Body where
   from b = 
      case b of
         Body_Hole _ i    -> BHole i
         Body_Body _ _ ds -> Body (map from ds)
   
   to b = 
      case b of 
         BHole i -> Body_Hole noRange i
         Body ds -> Body_Body noRange [] $ map to ds

instance Cast Declaration Decl where
   from d = 
      case d of 
         Declaration_Hole _ i               -> DHole i
         Declaration_Empty _                -> DEmpty
         Declaration_FunctionBindings _ fs  -> DFunBinds $ map from fs
         Declaration_PatternBinding _ p rhs -> DPatBind (from p) (from rhs)
         Declaration_TypeSignature _ _ _    -> DEmpty -- throw away type sigs
         Declaration_Fixity _ _ _ _         -> DEmpty -- throw away fixity decls
         Declaration_Data _ _ _ _ _         -> DEmpty
         _                                  -> castError d
   
   to d =
      case d of
         DHole i        -> Declaration_Hole noRange i
         DEmpty         -> Declaration_Empty noRange
         DFunBinds fs   -> Declaration_FunctionBindings noRange $ map to fs
         DPatBind p rhs -> Declaration_PatternBinding noRange (to p) (to rhs)

instance Cast FunctionBinding FunBind where
   from f = 
      case f of 
         FunctionBinding_Hole _ i -> FBHole i
         FunctionBinding_FunctionBinding _ lhs rhs -> 
            FunBind Nothing (from n') (map from ps') (from rhs)
               where 
                  (n', ps') = fromLhs lhs
                  fromLhs (LeftHandSide_Function _ n ps) = (n, ps)
                  fromLhs (LeftHandSide_Infix _ lp op rp) = (op, [lp, rp]) -- This is a shorcut (read: hack) we can't go back to infix!
                  fromLhs _ = castError f
         FunctionBinding_Feedback _ s fb -> (\(FunBind _ a b c) -> FunBind (Just s) a b c) (from fb)

   to f =
      case f of
         FBHole i -> FunctionBinding_Hole noRange i
         FunBind mfb n ps rhs -> maybe id (FunctionBinding_Feedback noRange) mfb
                              $ FunctionBinding_FunctionBinding noRange lhs (to rhs)
               where
                  lhs = LeftHandSide_Function noRange (to n) (map to ps)

instance Cast Expression Expr where
   from expr =
      case expr of
         Expression_Hole _ i                     -> Hole i
         Expression_Feedback _ s e               -> Feedback s (from e)
         Expression_Case _ e as                  -> Case (from e) (map from as)
         Expression_Constructor _ n              -> Con $ from n
         Expression_If _ c t e                   -> If (from c) (from t) (from e)
         Expression_InfixApplication _ mel e mer -> InfixApp (from mel) (from e) (from mer)
         Expression_Lambda _ ps e                -> Lambda (map from ps) (from e)
         Expression_Let _ ds e                   -> Let (map from ds) (from e)
         Expression_Literal _ l                  -> Lit $ from l
         Expression_NormalApplication _ f es     -> App (from f) (map from es)
         Expression_Parenthesized _ e            -> Paren (from e)
         Expression_Tuple _ es                   -> Tuple $ map from es
         Expression_Variable _ n                 -> Var $ from n
         Expression_Enum _ e me1 me2             -> Enum (from e) (from me1) (from me2)
         Expression_List _ es                    -> List (map from es)
         Expression_Negate _ e                   -> Neg $ from e
         Expression_NegateFloat _ e              -> Neg $ from e -- AG: hack we can't go back!!!
         _                                       -> castError expr
   
   to expr =
      case expr of
         Hole i             -> Expression_Hole noRange i
         Feedback s e       -> Expression_Feedback noRange s (to e)
         MustUse e          -> to e
         Case e as          -> Expression_Case noRange (to e) (map to as)
         Con n              -> Expression_Constructor noRange $ to n
         If c t e           -> Expression_If noRange (to c) (to t) (to e)
         InfixApp mel e mer -> Expression_InfixApplication noRange (to mel) (to e) (to mer)
         Lambda ps e        -> Expression_Lambda noRange (map to ps) (to e)
         Let ds e           -> Expression_Let noRange (map to ds) (to e)
         Lit l              -> Expression_Literal noRange $ to l
         App f es           -> Expression_NormalApplication noRange (to f) (map to es)
         Paren e            -> Expression_Parenthesized noRange $ to e
         Tuple es           -> Expression_Tuple noRange $ map to es
         Var n              -> Expression_Variable noRange $ to n
         Enum e me1 me2     -> Expression_Enum noRange (to e) (to me1) (to me2)
         List es            -> Expression_List noRange $ map to es
         Neg e              -> Expression_Negate noRange $ to e

instance Cast GuardedExpression GuardedExpr where
   from (GuardedExpression_GuardedExpression _ g e) = GExpr (from g) (from e)

   to gexpr =
      case gexpr of
         GExpr g e    -> 
            GuardedExpression_GuardedExpression noRange (to g) (to e)

instance Cast Pattern Pat where
   from pat = 
      case pat of
         Pattern_Hole _ i                   -> PHole i
         Pattern_Constructor _ n ps         -> PCon (from n) (map from ps)
         Pattern_InfixConstructor _ pl n pr -> PInfixCon (from pl) (from n) (from pr)
         Pattern_List _ ps                  -> PList (map from ps)
         Pattern_Literal _ l                -> PLit (from l)
         Pattern_Parenthesized _ p          -> PParen (from p)
         Pattern_Tuple _ ps                 -> PTuple (map from ps)
         Pattern_Variable _ n               -> PVar (from n)
         Pattern_As _ n p                   -> PAs (from n) (from p)
         Pattern_Wildcard _                 -> PWildcard
         _                                  -> castError pat
   
   to pat =
      case pat of
         PHole i           -> Pattern_Hole noRange i
         PCon n ps         -> Pattern_Constructor noRange (to n) (map to ps)
         PInfixCon pl n pr -> Pattern_InfixConstructor noRange (to pl) (to n) (to pr)
         PList ps          -> Pattern_List noRange $ map to ps
         PLit l            -> Pattern_Literal noRange $ to l
         PParen p          -> Pattern_Parenthesized noRange $ to p
         PTuple ps         -> Pattern_Tuple noRange $ map to ps
         PVar n            -> Pattern_Variable noRange $ to n
         PAs n p           -> Pattern_As noRange (to n) (to p)
         PWildcard         -> Pattern_Wildcard noRange

instance Cast Helium.Literal Literal where
   from l = 
      case l of
         Literal_Char _ s   -> LChar $ fst $ head $ readLitChar s
         Literal_Float _ s  -> LFloat $ read s
         Literal_Int _ s    -> LInt $ read s
         Literal_String _ s -> LString s

   to l =
      case l of
         LChar c   -> Literal_Char noRange [c]
         LFloat f  -> Literal_Float noRange $ show f
         LInt i    -> Literal_Int noRange $ show i
         LString s -> Literal_String noRange s

instance Cast RightHandSide Rhs where
   from rhs =  
      case rhs of
         RightHandSide_Expression _ e mds -> Rhs (from e) (from mds)
         RightHandSide_Guarded _ ges mds  -> GRhs (map from ges) (from mds)
   
   to rhs =
      case rhs of
          Rhs e ds    -> RightHandSide_Expression noRange (to e) (to ds)
          GRhs ges ds -> RightHandSide_Guarded noRange (map to ges) (to ds)

instance Cast MaybeDeclarations [Decl] where
   from mds =
      case mds of
         MaybeDeclarations_Just ds -> map from ds
         MaybeDeclarations_Nothing -> []
   
   to [] = MaybeDeclarations_Nothing 
   to ds = MaybeDeclarations_Just $ map to ds

instance Cast Helium.MaybeName MaybeName where
   from mn = 
      case mn of
         MaybeName_Just n  -> JustName $ from n
         MaybeName_Nothing -> NoName
   
   to mn = 
      case mn of
         JustName n -> MaybeName_Just $ to n
         NoName     -> MaybeName_Nothing

instance Cast MaybeExpression MaybeExpr where
   from me = 
      case me of
         MaybeExpression_Just e  -> JustExpr $ from e
         MaybeExpression_Nothing -> NoExpr
   
   to me = 
      case me of
         JustExpr e -> MaybeExpression_Just $ to e
         NoExpr     -> MaybeExpression_Nothing

instance Cast Helium.Name Name where
   from n = 
      case n of
         Name_Identifier _ _ s -> Ident s
         Name_Operator _ _ s   -> Operator s
         Name_Special _ _ s    -> Special s
   
   to n =
      case n of
         Ident s    -> Name_Identifier noRange [] s
         Operator s -> Name_Operator noRange [] s
         Special s  -> Name_Special noRange [] s

instance Cast Alternative Alt where
   from a = 
      case a of
         Alternative_Hole _ i            -> AHole i
         Alternative_Alternative _ p rhs -> Alt Nothing (from p) (from rhs)
         Alternative_Feedback _ s al     -> (\(Alt _ x y) -> Alt (Just s) x y) $ (from al)
         Alternative_Empty _             -> AltEmpty

   to a =
      case a of 
         AHole i   -> Alternative_Hole noRange i
         Alt mfb p rhs -> maybe id (Alternative_Feedback noRange) mfb
                        $ Alternative_Alternative noRange (to p) (to rhs)
         AltEmpty  -> Alternative_Empty noRange

-- | Convert bewteen Helium and own abstract syntax, keeping ranges
heliumWithRangesView ::Cast a b => View a b
heliumWithRangesView = makeView (Just . fromHeliumWithRanges) toHelium

fromHeliumWithRanges :: Cast a b => a -> b
fromHeliumWithRanges = from

toHeliumWithRanges :: Cast a b => b -> a
toHeliumWithRanges = to

inHeliumWithRanges :: Cast a b => (a -> a) -> b -> b
inHeliumWithRanges f = from . f . to

instance Cast Helium.Module ModuleR where
   from m = 
      case m of
         Module_Module r n _ b -> ModuleR (from n) (from b) (from r)
   
   to m = 
      case m of 
         ModuleR n b r ->
            Module_Module (to r) (to n) MaybeExports_Nothing (to b)

instance Cast Helium.Body BodyR where
   from b = 
      case b of
         Body_Hole r i    -> BHoleR i (from r)
         Body_Body r _ ds -> BodyR (map from ds) (from r)
   
   to b = 
      case b of 
         BHoleR i r -> Body_Hole (to r) i
         BodyR ds r -> Body_Body (to r) [] $ map to ds

instance Cast Declaration DeclR where
   from d = 
      case d of 
         Declaration_Hole r i               -> DHoleR i (from r)
         Declaration_Empty r                -> DEmptyR (from r)
         Declaration_FunctionBindings r fs  -> DFunBindsR (map from fs) (from r)
         Declaration_PatternBinding r p rhs -> DPatBindR (from p) (from rhs) (from r)
         Declaration_TypeSignature r _ _    -> DEmptyR (from r) -- throw away type sigs
         Declaration_Fixity r _ _ _         -> DEmptyR (from r) -- throw away fixity decls
         Declaration_Data r _ _ _ _         -> DEmptyR (from r)
         _                                  -> castError d
   
   to d =
      case d of
         DHoleR i r        -> Declaration_Hole (to r) i
         DEmptyR r         -> Declaration_Empty (to r)
         DFunBindsR fs r   -> Declaration_FunctionBindings (to r) $ map to fs
         DPatBindR p rhs r -> Declaration_PatternBinding (to r) (to p) (to rhs)


instance Cast FunctionBinding FunBindR where
   from f = 
      case f of 
         FunctionBinding_Hole r i -> FBHoleR i (from r)
         FunctionBinding_FunctionBinding r lhs rhs -> 
            FunBindR Nothing (from n') (map from ps') (from rhs) (from r)
               where 
                  (n', ps') = fromLhs lhs
                  fromLhs (LeftHandSide_Function _ n ps) = (n, ps)
                  fromLhs (LeftHandSide_Infix _ lp op rp) = (op, [lp, rp]) -- This is a shorcut (read: hack) we can't go back to infix!
                  fromLhs _ = castError f
         FunctionBinding_Feedback r s fb -> (\(FunBindR _ a b c r') -> FunBindR (Just s) a b c) (from fb) (from r)

   to f =
      case f of
         FBHoleR i r -> FunctionBinding_Hole (to r) i
         FunBindR mfb n ps rhs r -> maybe id (FunctionBinding_Feedback noRange) mfb
                                   $ FunctionBinding_FunctionBinding (to r) lhs (to rhs)
               where
                  lhs = LeftHandSide_Function noRange (to n) (map to ps)

instance Cast Expression ExprR where
   from expr =
      case expr of
         Expression_Hole r i                     -> HoleR i (from r)
         Expression_Feedback r s e               -> FeedbackR s (from e) (from r)
         Expression_Case r e as                  -> CaseR (from e) (map from as) (from r)
         Expression_Constructor r n              -> ConR (from n) (from r)
         Expression_If r c t e                   -> IfR (from c) (from t) (from e) (from r)
         Expression_InfixApplication r mel e mer -> InfixAppR (from mel) (from e) (from mer) (from r)
         Expression_Lambda r ps e                -> LambdaR (map from ps) (from e) (from r)
         Expression_Let r ds e                   -> LetR (map from ds) (from e) (from r)
         Expression_Literal r l                  -> LitR (from l) (from r)
         Expression_NormalApplication r f es     -> AppR (from f) (map from es) (from r)
         Expression_Parenthesized r e            -> ParenR (from e) (from r)
         Expression_Tuple r es                   -> TupleR (map from es) (from r)
         Expression_Variable r n                 -> VarR (from n) (from r)
         Expression_Enum r e me1 me2             -> EnumR (from e) (from me1) (from me2) (from r)
         Expression_List r es                    -> ListR (map from es) (from r)
         Expression_Negate r e                   -> NegR (from e) (from r)
         Expression_NegateFloat r e              -> NegR (from e) (from r) -- AG: hack we can't go back!!!
         _                                       -> castError expr
   
   to expr =
      case expr of
         HoleR i r             -> Expression_Hole (to r) i
         FeedbackR s e r       -> Expression_Feedback (to r) s (to e)
         MustUseR e r          -> Expression_MustUse (to r) (to e) 
         CaseR e as r          -> Expression_Case (to r) (to e) (map to as)
         ConR n r              -> Expression_Constructor (to r) $ to n
         IfR c t e r           -> Expression_If (to r) (to c) (to t) (to e)
         InfixAppR mel e mer r -> Expression_InfixApplication (to r) (to mel) (to e) (to mer)
         LambdaR ps e r        -> Expression_Lambda (to r) (map to ps) (to e)
         LetR ds e r           -> Expression_Let (to r) (map to ds) (to e)
         LitR l r              -> Expression_Literal (to r) $ to l
         AppR f es r           -> Expression_NormalApplication (to r) (to f) (map to es)
         ParenR e r            -> Expression_Parenthesized (to r) $ to e
         TupleR es r           -> Expression_Tuple (to r) $ map to es
         VarR n r              -> Expression_Variable (to r) $ to n
         EnumR e me1 me2 r     -> Expression_Enum (to r) (to e) (to me1) (to me2)
         ListR es r            -> Expression_List (to r) $ map to es
         NegR e r              -> Expression_Negate (to r) $ to e

instance Cast GuardedExpression GuardedExprR where
   from (GuardedExpression_GuardedExpression r g e) = GExprR (from g) (from e) (from r)

   to gexpr =
      case gexpr of
         GExprR g e r    -> 
            GuardedExpression_GuardedExpression (to r) (to g) (to e)

instance Cast Pattern PatR where
   from pat = 
      case pat of
         Pattern_Hole r i                   -> PHoleR i (from r)
         Pattern_Constructor r n ps         -> PConR (from n) (map from ps) (from r)
         Pattern_InfixConstructor r pl n pr -> PInfixConR (from pl) (from n) (from pr) (from r)
         Pattern_List r ps                  -> PListR (map from ps) (from r)
         Pattern_Literal r l                -> PLitR (from l) (from r)
         Pattern_Parenthesized r p          -> PParenR (from p) (from r)
         Pattern_Tuple r ps                 -> PTupleR (map from ps) (from r)
         Pattern_Variable r n               -> PVarR (from n) (from r)
         Pattern_As r n p                   -> PAsR (from n) (from p) (from r)
         Pattern_Wildcard r                 -> PWildcardR (from r)
         _                                  -> castError pat
   
   to pat =
      case pat of
         PHoleR i r           -> Pattern_Hole (to r) i
         PConR n ps r         -> Pattern_Constructor (to r) (to n) (map to ps)
         PInfixConR pl n pr r -> Pattern_InfixConstructor (to r) (to pl) (to n) (to pr)
         PListR ps r          -> Pattern_List (to r) $ map to ps
         PLitR l r            -> Pattern_Literal (to r) $ to l
         PParenR p r          -> Pattern_Parenthesized (to r) $ to p
         PTupleR ps r         -> Pattern_Tuple (to r) $ map to ps
         PVarR n r            -> Pattern_Variable (to r) $ to n
         PAsR n p r           -> Pattern_As (to r) (to n) (to p)
         PWildcardR r         -> Pattern_Wildcard (to r)

instance Cast Helium.Literal LiteralR where
   from l = 
      case l of
         Literal_Char r s   -> LCharR (fst $ head $ readLitChar s) (from r)
         Literal_Float r s  -> LFloatR (read s) (from r)
         Literal_Int r s    -> LIntR (read s) (from r)
         Literal_String r s -> LStringR s (from r)

   to l =
      case l of
         LCharR c r   -> Literal_Char (to r) [c]
         LFloatR f r  -> Literal_Float (to r) $ show f
         LIntR i r    -> Literal_Int (to r) $ show i
         LStringR s r -> Literal_String (to r) s

instance Cast RightHandSide RhsR where
   from rhs =  
      case rhs of
         RightHandSide_Expression r e mds -> RhsR (from e) (from mds) (from r)
         RightHandSide_Guarded r ges mds  -> GRhsR (map from ges) (from mds) (from r)
   
   to rhs =
      case rhs of
          RhsR e ds r    -> RightHandSide_Expression (to r) (to e) (to ds)
          GRhsR ges ds r -> RightHandSide_Guarded (to r) (map to ges) (to ds)

instance Cast MaybeDeclarations [DeclR] where
   from mds =
      case mds of
         MaybeDeclarations_Just ds -> map from ds
         MaybeDeclarations_Nothing -> []
   
   to [] = MaybeDeclarations_Nothing 
   to ds = MaybeDeclarations_Just $ map to ds

instance Cast Helium.MaybeName MaybeNameR where
   from mn = 
      case mn of
         MaybeName_Just n  -> JustNameR $ from n
         MaybeName_Nothing -> NoNameR
   
   to mn = 
      case mn of
         JustNameR n -> MaybeName_Just $ to n
         NoNameR     -> MaybeName_Nothing

instance Cast MaybeExpression MaybeExprR where
   from me = 
      case me of
         MaybeExpression_Just e  -> JustExprR $ from e
         MaybeExpression_Nothing -> NoExprR
   
   to me = 
      case me of
         JustExprR e -> MaybeExpression_Just $ to e
         NoExprR     -> MaybeExpression_Nothing

instance Cast Helium.Name NameR where
   from n = 
      case n of
         Name_Identifier r _ s -> IdentR s (from r)
         Name_Operator r _ s   -> OperatorR s (from r)
         Name_Special r _ s    -> SpecialR s (from r)
   
   to n =
      case n of
         IdentR s r    -> Name_Identifier (to r) [] s
         OperatorR s r -> Name_Operator (to r) [] s
         SpecialR s r  -> Name_Special (to r) [] s

instance Cast Alternative AltR where
   from a = 
      case a of
         Alternative_Hole r i            -> AHoleR i (from r)
         Alternative_Alternative r p rhs -> AltR Nothing (from p) (from rhs) (from r)
         Alternative_Feedback r s al     -> (\(AltR _ x y r') -> AltR (Just s) x y r') $ (from al)
         Alternative_Empty r             -> AltEmptyR (from r)

   to a =
      case a of 
         AHoleR i r   -> Alternative_Hole (to r) i
         AltR mfb p rhs r -> maybe id (Alternative_Feedback noRange) mfb
                        $ Alternative_Alternative (to r) (to p) (to rhs)
         AltEmptyR r  -> Alternative_Empty (to r)

instance Cast Range RangeR where
   from (Range_Range x y)  = RangeR (from x) (from y)
   to   (RangeR x y) = Range_Range (to x) (to y)

instance Cast Position PositionR where
  from (Position_Position n l c)  = PositionR n l c
  from Position_Unknown = UnknownR
  to   (PositionR n l c) = Position_Position n l c
  to   UnknownR = Position_Unknown

-- | Convert between GHC and own abstract syntax
-- ghcView :: View GHC.Module Module
-- ghcView = undefined


-- | Help functions
castError :: Show a => a -> b
castError x = error $ "Unable to cast: " ++ show x

--removeEmptyDecls :: Module -> Module -- Biplate a [Decl => a -> a
--removeEmptyDecls = transformBi (filter (/= DEmpty))
