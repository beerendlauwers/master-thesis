

-- UUAGC 0.9.40.2 (Datatypes.ag)
module Datatypes where
-- AExpr -------------------------------------------------------
data AExpr = AEUExpr (UExpr)
           | AOp (String) (AExpr) (AExpr)
-- cata
sem_AExpr :: AExpr ->
             T_AExpr
sem_AExpr (AEUExpr _ue) =
    (sem_AExpr_AEUExpr (sem_UExpr _ue))
sem_AExpr (AOp _i _ae1 _ae2) =
    (sem_AExpr_AOp _i (sem_AExpr _ae1) (sem_AExpr _ae2))
-- semantic domain
type T_AExpr = ( AExpr)
data Inh_AExpr = Inh_AExpr {}
data Syn_AExpr = Syn_AExpr {self_Syn_AExpr :: AExpr}
wrap_AExpr :: T_AExpr ->
              Inh_AExpr ->
              Syn_AExpr
wrap_AExpr sem (Inh_AExpr) =
    (let ( _lhsOself) = sem
     in  (Syn_AExpr _lhsOself))
sem_AExpr_AEUExpr :: T_UExpr ->
                     T_AExpr
sem_AExpr_AEUExpr ue_ =
    (case (ue_) of
     { ( _ueIself) ->
         (case (AEUExpr _ueIself) of
          { _self ->
          (case (_self) of
           { _lhsOself ->
           ( _lhsOself) }) }) })
sem_AExpr_AOp :: String ->
                 T_AExpr ->
                 T_AExpr ->
                 T_AExpr
sem_AExpr_AOp i_ ae1_ ae2_ =
    (case (ae2_) of
     { ( _ae2Iself) ->
         (case (ae1_) of
          { ( _ae1Iself) ->
              (case (AOp i_ _ae1Iself _ae2Iself) of
               { _self ->
               (case (_self) of
                { _lhsOself ->
                ( _lhsOself) }) }) }) })
-- ArrayLit ----------------------------------------------------
data ArrayLit = ArrSimple (AssignEList)
-- cata
sem_ArrayLit :: ArrayLit ->
                T_ArrayLit
sem_ArrayLit (ArrSimple _ael) =
    (sem_ArrayLit_ArrSimple (sem_AssignEList _ael))
-- semantic domain
type T_ArrayLit = ( ArrayLit)
data Inh_ArrayLit = Inh_ArrayLit {}
data Syn_ArrayLit = Syn_ArrayLit {self_Syn_ArrayLit :: ArrayLit}
wrap_ArrayLit :: T_ArrayLit ->
                 Inh_ArrayLit ->
                 Syn_ArrayLit
wrap_ArrayLit sem (Inh_ArrayLit) =
    (let ( _lhsOself) = sem
     in  (Syn_ArrayLit _lhsOself))
sem_ArrayLit_ArrSimple :: T_AssignEList ->
                          T_ArrayLit
sem_ArrayLit_ArrSimple ael_ =
    (case (ael_) of
     { ( _aelIself) ->
         (case (ArrSimple _aelIself) of
          { _self ->
          (case (_self) of
           { _lhsOself ->
           ( _lhsOself) }) }) })
-- AssignE -----------------------------------------------------
data AssignE = Assign (LeftExpr) (AssignOp) (AssignE)
             | CondE (CondE)
-- cata
sem_AssignE :: AssignE ->
               T_AssignE
sem_AssignE (Assign _le _op _ae) =
    (sem_AssignE_Assign (sem_LeftExpr _le) (sem_AssignOp _op) (sem_AssignE _ae))
sem_AssignE (CondE _ce) =
    (sem_AssignE_CondE (sem_CondE _ce))
-- semantic domain
type T_AssignE = ( AssignE)
data Inh_AssignE = Inh_AssignE {}
data Syn_AssignE = Syn_AssignE {self_Syn_AssignE :: AssignE}
wrap_AssignE :: T_AssignE ->
                Inh_AssignE ->
                Syn_AssignE
wrap_AssignE sem (Inh_AssignE) =
    (let ( _lhsOself) = sem
     in  (Syn_AssignE _lhsOself))
sem_AssignE_Assign :: T_LeftExpr ->
                      T_AssignOp ->
                      T_AssignE ->
                      T_AssignE
sem_AssignE_Assign le_ op_ ae_ =
    (case (ae_) of
     { ( _aeIself) ->
         (case (op_) of
          { ( _opIself) ->
              (case (le_) of
               { ( _leIself) ->
                   (case (Assign _leIself _opIself _aeIself) of
                    { _self ->
                    (case (_self) of
                     { _lhsOself ->
                     ( _lhsOself) }) }) }) }) })
sem_AssignE_CondE :: T_CondE ->
                     T_AssignE
sem_AssignE_CondE ce_ =
    (case (ce_) of
     { ( _ceIself) ->
         (case (CondE _ceIself) of
          { _self ->
          (case (_self) of
           { _lhsOself ->
           ( _lhsOself) }) }) })
-- AssignEList -------------------------------------------------
type AssignEList = [AssignE]
-- cata
sem_AssignEList :: AssignEList ->
                   T_AssignEList
sem_AssignEList list =
    (Prelude.foldr sem_AssignEList_Cons sem_AssignEList_Nil (Prelude.map sem_AssignE list))
-- semantic domain
type T_AssignEList = ( AssignEList)
data Inh_AssignEList = Inh_AssignEList {}
data Syn_AssignEList = Syn_AssignEList {self_Syn_AssignEList :: AssignEList}
wrap_AssignEList :: T_AssignEList ->
                    Inh_AssignEList ->
                    Syn_AssignEList
wrap_AssignEList sem (Inh_AssignEList) =
    (let ( _lhsOself) = sem
     in  (Syn_AssignEList _lhsOself))
sem_AssignEList_Cons :: T_AssignE ->
                        T_AssignEList ->
                        T_AssignEList
sem_AssignEList_Cons hd_ tl_ =
    (case (tl_) of
     { ( _tlIself) ->
         (case (hd_) of
          { ( _hdIself) ->
              (case ((:) _hdIself _tlIself) of
               { _self ->
               (case (_self) of
                { _lhsOself ->
                ( _lhsOself) }) }) }) })
sem_AssignEList_Nil :: T_AssignEList
sem_AssignEList_Nil =
    (case ([]) of
     { _self ->
     (case (_self) of
      { _lhsOself ->
      ( _lhsOself) }) })
-- AssignEMaybe ------------------------------------------------
type AssignEMaybe = Maybe AssignE
-- cata
sem_AssignEMaybe :: AssignEMaybe ->
                    T_AssignEMaybe
sem_AssignEMaybe (Prelude.Just x) =
    (sem_AssignEMaybe_Just (sem_AssignE x))
sem_AssignEMaybe Prelude.Nothing =
    sem_AssignEMaybe_Nothing
-- semantic domain
type T_AssignEMaybe = ( AssignEMaybe)
data Inh_AssignEMaybe = Inh_AssignEMaybe {}
data Syn_AssignEMaybe = Syn_AssignEMaybe {self_Syn_AssignEMaybe :: AssignEMaybe}
wrap_AssignEMaybe :: T_AssignEMaybe ->
                     Inh_AssignEMaybe ->
                     Syn_AssignEMaybe
wrap_AssignEMaybe sem (Inh_AssignEMaybe) =
    (let ( _lhsOself) = sem
     in  (Syn_AssignEMaybe _lhsOself))
sem_AssignEMaybe_Just :: T_AssignE ->
                         T_AssignEMaybe
sem_AssignEMaybe_Just just_ =
    (case (just_) of
     { ( _justIself) ->
         (case (Just _justIself) of
          { _self ->
          (case (_self) of
           { _lhsOself ->
           ( _lhsOself) }) }) })
sem_AssignEMaybe_Nothing :: T_AssignEMaybe
sem_AssignEMaybe_Nothing =
    (case (Nothing) of
     { _self ->
     (case (_self) of
      { _lhsOself ->
      ( _lhsOself) }) })
-- AssignOp ----------------------------------------------------
data AssignOp = AssignNormal
              | AssignOpDiv
              | AssignOpMinus
              | AssignOpMod
              | AssignOpMult
              | AssignOpPlus
-- cata
sem_AssignOp :: AssignOp ->
                T_AssignOp
sem_AssignOp (AssignNormal) =
    (sem_AssignOp_AssignNormal)
sem_AssignOp (AssignOpDiv) =
    (sem_AssignOp_AssignOpDiv)
sem_AssignOp (AssignOpMinus) =
    (sem_AssignOp_AssignOpMinus)
sem_AssignOp (AssignOpMod) =
    (sem_AssignOp_AssignOpMod)
sem_AssignOp (AssignOpMult) =
    (sem_AssignOp_AssignOpMult)
sem_AssignOp (AssignOpPlus) =
    (sem_AssignOp_AssignOpPlus)
-- semantic domain
type T_AssignOp = ( AssignOp)
data Inh_AssignOp = Inh_AssignOp {}
data Syn_AssignOp = Syn_AssignOp {self_Syn_AssignOp :: AssignOp}
wrap_AssignOp :: T_AssignOp ->
                 Inh_AssignOp ->
                 Syn_AssignOp
wrap_AssignOp sem (Inh_AssignOp) =
    (let ( _lhsOself) = sem
     in  (Syn_AssignOp _lhsOself))
sem_AssignOp_AssignNormal :: T_AssignOp
sem_AssignOp_AssignNormal =
    (case (AssignNormal) of
     { _self ->
     (case (_self) of
      { _lhsOself ->
      ( _lhsOself) }) })
sem_AssignOp_AssignOpDiv :: T_AssignOp
sem_AssignOp_AssignOpDiv =
    (case (AssignOpDiv) of
     { _self ->
     (case (_self) of
      { _lhsOself ->
      ( _lhsOself) }) })
sem_AssignOp_AssignOpMinus :: T_AssignOp
sem_AssignOp_AssignOpMinus =
    (case (AssignOpMinus) of
     { _self ->
     (case (_self) of
      { _lhsOself ->
      ( _lhsOself) }) })
sem_AssignOp_AssignOpMod :: T_AssignOp
sem_AssignOp_AssignOpMod =
    (case (AssignOpMod) of
     { _self ->
     (case (_self) of
      { _lhsOself ->
      ( _lhsOself) }) })
sem_AssignOp_AssignOpMult :: T_AssignOp
sem_AssignOp_AssignOpMult =
    (case (AssignOpMult) of
     { _self ->
     (case (_self) of
      { _lhsOself ->
      ( _lhsOself) }) })
sem_AssignOp_AssignOpPlus :: T_AssignOp
sem_AssignOp_AssignOpPlus =
    (case (AssignOpPlus) of
     { _self ->
     (case (_self) of
      { _lhsOself ->
      ( _lhsOself) }) })
-- CallExpr ----------------------------------------------------
data CallExpr = CallCall (CallExpr) (AssignEList)
              | CallDot (CallExpr) (String)
              | CallMember (MemberExpr) (AssignEList)
              | CallPrim (MemberExpr)
              | CallSquare (CallExpr) (Expr)
-- cata
sem_CallExpr :: CallExpr ->
                T_CallExpr
sem_CallExpr (CallCall _ce _ael) =
    (sem_CallExpr_CallCall (sem_CallExpr _ce) (sem_AssignEList _ael))
sem_CallExpr (CallDot _ce _s) =
    (sem_CallExpr_CallDot (sem_CallExpr _ce) _s)
sem_CallExpr (CallMember _me _ael) =
    (sem_CallExpr_CallMember (sem_MemberExpr _me) (sem_AssignEList _ael))
sem_CallExpr (CallPrim _me) =
    (sem_CallExpr_CallPrim (sem_MemberExpr _me))
sem_CallExpr (CallSquare _ce _e) =
    (sem_CallExpr_CallSquare (sem_CallExpr _ce) (sem_Expr _e))
-- semantic domain
type T_CallExpr = ( CallExpr)
data Inh_CallExpr = Inh_CallExpr {}
data Syn_CallExpr = Syn_CallExpr {self_Syn_CallExpr :: CallExpr}
wrap_CallExpr :: T_CallExpr ->
                 Inh_CallExpr ->
                 Syn_CallExpr
wrap_CallExpr sem (Inh_CallExpr) =
    (let ( _lhsOself) = sem
     in  (Syn_CallExpr _lhsOself))
sem_CallExpr_CallCall :: T_CallExpr ->
                         T_AssignEList ->
                         T_CallExpr
sem_CallExpr_CallCall ce_ ael_ =
    (case (ael_) of
     { ( _aelIself) ->
         (case (ce_) of
          { ( _ceIself) ->
              (case (CallCall _ceIself _aelIself) of
               { _self ->
               (case (_self) of
                { _lhsOself ->
                ( _lhsOself) }) }) }) })
sem_CallExpr_CallDot :: T_CallExpr ->
                        String ->
                        T_CallExpr
sem_CallExpr_CallDot ce_ s_ =
    (case (ce_) of
     { ( _ceIself) ->
         (case (CallDot _ceIself s_) of
          { _self ->
          (case (_self) of
           { _lhsOself ->
           ( _lhsOself) }) }) })
sem_CallExpr_CallMember :: T_MemberExpr ->
                           T_AssignEList ->
                           T_CallExpr
sem_CallExpr_CallMember me_ ael_ =
    (case (ael_) of
     { ( _aelIself) ->
         (case (me_) of
          { ( _meIself) ->
              (case (CallMember _meIself _aelIself) of
               { _self ->
               (case (_self) of
                { _lhsOself ->
                ( _lhsOself) }) }) }) })
sem_CallExpr_CallPrim :: T_MemberExpr ->
                         T_CallExpr
sem_CallExpr_CallPrim me_ =
    (case (me_) of
     { ( _meIself) ->
         (case (CallPrim _meIself) of
          { _self ->
          (case (_self) of
           { _lhsOself ->
           ( _lhsOself) }) }) })
sem_CallExpr_CallSquare :: T_CallExpr ->
                           T_Expr ->
                           T_CallExpr
sem_CallExpr_CallSquare ce_ e_ =
    (case (e_) of
     { ( _eIself) ->
         (case (ce_) of
          { ( _ceIself) ->
              (case (CallSquare _ceIself _eIself) of
               { _self ->
               (case (_self) of
                { _lhsOself ->
                ( _lhsOself) }) }) }) })
-- CaseClause --------------------------------------------------
data CaseClause = CaseClause (Expr) (StmtList)
                | DefaultClause (StmtList)
-- cata
sem_CaseClause :: CaseClause ->
                  T_CaseClause
sem_CaseClause (CaseClause _e _s) =
    (sem_CaseClause_CaseClause (sem_Expr _e) (sem_StmtList _s))
sem_CaseClause (DefaultClause _s) =
    (sem_CaseClause_DefaultClause (sem_StmtList _s))
-- semantic domain
type T_CaseClause = ( CaseClause)
data Inh_CaseClause = Inh_CaseClause {}
data Syn_CaseClause = Syn_CaseClause {self_Syn_CaseClause :: CaseClause}
wrap_CaseClause :: T_CaseClause ->
                   Inh_CaseClause ->
                   Syn_CaseClause
wrap_CaseClause sem (Inh_CaseClause) =
    (let ( _lhsOself) = sem
     in  (Syn_CaseClause _lhsOself))
sem_CaseClause_CaseClause :: T_Expr ->
                             T_StmtList ->
                             T_CaseClause
sem_CaseClause_CaseClause e_ s_ =
    (case (s_) of
     { ( _sIself) ->
         (case (e_) of
          { ( _eIself) ->
              (case (CaseClause _eIself _sIself) of
               { _self ->
               (case (_self) of
                { _lhsOself ->
                ( _lhsOself) }) }) }) })
sem_CaseClause_DefaultClause :: T_StmtList ->
                                T_CaseClause
sem_CaseClause_DefaultClause s_ =
    (case (s_) of
     { ( _sIself) ->
         (case (DefaultClause _sIself) of
          { _self ->
          (case (_self) of
           { _lhsOself ->
           ( _lhsOself) }) }) })
-- CaseClauseList ----------------------------------------------
type CaseClauseList = [CaseClause]
-- cata
sem_CaseClauseList :: CaseClauseList ->
                      T_CaseClauseList
sem_CaseClauseList list =
    (Prelude.foldr sem_CaseClauseList_Cons sem_CaseClauseList_Nil (Prelude.map sem_CaseClause list))
-- semantic domain
type T_CaseClauseList = ( CaseClauseList)
data Inh_CaseClauseList = Inh_CaseClauseList {}
data Syn_CaseClauseList = Syn_CaseClauseList {self_Syn_CaseClauseList :: CaseClauseList}
wrap_CaseClauseList :: T_CaseClauseList ->
                       Inh_CaseClauseList ->
                       Syn_CaseClauseList
wrap_CaseClauseList sem (Inh_CaseClauseList) =
    (let ( _lhsOself) = sem
     in  (Syn_CaseClauseList _lhsOself))
sem_CaseClauseList_Cons :: T_CaseClause ->
                           T_CaseClauseList ->
                           T_CaseClauseList
sem_CaseClauseList_Cons hd_ tl_ =
    (case (tl_) of
     { ( _tlIself) ->
         (case (hd_) of
          { ( _hdIself) ->
              (case ((:) _hdIself _tlIself) of
               { _self ->
               (case (_self) of
                { _lhsOself ->
                ( _lhsOself) }) }) }) })
sem_CaseClauseList_Nil :: T_CaseClauseList
sem_CaseClauseList_Nil =
    (case ([]) of
     { _self ->
     (case (_self) of
      { _lhsOself ->
      ( _lhsOself) }) })
-- Catch -------------------------------------------------------
data Catch = Catch (String) (StmtList)
           | CatchCatch (String) (ExprMaybe) (StmtList)
           | CatchIf (String) (StmtList) (Expr)
-- cata
sem_Catch :: Catch ->
             T_Catch
sem_Catch (Catch _i _s) =
    (sem_Catch_Catch _i (sem_StmtList _s))
sem_Catch (CatchCatch _i _me _sm) =
    (sem_Catch_CatchCatch _i (sem_ExprMaybe _me) (sem_StmtList _sm))
sem_Catch (CatchIf _i _s _e) =
    (sem_Catch_CatchIf _i (sem_StmtList _s) (sem_Expr _e))
-- semantic domain
type T_Catch = ( Catch)
data Inh_Catch = Inh_Catch {}
data Syn_Catch = Syn_Catch {self_Syn_Catch :: Catch}
wrap_Catch :: T_Catch ->
              Inh_Catch ->
              Syn_Catch
wrap_Catch sem (Inh_Catch) =
    (let ( _lhsOself) = sem
     in  (Syn_Catch _lhsOself))
sem_Catch_Catch :: String ->
                   T_StmtList ->
                   T_Catch
sem_Catch_Catch i_ s_ =
    (case (s_) of
     { ( _sIself) ->
         (case (Catch i_ _sIself) of
          { _self ->
          (case (_self) of
           { _lhsOself ->
           ( _lhsOself) }) }) })
sem_Catch_CatchCatch :: String ->
                        T_ExprMaybe ->
                        T_StmtList ->
                        T_Catch
sem_Catch_CatchCatch i_ me_ sm_ =
    (case (sm_) of
     { ( _smIself) ->
         (case (me_) of
          { ( _meIself) ->
              (case (CatchCatch i_ _meIself _smIself) of
               { _self ->
               (case (_self) of
                { _lhsOself ->
                ( _lhsOself) }) }) }) })
sem_Catch_CatchIf :: String ->
                     T_StmtList ->
                     T_Expr ->
                     T_Catch
sem_Catch_CatchIf i_ s_ e_ =
    (case (e_) of
     { ( _eIself) ->
         (case (s_) of
          { ( _sIself) ->
              (case (CatchIf i_ _sIself _eIself) of
               { _self ->
               (case (_self) of
                { _lhsOself ->
                ( _lhsOself) }) }) }) })
-- CatchList ---------------------------------------------------
type CatchList = [Catch]
-- cata
sem_CatchList :: CatchList ->
                 T_CatchList
sem_CatchList list =
    (Prelude.foldr sem_CatchList_Cons sem_CatchList_Nil (Prelude.map sem_Catch list))
-- semantic domain
type T_CatchList = ( CatchList)
data Inh_CatchList = Inh_CatchList {}
data Syn_CatchList = Syn_CatchList {self_Syn_CatchList :: CatchList}
wrap_CatchList :: T_CatchList ->
                  Inh_CatchList ->
                  Syn_CatchList
wrap_CatchList sem (Inh_CatchList) =
    (let ( _lhsOself) = sem
     in  (Syn_CatchList _lhsOself))
sem_CatchList_Cons :: T_Catch ->
                      T_CatchList ->
                      T_CatchList
sem_CatchList_Cons hd_ tl_ =
    (case (tl_) of
     { ( _tlIself) ->
         (case (hd_) of
          { ( _hdIself) ->
              (case ((:) _hdIself _tlIself) of
               { _self ->
               (case (_self) of
                { _lhsOself ->
                ( _lhsOself) }) }) }) })
sem_CatchList_Nil :: T_CatchList
sem_CatchList_Nil =
    (case ([]) of
     { _self ->
     (case (_self) of
      { _lhsOself ->
      ( _lhsOself) }) })
-- CondE -------------------------------------------------------
data CondE = AExpr (AExpr)
           | CondIf (AExpr) (AssignE) (AssignE)
-- cata
sem_CondE :: CondE ->
             T_CondE
sem_CondE (AExpr _ae) =
    (sem_CondE_AExpr (sem_AExpr _ae))
sem_CondE (CondIf _ae _a1 _a2) =
    (sem_CondE_CondIf (sem_AExpr _ae) (sem_AssignE _a1) (sem_AssignE _a2))
-- semantic domain
type T_CondE = ( CondE)
data Inh_CondE = Inh_CondE {}
data Syn_CondE = Syn_CondE {self_Syn_CondE :: CondE}
wrap_CondE :: T_CondE ->
              Inh_CondE ->
              Syn_CondE
wrap_CondE sem (Inh_CondE) =
    (let ( _lhsOself) = sem
     in  (Syn_CondE _lhsOself))
sem_CondE_AExpr :: T_AExpr ->
                   T_CondE
sem_CondE_AExpr ae_ =
    (case (ae_) of
     { ( _aeIself) ->
         (case (AExpr _aeIself) of
          { _self ->
          (case (_self) of
           { _lhsOself ->
           ( _lhsOself) }) }) })
sem_CondE_CondIf :: T_AExpr ->
                    T_AssignE ->
                    T_AssignE ->
                    T_CondE
sem_CondE_CondIf ae_ a1_ a2_ =
    (case (a2_) of
     { ( _a2Iself) ->
         (case (a1_) of
          { ( _a1Iself) ->
              (case (ae_) of
               { ( _aeIself) ->
                   (case (CondIf _aeIself _a1Iself _a2Iself) of
                    { _self ->
                    (case (_self) of
                     { _lhsOself ->
                     ( _lhsOself) }) }) }) }) })
-- Expr --------------------------------------------------------
data Expr = AssignE (AssignE)
-- cata
sem_Expr :: Expr ->
            T_Expr
sem_Expr (AssignE _ae) =
    (sem_Expr_AssignE (sem_AssignE _ae))
-- semantic domain
type T_Expr = ( Expr)
data Inh_Expr = Inh_Expr {}
data Syn_Expr = Syn_Expr {self_Syn_Expr :: Expr}
wrap_Expr :: T_Expr ->
             Inh_Expr ->
             Syn_Expr
wrap_Expr sem (Inh_Expr) =
    (let ( _lhsOself) = sem
     in  (Syn_Expr _lhsOself))
sem_Expr_AssignE :: T_AssignE ->
                    T_Expr
sem_Expr_AssignE ae_ =
    (case (ae_) of
     { ( _aeIself) ->
         (case (AssignE _aeIself) of
          { _self ->
          (case (_self) of
           { _lhsOself ->
           ( _lhsOself) }) }) })
-- ExprMaybe ---------------------------------------------------
type ExprMaybe = Maybe Expr
-- cata
sem_ExprMaybe :: ExprMaybe ->
                 T_ExprMaybe
sem_ExprMaybe (Prelude.Just x) =
    (sem_ExprMaybe_Just (sem_Expr x))
sem_ExprMaybe Prelude.Nothing =
    sem_ExprMaybe_Nothing
-- semantic domain
type T_ExprMaybe = ( ExprMaybe)
data Inh_ExprMaybe = Inh_ExprMaybe {}
data Syn_ExprMaybe = Syn_ExprMaybe {self_Syn_ExprMaybe :: ExprMaybe}
wrap_ExprMaybe :: T_ExprMaybe ->
                  Inh_ExprMaybe ->
                  Syn_ExprMaybe
wrap_ExprMaybe sem (Inh_ExprMaybe) =
    (let ( _lhsOself) = sem
     in  (Syn_ExprMaybe _lhsOself))
sem_ExprMaybe_Just :: T_Expr ->
                      T_ExprMaybe
sem_ExprMaybe_Just just_ =
    (case (just_) of
     { ( _justIself) ->
         (case (Just _justIself) of
          { _self ->
          (case (_self) of
           { _lhsOself ->
           ( _lhsOself) }) }) })
sem_ExprMaybe_Nothing :: T_ExprMaybe
sem_ExprMaybe_Nothing =
    (case (Nothing) of
     { _self ->
     (case (_self) of
      { _lhsOself ->
      ( _lhsOself) }) })
-- FuncDecl ----------------------------------------------------
data FuncDecl = FuncDecl (StringMaybe) (StringList) (SourceElementList)
-- cata
sem_FuncDecl :: FuncDecl ->
                T_FuncDecl
sem_FuncDecl (FuncDecl _sm _ss _se) =
    (sem_FuncDecl_FuncDecl (sem_StringMaybe _sm) (sem_StringList _ss) (sem_SourceElementList _se))
-- semantic domain
type T_FuncDecl = ( FuncDecl)
data Inh_FuncDecl = Inh_FuncDecl {}
data Syn_FuncDecl = Syn_FuncDecl {self_Syn_FuncDecl :: FuncDecl}
wrap_FuncDecl :: T_FuncDecl ->
                 Inh_FuncDecl ->
                 Syn_FuncDecl
wrap_FuncDecl sem (Inh_FuncDecl) =
    (let ( _lhsOself) = sem
     in  (Syn_FuncDecl _lhsOself))
sem_FuncDecl_FuncDecl :: T_StringMaybe ->
                         T_StringList ->
                         T_SourceElementList ->
                         T_FuncDecl
sem_FuncDecl_FuncDecl sm_ ss_ se_ =
    (case (se_) of
     { ( _seIself) ->
         (case (ss_) of
          { ( _ssIself) ->
              (case (sm_) of
               { ( _smIself) ->
                   (case (FuncDecl _smIself _ssIself _seIself) of
                    { _self ->
                    (case (_self) of
                     { _lhsOself ->
                     ( _lhsOself) }) }) }) }) })
-- GetterPutter ------------------------------------------------
data GetterPutter = GetterPutter (PropName) (FuncDecl)
                  | Putter (FuncDecl)
-- cata
sem_GetterPutter :: GetterPutter ->
                    T_GetterPutter
sem_GetterPutter (GetterPutter _pn _fd) =
    (sem_GetterPutter_GetterPutter (sem_PropName _pn) (sem_FuncDecl _fd))
sem_GetterPutter (Putter _fd) =
    (sem_GetterPutter_Putter (sem_FuncDecl _fd))
-- semantic domain
type T_GetterPutter = ( GetterPutter)
data Inh_GetterPutter = Inh_GetterPutter {}
data Syn_GetterPutter = Syn_GetterPutter {self_Syn_GetterPutter :: GetterPutter}
wrap_GetterPutter :: T_GetterPutter ->
                     Inh_GetterPutter ->
                     Syn_GetterPutter
wrap_GetterPutter sem (Inh_GetterPutter) =
    (let ( _lhsOself) = sem
     in  (Syn_GetterPutter _lhsOself))
sem_GetterPutter_GetterPutter :: T_PropName ->
                                 T_FuncDecl ->
                                 T_GetterPutter
sem_GetterPutter_GetterPutter pn_ fd_ =
    (case (fd_) of
     { ( _fdIself) ->
         (case (pn_) of
          { ( _pnIself) ->
              (case (GetterPutter _pnIself _fdIself) of
               { _self ->
               (case (_self) of
                { _lhsOself ->
                ( _lhsOself) }) }) }) })
sem_GetterPutter_Putter :: T_FuncDecl ->
                           T_GetterPutter
sem_GetterPutter_Putter fd_ =
    (case (fd_) of
     { ( _fdIself) ->
         (case (Putter _fdIself) of
          { _self ->
          (case (_self) of
           { _lhsOself ->
           ( _lhsOself) }) }) })
-- IfStmt ------------------------------------------------------
data IfStmt = If2 (Expr)
            | If3
            | IfElse (Expr) (Stmt) (Stmt)
            | IfOnly (Expr) (Stmt)
-- cata
sem_IfStmt :: IfStmt ->
              T_IfStmt
sem_IfStmt (If2 _e) =
    (sem_IfStmt_If2 (sem_Expr _e))
sem_IfStmt (If3) =
    (sem_IfStmt_If3)
sem_IfStmt (IfElse _e _s1 _s2) =
    (sem_IfStmt_IfElse (sem_Expr _e) (sem_Stmt _s1) (sem_Stmt _s2))
sem_IfStmt (IfOnly _e _s1) =
    (sem_IfStmt_IfOnly (sem_Expr _e) (sem_Stmt _s1))
-- semantic domain
type T_IfStmt = ( IfStmt)
data Inh_IfStmt = Inh_IfStmt {}
data Syn_IfStmt = Syn_IfStmt {self_Syn_IfStmt :: IfStmt}
wrap_IfStmt :: T_IfStmt ->
               Inh_IfStmt ->
               Syn_IfStmt
wrap_IfStmt sem (Inh_IfStmt) =
    (let ( _lhsOself) = sem
     in  (Syn_IfStmt _lhsOself))
sem_IfStmt_If2 :: T_Expr ->
                  T_IfStmt
sem_IfStmt_If2 e_ =
    (case (e_) of
     { ( _eIself) ->
         (case (If2 _eIself) of
          { _self ->
          (case (_self) of
           { _lhsOself ->
           ( _lhsOself) }) }) })
sem_IfStmt_If3 :: T_IfStmt
sem_IfStmt_If3 =
    (case (If3) of
     { _self ->
     (case (_self) of
      { _lhsOself ->
      ( _lhsOself) }) })
sem_IfStmt_IfElse :: T_Expr ->
                     T_Stmt ->
                     T_Stmt ->
                     T_IfStmt
sem_IfStmt_IfElse e_ s1_ s2_ =
    (case (s2_) of
     { ( _s2Iself) ->
         (case (s1_) of
          { ( _s1Iself) ->
              (case (e_) of
               { ( _eIself) ->
                   (case (IfElse _eIself _s1Iself _s2Iself) of
                    { _self ->
                    (case (_self) of
                     { _lhsOself ->
                     ( _lhsOself) }) }) }) }) })
sem_IfStmt_IfOnly :: T_Expr ->
                     T_Stmt ->
                     T_IfStmt
sem_IfStmt_IfOnly e_ s1_ =
    (case (s1_) of
     { ( _s1Iself) ->
         (case (e_) of
          { ( _eIself) ->
              (case (IfOnly _eIself _s1Iself) of
               { _self ->
               (case (_self) of
                { _lhsOself ->
                ( _lhsOself) }) }) }) })
-- IntIntPair --------------------------------------------------
type IntIntPair = ( (Int),(Int))
-- cata
sem_IntIntPair :: IntIntPair ->
                  T_IntIntPair
sem_IntIntPair ( x1,x2) =
    (sem_IntIntPair_Tuple x1 x2)
-- semantic domain
type T_IntIntPair = ( IntIntPair)
data Inh_IntIntPair = Inh_IntIntPair {}
data Syn_IntIntPair = Syn_IntIntPair {self_Syn_IntIntPair :: IntIntPair}
wrap_IntIntPair :: T_IntIntPair ->
                   Inh_IntIntPair ->
                   Syn_IntIntPair
wrap_IntIntPair sem (Inh_IntIntPair) =
    (let ( _lhsOself) = sem
     in  (Syn_IntIntPair _lhsOself))
sem_IntIntPair_Tuple :: Int ->
                        Int ->
                        T_IntIntPair
sem_IntIntPair_Tuple x1_ x2_ =
    (case ((x1_,x2_)) of
     { _self ->
     (case (_self) of
      { _lhsOself ->
      ( _lhsOself) }) })
-- ItStmt ------------------------------------------------------
data ItStmt = DoWhile (Stmt) (Expr)
            | For (ExprMaybe) (ExprMaybe) (ExprMaybe) (Stmt)
            | ForIn (LeftExpr) (Expr) (Stmt)
            | ForVar (VarDeclList) (ExprMaybe) (ExprMaybe) (Stmt)
            | It2 (Expr)
            | While (Expr) (Stmt)
-- cata
sem_ItStmt :: ItStmt ->
              T_ItStmt
sem_ItStmt (DoWhile _s _e) =
    (sem_ItStmt_DoWhile (sem_Stmt _s) (sem_Expr _e))
sem_ItStmt (For _em1 _em2 _em3 _s) =
    (sem_ItStmt_For (sem_ExprMaybe _em1) (sem_ExprMaybe _em2) (sem_ExprMaybe _em3) (sem_Stmt _s))
sem_ItStmt (ForIn _le _e _s) =
    (sem_ItStmt_ForIn (sem_LeftExpr _le) (sem_Expr _e) (sem_Stmt _s))
sem_ItStmt (ForVar _vdl _em1 _em2 _s) =
    (sem_ItStmt_ForVar (sem_VarDeclList _vdl) (sem_ExprMaybe _em1) (sem_ExprMaybe _em2) (sem_Stmt _s))
sem_ItStmt (It2 _e) =
    (sem_ItStmt_It2 (sem_Expr _e))
sem_ItStmt (While _e _s) =
    (sem_ItStmt_While (sem_Expr _e) (sem_Stmt _s))
-- semantic domain
type T_ItStmt = ( ItStmt)
data Inh_ItStmt = Inh_ItStmt {}
data Syn_ItStmt = Syn_ItStmt {self_Syn_ItStmt :: ItStmt}
wrap_ItStmt :: T_ItStmt ->
               Inh_ItStmt ->
               Syn_ItStmt
wrap_ItStmt sem (Inh_ItStmt) =
    (let ( _lhsOself) = sem
     in  (Syn_ItStmt _lhsOself))
sem_ItStmt_DoWhile :: T_Stmt ->
                      T_Expr ->
                      T_ItStmt
sem_ItStmt_DoWhile s_ e_ =
    (case (e_) of
     { ( _eIself) ->
         (case (s_) of
          { ( _sIself) ->
              (case (DoWhile _sIself _eIself) of
               { _self ->
               (case (_self) of
                { _lhsOself ->
                ( _lhsOself) }) }) }) })
sem_ItStmt_For :: T_ExprMaybe ->
                  T_ExprMaybe ->
                  T_ExprMaybe ->
                  T_Stmt ->
                  T_ItStmt
sem_ItStmt_For em1_ em2_ em3_ s_ =
    (case (s_) of
     { ( _sIself) ->
         (case (em3_) of
          { ( _em3Iself) ->
              (case (em2_) of
               { ( _em2Iself) ->
                   (case (em1_) of
                    { ( _em1Iself) ->
                        (case (For _em1Iself _em2Iself _em3Iself _sIself) of
                         { _self ->
                         (case (_self) of
                          { _lhsOself ->
                          ( _lhsOself) }) }) }) }) }) })
sem_ItStmt_ForIn :: T_LeftExpr ->
                    T_Expr ->
                    T_Stmt ->
                    T_ItStmt
sem_ItStmt_ForIn le_ e_ s_ =
    (case (s_) of
     { ( _sIself) ->
         (case (e_) of
          { ( _eIself) ->
              (case (le_) of
               { ( _leIself) ->
                   (case (ForIn _leIself _eIself _sIself) of
                    { _self ->
                    (case (_self) of
                     { _lhsOself ->
                     ( _lhsOself) }) }) }) }) })
sem_ItStmt_ForVar :: T_VarDeclList ->
                     T_ExprMaybe ->
                     T_ExprMaybe ->
                     T_Stmt ->
                     T_ItStmt
sem_ItStmt_ForVar vdl_ em1_ em2_ s_ =
    (case (s_) of
     { ( _sIself) ->
         (case (em2_) of
          { ( _em2Iself) ->
              (case (em1_) of
               { ( _em1Iself) ->
                   (case (vdl_) of
                    { ( _vdlIself) ->
                        (case (ForVar _vdlIself _em1Iself _em2Iself _sIself) of
                         { _self ->
                         (case (_self) of
                          { _lhsOself ->
                          ( _lhsOself) }) }) }) }) }) })
sem_ItStmt_It2 :: T_Expr ->
                  T_ItStmt
sem_ItStmt_It2 e_ =
    (case (e_) of
     { ( _eIself) ->
         (case (It2 _eIself) of
          { _self ->
          (case (_self) of
           { _lhsOself ->
           ( _lhsOself) }) }) })
sem_ItStmt_While :: T_Expr ->
                    T_Stmt ->
                    T_ItStmt
sem_ItStmt_While e_ s_ =
    (case (s_) of
     { ( _sIself) ->
         (case (e_) of
          { ( _eIself) ->
              (case (While _eIself _sIself) of
               { _self ->
               (case (_self) of
                { _lhsOself ->
                ( _lhsOself) }) }) }) })
-- JSProgram ---------------------------------------------------
data JSProgram = JSProgram (SourceElementList)
-- cata
sem_JSProgram :: JSProgram ->
                 T_JSProgram
sem_JSProgram (JSProgram _se) =
    (sem_JSProgram_JSProgram (sem_SourceElementList _se))
-- semantic domain
type T_JSProgram = ( JSProgram)
data Inh_JSProgram = Inh_JSProgram {}
data Syn_JSProgram = Syn_JSProgram {self_Syn_JSProgram :: JSProgram}
wrap_JSProgram :: T_JSProgram ->
                  Inh_JSProgram ->
                  Syn_JSProgram
wrap_JSProgram sem (Inh_JSProgram) =
    (let ( _lhsOself) = sem
     in  (Syn_JSProgram _lhsOself))
sem_JSProgram_JSProgram :: T_SourceElementList ->
                           T_JSProgram
sem_JSProgram_JSProgram se_ =
    (case (se_) of
     { ( _seIself) ->
         (case (JSProgram _seIself) of
          { _self ->
          (case (_self) of
           { _lhsOself ->
           ( _lhsOself) }) }) })
-- LeftExpr ----------------------------------------------------
data LeftExpr = CallExpr (CallExpr)
              | NewExpr (NewExpr)
-- cata
sem_LeftExpr :: LeftExpr ->
                T_LeftExpr
sem_LeftExpr (CallExpr _ce) =
    (sem_LeftExpr_CallExpr (sem_CallExpr _ce))
sem_LeftExpr (NewExpr _ne) =
    (sem_LeftExpr_NewExpr (sem_NewExpr _ne))
-- semantic domain
type T_LeftExpr = ( LeftExpr)
data Inh_LeftExpr = Inh_LeftExpr {}
data Syn_LeftExpr = Syn_LeftExpr {self_Syn_LeftExpr :: LeftExpr}
wrap_LeftExpr :: T_LeftExpr ->
                 Inh_LeftExpr ->
                 Syn_LeftExpr
wrap_LeftExpr sem (Inh_LeftExpr) =
    (let ( _lhsOself) = sem
     in  (Syn_LeftExpr _lhsOself))
sem_LeftExpr_CallExpr :: T_CallExpr ->
                         T_LeftExpr
sem_LeftExpr_CallExpr ce_ =
    (case (ce_) of
     { ( _ceIself) ->
         (case (CallExpr _ceIself) of
          { _self ->
          (case (_self) of
           { _lhsOself ->
           ( _lhsOself) }) }) })
sem_LeftExpr_NewExpr :: T_NewExpr ->
                        T_LeftExpr
sem_LeftExpr_NewExpr ne_ =
    (case (ne_) of
     { ( _neIself) ->
         (case (NewExpr _neIself) of
          { _self ->
          (case (_self) of
           { _lhsOself ->
           ( _lhsOself) }) }) })
-- Literal -----------------------------------------------------
data Literal = LitBool (Bool)
             | LitInt (Int)
             | LitNull
             | LitString (String)
-- cata
sem_Literal :: Literal ->
               T_Literal
sem_Literal (LitBool _v) =
    (sem_Literal_LitBool _v)
sem_Literal (LitInt _v) =
    (sem_Literal_LitInt _v)
sem_Literal (LitNull) =
    (sem_Literal_LitNull)
sem_Literal (LitString _v) =
    (sem_Literal_LitString _v)
-- semantic domain
type T_Literal = ( Literal)
data Inh_Literal = Inh_Literal {}
data Syn_Literal = Syn_Literal {self_Syn_Literal :: Literal}
wrap_Literal :: T_Literal ->
                Inh_Literal ->
                Syn_Literal
wrap_Literal sem (Inh_Literal) =
    (let ( _lhsOself) = sem
     in  (Syn_Literal _lhsOself))
sem_Literal_LitBool :: Bool ->
                       T_Literal
sem_Literal_LitBool v_ =
    (case (LitBool v_) of
     { _self ->
     (case (_self) of
      { _lhsOself ->
      ( _lhsOself) }) })
sem_Literal_LitInt :: Int ->
                      T_Literal
sem_Literal_LitInt v_ =
    (case (LitInt v_) of
     { _self ->
     (case (_self) of
      { _lhsOself ->
      ( _lhsOself) }) })
sem_Literal_LitNull :: T_Literal
sem_Literal_LitNull =
    (case (LitNull) of
     { _self ->
     (case (_self) of
      { _lhsOself ->
      ( _lhsOself) }) })
sem_Literal_LitString :: String ->
                         T_Literal
sem_Literal_LitString v_ =
    (case (LitString v_) of
     { _self ->
     (case (_self) of
      { _lhsOself ->
      ( _lhsOself) }) })
-- MemberExpr --------------------------------------------------
data MemberExpr = ArrayExpr (MemberExpr) (Expr)
                | MemPrimExpr (PrimExpr)
                | MemberCall (MemberExpr) (String)
                | MemberCall2 (MemberExpr) (MemberExpr)
                | MemberNew (MemberExpr) (AssignEList)
-- cata
sem_MemberExpr :: MemberExpr ->
                  T_MemberExpr
sem_MemberExpr (ArrayExpr _me _e) =
    (sem_MemberExpr_ArrayExpr (sem_MemberExpr _me) (sem_Expr _e))
sem_MemberExpr (MemPrimExpr _pe) =
    (sem_MemberExpr_MemPrimExpr (sem_PrimExpr _pe))
sem_MemberExpr (MemberCall _me _s) =
    (sem_MemberExpr_MemberCall (sem_MemberExpr _me) _s)
sem_MemberExpr (MemberCall2 _me _me2) =
    (sem_MemberExpr_MemberCall2 (sem_MemberExpr _me) (sem_MemberExpr _me2))
sem_MemberExpr (MemberNew _me _ael) =
    (sem_MemberExpr_MemberNew (sem_MemberExpr _me) (sem_AssignEList _ael))
-- semantic domain
type T_MemberExpr = ( MemberExpr)
data Inh_MemberExpr = Inh_MemberExpr {}
data Syn_MemberExpr = Syn_MemberExpr {self_Syn_MemberExpr :: MemberExpr}
wrap_MemberExpr :: T_MemberExpr ->
                   Inh_MemberExpr ->
                   Syn_MemberExpr
wrap_MemberExpr sem (Inh_MemberExpr) =
    (let ( _lhsOself) = sem
     in  (Syn_MemberExpr _lhsOself))
sem_MemberExpr_ArrayExpr :: T_MemberExpr ->
                            T_Expr ->
                            T_MemberExpr
sem_MemberExpr_ArrayExpr me_ e_ =
    (case (e_) of
     { ( _eIself) ->
         (case (me_) of
          { ( _meIself) ->
              (case (ArrayExpr _meIself _eIself) of
               { _self ->
               (case (_self) of
                { _lhsOself ->
                ( _lhsOself) }) }) }) })
sem_MemberExpr_MemPrimExpr :: T_PrimExpr ->
                              T_MemberExpr
sem_MemberExpr_MemPrimExpr pe_ =
    (case (pe_) of
     { ( _peIself) ->
         (case (MemPrimExpr _peIself) of
          { _self ->
          (case (_self) of
           { _lhsOself ->
           ( _lhsOself) }) }) })
sem_MemberExpr_MemberCall :: T_MemberExpr ->
                             String ->
                             T_MemberExpr
sem_MemberExpr_MemberCall me_ s_ =
    (case (me_) of
     { ( _meIself) ->
         (case (MemberCall _meIself s_) of
          { _self ->
          (case (_self) of
           { _lhsOself ->
           ( _lhsOself) }) }) })
sem_MemberExpr_MemberCall2 :: T_MemberExpr ->
                              T_MemberExpr ->
                              T_MemberExpr
sem_MemberExpr_MemberCall2 me_ me2_ =
    (case (me2_) of
     { ( _me2Iself) ->
         (case (me_) of
          { ( _meIself) ->
              (case (MemberCall2 _meIself _me2Iself) of
               { _self ->
               (case (_self) of
                { _lhsOself ->
                ( _lhsOself) }) }) }) })
sem_MemberExpr_MemberNew :: T_MemberExpr ->
                            T_AssignEList ->
                            T_MemberExpr
sem_MemberExpr_MemberNew me_ ael_ =
    (case (ael_) of
     { ( _aelIself) ->
         (case (me_) of
          { ( _meIself) ->
              (case (MemberNew _meIself _aelIself) of
               { _self ->
               (case (_self) of
                { _lhsOself ->
                ( _lhsOself) }) }) }) })
-- NewExpr -----------------------------------------------------
data NewExpr = MemberExpr (MemberExpr)
             | NewNewExpr (NewExpr)
-- cata
sem_NewExpr :: NewExpr ->
               T_NewExpr
sem_NewExpr (MemberExpr _me) =
    (sem_NewExpr_MemberExpr (sem_MemberExpr _me))
sem_NewExpr (NewNewExpr _ne) =
    (sem_NewExpr_NewNewExpr (sem_NewExpr _ne))
-- semantic domain
type T_NewExpr = ( NewExpr)
data Inh_NewExpr = Inh_NewExpr {}
data Syn_NewExpr = Syn_NewExpr {self_Syn_NewExpr :: NewExpr}
wrap_NewExpr :: T_NewExpr ->
                Inh_NewExpr ->
                Syn_NewExpr
wrap_NewExpr sem (Inh_NewExpr) =
    (let ( _lhsOself) = sem
     in  (Syn_NewExpr _lhsOself))
sem_NewExpr_MemberExpr :: T_MemberExpr ->
                          T_NewExpr
sem_NewExpr_MemberExpr me_ =
    (case (me_) of
     { ( _meIself) ->
         (case (MemberExpr _meIself) of
          { _self ->
          (case (_self) of
           { _lhsOself ->
           ( _lhsOself) }) }) })
sem_NewExpr_NewNewExpr :: T_NewExpr ->
                          T_NewExpr
sem_NewExpr_NewNewExpr ne_ =
    (case (ne_) of
     { ( _neIself) ->
         (case (NewNewExpr _neIself) of
          { _self ->
          (case (_self) of
           { _lhsOself ->
           ( _lhsOself) }) }) })
-- PostFix -----------------------------------------------------
data PostFix = LeftExpr (LeftExpr)
             | PostDec (LeftExpr)
             | PostInc (LeftExpr)
-- cata
sem_PostFix :: PostFix ->
               T_PostFix
sem_PostFix (LeftExpr _le) =
    (sem_PostFix_LeftExpr (sem_LeftExpr _le))
sem_PostFix (PostDec _le) =
    (sem_PostFix_PostDec (sem_LeftExpr _le))
sem_PostFix (PostInc _le) =
    (sem_PostFix_PostInc (sem_LeftExpr _le))
-- semantic domain
type T_PostFix = ( PostFix)
data Inh_PostFix = Inh_PostFix {}
data Syn_PostFix = Syn_PostFix {self_Syn_PostFix :: PostFix}
wrap_PostFix :: T_PostFix ->
                Inh_PostFix ->
                Syn_PostFix
wrap_PostFix sem (Inh_PostFix) =
    (let ( _lhsOself) = sem
     in  (Syn_PostFix _lhsOself))
sem_PostFix_LeftExpr :: T_LeftExpr ->
                        T_PostFix
sem_PostFix_LeftExpr le_ =
    (case (le_) of
     { ( _leIself) ->
         (case (LeftExpr _leIself) of
          { _self ->
          (case (_self) of
           { _lhsOself ->
           ( _lhsOself) }) }) })
sem_PostFix_PostDec :: T_LeftExpr ->
                       T_PostFix
sem_PostFix_PostDec le_ =
    (case (le_) of
     { ( _leIself) ->
         (case (PostDec _leIself) of
          { _self ->
          (case (_self) of
           { _lhsOself ->
           ( _lhsOself) }) }) })
sem_PostFix_PostInc :: T_LeftExpr ->
                       T_PostFix
sem_PostFix_PostInc le_ =
    (case (le_) of
     { ( _leIself) ->
         (case (PostInc _leIself) of
          { _self ->
          (case (_self) of
           { _lhsOself ->
           ( _lhsOself) }) }) })
-- PrimExpr ----------------------------------------------------
data PrimExpr = Array (ArrayLit)
              | Brack (Expr)
              | Ident (String)
              | Literal (Literal)
              | Object (PropNameAssignEPairGetterPutterEitherList)
              | PEFuncDecl (FuncDecl)
              | Regex (StringStringPair)
              | This
-- cata
sem_PrimExpr :: PrimExpr ->
                T_PrimExpr
sem_PrimExpr (Array _a) =
    (sem_PrimExpr_Array (sem_ArrayLit _a))
sem_PrimExpr (Brack _e) =
    (sem_PrimExpr_Brack (sem_Expr _e))
sem_PrimExpr (Ident _i) =
    (sem_PrimExpr_Ident _i)
sem_PrimExpr (Literal _l) =
    (sem_PrimExpr_Literal (sem_Literal _l))
sem_PrimExpr (Object _o) =
    (sem_PrimExpr_Object (sem_PropNameAssignEPairGetterPutterEitherList _o))
sem_PrimExpr (PEFuncDecl _f) =
    (sem_PrimExpr_PEFuncDecl (sem_FuncDecl _f))
sem_PrimExpr (Regex _stringStringPair) =
    (sem_PrimExpr_Regex (sem_StringStringPair _stringStringPair))
sem_PrimExpr (This) =
    (sem_PrimExpr_This)
-- semantic domain
type T_PrimExpr = ( PrimExpr)
data Inh_PrimExpr = Inh_PrimExpr {}
data Syn_PrimExpr = Syn_PrimExpr {self_Syn_PrimExpr :: PrimExpr}
wrap_PrimExpr :: T_PrimExpr ->
                 Inh_PrimExpr ->
                 Syn_PrimExpr
wrap_PrimExpr sem (Inh_PrimExpr) =
    (let ( _lhsOself) = sem
     in  (Syn_PrimExpr _lhsOself))
sem_PrimExpr_Array :: T_ArrayLit ->
                      T_PrimExpr
sem_PrimExpr_Array a_ =
    (case (a_) of
     { ( _aIself) ->
         (case (Array _aIself) of
          { _self ->
          (case (_self) of
           { _lhsOself ->
           ( _lhsOself) }) }) })
sem_PrimExpr_Brack :: T_Expr ->
                      T_PrimExpr
sem_PrimExpr_Brack e_ =
    (case (e_) of
     { ( _eIself) ->
         (case (Brack _eIself) of
          { _self ->
          (case (_self) of
           { _lhsOself ->
           ( _lhsOself) }) }) })
sem_PrimExpr_Ident :: String ->
                      T_PrimExpr
sem_PrimExpr_Ident i_ =
    (case (Ident i_) of
     { _self ->
     (case (_self) of
      { _lhsOself ->
      ( _lhsOself) }) })
sem_PrimExpr_Literal :: T_Literal ->
                        T_PrimExpr
sem_PrimExpr_Literal l_ =
    (case (l_) of
     { ( _lIself) ->
         (case (Literal _lIself) of
          { _self ->
          (case (_self) of
           { _lhsOself ->
           ( _lhsOself) }) }) })
sem_PrimExpr_Object :: T_PropNameAssignEPairGetterPutterEitherList ->
                       T_PrimExpr
sem_PrimExpr_Object o_ =
    (case (o_) of
     { ( _oIself) ->
         (case (Object _oIself) of
          { _self ->
          (case (_self) of
           { _lhsOself ->
           ( _lhsOself) }) }) })
sem_PrimExpr_PEFuncDecl :: T_FuncDecl ->
                           T_PrimExpr
sem_PrimExpr_PEFuncDecl f_ =
    (case (f_) of
     { ( _fIself) ->
         (case (PEFuncDecl _fIself) of
          { _self ->
          (case (_self) of
           { _lhsOself ->
           ( _lhsOself) }) }) })
sem_PrimExpr_Regex :: T_StringStringPair ->
                      T_PrimExpr
sem_PrimExpr_Regex stringStringPair_ =
    (case (stringStringPair_) of
     { ( _stringStringPairIself) ->
         (case (Regex _stringStringPairIself) of
          { _self ->
          (case (_self) of
           { _lhsOself ->
           ( _lhsOself) }) }) })
sem_PrimExpr_This :: T_PrimExpr
sem_PrimExpr_This =
    (case (This) of
     { _self ->
     (case (_self) of
      { _lhsOself ->
      ( _lhsOself) }) })
-- PropName ----------------------------------------------------
data PropName = PropNameId (String)
              | PropNameInt (Int)
              | PropNameStr (String)
-- cata
sem_PropName :: PropName ->
                T_PropName
sem_PropName (PropNameId _pn) =
    (sem_PropName_PropNameId _pn)
sem_PropName (PropNameInt _pn) =
    (sem_PropName_PropNameInt _pn)
sem_PropName (PropNameStr _pn) =
    (sem_PropName_PropNameStr _pn)
-- semantic domain
type T_PropName = ( PropName)
data Inh_PropName = Inh_PropName {}
data Syn_PropName = Syn_PropName {self_Syn_PropName :: PropName}
wrap_PropName :: T_PropName ->
                 Inh_PropName ->
                 Syn_PropName
wrap_PropName sem (Inh_PropName) =
    (let ( _lhsOself) = sem
     in  (Syn_PropName _lhsOself))
sem_PropName_PropNameId :: String ->
                           T_PropName
sem_PropName_PropNameId pn_ =
    (case (PropNameId pn_) of
     { _self ->
     (case (_self) of
      { _lhsOself ->
      ( _lhsOself) }) })
sem_PropName_PropNameInt :: Int ->
                            T_PropName
sem_PropName_PropNameInt pn_ =
    (case (PropNameInt pn_) of
     { _self ->
     (case (_self) of
      { _lhsOself ->
      ( _lhsOself) }) })
sem_PropName_PropNameStr :: String ->
                            T_PropName
sem_PropName_PropNameStr pn_ =
    (case (PropNameStr pn_) of
     { _self ->
     (case (_self) of
      { _lhsOself ->
      ( _lhsOself) }) })
-- PropNameAssignEPair -----------------------------------------
type PropNameAssignEPair = ( PropName,AssignE)
-- cata
sem_PropNameAssignEPair :: PropNameAssignEPair ->
                           T_PropNameAssignEPair
sem_PropNameAssignEPair ( x1,x2) =
    (sem_PropNameAssignEPair_Tuple (sem_PropName x1) (sem_AssignE x2))
-- semantic domain
type T_PropNameAssignEPair = ( PropNameAssignEPair)
data Inh_PropNameAssignEPair = Inh_PropNameAssignEPair {}
data Syn_PropNameAssignEPair = Syn_PropNameAssignEPair {self_Syn_PropNameAssignEPair :: PropNameAssignEPair}
wrap_PropNameAssignEPair :: T_PropNameAssignEPair ->
                            Inh_PropNameAssignEPair ->
                            Syn_PropNameAssignEPair
wrap_PropNameAssignEPair sem (Inh_PropNameAssignEPair) =
    (let ( _lhsOself) = sem
     in  (Syn_PropNameAssignEPair _lhsOself))
sem_PropNameAssignEPair_Tuple :: T_PropName ->
                                 T_AssignE ->
                                 T_PropNameAssignEPair
sem_PropNameAssignEPair_Tuple x1_ x2_ =
    (case (x2_) of
     { ( _x2Iself) ->
         (case (x1_) of
          { ( _x1Iself) ->
              (case ((_x1Iself,_x2Iself)) of
               { _self ->
               (case (_self) of
                { _lhsOself ->
                ( _lhsOself) }) }) }) })
-- PropNameAssignEPairGetterPutterEither -----------------------
type PropNameAssignEPairGetterPutterEither = Either (PropNameAssignEPair) (GetterPutter)
-- cata
sem_PropNameAssignEPairGetterPutterEither :: PropNameAssignEPairGetterPutterEither ->
                                             T_PropNameAssignEPairGetterPutterEither
sem_PropNameAssignEPairGetterPutterEither (Prelude.Left x) =
    (sem_PropNameAssignEPairGetterPutterEither_Left (sem_PropNameAssignEPair x))
sem_PropNameAssignEPairGetterPutterEither (Prelude.Right x) =
    (sem_PropNameAssignEPairGetterPutterEither_Right (sem_GetterPutter x))
-- semantic domain
type T_PropNameAssignEPairGetterPutterEither = ( PropNameAssignEPairGetterPutterEither)
data Inh_PropNameAssignEPairGetterPutterEither = Inh_PropNameAssignEPairGetterPutterEither {}
data Syn_PropNameAssignEPairGetterPutterEither = Syn_PropNameAssignEPairGetterPutterEither {self_Syn_PropNameAssignEPairGetterPutterEither :: PropNameAssignEPairGetterPutterEither}
wrap_PropNameAssignEPairGetterPutterEither :: T_PropNameAssignEPairGetterPutterEither ->
                                              Inh_PropNameAssignEPairGetterPutterEither ->
                                              Syn_PropNameAssignEPairGetterPutterEither
wrap_PropNameAssignEPairGetterPutterEither sem (Inh_PropNameAssignEPairGetterPutterEither) =
    (let ( _lhsOself) = sem
     in  (Syn_PropNameAssignEPairGetterPutterEither _lhsOself))
sem_PropNameAssignEPairGetterPutterEither_Left :: T_PropNameAssignEPair ->
                                                  T_PropNameAssignEPairGetterPutterEither
sem_PropNameAssignEPairGetterPutterEither_Left left_ =
    (case (left_) of
     { ( _leftIself) ->
         (case (Left _leftIself) of
          { _self ->
          (case (_self) of
           { _lhsOself ->
           ( _lhsOself) }) }) })
sem_PropNameAssignEPairGetterPutterEither_Right :: T_GetterPutter ->
                                                   T_PropNameAssignEPairGetterPutterEither
sem_PropNameAssignEPairGetterPutterEither_Right right_ =
    (case (right_) of
     { ( _rightIself) ->
         (case (Right _rightIself) of
          { _self ->
          (case (_self) of
           { _lhsOself ->
           ( _lhsOself) }) }) })
-- PropNameAssignEPairGetterPutterEitherList -------------------
type PropNameAssignEPairGetterPutterEitherList = [PropNameAssignEPairGetterPutterEither]
-- cata
sem_PropNameAssignEPairGetterPutterEitherList :: PropNameAssignEPairGetterPutterEitherList ->
                                                 T_PropNameAssignEPairGetterPutterEitherList
sem_PropNameAssignEPairGetterPutterEitherList list =
    (Prelude.foldr sem_PropNameAssignEPairGetterPutterEitherList_Cons sem_PropNameAssignEPairGetterPutterEitherList_Nil (Prelude.map sem_PropNameAssignEPairGetterPutterEither list))
-- semantic domain
type T_PropNameAssignEPairGetterPutterEitherList = ( PropNameAssignEPairGetterPutterEitherList)
data Inh_PropNameAssignEPairGetterPutterEitherList = Inh_PropNameAssignEPairGetterPutterEitherList {}
data Syn_PropNameAssignEPairGetterPutterEitherList = Syn_PropNameAssignEPairGetterPutterEitherList {self_Syn_PropNameAssignEPairGetterPutterEitherList :: PropNameAssignEPairGetterPutterEitherList}
wrap_PropNameAssignEPairGetterPutterEitherList :: T_PropNameAssignEPairGetterPutterEitherList ->
                                                  Inh_PropNameAssignEPairGetterPutterEitherList ->
                                                  Syn_PropNameAssignEPairGetterPutterEitherList
wrap_PropNameAssignEPairGetterPutterEitherList sem (Inh_PropNameAssignEPairGetterPutterEitherList) =
    (let ( _lhsOself) = sem
     in  (Syn_PropNameAssignEPairGetterPutterEitherList _lhsOself))
sem_PropNameAssignEPairGetterPutterEitherList_Cons :: T_PropNameAssignEPairGetterPutterEither ->
                                                      T_PropNameAssignEPairGetterPutterEitherList ->
                                                      T_PropNameAssignEPairGetterPutterEitherList
sem_PropNameAssignEPairGetterPutterEitherList_Cons hd_ tl_ =
    (case (tl_) of
     { ( _tlIself) ->
         (case (hd_) of
          { ( _hdIself) ->
              (case ((:) _hdIself _tlIself) of
               { _self ->
               (case (_self) of
                { _lhsOself ->
                ( _lhsOself) }) }) }) })
sem_PropNameAssignEPairGetterPutterEitherList_Nil :: T_PropNameAssignEPairGetterPutterEitherList
sem_PropNameAssignEPairGetterPutterEitherList_Nil =
    (case ([]) of
     { _self ->
     (case (_self) of
      { _lhsOself ->
      ( _lhsOself) }) })
-- SourceElement -----------------------------------------------
data SourceElement = SEFuncDecl (FuncDecl)
                   | Stmt (Stmt)
-- cata
sem_SourceElement :: SourceElement ->
                     T_SourceElement
sem_SourceElement (SEFuncDecl _fd) =
    (sem_SourceElement_SEFuncDecl (sem_FuncDecl _fd))
sem_SourceElement (Stmt _s) =
    (sem_SourceElement_Stmt (sem_Stmt _s))
-- semantic domain
type T_SourceElement = ( SourceElement)
data Inh_SourceElement = Inh_SourceElement {}
data Syn_SourceElement = Syn_SourceElement {self_Syn_SourceElement :: SourceElement}
wrap_SourceElement :: T_SourceElement ->
                      Inh_SourceElement ->
                      Syn_SourceElement
wrap_SourceElement sem (Inh_SourceElement) =
    (let ( _lhsOself) = sem
     in  (Syn_SourceElement _lhsOself))
sem_SourceElement_SEFuncDecl :: T_FuncDecl ->
                                T_SourceElement
sem_SourceElement_SEFuncDecl fd_ =
    (case (fd_) of
     { ( _fdIself) ->
         (case (SEFuncDecl _fdIself) of
          { _self ->
          (case (_self) of
           { _lhsOself ->
           ( _lhsOself) }) }) })
sem_SourceElement_Stmt :: T_Stmt ->
                          T_SourceElement
sem_SourceElement_Stmt s_ =
    (case (s_) of
     { ( _sIself) ->
         (case (Stmt _sIself) of
          { _self ->
          (case (_self) of
           { _lhsOself ->
           ( _lhsOself) }) }) })
-- SourceElementList -------------------------------------------
type SourceElementList = [SourceElement]
-- cata
sem_SourceElementList :: SourceElementList ->
                         T_SourceElementList
sem_SourceElementList list =
    (Prelude.foldr sem_SourceElementList_Cons sem_SourceElementList_Nil (Prelude.map sem_SourceElement list))
-- semantic domain
type T_SourceElementList = ( SourceElementList)
data Inh_SourceElementList = Inh_SourceElementList {}
data Syn_SourceElementList = Syn_SourceElementList {self_Syn_SourceElementList :: SourceElementList}
wrap_SourceElementList :: T_SourceElementList ->
                          Inh_SourceElementList ->
                          Syn_SourceElementList
wrap_SourceElementList sem (Inh_SourceElementList) =
    (let ( _lhsOself) = sem
     in  (Syn_SourceElementList _lhsOself))
sem_SourceElementList_Cons :: T_SourceElement ->
                              T_SourceElementList ->
                              T_SourceElementList
sem_SourceElementList_Cons hd_ tl_ =
    (case (tl_) of
     { ( _tlIself) ->
         (case (hd_) of
          { ( _hdIself) ->
              (case ((:) _hdIself _tlIself) of
               { _self ->
               (case (_self) of
                { _lhsOself ->
                ( _lhsOself) }) }) }) })
sem_SourceElementList_Nil :: T_SourceElementList
sem_SourceElementList_Nil =
    (case ([]) of
     { _self ->
     (case (_self) of
      { _lhsOself ->
      ( _lhsOself) }) })
-- Stmt --------------------------------------------------------
data Stmt = StmtPos (IntIntPair) (Stmt')
-- cata
sem_Stmt :: Stmt ->
            T_Stmt
sem_Stmt (StmtPos _lc _s) =
    (sem_Stmt_StmtPos (sem_IntIntPair _lc) (sem_Stmt' _s))
-- semantic domain
type T_Stmt = ( Stmt)
data Inh_Stmt = Inh_Stmt {}
data Syn_Stmt = Syn_Stmt {self_Syn_Stmt :: Stmt}
wrap_Stmt :: T_Stmt ->
             Inh_Stmt ->
             Syn_Stmt
wrap_Stmt sem (Inh_Stmt) =
    (let ( _lhsOself) = sem
     in  (Syn_Stmt _lhsOself))
sem_Stmt_StmtPos :: T_IntIntPair ->
                    (T_Stmt') ->
                    T_Stmt
sem_Stmt_StmtPos lc_ s_ =
    (case (s_) of
     { ( _sIself) ->
         (case (lc_) of
          { ( _lcIself) ->
              (case (StmtPos _lcIself _sIself) of
               { _self ->
               (case (_self) of
                { _lhsOself ->
                ( _lhsOself) }) }) }) })
-- Stmt' -------------------------------------------------------
data Stmt' = Block (StmtList)
           | BreakStmt (StringMaybe)
           | ContStmt (StringMaybe)
           | EmptyStmt
           | ExprStmt (Expr)
           | IfStmt (IfStmt)
           | ItStmt (ItStmt)
           | LabelledStmt (String) (Stmt)
           | ReturnStmt (ExprMaybe)
           | Switch (Expr) (CaseClauseList)
           | ThrowExpr (Expr)
           | TryStmt (TryStmt)
           | VarStmt (VarDeclList)
           | WithStmt (Expr) (Stmt)
-- cata
sem_Stmt' :: (Stmt') ->
             (T_Stmt')
sem_Stmt' (Block _s) =
    (sem_Stmt'_Block (sem_StmtList _s))
sem_Stmt' (BreakStmt _sm) =
    (sem_Stmt'_BreakStmt (sem_StringMaybe _sm))
sem_Stmt' (ContStmt _sm) =
    (sem_Stmt'_ContStmt (sem_StringMaybe _sm))
sem_Stmt' (EmptyStmt) =
    (sem_Stmt'_EmptyStmt)
sem_Stmt' (ExprStmt _e) =
    (sem_Stmt'_ExprStmt (sem_Expr _e))
sem_Stmt' (IfStmt _s) =
    (sem_Stmt'_IfStmt (sem_IfStmt _s))
sem_Stmt' (ItStmt _is) =
    (sem_Stmt'_ItStmt (sem_ItStmt _is))
sem_Stmt' (LabelledStmt _l _s) =
    (sem_Stmt'_LabelledStmt _l (sem_Stmt _s))
sem_Stmt' (ReturnStmt _em) =
    (sem_Stmt'_ReturnStmt (sem_ExprMaybe _em))
sem_Stmt' (Switch _e _cc) =
    (sem_Stmt'_Switch (sem_Expr _e) (sem_CaseClauseList _cc))
sem_Stmt' (ThrowExpr _e) =
    (sem_Stmt'_ThrowExpr (sem_Expr _e))
sem_Stmt' (TryStmt _ts) =
    (sem_Stmt'_TryStmt (sem_TryStmt _ts))
sem_Stmt' (VarStmt _vd) =
    (sem_Stmt'_VarStmt (sem_VarDeclList _vd))
sem_Stmt' (WithStmt _e _s) =
    (sem_Stmt'_WithStmt (sem_Expr _e) (sem_Stmt _s))
-- semantic domain
type T_Stmt' = ( Stmt')
data Inh_Stmt' = Inh_Stmt' {}
data Syn_Stmt' = Syn_Stmt' {self_Syn_Stmt' :: Stmt'}
wrap_Stmt' :: (T_Stmt') ->
              (Inh_Stmt') ->
              (Syn_Stmt')
wrap_Stmt' sem (Inh_Stmt') =
    (let ( _lhsOself) = sem
     in  (Syn_Stmt' _lhsOself))
sem_Stmt'_Block :: T_StmtList ->
                   (T_Stmt')
sem_Stmt'_Block s_ =
    (case (s_) of
     { ( _sIself) ->
         (case (Block _sIself) of
          { _self ->
          (case (_self) of
           { _lhsOself ->
           ( _lhsOself) }) }) })
sem_Stmt'_BreakStmt :: T_StringMaybe ->
                       (T_Stmt')
sem_Stmt'_BreakStmt sm_ =
    (case (sm_) of
     { ( _smIself) ->
         (case (BreakStmt _smIself) of
          { _self ->
          (case (_self) of
           { _lhsOself ->
           ( _lhsOself) }) }) })
sem_Stmt'_ContStmt :: T_StringMaybe ->
                      (T_Stmt')
sem_Stmt'_ContStmt sm_ =
    (case (sm_) of
     { ( _smIself) ->
         (case (ContStmt _smIself) of
          { _self ->
          (case (_self) of
           { _lhsOself ->
           ( _lhsOself) }) }) })
sem_Stmt'_EmptyStmt :: (T_Stmt')
sem_Stmt'_EmptyStmt =
    (case (EmptyStmt) of
     { _self ->
     (case (_self) of
      { _lhsOself ->
      ( _lhsOself) }) })
sem_Stmt'_ExprStmt :: T_Expr ->
                      (T_Stmt')
sem_Stmt'_ExprStmt e_ =
    (case (e_) of
     { ( _eIself) ->
         (case (ExprStmt _eIself) of
          { _self ->
          (case (_self) of
           { _lhsOself ->
           ( _lhsOself) }) }) })
sem_Stmt'_IfStmt :: T_IfStmt ->
                    (T_Stmt')
sem_Stmt'_IfStmt s_ =
    (case (s_) of
     { ( _sIself) ->
         (case (IfStmt _sIself) of
          { _self ->
          (case (_self) of
           { _lhsOself ->
           ( _lhsOself) }) }) })
sem_Stmt'_ItStmt :: T_ItStmt ->
                    (T_Stmt')
sem_Stmt'_ItStmt is_ =
    (case (is_) of
     { ( _isIself) ->
         (case (ItStmt _isIself) of
          { _self ->
          (case (_self) of
           { _lhsOself ->
           ( _lhsOself) }) }) })
sem_Stmt'_LabelledStmt :: String ->
                          T_Stmt ->
                          (T_Stmt')
sem_Stmt'_LabelledStmt l_ s_ =
    (case (s_) of
     { ( _sIself) ->
         (case (LabelledStmt l_ _sIself) of
          { _self ->
          (case (_self) of
           { _lhsOself ->
           ( _lhsOself) }) }) })
sem_Stmt'_ReturnStmt :: T_ExprMaybe ->
                        (T_Stmt')
sem_Stmt'_ReturnStmt em_ =
    (case (em_) of
     { ( _emIself) ->
         (case (ReturnStmt _emIself) of
          { _self ->
          (case (_self) of
           { _lhsOself ->
           ( _lhsOself) }) }) })
sem_Stmt'_Switch :: T_Expr ->
                    T_CaseClauseList ->
                    (T_Stmt')
sem_Stmt'_Switch e_ cc_ =
    (case (cc_) of
     { ( _ccIself) ->
         (case (e_) of
          { ( _eIself) ->
              (case (Switch _eIself _ccIself) of
               { _self ->
               (case (_self) of
                { _lhsOself ->
                ( _lhsOself) }) }) }) })
sem_Stmt'_ThrowExpr :: T_Expr ->
                       (T_Stmt')
sem_Stmt'_ThrowExpr e_ =
    (case (e_) of
     { ( _eIself) ->
         (case (ThrowExpr _eIself) of
          { _self ->
          (case (_self) of
           { _lhsOself ->
           ( _lhsOself) }) }) })
sem_Stmt'_TryStmt :: T_TryStmt ->
                     (T_Stmt')
sem_Stmt'_TryStmt ts_ =
    (case (ts_) of
     { ( _tsIself) ->
         (case (TryStmt _tsIself) of
          { _self ->
          (case (_self) of
           { _lhsOself ->
           ( _lhsOself) }) }) })
sem_Stmt'_VarStmt :: T_VarDeclList ->
                     (T_Stmt')
sem_Stmt'_VarStmt vd_ =
    (case (vd_) of
     { ( _vdIself) ->
         (case (VarStmt _vdIself) of
          { _self ->
          (case (_self) of
           { _lhsOself ->
           ( _lhsOself) }) }) })
sem_Stmt'_WithStmt :: T_Expr ->
                      T_Stmt ->
                      (T_Stmt')
sem_Stmt'_WithStmt e_ s_ =
    (case (s_) of
     { ( _sIself) ->
         (case (e_) of
          { ( _eIself) ->
              (case (WithStmt _eIself _sIself) of
               { _self ->
               (case (_self) of
                { _lhsOself ->
                ( _lhsOself) }) }) }) })
-- StmtList ----------------------------------------------------
type StmtList = [Stmt]
-- cata
sem_StmtList :: StmtList ->
                T_StmtList
sem_StmtList list =
    (Prelude.foldr sem_StmtList_Cons sem_StmtList_Nil (Prelude.map sem_Stmt list))
-- semantic domain
type T_StmtList = ( StmtList)
data Inh_StmtList = Inh_StmtList {}
data Syn_StmtList = Syn_StmtList {self_Syn_StmtList :: StmtList}
wrap_StmtList :: T_StmtList ->
                 Inh_StmtList ->
                 Syn_StmtList
wrap_StmtList sem (Inh_StmtList) =
    (let ( _lhsOself) = sem
     in  (Syn_StmtList _lhsOself))
sem_StmtList_Cons :: T_Stmt ->
                     T_StmtList ->
                     T_StmtList
sem_StmtList_Cons hd_ tl_ =
    (case (tl_) of
     { ( _tlIself) ->
         (case (hd_) of
          { ( _hdIself) ->
              (case ((:) _hdIself _tlIself) of
               { _self ->
               (case (_self) of
                { _lhsOself ->
                ( _lhsOself) }) }) }) })
sem_StmtList_Nil :: T_StmtList
sem_StmtList_Nil =
    (case ([]) of
     { _self ->
     (case (_self) of
      { _lhsOself ->
      ( _lhsOself) }) })
-- StringList --------------------------------------------------
type StringList = [(String)]
-- cata
sem_StringList :: StringList ->
                  T_StringList
sem_StringList list =
    (Prelude.foldr sem_StringList_Cons sem_StringList_Nil list)
-- semantic domain
type T_StringList = ( StringList)
data Inh_StringList = Inh_StringList {}
data Syn_StringList = Syn_StringList {self_Syn_StringList :: StringList}
wrap_StringList :: T_StringList ->
                   Inh_StringList ->
                   Syn_StringList
wrap_StringList sem (Inh_StringList) =
    (let ( _lhsOself) = sem
     in  (Syn_StringList _lhsOself))
sem_StringList_Cons :: String ->
                       T_StringList ->
                       T_StringList
sem_StringList_Cons hd_ tl_ =
    (case (tl_) of
     { ( _tlIself) ->
         (case ((:) hd_ _tlIself) of
          { _self ->
          (case (_self) of
           { _lhsOself ->
           ( _lhsOself) }) }) })
sem_StringList_Nil :: T_StringList
sem_StringList_Nil =
    (case ([]) of
     { _self ->
     (case (_self) of
      { _lhsOself ->
      ( _lhsOself) }) })
-- StringMaybe -------------------------------------------------
type StringMaybe = Maybe (String)
-- cata
sem_StringMaybe :: StringMaybe ->
                   T_StringMaybe
sem_StringMaybe (Prelude.Just x) =
    (sem_StringMaybe_Just x)
sem_StringMaybe Prelude.Nothing =
    sem_StringMaybe_Nothing
-- semantic domain
type T_StringMaybe = ( StringMaybe)
data Inh_StringMaybe = Inh_StringMaybe {}
data Syn_StringMaybe = Syn_StringMaybe {self_Syn_StringMaybe :: StringMaybe}
wrap_StringMaybe :: T_StringMaybe ->
                    Inh_StringMaybe ->
                    Syn_StringMaybe
wrap_StringMaybe sem (Inh_StringMaybe) =
    (let ( _lhsOself) = sem
     in  (Syn_StringMaybe _lhsOself))
sem_StringMaybe_Just :: String ->
                        T_StringMaybe
sem_StringMaybe_Just just_ =
    (case (Just just_) of
     { _self ->
     (case (_self) of
      { _lhsOself ->
      ( _lhsOself) }) })
sem_StringMaybe_Nothing :: T_StringMaybe
sem_StringMaybe_Nothing =
    (case (Nothing) of
     { _self ->
     (case (_self) of
      { _lhsOself ->
      ( _lhsOself) }) })
-- StringStringPair --------------------------------------------
type StringStringPair = ( (String),(String))
-- cata
sem_StringStringPair :: StringStringPair ->
                        T_StringStringPair
sem_StringStringPair ( x1,x2) =
    (sem_StringStringPair_Tuple x1 x2)
-- semantic domain
type T_StringStringPair = ( StringStringPair)
data Inh_StringStringPair = Inh_StringStringPair {}
data Syn_StringStringPair = Syn_StringStringPair {self_Syn_StringStringPair :: StringStringPair}
wrap_StringStringPair :: T_StringStringPair ->
                         Inh_StringStringPair ->
                         Syn_StringStringPair
wrap_StringStringPair sem (Inh_StringStringPair) =
    (let ( _lhsOself) = sem
     in  (Syn_StringStringPair _lhsOself))
sem_StringStringPair_Tuple :: String ->
                              String ->
                              T_StringStringPair
sem_StringStringPair_Tuple x1_ x2_ =
    (case ((x1_,x2_)) of
     { _self ->
     (case (_self) of
      { _lhsOself ->
      ( _lhsOself) }) })
-- TryStmt -----------------------------------------------------
data TryStmt = TryBC (StmtList) (CatchList)
             | TryBCF (StmtList) (CatchList) (StmtList)
             | TryBF (StmtList) (StmtList)
             | TryTry (StmtList) (CatchList) (StmtList)
-- cata
sem_TryStmt :: TryStmt ->
               T_TryStmt
sem_TryStmt (TryBC _b _c) =
    (sem_TryStmt_TryBC (sem_StmtList _b) (sem_CatchList _c))
sem_TryStmt (TryBCF _b _c _f) =
    (sem_TryStmt_TryBCF (sem_StmtList _b) (sem_CatchList _c) (sem_StmtList _f))
sem_TryStmt (TryBF _b _f) =
    (sem_TryStmt_TryBF (sem_StmtList _b) (sem_StmtList _f))
sem_TryStmt (TryTry _b _c _f) =
    (sem_TryStmt_TryTry (sem_StmtList _b) (sem_CatchList _c) (sem_StmtList _f))
-- semantic domain
type T_TryStmt = ( TryStmt)
data Inh_TryStmt = Inh_TryStmt {}
data Syn_TryStmt = Syn_TryStmt {self_Syn_TryStmt :: TryStmt}
wrap_TryStmt :: T_TryStmt ->
                Inh_TryStmt ->
                Syn_TryStmt
wrap_TryStmt sem (Inh_TryStmt) =
    (let ( _lhsOself) = sem
     in  (Syn_TryStmt _lhsOself))
sem_TryStmt_TryBC :: T_StmtList ->
                     T_CatchList ->
                     T_TryStmt
sem_TryStmt_TryBC b_ c_ =
    (case (c_) of
     { ( _cIself) ->
         (case (b_) of
          { ( _bIself) ->
              (case (TryBC _bIself _cIself) of
               { _self ->
               (case (_self) of
                { _lhsOself ->
                ( _lhsOself) }) }) }) })
sem_TryStmt_TryBCF :: T_StmtList ->
                      T_CatchList ->
                      T_StmtList ->
                      T_TryStmt
sem_TryStmt_TryBCF b_ c_ f_ =
    (case (f_) of
     { ( _fIself) ->
         (case (c_) of
          { ( _cIself) ->
              (case (b_) of
               { ( _bIself) ->
                   (case (TryBCF _bIself _cIself _fIself) of
                    { _self ->
                    (case (_self) of
                     { _lhsOself ->
                     ( _lhsOself) }) }) }) }) })
sem_TryStmt_TryBF :: T_StmtList ->
                     T_StmtList ->
                     T_TryStmt
sem_TryStmt_TryBF b_ f_ =
    (case (f_) of
     { ( _fIself) ->
         (case (b_) of
          { ( _bIself) ->
              (case (TryBF _bIself _fIself) of
               { _self ->
               (case (_self) of
                { _lhsOself ->
                ( _lhsOself) }) }) }) })
sem_TryStmt_TryTry :: T_StmtList ->
                      T_CatchList ->
                      T_StmtList ->
                      T_TryStmt
sem_TryStmt_TryTry b_ c_ f_ =
    (case (f_) of
     { ( _fIself) ->
         (case (c_) of
          { ( _cIself) ->
              (case (b_) of
               { ( _bIself) ->
                   (case (TryTry _bIself _cIself _fIself) of
                    { _self ->
                    (case (_self) of
                     { _lhsOself ->
                     ( _lhsOself) }) }) }) }) })
-- UExpr -------------------------------------------------------
data UExpr = BitNot (UExpr)
           | Delete (UExpr)
           | DoubleMinus (UExpr)
           | DoublePlus (UExpr)
           | Not (UExpr)
           | PostFix (PostFix)
           | TypeOf (UExpr)
           | UnaryMinus (UExpr)
           | UnaryPlus (UExpr)
           | Void (UExpr)
-- cata
sem_UExpr :: UExpr ->
             T_UExpr
sem_UExpr (BitNot _ue) =
    (sem_UExpr_BitNot (sem_UExpr _ue))
sem_UExpr (Delete _ue) =
    (sem_UExpr_Delete (sem_UExpr _ue))
sem_UExpr (DoubleMinus _ue) =
    (sem_UExpr_DoubleMinus (sem_UExpr _ue))
sem_UExpr (DoublePlus _ue) =
    (sem_UExpr_DoublePlus (sem_UExpr _ue))
sem_UExpr (Not _ue) =
    (sem_UExpr_Not (sem_UExpr _ue))
sem_UExpr (PostFix _pf) =
    (sem_UExpr_PostFix (sem_PostFix _pf))
sem_UExpr (TypeOf _ue) =
    (sem_UExpr_TypeOf (sem_UExpr _ue))
sem_UExpr (UnaryMinus _ue) =
    (sem_UExpr_UnaryMinus (sem_UExpr _ue))
sem_UExpr (UnaryPlus _ue) =
    (sem_UExpr_UnaryPlus (sem_UExpr _ue))
sem_UExpr (Void _ue) =
    (sem_UExpr_Void (sem_UExpr _ue))
-- semantic domain
type T_UExpr = ( UExpr)
data Inh_UExpr = Inh_UExpr {}
data Syn_UExpr = Syn_UExpr {self_Syn_UExpr :: UExpr}
wrap_UExpr :: T_UExpr ->
              Inh_UExpr ->
              Syn_UExpr
wrap_UExpr sem (Inh_UExpr) =
    (let ( _lhsOself) = sem
     in  (Syn_UExpr _lhsOself))
sem_UExpr_BitNot :: T_UExpr ->
                    T_UExpr
sem_UExpr_BitNot ue_ =
    (case (ue_) of
     { ( _ueIself) ->
         (case (BitNot _ueIself) of
          { _self ->
          (case (_self) of
           { _lhsOself ->
           ( _lhsOself) }) }) })
sem_UExpr_Delete :: T_UExpr ->
                    T_UExpr
sem_UExpr_Delete ue_ =
    (case (ue_) of
     { ( _ueIself) ->
         (case (Delete _ueIself) of
          { _self ->
          (case (_self) of
           { _lhsOself ->
           ( _lhsOself) }) }) })
sem_UExpr_DoubleMinus :: T_UExpr ->
                         T_UExpr
sem_UExpr_DoubleMinus ue_ =
    (case (ue_) of
     { ( _ueIself) ->
         (case (DoubleMinus _ueIself) of
          { _self ->
          (case (_self) of
           { _lhsOself ->
           ( _lhsOself) }) }) })
sem_UExpr_DoublePlus :: T_UExpr ->
                        T_UExpr
sem_UExpr_DoublePlus ue_ =
    (case (ue_) of
     { ( _ueIself) ->
         (case (DoublePlus _ueIself) of
          { _self ->
          (case (_self) of
           { _lhsOself ->
           ( _lhsOself) }) }) })
sem_UExpr_Not :: T_UExpr ->
                 T_UExpr
sem_UExpr_Not ue_ =
    (case (ue_) of
     { ( _ueIself) ->
         (case (Not _ueIself) of
          { _self ->
          (case (_self) of
           { _lhsOself ->
           ( _lhsOself) }) }) })
sem_UExpr_PostFix :: T_PostFix ->
                     T_UExpr
sem_UExpr_PostFix pf_ =
    (case (pf_) of
     { ( _pfIself) ->
         (case (PostFix _pfIself) of
          { _self ->
          (case (_self) of
           { _lhsOself ->
           ( _lhsOself) }) }) })
sem_UExpr_TypeOf :: T_UExpr ->
                    T_UExpr
sem_UExpr_TypeOf ue_ =
    (case (ue_) of
     { ( _ueIself) ->
         (case (TypeOf _ueIself) of
          { _self ->
          (case (_self) of
           { _lhsOself ->
           ( _lhsOself) }) }) })
sem_UExpr_UnaryMinus :: T_UExpr ->
                        T_UExpr
sem_UExpr_UnaryMinus ue_ =
    (case (ue_) of
     { ( _ueIself) ->
         (case (UnaryMinus _ueIself) of
          { _self ->
          (case (_self) of
           { _lhsOself ->
           ( _lhsOself) }) }) })
sem_UExpr_UnaryPlus :: T_UExpr ->
                       T_UExpr
sem_UExpr_UnaryPlus ue_ =
    (case (ue_) of
     { ( _ueIself) ->
         (case (UnaryPlus _ueIself) of
          { _self ->
          (case (_self) of
           { _lhsOself ->
           ( _lhsOself) }) }) })
sem_UExpr_Void :: T_UExpr ->
                  T_UExpr
sem_UExpr_Void ue_ =
    (case (ue_) of
     { ( _ueIself) ->
         (case (Void _ueIself) of
          { _self ->
          (case (_self) of
           { _lhsOself ->
           ( _lhsOself) }) }) })
-- VarDecl -----------------------------------------------------
data VarDecl = VarDecl (String) (AssignEMaybe)
-- cata
sem_VarDecl :: VarDecl ->
               T_VarDecl
sem_VarDecl (VarDecl _i _aem) =
    (sem_VarDecl_VarDecl _i (sem_AssignEMaybe _aem))
-- semantic domain
type T_VarDecl = ( VarDecl)
data Inh_VarDecl = Inh_VarDecl {}
data Syn_VarDecl = Syn_VarDecl {self_Syn_VarDecl :: VarDecl}
wrap_VarDecl :: T_VarDecl ->
                Inh_VarDecl ->
                Syn_VarDecl
wrap_VarDecl sem (Inh_VarDecl) =
    (let ( _lhsOself) = sem
     in  (Syn_VarDecl _lhsOself))
sem_VarDecl_VarDecl :: String ->
                       T_AssignEMaybe ->
                       T_VarDecl
sem_VarDecl_VarDecl i_ aem_ =
    (case (aem_) of
     { ( _aemIself) ->
         (case (VarDecl i_ _aemIself) of
          { _self ->
          (case (_self) of
           { _lhsOself ->
           ( _lhsOself) }) }) })
-- VarDeclList -------------------------------------------------
type VarDeclList = [VarDecl]
-- cata
sem_VarDeclList :: VarDeclList ->
                   T_VarDeclList
sem_VarDeclList list =
    (Prelude.foldr sem_VarDeclList_Cons sem_VarDeclList_Nil (Prelude.map sem_VarDecl list))
-- semantic domain
type T_VarDeclList = ( VarDeclList)
data Inh_VarDeclList = Inh_VarDeclList {}
data Syn_VarDeclList = Syn_VarDeclList {self_Syn_VarDeclList :: VarDeclList}
wrap_VarDeclList :: T_VarDeclList ->
                    Inh_VarDeclList ->
                    Syn_VarDeclList
wrap_VarDeclList sem (Inh_VarDeclList) =
    (let ( _lhsOself) = sem
     in  (Syn_VarDeclList _lhsOself))
sem_VarDeclList_Cons :: T_VarDecl ->
                        T_VarDeclList ->
                        T_VarDeclList
sem_VarDeclList_Cons hd_ tl_ =
    (case (tl_) of
     { ( _tlIself) ->
         (case (hd_) of
          { ( _hdIself) ->
              (case ((:) _hdIself _tlIself) of
               { _self ->
               (case (_self) of
                { _lhsOself ->
                ( _lhsOself) }) }) }) })
sem_VarDeclList_Nil :: T_VarDeclList
sem_VarDeclList_Nil =
    (case ([]) of
     { _self ->
     (case (_self) of
      { _lhsOself ->
      ( _lhsOself) }) })