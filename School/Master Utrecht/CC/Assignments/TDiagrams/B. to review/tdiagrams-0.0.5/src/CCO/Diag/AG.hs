

-- UUAGC 0.9.40.2 (src/CCO/Diag/AG.ag)
module CCO.Diag.AG where

{-# LINE 2 "src/CCO/Diag/AG/Base.ag" #-}

import CCO.SourcePos        (SourcePos)
import CCO.Tree             (ATerm (App), Tree (fromTree, toTree))
import CCO.Tree.Parser      (parseTree, app, arg)
import Control.Applicative  (Applicative ((<*>)), (<$>), pure)
{-# LINE 13 "src/CCO/Diag/AG.hs" #-}

{-# LINE 1 "src/CCO/Diag/AG/Typecheck.ag" #-}

import CCO.SourcePos
import CCO.Feedback
import CCO.Printing
import Data.Map (Map)
import qualified Data.Map as M
import Data.Char
import Text.Printf
import Control.Applicative
import Data.Maybe
import Control.Monad
{-# LINE 27 "src/CCO/Diag/AG.hs" #-}

{-# LINE 1 "src/CCO/Diag/AG/TDiag2Picture.ag" #-}

import CCO.Picture.AG
import Data.Map (Map)
import qualified Data.Map as M
import Data.Char
import Text.Printf
import Control.Applicative
import Data.Maybe
import Control.Monad
{-# LINE 39 "src/CCO/Diag/AG.hs" #-}
{-# LINE 13 "src/CCO/Diag/AG/Base.ag" #-}

type Ident = String
{-# LINE 43 "src/CCO/Diag/AG.hs" #-}

{-# LINE 50 "src/CCO/Diag/AG/Base.ag" #-}

instance Tree Diag where
  fromTree (Diag pos d) = App "Diag" [fromTree pos, fromTree d]
  toTree = parseTree [app "Diag" (Diag <$> arg <*> arg)]

instance Tree Diag_ where
  fromTree (Program p l)        = App "Program"  [fromTree p, fromTree l]
  fromTree (Platform m)         = App "Platform" [fromTree m]
  fromTree (Interpreter i l m)  = App "Interpreter"
                                    [fromTree i, fromTree l, fromTree m]
  fromTree (Compiler c l1 l2 m) =
    App "Compiler" [fromTree c, fromTree l1, fromTree l2, fromTree m]
  fromTree (Execute d1 d2)      = App "Execute" [fromTree d1, fromTree d2]
  fromTree (Compile d1 d2)      = App "Compile" [fromTree d1, fromTree d2]
  fromTree (Let v d1 d2)        = App "Let" [fromTree v, fromTree d1, fromTree d2]
  fromTree (Use v)              = App "Use" [fromTree v]

  toTree = parseTree 
             [ app "Program"     (Program     <$> arg <*> arg                )
             , app "Platform"    (Platform    <$> arg                        )
             , app "Interpreter" (Interpreter <$> arg <*> arg <*> arg        )
             , app "Compiler"    (Compiler    <$> arg <*> arg <*> arg <*> arg)
             , app "Execute"     (Execute     <$> arg <*> arg                )
             , app "Compile"     (Compile     <$> arg <*> arg                )
             , app "Let"         (Let         <$> arg <*> arg <*> arg        )
             , app "Use"         (Use         <$> arg                        )
             ]

instance Tree CoDiag where
  fromTree (CoDiag pos d) = App "CoDiag" [fromTree pos, fromTree d]
  toTree = parseTree [app "CoDiag" (CoDiag <$> arg <*> arg)]

instance Tree CoDiag_ where
  fromTree (CoProgram p l d)       = App "CoProgram"  
                                     [fromTree p, fromTree l, fromTree d]
  fromTree (CoPlatform m)          = App "CoPlatform" [fromTree m]
  fromTree (CoInterpreter i l m d) = App "CoInterpreter"
                                     [fromTree i, fromTree l, fromTree m, fromTree d]
  fromTree (CoCompiler c l1 l2 m d1 d2) =
    App "CoCompiler" [fromTree c, fromTree l1, fromTree l2, fromTree m,
                      fromTree d1, fromTree d2 ]
  fromTree CoNothing               = App "CoNothing" []

  toTree = parseTree 
             [ app "CoProgram"     (CoProgram     <$> arg <*> arg <*> arg        )
             , app "CoPlatform"    (CoPlatform    <$> arg                        )
             , app "CoInterpreter" (CoInterpreter <$> arg <*> arg <*> arg <*> arg)
             , app "CoCompiler"    (CoCompiler    <$> arg <*> arg <*> arg <*> arg 
                                                          <*> arg <*> arg        )
             , app "CoNothing"     (pure CoNothing)
             ]

{-# LINE 98 "src/CCO/Diag/AG.hs" #-}

{-# LINE 14 "src/CCO/Diag/AG/Typecheck.ag" #-}

fatal_ s = errorMessage $ text $ "Fatal error: " ++ s
error_ s = message $ Warning 1 $ text $ "Error: " ++ s
warning_ s = message $ Log 1 $ text $ "Warning: " ++ s
message_ s = message $ Log 1 $ text $ "Message: " ++ s

-- | Check whether the given monadic value yields an error and throw a
-- fatal if that's the case.
mkFatal :: Feedback a -> Feedback a
mkFatal f = do
  a <- f
  when (failing $ wError f) (fatal_ "one or more errors found")
  return a
  
-- | Make a string lowercase.
lowercase :: String -> String
lowercase = map toLower

-- | Alternative to the standard show implementation.
show' :: SourcePos -> String
show' (SourcePos _ (Pos l c)) = show l ++ ":" ++ show c

data Type = TProgram | TPlatform | TInterpreter | TCompiler | TNothing 
          deriving (Show, Eq)

-- | Check whether the given element is an element of the list. Throws
-- an error message if this is not the case.
checkOneOf :: (Show a, Eq a) => a -> SourcePos -> [a] -> SourcePos -> Feedback ()
checkOneOf a p1 as p2 = 
  if a `elem` as 
    then return ()
    else error_ $ printf "(%s) expected one of %s, found %s at (%s)" (show' p2) (show as) (show a) (show' p1)

wrapDiag :: Diag -> Syn_Root
wrapDiag d = wrap_Root (sem_Root (Root d)) Inh_Root

wrapCoDiag :: CoDiag -> Syn_CoRoot
wrapCoDiag cd = wrap_CoRoot (sem_CoRoot (CoRoot cd)) Inh_CoRoot
{-# LINE 139 "src/CCO/Diag/AG.hs" #-}

{-# LINE 12 "src/CCO/Diag/AG/TDiag2Picture.ag" #-}

data Draw = Draw { width :: Double
                 , height :: Double
                 , draw :: Double -> Double -> [Command] -> [Command]
                 }

mindim :: Draw -> Draw -> Draw
mindim d1 d2 = Draw (max (width d1) (width d2))
                    (max (height d1) (height d2))
                    (draw d2)                
                    
-- | Translate a Draw by its height.
neg :: Draw -> Draw
neg d = d { draw = (\x y -> draw d x (y - height d)) }
                 
{-# LINE 157 "src/CCO/Diag/AG.hs" #-}

{-# LINE 79 "src/CCO/Diag/AG/TDiag2Picture.ag" #-}

drawProgram p l = neg $ Draw 65 30
  (\x y z -> 
    Put (x+7.5,y+0) (Line (1,0) 50) :
    Put (x+7.5,y+0) (Line (0,1) 15) :
    Put (x+7.5,y+15) (Line (-1,2) 7.5) :
    Put (x+57.5,y+15) (Line (1,2) 7.5) :
    Put (x+57.5,y+0) (Line (0,1) 15) :
    Put (x+0,y+30) (Line (1,0) 65) :
    Put (x+7.5,y+15) (Makebox (50,15) p) :
    Put (x+7.5,y+0) (Makebox (50,15) l) :
    z)
    
drawPlatform m = neg $ Draw 50 30
  (\x y z -> 
    Put (x+0,y+15) (Line (5,-3) 25) :
    Put (x+25,y+0) (Line (5,3) 25) :
    Put (x+0,y+15) (Line (0,1) 15) :
    Put (x+0,y+30) (Line (1,0) 50) :
    Put (x+50,y+30) (Line (0,-1) 15) :
    Put (x+0,y+15) (Makebox (50,15) m) :
    z)
    
drawInterpreter i l m = neg $ Draw 50 30
  (\x y z -> 
    Put (x+0,y+0) (Framebox (50,30) "") :
    Put (x+0,y+20) (Makebox (50,10) l) :
    Put (x+0,y+10) (Makebox (50,10) i) :
    Put (x+0,y+0) (Makebox (50,10) m) :
    z)
    
drawCompiler c l1 l2 m = neg $ Draw 150 30
  (\x y z -> 
    Put (x+50,y+0) (Line (0,1) 20) :
    Put (x+50,y+20) (Line (-1,0) 50) :
    Put (x+0,y+20) (Line (0,1) 10) :
    Put (x+0,y+30) (Line (1,0) 150) :
    Put (x+150,y+30) (Line (0,-1) 10) :
    Put (x+150,y+20) (Line (-1,0) 50) :
    Put (x+100,y+20) (Line (0,-1) 20) :
    Put (x+100,y+0) (Line (-1,0) 50) :
    Put (x+0,y+20) (Makebox (50,10) l1) :
    Put (x+50,y+20) (Makebox (50,10) "$\\longrightarrow$") :
    Put (x+100,y+20) (Makebox (50,10) l2) :
    Put (x+50,y+10) (Makebox (50,10) c) :
    Put (x+50,y+0) (Makebox (50,10) m) :
    z)
    
drawNothing = neg $ Draw 0 0
  (\x y z -> z)
{-# LINE 210 "src/CCO/Diag/AG.hs" #-}
-- CoDiag ------------------------------------------------------
data CoDiag = CoDiag (SourcePos) (CoDiag_)
-- cata
sem_CoDiag :: CoDiag ->
              T_CoDiag
sem_CoDiag (CoDiag _pos _d) =
    (sem_CoDiag_CoDiag _pos (sem_CoDiag_ _d))
-- semantic domain
type T_CoDiag = String ->
                SourcePos ->
                (String -> Draw) ->
                Type ->
                ( (Feedback ()),(Feedback ()),Draw,String,SourcePos,Type)
data Inh_CoDiag = Inh_CoDiag {name_Inh_CoDiag :: String,ppos_Inh_CoDiag :: SourcePos,program_Inh_CoDiag :: (String -> Draw),type__Inh_CoDiag :: Type}
data Syn_CoDiag = Syn_CoDiag {checkn_Syn_CoDiag :: (Feedback ()),checkt_Syn_CoDiag :: (Feedback ()),draw_Syn_CoDiag :: Draw,name_Syn_CoDiag :: String,pos_Syn_CoDiag :: SourcePos,type__Syn_CoDiag :: Type}
wrap_CoDiag :: T_CoDiag ->
               Inh_CoDiag ->
               Syn_CoDiag
wrap_CoDiag sem (Inh_CoDiag _lhsIname _lhsIppos _lhsIprogram _lhsItype_) =
    (let ( _lhsOcheckn,_lhsOcheckt,_lhsOdraw,_lhsOname,_lhsOpos,_lhsOtype_) = sem _lhsIname _lhsIppos _lhsIprogram _lhsItype_
     in  (Syn_CoDiag _lhsOcheckn _lhsOcheckt _lhsOdraw _lhsOname _lhsOpos _lhsOtype_))
sem_CoDiag_CoDiag :: SourcePos ->
                     T_CoDiag_ ->
                     T_CoDiag
sem_CoDiag_CoDiag pos_ d_ =
    (\ _lhsIname
       _lhsIppos
       _lhsIprogram
       _lhsItype_ ->
         (let _lhsOpos :: SourcePos
              _dOpos :: SourcePos
              _dOppos :: SourcePos
              _lhsOcheckn :: (Feedback ())
              _lhsOcheckt :: (Feedback ())
              _lhsOdraw :: Draw
              _lhsOname :: String
              _lhsOtype_ :: Type
              _dOname :: String
              _dOprogram :: (String -> Draw)
              _dOtype_ :: Type
              _dIcheckn :: (Feedback ())
              _dIcheckt :: (Feedback ())
              _dIdraw :: Draw
              _dIname :: String
              _dItype_ :: Type
              _lhsOpos =
                  ({-# LINE 207 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   pos_
                   {-# LINE 259 "src/CCO/Diag/AG.hs" #-}
                   )
              _dOpos =
                  ({-# LINE 208 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   pos_
                   {-# LINE 264 "src/CCO/Diag/AG.hs" #-}
                   )
              _dOppos =
                  ({-# LINE 209 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   _lhsIppos
                   {-# LINE 269 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOcheckn =
                  ({-# LINE 202 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   _dIcheckn
                   {-# LINE 274 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOcheckt =
                  ({-# LINE 201 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   _dIcheckt
                   {-# LINE 279 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOdraw =
                  ({-# LINE 36 "src/CCO/Diag/AG/TDiag2Picture.ag" #-}
                   _dIdraw
                   {-# LINE 284 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOname =
                  ({-# LINE 200 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   _dIname
                   {-# LINE 289 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOtype_ =
                  ({-# LINE 198 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   _dItype_
                   {-# LINE 294 "src/CCO/Diag/AG.hs" #-}
                   )
              _dOname =
                  ({-# LINE 214 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   _lhsIname
                   {-# LINE 299 "src/CCO/Diag/AG.hs" #-}
                   )
              _dOprogram =
                  ({-# LINE 41 "src/CCO/Diag/AG/TDiag2Picture.ag" #-}
                   _lhsIprogram
                   {-# LINE 304 "src/CCO/Diag/AG.hs" #-}
                   )
              _dOtype_ =
                  ({-# LINE 212 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   _lhsItype_
                   {-# LINE 309 "src/CCO/Diag/AG.hs" #-}
                   )
              ( _dIcheckn,_dIcheckt,_dIdraw,_dIname,_dItype_) =
                  d_ _dOname _dOpos _dOppos _dOprogram _dOtype_
          in  ( _lhsOcheckn,_lhsOcheckt,_lhsOdraw,_lhsOname,_lhsOpos,_lhsOtype_)))
-- CoDiag_ -----------------------------------------------------
data CoDiag_ = CoCompiler (Ident) (Ident) (Ident) (Ident) (CoDiag) (CoDiag)
             | CoInterpreter (Ident) (Ident) (Ident) (CoDiag)
             | CoNothing
             | CoPlatform (Ident)
             | CoProgram (Ident) (Ident) (CoDiag)
-- cata
sem_CoDiag_ :: CoDiag_ ->
               T_CoDiag_
sem_CoDiag_ (CoCompiler _c _l1 _l2 _m _d1 _d2) =
    (sem_CoDiag__CoCompiler _c _l1 _l2 _m (sem_CoDiag _d1) (sem_CoDiag _d2))
sem_CoDiag_ (CoInterpreter _i _l _m _d) =
    (sem_CoDiag__CoInterpreter _i _l _m (sem_CoDiag _d))
sem_CoDiag_ (CoNothing) =
    (sem_CoDiag__CoNothing)
sem_CoDiag_ (CoPlatform _m) =
    (sem_CoDiag__CoPlatform _m)
sem_CoDiag_ (CoProgram _p _l _d) =
    (sem_CoDiag__CoProgram _p _l (sem_CoDiag _d))
-- semantic domain
type T_CoDiag_ = String ->
                 SourcePos ->
                 SourcePos ->
                 (String -> Draw) ->
                 Type ->
                 ( (Feedback ()),(Feedback ()),Draw,String,Type)
data Inh_CoDiag_ = Inh_CoDiag_ {name_Inh_CoDiag_ :: String,pos_Inh_CoDiag_ :: SourcePos,ppos_Inh_CoDiag_ :: SourcePos,program_Inh_CoDiag_ :: (String -> Draw),type__Inh_CoDiag_ :: Type}
data Syn_CoDiag_ = Syn_CoDiag_ {checkn_Syn_CoDiag_ :: (Feedback ()),checkt_Syn_CoDiag_ :: (Feedback ()),draw_Syn_CoDiag_ :: Draw,name_Syn_CoDiag_ :: String,type__Syn_CoDiag_ :: Type}
wrap_CoDiag_ :: T_CoDiag_ ->
                Inh_CoDiag_ ->
                Syn_CoDiag_
wrap_CoDiag_ sem (Inh_CoDiag_ _lhsIname _lhsIpos _lhsIppos _lhsIprogram _lhsItype_) =
    (let ( _lhsOcheckn,_lhsOcheckt,_lhsOdraw,_lhsOname,_lhsOtype_) = sem _lhsIname _lhsIpos _lhsIppos _lhsIprogram _lhsItype_
     in  (Syn_CoDiag_ _lhsOcheckn _lhsOcheckt _lhsOdraw _lhsOname _lhsOtype_))
sem_CoDiag__CoCompiler :: Ident ->
                          Ident ->
                          Ident ->
                          Ident ->
                          T_CoDiag ->
                          T_CoDiag ->
                          T_CoDiag_
sem_CoDiag__CoCompiler c_ l1_ l2_ m_ d1_ d2_ =
    (\ _lhsIname
       _lhsIpos
       _lhsIppos
       _lhsIprogram
       _lhsItype_ ->
         (let _d1Oppos :: SourcePos
              _d2Oppos :: SourcePos
              _d1Otype_ :: Type
              _d2Otype_ :: Type
              _d1Oname :: String
              _d2Oname :: String
              _lhsOcheckt :: (Feedback ())
              _lhsOcheckn :: (Feedback ())
              _d1Oprogram :: (String -> Draw)
              _lhsOdraw :: Draw
              _lhsOname :: String
              _lhsOtype_ :: Type
              _d2Oprogram :: (String -> Draw)
              _d1Icheckn :: (Feedback ())
              _d1Icheckt :: (Feedback ())
              _d1Idraw :: Draw
              _d1Iname :: String
              _d1Ipos :: SourcePos
              _d1Itype_ :: Type
              _d2Icheckn :: (Feedback ())
              _d2Icheckt :: (Feedback ())
              _d2Idraw :: Draw
              _d2Iname :: String
              _d2Ipos :: SourcePos
              _d2Itype_ :: Type
              _d1Oppos =
                  ({-# LINE 224 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   _lhsIpos
                   {-# LINE 389 "src/CCO/Diag/AG.hs" #-}
                   )
              _d2Oppos =
                  ({-# LINE 225 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   _lhsIpos
                   {-# LINE 394 "src/CCO/Diag/AG.hs" #-}
                   )
              _type_ =
                  ({-# LINE 233 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   TCompiler
                   {-# LINE 399 "src/CCO/Diag/AG.hs" #-}
                   )
              _d1Otype_ =
                  ({-# LINE 234 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   TCompiler
                   {-# LINE 404 "src/CCO/Diag/AG.hs" #-}
                   )
              _d2Otype_ =
                  ({-# LINE 235 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   TCompiler
                   {-# LINE 409 "src/CCO/Diag/AG.hs" #-}
                   )
              _name =
                  ({-# LINE 244 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   l1_
                   {-# LINE 414 "src/CCO/Diag/AG.hs" #-}
                   )
              _d1Oname =
                  ({-# LINE 245 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   l2_
                   {-# LINE 419 "src/CCO/Diag/AG.hs" #-}
                   )
              _d2Oname =
                  ({-# LINE 246 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   m_
                   {-# LINE 424 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOcheckt =
                  ({-# LINE 256 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   do checkOneOf _lhsItype_ _lhsIppos [TProgram, TCompiler] _lhsIpos
                      _d1Icheckt
                      _d2Icheckt
                   {-# LINE 431 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOcheckn =
                  ({-# LINE 268 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   do checkOneOf _lhsIname _lhsIppos [_name    ] _lhsIpos
                      _d1Icheckn
                      _d2Icheckn
                   {-# LINE 438 "src/CCO/Diag/AG.hs" #-}
                   )
              _d1Oprogram =
                  ({-# LINE 45 "src/CCO/Diag/AG/TDiag2Picture.ag" #-}
                   _lhsIprogram
                   {-# LINE 443 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOdraw =
                  ({-# LINE 64 "src/CCO/Diag/AG/TDiag2Picture.ag" #-}
                   let lhs = drawCompiler c_ l1_ l2_ m_
                       d1  = _d1Idraw
                       d2  = _d2Idraw
                       p   = _lhsIprogram l2_
                       r@(Draw w h d) = mindim lhs $ case _d1Itype_ of
                         TCompiler -> Draw (max (width lhs + width d1) (50 + width d2))
                                           (max (height d1) (height lhs + height d2))
                                           (\x y z -> draw lhs x y $ draw d1 (x + width lhs) y $ draw d2 (x + 50) (y - 30) z)
                         _         -> Draw (max (width lhs + width d1) (50 + width d2))
                                           (max (10 + height d1) (height lhs + height d2))
                                           (\x y z -> draw lhs x y $ draw d1 (x + width lhs) (y - 10) $ draw d2 (x + 50) (y - 30) $ draw p (x + width lhs - 7.5) (y + height p - 10) z)
                   in r
                   {-# LINE 459 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOname =
                  ({-# LINE 215 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   _name
                   {-# LINE 464 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOtype_ =
                  ({-# LINE 213 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   _type_
                   {-# LINE 469 "src/CCO/Diag/AG.hs" #-}
                   )
              _d2Oprogram =
                  ({-# LINE 37 "src/CCO/Diag/AG/TDiag2Picture.ag" #-}
                   _lhsIprogram
                   {-# LINE 474 "src/CCO/Diag/AG.hs" #-}
                   )
              ( _d1Icheckn,_d1Icheckt,_d1Idraw,_d1Iname,_d1Ipos,_d1Itype_) =
                  d1_ _d1Oname _d1Oppos _d1Oprogram _d1Otype_
              ( _d2Icheckn,_d2Icheckt,_d2Idraw,_d2Iname,_d2Ipos,_d2Itype_) =
                  d2_ _d2Oname _d2Oppos _d2Oprogram _d2Otype_
          in  ( _lhsOcheckn,_lhsOcheckt,_lhsOdraw,_lhsOname,_lhsOtype_)))
sem_CoDiag__CoInterpreter :: Ident ->
                             Ident ->
                             Ident ->
                             T_CoDiag ->
                             T_CoDiag_
sem_CoDiag__CoInterpreter i_ l_ m_ d_ =
    (\ _lhsIname
       _lhsIpos
       _lhsIppos
       _lhsIprogram
       _lhsItype_ ->
         (let _dOppos :: SourcePos
              _dOtype_ :: Type
              _dOname :: String
              _lhsOcheckt :: (Feedback ())
              _lhsOcheckn :: (Feedback ())
              _lhsOdraw :: Draw
              _lhsOname :: String
              _lhsOtype_ :: Type
              _dOprogram :: (String -> Draw)
              _dIcheckn :: (Feedback ())
              _dIcheckt :: (Feedback ())
              _dIdraw :: Draw
              _dIname :: String
              _dIpos :: SourcePos
              _dItype_ :: Type
              _dOppos =
                  ({-# LINE 223 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   _lhsIpos
                   {-# LINE 510 "src/CCO/Diag/AG.hs" #-}
                   )
              _type_ =
                  ({-# LINE 231 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   TInterpreter
                   {-# LINE 515 "src/CCO/Diag/AG.hs" #-}
                   )
              _dOtype_ =
                  ({-# LINE 232 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   TInterpreter
                   {-# LINE 520 "src/CCO/Diag/AG.hs" #-}
                   )
              _name =
                  ({-# LINE 242 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   l_
                   {-# LINE 525 "src/CCO/Diag/AG.hs" #-}
                   )
              _dOname =
                  ({-# LINE 243 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   m_
                   {-# LINE 530 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOcheckt =
                  ({-# LINE 254 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   do checkOneOf _lhsItype_ _lhsIppos [TProgram, TInterpreter, TCompiler] _lhsIpos
                      _dIcheckt
                   {-# LINE 536 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOcheckn =
                  ({-# LINE 266 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   do checkOneOf _lhsIname _lhsIppos [_name    ] _lhsIpos
                      _dIcheckn
                   {-# LINE 542 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOdraw =
                  ({-# LINE 58 "src/CCO/Diag/AG/TDiag2Picture.ag" #-}
                   let lhs = drawInterpreter i_ l_ m_
                       d   = _dIdraw
                   in mindim lhs $
                        Draw (width d)
                             (height lhs + height d)
                             (\x y z -> draw lhs x y $ draw d x (y - height lhs) z)
                   {-# LINE 552 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOname =
                  ({-# LINE 215 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   _name
                   {-# LINE 557 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOtype_ =
                  ({-# LINE 213 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   _type_
                   {-# LINE 562 "src/CCO/Diag/AG.hs" #-}
                   )
              _dOprogram =
                  ({-# LINE 37 "src/CCO/Diag/AG/TDiag2Picture.ag" #-}
                   _lhsIprogram
                   {-# LINE 567 "src/CCO/Diag/AG.hs" #-}
                   )
              ( _dIcheckn,_dIcheckt,_dIdraw,_dIname,_dIpos,_dItype_) =
                  d_ _dOname _dOppos _dOprogram _dOtype_
          in  ( _lhsOcheckn,_lhsOcheckt,_lhsOdraw,_lhsOname,_lhsOtype_)))
sem_CoDiag__CoNothing :: T_CoDiag_
sem_CoDiag__CoNothing =
    (\ _lhsIname
       _lhsIpos
       _lhsIppos
       _lhsIprogram
       _lhsItype_ ->
         (let _lhsOcheckt :: (Feedback ())
              _lhsOcheckn :: (Feedback ())
              _lhsOdraw :: Draw
              _lhsOname :: String
              _lhsOtype_ :: Type
              _type_ =
                  ({-# LINE 236 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   TNothing
                   {-# LINE 587 "src/CCO/Diag/AG.hs" #-}
                   )
              _name =
                  ({-# LINE 247 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   ""
                   {-# LINE 592 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOcheckt =
                  ({-# LINE 259 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   return ()
                   {-# LINE 597 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOcheckn =
                  ({-# LINE 271 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   return ()
                   {-# LINE 602 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOdraw =
                  ({-# LINE 76 "src/CCO/Diag/AG/TDiag2Picture.ag" #-}
                   drawNothing
                   {-# LINE 607 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOname =
                  ({-# LINE 215 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   _name
                   {-# LINE 612 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOtype_ =
                  ({-# LINE 213 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   _type_
                   {-# LINE 617 "src/CCO/Diag/AG.hs" #-}
                   )
          in  ( _lhsOcheckn,_lhsOcheckt,_lhsOdraw,_lhsOname,_lhsOtype_)))
sem_CoDiag__CoPlatform :: Ident ->
                          T_CoDiag_
sem_CoDiag__CoPlatform m_ =
    (\ _lhsIname
       _lhsIpos
       _lhsIppos
       _lhsIprogram
       _lhsItype_ ->
         (let _lhsOcheckt :: (Feedback ())
              _lhsOcheckn :: (Feedback ())
              _lhsOdraw :: Draw
              _lhsOname :: String
              _lhsOtype_ :: Type
              _type_ =
                  ({-# LINE 230 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   TPlatform
                   {-# LINE 636 "src/CCO/Diag/AG.hs" #-}
                   )
              _name =
                  ({-# LINE 241 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   m_
                   {-# LINE 641 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOcheckt =
                  ({-# LINE 253 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   do checkOneOf _lhsItype_ _lhsIppos [TProgram, TInterpreter, TCompiler] _lhsIpos
                   {-# LINE 646 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOcheckn =
                  ({-# LINE 265 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   do checkOneOf _lhsIname _lhsIppos [_name    ] _lhsIpos
                   {-# LINE 651 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOdraw =
                  ({-# LINE 57 "src/CCO/Diag/AG/TDiag2Picture.ag" #-}
                   drawPlatform m_
                   {-# LINE 656 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOname =
                  ({-# LINE 215 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   _name
                   {-# LINE 661 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOtype_ =
                  ({-# LINE 213 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   _type_
                   {-# LINE 666 "src/CCO/Diag/AG.hs" #-}
                   )
          in  ( _lhsOcheckn,_lhsOcheckt,_lhsOdraw,_lhsOname,_lhsOtype_)))
sem_CoDiag__CoProgram :: Ident ->
                         Ident ->
                         T_CoDiag ->
                         T_CoDiag_
sem_CoDiag__CoProgram p_ l_ d_ =
    (\ _lhsIname
       _lhsIpos
       _lhsIppos
       _lhsIprogram
       _lhsItype_ ->
         (let _dOppos :: SourcePos
              _dOtype_ :: Type
              _dOname :: String
              _lhsOcheckt :: (Feedback ())
              _lhsOcheckn :: (Feedback ())
              _dOprogram :: (String -> Draw)
              _lhsOdraw :: Draw
              _lhsOname :: String
              _lhsOtype_ :: Type
              _dIcheckn :: (Feedback ())
              _dIcheckt :: (Feedback ())
              _dIdraw :: Draw
              _dIname :: String
              _dIpos :: SourcePos
              _dItype_ :: Type
              _dOppos =
                  ({-# LINE 222 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   _lhsIpos
                   {-# LINE 697 "src/CCO/Diag/AG.hs" #-}
                   )
              _type_ =
                  ({-# LINE 228 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   TProgram
                   {-# LINE 702 "src/CCO/Diag/AG.hs" #-}
                   )
              _dOtype_ =
                  ({-# LINE 229 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   TProgram
                   {-# LINE 707 "src/CCO/Diag/AG.hs" #-}
                   )
              _name =
                  ({-# LINE 239 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   ""
                   {-# LINE 712 "src/CCO/Diag/AG.hs" #-}
                   )
              _dOname =
                  ({-# LINE 240 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   l_
                   {-# LINE 717 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOcheckt =
                  ({-# LINE 251 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   do checkOneOf _lhsItype_ _lhsIppos [TNothing] _lhsIpos
                      _dIcheckt
                   {-# LINE 723 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOcheckn =
                  ({-# LINE 263 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   do checkOneOf _lhsIname _lhsIppos [_name    ] _lhsIpos
                      _dIcheckn
                   {-# LINE 729 "src/CCO/Diag/AG.hs" #-}
                   )
              _dOprogram =
                  ({-# LINE 44 "src/CCO/Diag/AG/TDiag2Picture.ag" #-}
                   drawProgram p_
                   {-# LINE 734 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOdraw =
                  ({-# LINE 48 "src/CCO/Diag/AG/TDiag2Picture.ag" #-}
                   let lhs = drawProgram p_ l_
                       d   = _dIdraw
                   in mindim lhs $ case _dItype_ of
                        TCompiler -> Draw (width d - 57.5)
                                          (height lhs + height d - 10)
                                          (\x y z -> draw lhs x y $ draw d (x + 57.5) (y - height lhs + 10) z)
                        _ ->         Draw (width d + 7.5)
                                          (height lhs + height d)
                                          (\x y z -> draw lhs x y $ draw d (x + 7.5) (y - height lhs) z)
                   {-# LINE 747 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOname =
                  ({-# LINE 215 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   _name
                   {-# LINE 752 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOtype_ =
                  ({-# LINE 213 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   _type_
                   {-# LINE 757 "src/CCO/Diag/AG.hs" #-}
                   )
              ( _dIcheckn,_dIcheckt,_dIdraw,_dIname,_dIpos,_dItype_) =
                  d_ _dOname _dOppos _dOprogram _dOtype_
          in  ( _lhsOcheckn,_lhsOcheckt,_lhsOdraw,_lhsOname,_lhsOtype_)))
-- CoRoot ------------------------------------------------------
data CoRoot = CoRoot (CoDiag)
-- cata
sem_CoRoot :: CoRoot ->
              T_CoRoot
sem_CoRoot (CoRoot _d) =
    (sem_CoRoot_CoRoot (sem_CoDiag _d))
-- semantic domain
type T_CoRoot = ( Picture,(Feedback ()))
data Inh_CoRoot = Inh_CoRoot {}
data Syn_CoRoot = Syn_CoRoot {draw_Syn_CoRoot :: Picture,typecheck_Syn_CoRoot :: (Feedback ())}
wrap_CoRoot :: T_CoRoot ->
               Inh_CoRoot ->
               Syn_CoRoot
wrap_CoRoot sem (Inh_CoRoot) =
    (let ( _lhsOdraw,_lhsOtypecheck) = sem
     in  (Syn_CoRoot _lhsOdraw _lhsOtypecheck))
sem_CoRoot_CoRoot :: T_CoDiag ->
                     T_CoRoot
sem_CoRoot_CoRoot d_ =
    (let _dOtype_ :: Type
         _dOname :: String
         _lhsOtypecheck :: (Feedback ())
         _lhsOdraw :: Picture
         _dOppos :: SourcePos
         _dOprogram :: (String -> Draw)
         _dIcheckn :: (Feedback ())
         _dIcheckt :: (Feedback ())
         _dIdraw :: Draw
         _dIname :: String
         _dIpos :: SourcePos
         _dItype_ :: Type
         _dOtype_ =
             ({-# LINE 83 "src/CCO/Diag/AG/Typecheck.ag" #-}
              TNothing
              {-# LINE 797 "src/CCO/Diag/AG.hs" #-}
              )
         _dOname =
             ({-# LINE 84 "src/CCO/Diag/AG/Typecheck.ag" #-}
              ""
              {-# LINE 802 "src/CCO/Diag/AG.hs" #-}
              )
         _lhsOtypecheck =
             ({-# LINE 85 "src/CCO/Diag/AG/Typecheck.ag" #-}
              do mkFatal _dIcheckt
                 mkFatal _dIcheckn
              {-# LINE 808 "src/CCO/Diag/AG.hs" #-}
              )
         _lhsOdraw =
             ({-# LINE 33 "src/CCO/Diag/AG/TDiag2Picture.ag" #-}
              let d = _dIdraw in Picture (width d, height d) (draw d 0 (height d) [])
              {-# LINE 813 "src/CCO/Diag/AG.hs" #-}
              )
         _dOppos =
             ({-# LINE 204 "src/CCO/Diag/AG/Typecheck.ag" #-}
              error "missing rule: CoRoot.CoRoot.d.ppos"
              {-# LINE 818 "src/CCO/Diag/AG.hs" #-}
              )
         _dOprogram =
             ({-# LINE 37 "src/CCO/Diag/AG/TDiag2Picture.ag" #-}
              error "missing rule: CoRoot.CoRoot.d.program"
              {-# LINE 823 "src/CCO/Diag/AG.hs" #-}
              )
         ( _dIcheckn,_dIcheckt,_dIdraw,_dIname,_dIpos,_dItype_) =
             d_ _dOname _dOppos _dOprogram _dOtype_
     in  ( _lhsOdraw,_lhsOtypecheck))
-- Diag --------------------------------------------------------
data Diag = Diag (SourcePos) (Diag_)
-- cata
sem_Diag :: Diag ->
            T_Diag
sem_Diag (Diag _pos _d) =
    (sem_Diag_Diag _pos (sem_Diag_ _d))
-- semantic domain
type T_Diag = ([CoDiag]) ->
              (Feedback (Map String Diag)) ->
              ( ([CoDiag]),(Feedback ()),Bool,Bool,(Feedback Diag),Int,SourcePos)
data Inh_Diag = Inh_Diag {cd_Inh_Diag :: ([CoDiag]),variables_Inh_Diag :: (Feedback (Map String Diag))}
data Syn_Diag = Syn_Diag {cd_Syn_Diag :: ([CoDiag]),check_Syn_Diag :: (Feedback ()),compiler_Syn_Diag :: Bool,executer_Syn_Diag :: Bool,letless_Syn_Diag :: (Feedback Diag),outputs_Syn_Diag :: Int,pos_Syn_Diag :: SourcePos}
wrap_Diag :: T_Diag ->
             Inh_Diag ->
             Syn_Diag
wrap_Diag sem (Inh_Diag _lhsIcd _lhsIvariables) =
    (let ( _lhsOcd,_lhsOcheck,_lhsOcompiler,_lhsOexecuter,_lhsOletless,_lhsOoutputs,_lhsOpos) = sem _lhsIcd _lhsIvariables
     in  (Syn_Diag _lhsOcd _lhsOcheck _lhsOcompiler _lhsOexecuter _lhsOletless _lhsOoutputs _lhsOpos))
sem_Diag_Diag :: SourcePos ->
                 T_Diag_ ->
                 T_Diag
sem_Diag_Diag pos_ d_ =
    (\ _lhsIcd
       _lhsIvariables ->
         (let _dOpos :: SourcePos
              _lhsOpos :: SourcePos
              _lhsOcd :: ([CoDiag])
              _lhsOcheck :: (Feedback ())
              _lhsOcompiler :: Bool
              _lhsOexecuter :: Bool
              _lhsOletless :: (Feedback Diag)
              _lhsOoutputs :: Int
              _dOcd :: ([CoDiag])
              _dOvariables :: (Feedback (Map String Diag))
              _dIcd :: ([CoDiag])
              _dIcheck :: (Feedback ())
              _dIcompiler :: Bool
              _dIexecuter :: Bool
              _dIletless :: (Feedback Diag)
              _dIoutputs :: Int
              _dOpos =
                  ({-# LINE 107 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   pos_
                   {-# LINE 872 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOpos =
                  ({-# LINE 108 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   pos_
                   {-# LINE 877 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOcd =
                  ({-# LINE 102 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   _dIcd
                   {-# LINE 882 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOcheck =
                  ({-# LINE 99 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   _dIcheck
                   {-# LINE 887 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOcompiler =
                  ({-# LINE 95 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   _dIcompiler
                   {-# LINE 892 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOexecuter =
                  ({-# LINE 96 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   _dIexecuter
                   {-# LINE 897 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOletless =
                  ({-# LINE 92 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   _dIletless
                   {-# LINE 902 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOoutputs =
                  ({-# LINE 104 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   _dIoutputs
                   {-# LINE 907 "src/CCO/Diag/AG.hs" #-}
                   )
              _dOcd =
                  ({-# LINE 117 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   _lhsIcd
                   {-# LINE 912 "src/CCO/Diag/AG.hs" #-}
                   )
              _dOvariables =
                  ({-# LINE 111 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   _lhsIvariables
                   {-# LINE 917 "src/CCO/Diag/AG.hs" #-}
                   )
              ( _dIcd,_dIcheck,_dIcompiler,_dIexecuter,_dIletless,_dIoutputs) =
                  d_ _dOcd _dOpos _dOvariables
          in  ( _lhsOcd,_lhsOcheck,_lhsOcompiler,_lhsOexecuter,_lhsOletless,_lhsOoutputs,_lhsOpos)))
-- Diag_ -------------------------------------------------------
data Diag_ = Compile (Diag) (Diag)
           | Compiler (Ident) (Ident) (Ident) (Ident)
           | Execute (Diag) (Diag)
           | Interpreter (Ident) (Ident) (Ident)
           | Let (Ident) (Diag) (Diag)
           | Platform (Ident)
           | Program (Ident) (Ident)
           | Use (Ident)
-- cata
sem_Diag_ :: Diag_ ->
             T_Diag_
sem_Diag_ (Compile _d1 _d2) =
    (sem_Diag__Compile (sem_Diag _d1) (sem_Diag _d2))
sem_Diag_ (Compiler _c _l1 _l2 _m) =
    (sem_Diag__Compiler _c _l1 _l2 _m)
sem_Diag_ (Execute _d1 _d2) =
    (sem_Diag__Execute (sem_Diag _d1) (sem_Diag _d2))
sem_Diag_ (Interpreter _i _l _m) =
    (sem_Diag__Interpreter _i _l _m)
sem_Diag_ (Let _v _d1 _d2) =
    (sem_Diag__Let _v (sem_Diag _d1) (sem_Diag _d2))
sem_Diag_ (Platform _m) =
    (sem_Diag__Platform _m)
sem_Diag_ (Program _p _l) =
    (sem_Diag__Program _p _l)
sem_Diag_ (Use _v) =
    (sem_Diag__Use _v)
-- semantic domain
type T_Diag_ = ([CoDiag]) ->
               SourcePos ->
               (Feedback (Map String Diag)) ->
               ( ([CoDiag]),(Feedback ()),Bool,Bool,(Feedback Diag),Int)
data Inh_Diag_ = Inh_Diag_ {cd_Inh_Diag_ :: ([CoDiag]),pos_Inh_Diag_ :: SourcePos,variables_Inh_Diag_ :: (Feedback (Map String Diag))}
data Syn_Diag_ = Syn_Diag_ {cd_Syn_Diag_ :: ([CoDiag]),check_Syn_Diag_ :: (Feedback ()),compiler_Syn_Diag_ :: Bool,executer_Syn_Diag_ :: Bool,letless_Syn_Diag_ :: (Feedback Diag),outputs_Syn_Diag_ :: Int}
wrap_Diag_ :: T_Diag_ ->
              Inh_Diag_ ->
              Syn_Diag_
wrap_Diag_ sem (Inh_Diag_ _lhsIcd _lhsIpos _lhsIvariables) =
    (let ( _lhsOcd,_lhsOcheck,_lhsOcompiler,_lhsOexecuter,_lhsOletless,_lhsOoutputs) = sem _lhsIcd _lhsIpos _lhsIvariables
     in  (Syn_Diag_ _lhsOcd _lhsOcheck _lhsOcompiler _lhsOexecuter _lhsOletless _lhsOoutputs))
sem_Diag__Compile :: T_Diag ->
                     T_Diag ->
                     T_Diag_
sem_Diag__Compile d1_ d2_ =
    (\ _lhsIcd
       _lhsIpos
       _lhsIvariables ->
         (let _lhsOletless :: (Feedback Diag)
              _lhsOcompiler :: Bool
              _lhsOexecuter :: Bool
              _lhsOcheck :: (Feedback ())
              _d2Ocd :: ([CoDiag])
              _d1Ocd :: ([CoDiag])
              _lhsOcd :: ([CoDiag])
              _lhsOoutputs :: Int
              _d1Ovariables :: (Feedback (Map String Diag))
              _d2Ovariables :: (Feedback (Map String Diag))
              _d1Icd :: ([CoDiag])
              _d1Icheck :: (Feedback ())
              _d1Icompiler :: Bool
              _d1Iexecuter :: Bool
              _d1Iletless :: (Feedback Diag)
              _d1Ioutputs :: Int
              _d1Ipos :: SourcePos
              _d2Icd :: ([CoDiag])
              _d2Icheck :: (Feedback ())
              _d2Icompiler :: Bool
              _d2Iexecuter :: Bool
              _d2Iletless :: (Feedback Diag)
              _d2Ioutputs :: Int
              _d2Ipos :: SourcePos
              _lhsOletless =
                  ({-# LINE 129 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   do d1 <- _d1Iletless
                      d2 <- _d2Iletless
                      return $ Diag _lhsIpos $ Compile d1 d2
                   {-# LINE 999 "src/CCO/Diag/AG.hs" #-}
                   )
              _outputs =
                  ({-# LINE 147 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   _d1Ioutputs + _d2Ioutputs - 1
                   {-# LINE 1004 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOcompiler =
                  ({-# LINE 163 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   _d1Icompiler
                   {-# LINE 1009 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOexecuter =
                  ({-# LINE 164 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   _d1Iexecuter
                   {-# LINE 1014 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOcheck =
                  ({-# LINE 178 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   do unless _d2Icompiler (error_ $ printf "(%s) a compiler is required" (show' _d2Ipos))
                      _d1Icheck
                      _d2Icheck
                   {-# LINE 1021 "src/CCO/Diag/AG.hs" #-}
                   )
              _d2Ocd =
                  ({-# LINE 192 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   _lhsIcd
                   {-# LINE 1026 "src/CCO/Diag/AG.hs" #-}
                   )
              _d1Ocd =
                  ({-# LINE 193 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   _d2Icd
                   {-# LINE 1031 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOcd =
                  ({-# LINE 194 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   _d1Icd
                   {-# LINE 1036 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOoutputs =
                  ({-# LINE 119 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   _outputs
                   {-# LINE 1041 "src/CCO/Diag/AG.hs" #-}
                   )
              _d1Ovariables =
                  ({-# LINE 90 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   _lhsIvariables
                   {-# LINE 1046 "src/CCO/Diag/AG.hs" #-}
                   )
              _d2Ovariables =
                  ({-# LINE 90 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   _lhsIvariables
                   {-# LINE 1051 "src/CCO/Diag/AG.hs" #-}
                   )
              ( _d1Icd,_d1Icheck,_d1Icompiler,_d1Iexecuter,_d1Iletless,_d1Ioutputs,_d1Ipos) =
                  d1_ _d1Ocd _d1Ovariables
              ( _d2Icd,_d2Icheck,_d2Icompiler,_d2Iexecuter,_d2Iletless,_d2Ioutputs,_d2Ipos) =
                  d2_ _d2Ocd _d2Ovariables
          in  ( _lhsOcd,_lhsOcheck,_lhsOcompiler,_lhsOexecuter,_lhsOletless,_lhsOoutputs)))
sem_Diag__Compiler :: Ident ->
                      Ident ->
                      Ident ->
                      Ident ->
                      T_Diag_
sem_Diag__Compiler c_ l1_ l2_ m_ =
    (\ _lhsIcd
       _lhsIpos
       _lhsIvariables ->
         (let _lhsOletless :: (Feedback Diag)
              _lhsOcompiler :: Bool
              _lhsOexecuter :: Bool
              _lhsOcheck :: (Feedback ())
              _lhsOcd :: ([CoDiag])
              _lhsOoutputs :: Int
              _lhsOletless =
                  ({-# LINE 125 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   return $ Diag _lhsIpos $ Compiler c_ l1_ l2_ m_
                   {-# LINE 1076 "src/CCO/Diag/AG.hs" #-}
                   )
              _outputs =
                  ({-# LINE 145 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   2
                   {-# LINE 1081 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOcompiler =
                  ({-# LINE 159 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   True
                   {-# LINE 1086 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOexecuter =
                  ({-# LINE 160 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   False
                   {-# LINE 1091 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOcheck =
                  ({-# LINE 174 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   return ()
                   {-# LINE 1096 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOcd =
                  ({-# LINE 188 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   (\(h1:h2:s) -> (CoDiag _lhsIpos $ CoCompiler c_ l1_ l2_ m_ h1 h2) : s) _lhsIcd
                   {-# LINE 1101 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOoutputs =
                  ({-# LINE 119 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   _outputs
                   {-# LINE 1106 "src/CCO/Diag/AG.hs" #-}
                   )
          in  ( _lhsOcd,_lhsOcheck,_lhsOcompiler,_lhsOexecuter,_lhsOletless,_lhsOoutputs)))
sem_Diag__Execute :: T_Diag ->
                     T_Diag ->
                     T_Diag_
sem_Diag__Execute d1_ d2_ =
    (\ _lhsIcd
       _lhsIpos
       _lhsIvariables ->
         (let _lhsOletless :: (Feedback Diag)
              _lhsOcompiler :: Bool
              _lhsOexecuter :: Bool
              _lhsOcheck :: (Feedback ())
              _d2Ocd :: ([CoDiag])
              _d1Ocd :: ([CoDiag])
              _lhsOcd :: ([CoDiag])
              _lhsOoutputs :: Int
              _d1Ovariables :: (Feedback (Map String Diag))
              _d2Ovariables :: (Feedback (Map String Diag))
              _d1Icd :: ([CoDiag])
              _d1Icheck :: (Feedback ())
              _d1Icompiler :: Bool
              _d1Iexecuter :: Bool
              _d1Iletless :: (Feedback Diag)
              _d1Ioutputs :: Int
              _d1Ipos :: SourcePos
              _d2Icd :: ([CoDiag])
              _d2Icheck :: (Feedback ())
              _d2Icompiler :: Bool
              _d2Iexecuter :: Bool
              _d2Iletless :: (Feedback Diag)
              _d2Ioutputs :: Int
              _d2Ipos :: SourcePos
              _lhsOletless =
                  ({-# LINE 126 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   do d1 <- _d1Iletless
                      d2 <- _d2Iletless
                      return $ Diag _lhsIpos $ Execute d1 d2
                   {-# LINE 1145 "src/CCO/Diag/AG.hs" #-}
                   )
              _outputs =
                  ({-# LINE 146 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   _d1Ioutputs + _d2Ioutputs - 1
                   {-# LINE 1150 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOcompiler =
                  ({-# LINE 161 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   _d1Icompiler
                   {-# LINE 1155 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOexecuter =
                  ({-# LINE 162 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   _d1Iexecuter
                   {-# LINE 1160 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOcheck =
                  ({-# LINE 175 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   do unless _d2Iexecuter (error_ $ printf "(%s) an interpreter or platform is required" (show' _d2Ipos))
                      _d1Icheck
                      _d2Icheck
                   {-# LINE 1167 "src/CCO/Diag/AG.hs" #-}
                   )
              _d2Ocd =
                  ({-# LINE 189 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   _lhsIcd
                   {-# LINE 1172 "src/CCO/Diag/AG.hs" #-}
                   )
              _d1Ocd =
                  ({-# LINE 190 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   _d2Icd
                   {-# LINE 1177 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOcd =
                  ({-# LINE 191 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   _d1Icd
                   {-# LINE 1182 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOoutputs =
                  ({-# LINE 119 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   _outputs
                   {-# LINE 1187 "src/CCO/Diag/AG.hs" #-}
                   )
              _d1Ovariables =
                  ({-# LINE 90 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   _lhsIvariables
                   {-# LINE 1192 "src/CCO/Diag/AG.hs" #-}
                   )
              _d2Ovariables =
                  ({-# LINE 90 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   _lhsIvariables
                   {-# LINE 1197 "src/CCO/Diag/AG.hs" #-}
                   )
              ( _d1Icd,_d1Icheck,_d1Icompiler,_d1Iexecuter,_d1Iletless,_d1Ioutputs,_d1Ipos) =
                  d1_ _d1Ocd _d1Ovariables
              ( _d2Icd,_d2Icheck,_d2Icompiler,_d2Iexecuter,_d2Iletless,_d2Ioutputs,_d2Ipos) =
                  d2_ _d2Ocd _d2Ovariables
          in  ( _lhsOcd,_lhsOcheck,_lhsOcompiler,_lhsOexecuter,_lhsOletless,_lhsOoutputs)))
sem_Diag__Interpreter :: Ident ->
                         Ident ->
                         Ident ->
                         T_Diag_
sem_Diag__Interpreter i_ l_ m_ =
    (\ _lhsIcd
       _lhsIpos
       _lhsIvariables ->
         (let _lhsOletless :: (Feedback Diag)
              _lhsOcompiler :: Bool
              _lhsOexecuter :: Bool
              _lhsOcheck :: (Feedback ())
              _lhsOcd :: ([CoDiag])
              _lhsOoutputs :: Int
              _lhsOletless =
                  ({-# LINE 124 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   return $ Diag _lhsIpos $ Interpreter i_ l_ m_
                   {-# LINE 1221 "src/CCO/Diag/AG.hs" #-}
                   )
              _outputs =
                  ({-# LINE 144 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   1
                   {-# LINE 1226 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOcompiler =
                  ({-# LINE 157 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   False
                   {-# LINE 1231 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOexecuter =
                  ({-# LINE 158 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   True
                   {-# LINE 1236 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOcheck =
                  ({-# LINE 173 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   return ()
                   {-# LINE 1241 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOcd =
                  ({-# LINE 187 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   (\(h:s) -> (CoDiag _lhsIpos $ CoInterpreter i_ l_ m_ h) : s) _lhsIcd
                   {-# LINE 1246 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOoutputs =
                  ({-# LINE 119 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   _outputs
                   {-# LINE 1251 "src/CCO/Diag/AG.hs" #-}
                   )
          in  ( _lhsOcd,_lhsOcheck,_lhsOcompiler,_lhsOexecuter,_lhsOletless,_lhsOoutputs)))
sem_Diag__Let :: Ident ->
                 T_Diag ->
                 T_Diag ->
                 T_Diag_
sem_Diag__Let v_ d1_ d2_ =
    (\ _lhsIcd
       _lhsIpos
       _lhsIvariables ->
         (let _d2Ovariables :: (Feedback (Map String Diag))
              _lhsOletless :: (Feedback Diag)
              _lhsOexecuter :: Bool
              _lhsOcompiler :: Bool
              _lhsOcheck :: (Feedback ())
              _lhsOcd :: ([CoDiag])
              _lhsOoutputs :: Int
              _d1Ocd :: ([CoDiag])
              _d1Ovariables :: (Feedback (Map String Diag))
              _d2Ocd :: ([CoDiag])
              _d1Icd :: ([CoDiag])
              _d1Icheck :: (Feedback ())
              _d1Icompiler :: Bool
              _d1Iexecuter :: Bool
              _d1Iletless :: (Feedback Diag)
              _d1Ioutputs :: Int
              _d1Ipos :: SourcePos
              _d2Icd :: ([CoDiag])
              _d2Icheck :: (Feedback ())
              _d2Icompiler :: Bool
              _d2Iexecuter :: Bool
              _d2Iletless :: (Feedback Diag)
              _d2Ioutputs :: Int
              _d2Ipos :: SourcePos
              _d2Ovariables =
                  ({-# LINE 132 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   do d1 <- _d1Iletless
                      variables <- _lhsIvariables
                      return $ M.insert (lowercase v_) d1 variables
                   {-# LINE 1291 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOletless =
                  ({-# LINE 135 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   _d2Iletless
                   {-# LINE 1296 "src/CCO/Diag/AG.hs" #-}
                   )
              _outputs =
                  ({-# LINE 148 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   error "Let bindings may not occur in this step."
                   {-# LINE 1301 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOexecuter =
                  ({-# LINE 165 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   error "Let bindings may not occur in this step."
                   {-# LINE 1306 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOcompiler =
                  ({-# LINE 166 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   error "Let bindings may not occur in this step."
                   {-# LINE 1311 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOcheck =
                  ({-# LINE 181 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   error_ $ "Let bindings may not occur in check step."
                   {-# LINE 1316 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOcd =
                  ({-# LINE 118 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   _d2Icd
                   {-# LINE 1321 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOoutputs =
                  ({-# LINE 119 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   _outputs
                   {-# LINE 1326 "src/CCO/Diag/AG.hs" #-}
                   )
              _d1Ocd =
                  ({-# LINE 101 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   _lhsIcd
                   {-# LINE 1331 "src/CCO/Diag/AG.hs" #-}
                   )
              _d1Ovariables =
                  ({-# LINE 90 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   _lhsIvariables
                   {-# LINE 1336 "src/CCO/Diag/AG.hs" #-}
                   )
              _d2Ocd =
                  ({-# LINE 101 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   _d1Icd
                   {-# LINE 1341 "src/CCO/Diag/AG.hs" #-}
                   )
              ( _d1Icd,_d1Icheck,_d1Icompiler,_d1Iexecuter,_d1Iletless,_d1Ioutputs,_d1Ipos) =
                  d1_ _d1Ocd _d1Ovariables
              ( _d2Icd,_d2Icheck,_d2Icompiler,_d2Iexecuter,_d2Iletless,_d2Ioutputs,_d2Ipos) =
                  d2_ _d2Ocd _d2Ovariables
          in  ( _lhsOcd,_lhsOcheck,_lhsOcompiler,_lhsOexecuter,_lhsOletless,_lhsOoutputs)))
sem_Diag__Platform :: Ident ->
                      T_Diag_
sem_Diag__Platform m_ =
    (\ _lhsIcd
       _lhsIpos
       _lhsIvariables ->
         (let _lhsOletless :: (Feedback Diag)
              _lhsOcompiler :: Bool
              _lhsOexecuter :: Bool
              _lhsOcheck :: (Feedback ())
              _lhsOcd :: ([CoDiag])
              _lhsOoutputs :: Int
              _lhsOletless =
                  ({-# LINE 123 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   return $ Diag _lhsIpos $ Platform m_
                   {-# LINE 1363 "src/CCO/Diag/AG.hs" #-}
                   )
              _outputs =
                  ({-# LINE 143 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   0
                   {-# LINE 1368 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOcompiler =
                  ({-# LINE 155 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   False
                   {-# LINE 1373 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOexecuter =
                  ({-# LINE 156 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   True
                   {-# LINE 1378 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOcheck =
                  ({-# LINE 172 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   return ()
                   {-# LINE 1383 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOcd =
                  ({-# LINE 186 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   (CoDiag _lhsIpos $ CoPlatform m_) : _lhsIcd
                   {-# LINE 1388 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOoutputs =
                  ({-# LINE 119 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   _outputs
                   {-# LINE 1393 "src/CCO/Diag/AG.hs" #-}
                   )
          in  ( _lhsOcd,_lhsOcheck,_lhsOcompiler,_lhsOexecuter,_lhsOletless,_lhsOoutputs)))
sem_Diag__Program :: Ident ->
                     Ident ->
                     T_Diag_
sem_Diag__Program p_ l_ =
    (\ _lhsIcd
       _lhsIpos
       _lhsIvariables ->
         (let _lhsOletless :: (Feedback Diag)
              _lhsOcompiler :: Bool
              _lhsOexecuter :: Bool
              _lhsOcheck :: (Feedback ())
              _lhsOcd :: ([CoDiag])
              _lhsOoutputs :: Int
              _lhsOletless =
                  ({-# LINE 122 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   return $ Diag _lhsIpos $ Program p_ l_
                   {-# LINE 1412 "src/CCO/Diag/AG.hs" #-}
                   )
              _outputs =
                  ({-# LINE 142 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   1
                   {-# LINE 1417 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOcompiler =
                  ({-# LINE 153 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   False
                   {-# LINE 1422 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOexecuter =
                  ({-# LINE 154 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   False
                   {-# LINE 1427 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOcheck =
                  ({-# LINE 171 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   return ()
                   {-# LINE 1432 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOcd =
                  ({-# LINE 185 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   (\(h:s) -> (CoDiag _lhsIpos $ CoProgram p_ l_ h) : s) _lhsIcd
                   {-# LINE 1437 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOoutputs =
                  ({-# LINE 119 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   _outputs
                   {-# LINE 1442 "src/CCO/Diag/AG.hs" #-}
                   )
          in  ( _lhsOcd,_lhsOcheck,_lhsOcompiler,_lhsOexecuter,_lhsOletless,_lhsOoutputs)))
sem_Diag__Use :: Ident ->
                 T_Diag_
sem_Diag__Use v_ =
    (\ _lhsIcd
       _lhsIpos
       _lhsIvariables ->
         (let _lhsOletless :: (Feedback Diag)
              _lhsOexecuter :: Bool
              _lhsOcompiler :: Bool
              _lhsOcheck :: (Feedback ())
              _lhsOcd :: ([CoDiag])
              _lhsOoutputs :: Int
              _lhsOletless =
                  ({-# LINE 136 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   do variables <- _lhsIvariables
                      case M.lookup (lowercase v_) variables of
                        Nothing -> fatal_ $ printf "(%s) variable '%s' does not exist." (show _lhsIpos) v_
                        Just a -> return a
                   {-# LINE 1463 "src/CCO/Diag/AG.hs" #-}
                   )
              _outputs =
                  ({-# LINE 149 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   error "Variables may not occur in this step."
                   {-# LINE 1468 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOexecuter =
                  ({-# LINE 167 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   error "Variables may not occur in this step."
                   {-# LINE 1473 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOcompiler =
                  ({-# LINE 168 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   error "Variables may not occur in this step."
                   {-# LINE 1478 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOcheck =
                  ({-# LINE 182 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   error_ $ "Variables may not occur in check step."
                   {-# LINE 1483 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOcd =
                  ({-# LINE 118 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   _lhsIcd
                   {-# LINE 1488 "src/CCO/Diag/AG.hs" #-}
                   )
              _lhsOoutputs =
                  ({-# LINE 119 "src/CCO/Diag/AG/Typecheck.ag" #-}
                   _outputs
                   {-# LINE 1493 "src/CCO/Diag/AG.hs" #-}
                   )
          in  ( _lhsOcd,_lhsOcheck,_lhsOcompiler,_lhsOexecuter,_lhsOletless,_lhsOoutputs)))
-- Root --------------------------------------------------------
data Root = Root (Diag)
-- cata
sem_Root :: Root ->
            T_Root
sem_Root (Root _d) =
    (sem_Root_Root (sem_Diag _d))
-- semantic domain
type T_Root = ( (Feedback CoDiag),([CoDiag]),(Feedback ()),Int)
data Inh_Root = Inh_Root {}
data Syn_Root = Syn_Root {check_Syn_Root :: (Feedback CoDiag),rcd_Syn_Root :: ([CoDiag]),rcheck_Syn_Root :: (Feedback ()),routputs_Syn_Root :: Int}
wrap_Root :: T_Root ->
             Inh_Root ->
             Syn_Root
wrap_Root sem (Inh_Root) =
    (let ( _lhsOcheck,_lhsOrcd,_lhsOrcheck,_lhsOroutputs) = sem
     in  (Syn_Root _lhsOcheck _lhsOrcd _lhsOrcheck _lhsOroutputs))
sem_Root_Root :: T_Diag ->
                 T_Root
sem_Root_Root d_ =
    (let _dOvariables :: (Feedback (Map String Diag))
         _dOcd :: ([CoDiag])
         _lhsOrcheck :: (Feedback ())
         _lhsOrcd :: ([CoDiag])
         _lhsOroutputs :: Int
         _lhsOcheck :: (Feedback CoDiag)
         _dIcd :: ([CoDiag])
         _dIcheck :: (Feedback ())
         _dIcompiler :: Bool
         _dIexecuter :: Bool
         _dIletless :: (Feedback Diag)
         _dIoutputs :: Int
         _dIpos :: SourcePos
         _dOvariables =
             ({-# LINE 66 "src/CCO/Diag/AG/Typecheck.ag" #-}
              return $ M.empty
              {-# LINE 1532 "src/CCO/Diag/AG.hs" #-}
              )
         _dOcd =
             ({-# LINE 67 "src/CCO/Diag/AG/Typecheck.ag" #-}
              repeat $ CoDiag (SourcePos Stdin EOF) CoNothing
              {-# LINE 1537 "src/CCO/Diag/AG.hs" #-}
              )
         _lhsOrcheck =
             ({-# LINE 68 "src/CCO/Diag/AG/Typecheck.ag" #-}
              mkFatal _dIcheck
              {-# LINE 1542 "src/CCO/Diag/AG.hs" #-}
              )
         _lhsOrcd =
             ({-# LINE 69 "src/CCO/Diag/AG/Typecheck.ag" #-}
              _dIcd
              {-# LINE 1547 "src/CCO/Diag/AG.hs" #-}
              )
         _lhsOroutputs =
             ({-# LINE 70 "src/CCO/Diag/AG/Typecheck.ag" #-}
              _dIoutputs
              {-# LINE 1552 "src/CCO/Diag/AG.hs" #-}
              )
         _lhsOcheck =
             ({-# LINE 71 "src/CCO/Diag/AG/Typecheck.ag" #-}
              do r <- fmap wrapDiag _dIletless
                 rcheck_Syn_Root r
                 when (routputs_Syn_Root r < 0) (fatal_ $ "Too much outputs specified")
                 when (routputs_Syn_Root r > 0) (warning_ $ "Not all outputs are being used")
                 let cd = head $ rcd_Syn_Root r
                 typecheck_Syn_CoRoot $ wrapCoDiag cd
                 return cd
              {-# LINE 1563 "src/CCO/Diag/AG.hs" #-}
              )
         ( _dIcd,_dIcheck,_dIcompiler,_dIexecuter,_dIletless,_dIoutputs,_dIpos) =
             d_ _dOcd _dOvariables
     in  ( _lhsOcheck,_lhsOrcd,_lhsOrcheck,_lhsOroutputs))