

-- UUAGC 0.9.40.2 (src\CCO\SystemF\AG.ag)
module CCO.SystemF.AG where

{-# LINE 2 "src\\CCO\\SystemF\\AG/Base.ag" #-}

import CCO.SourcePos
{-# LINE 10 "dist\\build\\pp-systemf\\pp-systemf-tmp\\CCO\\SystemF\\AG.hs" #-}

{-# LINE 2 "src\\CCO\\SystemF\\AG/Printing.ag" #-}

import CCO.Printing
{-# LINE 15 "dist\\build\\pp-systemf\\pp-systemf-tmp\\CCO\\SystemF\\AG.hs" #-}
{-# LINE 10 "src\\CCO\\SystemF\\AG/Base.ag" #-}

type TyVar = String    -- ^ Type of type variables. 
type Var   = String    -- ^ Type of variables.
{-# LINE 20 "dist\\build\\pp-systemf\\pp-systemf-tmp\\CCO\\SystemF\\AG.hs" #-}

{-# LINE 49 "src\\CCO\\SystemF\\AG/Printing.ag" #-}

-- | Type of precedence levels.
type Prec = Int
{-# LINE 26 "dist\\build\\pp-systemf\\pp-systemf-tmp\\CCO\\SystemF\\AG.hs" #-}

{-# LINE 71 "src\\CCO\\SystemF\\AG/Printing.ag" #-}

-- | Pretty prints in single-line mode, given the precedence level of its
-- immediate context, a term constructed from a binary operator of a specified
-- precedence level.
-- 
-- A term is enclosed in parentheses if the precedence level of its operator 
-- is less than the precedence level of the enclosing context.

ppInfixSL :: Prec -> (String, Prec) -> Doc -> Doc -> Doc
ppInfixSL ctx (op, prec) l r = modifier $ l >#< ppOp >#< r
  where
    modifier = if prec < ctx then parens else id
    ppOp     = text op

-- | Pretty prints in multiline mode, given the precedence level of its
-- immediate context, a term constructed from a binary operator of a specified
-- precedence level.
-- 
-- A term is enclosed in parentheses if the precedence level of its operator 
-- is less than the precedence level of the enclosing context.

ppInfixML :: Prec -> (String, Prec) -> Doc -> Doc -> Doc
ppInfixML ctx (op, prec) l r = modifier $ l >#< ppOp >-< r
  where
    modifier doc = if prec < ctx then (lparen >#< doc >-< rparen) else doc
    ppOp         = text op
{-# LINE 55 "dist\\build\\pp-systemf\\pp-systemf-tmp\\CCO\\SystemF\\AG.hs" #-}

{-# LINE 103 "src\\CCO\\SystemF\\AG/Printing.ag" #-}

-- | Pretty prints in single-line mode, a construct involving a binder.
ppBinderSL :: String -> Doc -> Doc -> Doc
ppBinderSL binder arg body = text binder >|< arg >|< period >#< body

-- | Pretty prints in multiline mode, a construct involving a binder.
ppBinderML :: String -> Doc -> Doc -> Doc
ppBinderML binder arg body = text binder >|< arg >|< period >-< indent 2 body
{-# LINE 66 "dist\\build\\pp-systemf\\pp-systemf-tmp\\CCO\\SystemF\\AG.hs" #-}
-- Tm ----------------------------------------------------------
data Tm = App (Tm) (Tm)
        | Lam (Var) (Ty) (Tm)
        | TyApp (Tm) (Ty)
        | TyLam (TyVar) (Tm)
        | Var (Var)
-- cata
sem_Tm :: Tm ->
          T_Tm
sem_Tm (App _t1 _t2) =
    (sem_Tm_App (sem_Tm _t1) (sem_Tm _t2))
sem_Tm (Lam _x _ty _t1) =
    (sem_Tm_Lam _x (sem_Ty _ty) (sem_Tm _t1))
sem_Tm (TyApp _t1 _ty) =
    (sem_Tm_TyApp (sem_Tm _t1) (sem_Ty _ty))
sem_Tm (TyLam _a _t1) =
    (sem_Tm_TyLam _a (sem_Tm _t1))
sem_Tm (Var _x) =
    (sem_Tm_Var _x)
-- semantic domain
type T_Tm = Prec ->
            ( Doc,Doc)
data Inh_Tm = Inh_Tm {prec_Inh_Tm :: Prec}
data Syn_Tm = Syn_Tm {ppML_Syn_Tm :: Doc,ppSL_Syn_Tm :: Doc}
wrap_Tm :: T_Tm ->
           Inh_Tm ->
           Syn_Tm
wrap_Tm sem (Inh_Tm _lhsIprec) =
    (let ( _lhsOppML,_lhsOppSL) = sem _lhsIprec
     in  (Syn_Tm _lhsOppML _lhsOppSL))
sem_Tm_App :: T_Tm ->
              T_Tm ->
              T_Tm
sem_Tm_App t1_ t2_ =
    (\ _lhsIprec ->
         (let _lhsOppML :: Doc
              _t1Oprec :: Prec
              _t2Oprec :: Prec
              _lhsOppSL :: Doc
              _t1IppML :: Doc
              _t1IppSL :: Doc
              _t2IppML :: Doc
              _t2IppSL :: Doc
              _ppSL =
                  ({-# LINE 29 "src\\CCO\\SystemF\\AG/Printing.ag" #-}
                   ppInfixSL _lhsIprec ("", 10) _t1IppSL _t2IppSL
                   {-# LINE 113 "dist\\build\\pp-systemf\\pp-systemf-tmp\\CCO\\SystemF\\AG" #-}
                   )
              _lhsOppML =
                  ({-# LINE 37 "src\\CCO\\SystemF\\AG/Printing.ag" #-}
                   _ppSL     >^<
                   ppInfixML _lhsIprec ("", 10) _t1IppML _t2IppML
                   {-# LINE 119 "dist\\build\\pp-systemf\\pp-systemf-tmp\\CCO\\SystemF\\AG" #-}
                   )
              _t1Oprec =
                  ({-# LINE 65 "src\\CCO\\SystemF\\AG/Printing.ag" #-}
                   10
                   {-# LINE 124 "dist\\build\\pp-systemf\\pp-systemf-tmp\\CCO\\SystemF\\AG" #-}
                   )
              _t2Oprec =
                  ({-# LINE 66 "src\\CCO\\SystemF\\AG/Printing.ag" #-}
                   11
                   {-# LINE 129 "dist\\build\\pp-systemf\\pp-systemf-tmp\\CCO\\SystemF\\AG" #-}
                   )
              _lhsOppSL =
                  ({-# LINE 11 "src\\CCO\\SystemF\\AG/Printing.ag" #-}
                   _ppSL
                   {-# LINE 134 "dist\\build\\pp-systemf\\pp-systemf-tmp\\CCO\\SystemF\\AG" #-}
                   )
              ( _t1IppML,_t1IppSL) =
                  t1_ _t1Oprec
              ( _t2IppML,_t2IppSL) =
                  t2_ _t2Oprec
          in  ( _lhsOppML,_lhsOppSL)))
sem_Tm_Lam :: Var ->
              T_Ty ->
              T_Tm ->
              T_Tm
sem_Tm_Lam x_ ty_ t1_ =
    (\ _lhsIprec ->
         (let _lhsOppML :: Doc
              _tyOprec :: Prec
              _t1Oprec :: Prec
              _lhsOppSL :: Doc
              _tyIppML :: Doc
              _tyIppSL :: Doc
              _t1IppML :: Doc
              _t1IppSL :: Doc
              _ppSL =
                  ({-# LINE 27 "src\\CCO\\SystemF\\AG/Printing.ag" #-}
                   ppBinderSL "\\" (text x_ >#< text ":" >#< _tyIppSL)
                     _t1IppSL
                   {-# LINE 159 "dist\\build\\pp-systemf\\pp-systemf-tmp\\CCO\\SystemF\\AG" #-}
                   )
              _lhsOppML =
                  ({-# LINE 34 "src\\CCO\\SystemF\\AG/Printing.ag" #-}
                   _ppSL     >^<
                   ppBinderML "\\" (text x_ >#< text ":" >#< _tyIppML)
                     _t1IppML
                   {-# LINE 166 "dist\\build\\pp-systemf\\pp-systemf-tmp\\CCO\\SystemF\\AG" #-}
                   )
              _tyOprec =
                  ({-# LINE 63 "src\\CCO\\SystemF\\AG/Printing.ag" #-}
                   0
                   {-# LINE 171 "dist\\build\\pp-systemf\\pp-systemf-tmp\\CCO\\SystemF\\AG" #-}
                   )
              _t1Oprec =
                  ({-# LINE 64 "src\\CCO\\SystemF\\AG/Printing.ag" #-}
                   0
                   {-# LINE 176 "dist\\build\\pp-systemf\\pp-systemf-tmp\\CCO\\SystemF\\AG" #-}
                   )
              _lhsOppSL =
                  ({-# LINE 11 "src\\CCO\\SystemF\\AG/Printing.ag" #-}
                   _ppSL
                   {-# LINE 181 "dist\\build\\pp-systemf\\pp-systemf-tmp\\CCO\\SystemF\\AG" #-}
                   )
              ( _tyIppML,_tyIppSL) =
                  ty_ _tyOprec
              ( _t1IppML,_t1IppSL) =
                  t1_ _t1Oprec
          in  ( _lhsOppML,_lhsOppSL)))
sem_Tm_TyApp :: T_Tm ->
                T_Ty ->
                T_Tm
sem_Tm_TyApp t1_ ty_ =
    (\ _lhsIprec ->
         (let _lhsOppML :: Doc
              _t1Oprec :: Prec
              _tyOprec :: Prec
              _lhsOppSL :: Doc
              _t1IppML :: Doc
              _t1IppSL :: Doc
              _tyIppML :: Doc
              _tyIppSL :: Doc
              _ppSL =
                  ({-# LINE 31 "src\\CCO\\SystemF\\AG/Printing.ag" #-}
                   ppInfixSL _lhsIprec ("", 10) _t1IppSL (brackets _tyIppSL)
                   {-# LINE 204 "dist\\build\\pp-systemf\\pp-systemf-tmp\\CCO\\SystemF\\AG" #-}
                   )
              _lhsOppML =
                  ({-# LINE 41 "src\\CCO\\SystemF\\AG/Printing.ag" #-}
                   _ppSL     >^<
                   ppInfixML _lhsIprec ("", 10) _t1IppML
                     (lbracket >#< _tyIppML >-< rbracket)
                   {-# LINE 211 "dist\\build\\pp-systemf\\pp-systemf-tmp\\CCO\\SystemF\\AG" #-}
                   )
              _t1Oprec =
                  ({-# LINE 68 "src\\CCO\\SystemF\\AG/Printing.ag" #-}
                   9
                   {-# LINE 216 "dist\\build\\pp-systemf\\pp-systemf-tmp\\CCO\\SystemF\\AG" #-}
                   )
              _tyOprec =
                  ({-# LINE 69 "src\\CCO\\SystemF\\AG/Printing.ag" #-}
                   0
                   {-# LINE 221 "dist\\build\\pp-systemf\\pp-systemf-tmp\\CCO\\SystemF\\AG" #-}
                   )
              _lhsOppSL =
                  ({-# LINE 11 "src\\CCO\\SystemF\\AG/Printing.ag" #-}
                   _ppSL
                   {-# LINE 226 "dist\\build\\pp-systemf\\pp-systemf-tmp\\CCO\\SystemF\\AG" #-}
                   )
              ( _t1IppML,_t1IppSL) =
                  t1_ _t1Oprec
              ( _tyIppML,_tyIppSL) =
                  ty_ _tyOprec
          in  ( _lhsOppML,_lhsOppSL)))
sem_Tm_TyLam :: TyVar ->
                T_Tm ->
                T_Tm
sem_Tm_TyLam a_ t1_ =
    (\ _lhsIprec ->
         (let _lhsOppML :: Doc
              _t1Oprec :: Prec
              _lhsOppSL :: Doc
              _t1IppML :: Doc
              _t1IppSL :: Doc
              _ppSL =
                  ({-# LINE 30 "src\\CCO\\SystemF\\AG/Printing.ag" #-}
                   ppBinderSL "/\\" (text a_) _t1IppSL
                   {-# LINE 246 "dist\\build\\pp-systemf\\pp-systemf-tmp\\CCO\\SystemF\\AG" #-}
                   )
              _lhsOppML =
                  ({-# LINE 39 "src\\CCO\\SystemF\\AG/Printing.ag" #-}
                   _ppSL     >^<
                   ppBinderML "/\\" (text a_) _t1IppML
                   {-# LINE 252 "dist\\build\\pp-systemf\\pp-systemf-tmp\\CCO\\SystemF\\AG" #-}
                   )
              _t1Oprec =
                  ({-# LINE 67 "src\\CCO\\SystemF\\AG/Printing.ag" #-}
                   0
                   {-# LINE 257 "dist\\build\\pp-systemf\\pp-systemf-tmp\\CCO\\SystemF\\AG" #-}
                   )
              _lhsOppSL =
                  ({-# LINE 11 "src\\CCO\\SystemF\\AG/Printing.ag" #-}
                   _ppSL
                   {-# LINE 262 "dist\\build\\pp-systemf\\pp-systemf-tmp\\CCO\\SystemF\\AG" #-}
                   )
              ( _t1IppML,_t1IppSL) =
                  t1_ _t1Oprec
          in  ( _lhsOppML,_lhsOppSL)))
sem_Tm_Var :: Var ->
              T_Tm
sem_Tm_Var x_ =
    (\ _lhsIprec ->
         (let _lhsOppML :: Doc
              _lhsOppSL :: Doc
              _ppSL =
                  ({-# LINE 26 "src\\CCO\\SystemF\\AG/Printing.ag" #-}
                   text x_
                   {-# LINE 276 "dist\\build\\pp-systemf\\pp-systemf-tmp\\CCO\\SystemF\\AG" #-}
                   )
              _lhsOppML =
                  ({-# LINE 33 "src\\CCO\\SystemF\\AG/Printing.ag" #-}
                   _ppSL
                   {-# LINE 281 "dist\\build\\pp-systemf\\pp-systemf-tmp\\CCO\\SystemF\\AG" #-}
                   )
              _lhsOppSL =
                  ({-# LINE 11 "src\\CCO\\SystemF\\AG/Printing.ag" #-}
                   _ppSL
                   {-# LINE 286 "dist\\build\\pp-systemf\\pp-systemf-tmp\\CCO\\SystemF\\AG" #-}
                   )
          in  ( _lhsOppML,_lhsOppSL)))
-- Ty ----------------------------------------------------------
data Ty = Arr (Ty) (Ty)
        | Forall (TyVar) (Ty)
        | TyVar (TyVar)
        deriving ( Eq,Show)
-- cata
sem_Ty :: Ty ->
          T_Ty
sem_Ty (Arr _ty1 _ty2) =
    (sem_Ty_Arr (sem_Ty _ty1) (sem_Ty _ty2))
sem_Ty (Forall _a _ty1) =
    (sem_Ty_Forall _a (sem_Ty _ty1))
sem_Ty (TyVar _a) =
    (sem_Ty_TyVar _a)
-- semantic domain
type T_Ty = Prec ->
            ( Doc,Doc)
data Inh_Ty = Inh_Ty {prec_Inh_Ty :: Prec}
data Syn_Ty = Syn_Ty {ppML_Syn_Ty :: Doc,ppSL_Syn_Ty :: Doc}
wrap_Ty :: T_Ty ->
           Inh_Ty ->
           Syn_Ty
wrap_Ty sem (Inh_Ty _lhsIprec) =
    (let ( _lhsOppML,_lhsOppSL) = sem _lhsIprec
     in  (Syn_Ty _lhsOppML _lhsOppSL))
sem_Ty_Arr :: T_Ty ->
              T_Ty ->
              T_Ty
sem_Ty_Arr ty1_ ty2_ =
    (\ _lhsIprec ->
         (let _lhsOppML :: Doc
              _ty1Oprec :: Prec
              _ty2Oprec :: Prec
              _lhsOppSL :: Doc
              _ty1IppML :: Doc
              _ty1IppSL :: Doc
              _ty2IppML :: Doc
              _ty2IppSL :: Doc
              _ppSL =
                  ({-# LINE 16 "src\\CCO\\SystemF\\AG/Printing.ag" #-}
                   ppInfixSL _lhsIprec ("->", 0) _ty1IppSL _ty2IppSL
                   {-# LINE 330 "dist\\build\\pp-systemf\\pp-systemf-tmp\\CCO\\SystemF\\AG" #-}
                   )
              _lhsOppML =
                  ({-# LINE 20 "src\\CCO\\SystemF\\AG/Printing.ag" #-}
                   _ppSL     >^<
                   ppInfixML _lhsIprec ("->", 0) _ty1IppML _ty2IppML
                   {-# LINE 336 "dist\\build\\pp-systemf\\pp-systemf-tmp\\CCO\\SystemF\\AG" #-}
                   )
              _ty1Oprec =
                  ({-# LINE 58 "src\\CCO\\SystemF\\AG/Printing.ag" #-}
                   1
                   {-# LINE 341 "dist\\build\\pp-systemf\\pp-systemf-tmp\\CCO\\SystemF\\AG" #-}
                   )
              _ty2Oprec =
                  ({-# LINE 59 "src\\CCO\\SystemF\\AG/Printing.ag" #-}
                   0
                   {-# LINE 346 "dist\\build\\pp-systemf\\pp-systemf-tmp\\CCO\\SystemF\\AG" #-}
                   )
              _lhsOppSL =
                  ({-# LINE 11 "src\\CCO\\SystemF\\AG/Printing.ag" #-}
                   _ppSL
                   {-# LINE 351 "dist\\build\\pp-systemf\\pp-systemf-tmp\\CCO\\SystemF\\AG" #-}
                   )
              ( _ty1IppML,_ty1IppSL) =
                  ty1_ _ty1Oprec
              ( _ty2IppML,_ty2IppSL) =
                  ty2_ _ty2Oprec
          in  ( _lhsOppML,_lhsOppSL)))
sem_Ty_Forall :: TyVar ->
                 T_Ty ->
                 T_Ty
sem_Ty_Forall a_ ty1_ =
    (\ _lhsIprec ->
         (let _lhsOppML :: Doc
              _ty1Oprec :: Prec
              _lhsOppSL :: Doc
              _ty1IppML :: Doc
              _ty1IppSL :: Doc
              _ppSL =
                  ({-# LINE 17 "src\\CCO\\SystemF\\AG/Printing.ag" #-}
                   ppBinderSL "forall " (text a_) _ty1IppSL
                   {-# LINE 371 "dist\\build\\pp-systemf\\pp-systemf-tmp\\CCO\\SystemF\\AG" #-}
                   )
              _lhsOppML =
                  ({-# LINE 22 "src\\CCO\\SystemF\\AG/Printing.ag" #-}
                   _ppSL     >^<
                   ppBinderML "forall " (text a_) _ty1IppML
                   {-# LINE 377 "dist\\build\\pp-systemf\\pp-systemf-tmp\\CCO\\SystemF\\AG" #-}
                   )
              _ty1Oprec =
                  ({-# LINE 60 "src\\CCO\\SystemF\\AG/Printing.ag" #-}
                   0
                   {-# LINE 382 "dist\\build\\pp-systemf\\pp-systemf-tmp\\CCO\\SystemF\\AG" #-}
                   )
              _lhsOppSL =
                  ({-# LINE 11 "src\\CCO\\SystemF\\AG/Printing.ag" #-}
                   _ppSL
                   {-# LINE 387 "dist\\build\\pp-systemf\\pp-systemf-tmp\\CCO\\SystemF\\AG" #-}
                   )
              ( _ty1IppML,_ty1IppSL) =
                  ty1_ _ty1Oprec
          in  ( _lhsOppML,_lhsOppSL)))
sem_Ty_TyVar :: TyVar ->
                T_Ty
sem_Ty_TyVar a_ =
    (\ _lhsIprec ->
         (let _lhsOppML :: Doc
              _lhsOppSL :: Doc
              _ppSL =
                  ({-# LINE 15 "src\\CCO\\SystemF\\AG/Printing.ag" #-}
                   text a_
                   {-# LINE 401 "dist\\build\\pp-systemf\\pp-systemf-tmp\\CCO\\SystemF\\AG" #-}
                   )
              _lhsOppML =
                  ({-# LINE 19 "src\\CCO\\SystemF\\AG/Printing.ag" #-}
                   _ppSL
                   {-# LINE 406 "dist\\build\\pp-systemf\\pp-systemf-tmp\\CCO\\SystemF\\AG" #-}
                   )
              _lhsOppSL =
                  ({-# LINE 11 "src\\CCO\\SystemF\\AG/Printing.ag" #-}
                   _ppSL
                   {-# LINE 411 "dist\\build\\pp-systemf\\pp-systemf-tmp\\CCO\\SystemF\\AG" #-}
                   )
          in  ( _lhsOppML,_lhsOppSL)))