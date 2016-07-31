

-- UUAGC 0.9.40.2 (CodeGeneration.ag)
module CCO.Imp.AG where

{-# LINE 4 "CodeGeneration.ag" #-}

import CCO.Ssm hiding (Add, Sub, Mul, Div, Eq, Lt, Gt)
import Prelude hiding (div)
import Data.List (intersperse,nub,elemIndex,(\\),sortBy,sort)
import Data.Maybe (fromJust)
{-# LINE 13 "../AG.hs" #-}
{-# LINE 53 "CodeGeneration.ag" #-}

type CachedVar = (Ident,Int)
{-# LINE 17 "../AG.hs" #-}

{-# LINE 60 "CodeGeneration.ag" #-}

-- |For each variable, generate a tuple of the variable name and its depth relative to the function definition.
generateCachedvars :: [Ident] -> Syms -> [CachedVar]
generateCachedvars vars s = map (\x -> (x,getDepth x s)) vars

-- |Given a variable and a symbol table, get the depth of the variable relative to the function definition.
-- |Local variable = 0, variable one scope higher = 1, etc.
getDepth :: Ident -> Syms -> Int
getDepth v [] = 0
getDepth v (x:xs) = case lookup v (vars x) of
    Nothing -> 1 + getDepth v xs
    Just x  -> 0
    
-- |Sort a list of 'CachedVar's by depth. 
sortBySnd :: [CachedVar] -> [CachedVar]
sortBySnd = sortBy (\x y -> compare (snd x) (snd y))
{-# LINE 36 "../AG.hs" #-}

{-# LINE 123 "CodeGeneration.ag" #-}

-- | An environment maps identifiers to symbol descriptors.
type Env = [(Ident, Sym)]

-- | A symbol descriptor either describes a variable or a function symbol.
-- For a variable, we store its offset relative to the mark pointer; for
-- a function we store its begin label.
data Sym = V Int | F Int

-- | Restrict environments to a particular type of descriptor.
vars   env = [entry | entry@(_, V _     ) <- env            ]
funs   env = [entry | entry@(_, F _     ) <- env            ]
params env = [entry | entry@(_, V offset) <- env, offset < 0]
{-# LINE 52 "../AG.hs" #-}

{-# LINE 165 "CodeGeneration.ag" #-}

-- | A symbol table contains descriptors for each variable that is in scope at
-- a certain program point.
-- The table consists of levels of 'Env's reflecting the nesting of functions:
-- * The head of the list of 'Env's corresponds to the innermost function scope
--   and so it contains the descriptors of the symbols that are allocated
--   relative to the current mark pointer.
-- * To access the symbols described in the tail of the list, static links are
--   to be followed.
type Syms = [Env]
{-# LINE 65 "../AG.hs" #-}

{-# LINE 279 "CodeGeneration.ag" #-}

-- |Returns true if the depth of a variable is higher than 1.
isGlobalVar :: Syms -> CachedVar -> Bool
isGlobalVar xs v = let depth = snd v
                   in if depth == 0 || depth == 1 then False else True
    
-- |Removes any 'Cachedvar' whose depth is lower than 2.
removeLocals :: [CachedVar] -> Syms -> [CachedVar]
removeLocals vars envs = filter (isGlobalVar envs) vars

-- |Fetches a positive offset to the MP to where an address can be cached. 
getPos :: (Eq a) => Int -> a -> [a] -> Int
getPos n v vars = n + 1 + (fromJust $ v `elemIndex` vars)

-- |Thins out a 'CachedVar' list so that each level only has a single representative variable.
-- |[("x",2),("y",2),("count",3)] -> [("y",2),("count",3)] 
removeDoubleLevels :: [CachedVar] -> [CachedVar]
removeDoubleLevels xs = nos' xs []
 where
   nos' [] ys = sort ys
   nos' (x@(v,n):xs) ys = nos' xs (if elem n (map snd ys) then ys else x:ys)

-- |Caches static links.
cache :: Int -> [CachedVar] -> Syms -> CodeS
cache n vars envs = let globals = removeDoubleLevels $ removeLocals vars envs
                    in foldr (.) id $ map (\v -> cacheAddress n v globals envs) globals
      
-- |Given a 'CachedVar', create some code that caches the static link      
cacheAddress :: Int -> CachedVar -> [CachedVar] -> Syms -> CodeS
cacheAddress lv (v,n) levels envs = let position = getPos lv v (map fst levels)
                                    in ldc position . getStaticLink v envs . stl position . annote SP 0 0 "green" ("cache lvl " ++ show n)

-- |Fetches a static link.
getStaticLink :: Ident -> Syms -> CodeS
getStaticLink v (local:global) = case lookup v (vars local) of
    Nothing -> ldl (- 2) . getStaticLink' v global
    Just (V offset) -> id
    
-- |Fetches a static link.
getStaticLink' :: Ident -> Syms -> CodeS
getStaticLink' v []           = error ("unknown variable: " ++ v)
getStaticLink' v (e:ev) = case lookup v (vars e) of
  Nothing         -> lda (- 2) . getStaticLink' v ev
  Just (V offset) -> id

-- | Produces code for annotating parameters.
enterparams :: Env -> CodeS
enterparams env = foldr (.) id [annote MP off off "green" (x ++ " (param)") | (x, V off) <- env]

-- | Produces code for entering a block.
enter :: Env -> CodeS
enter env = foldr (.) id [ldc 0 . annote SP 0 0 "green" (x ++ " (var)") | (x, V _) <- env]

-- | Produces code for exiting a block.
exit :: Env -> CodeS
exit env = ajs (- length (vars env))

-- | Produces code for retrieving the value of a variable.
get :: Ident -> Syms -> CodeS
get x (local : global) = case lookup x (vars local) of
  Nothing         -> ldl (- 2) . getGlobal x global
  Just (V offset) -> ldl offset

-- | Produces code for retrieving the value of a variable.
get' :: Int -> Ident -> Syms -> [CachedVar] -> CodeS
get' n x envs@(local : global) inCache = if (elem x (map fst inCache)) 
   then ldl (getOffset n x inCache) .
        getGlobal' x envs
   else get x envs
   
-- |Given a variable, fetches the depth of the variable and retrieves the offset of the static link address of that depth. 
getOffset :: Int -> Ident -> [CachedVar] -> Int
getOffset n x cache = let lvl = fromJust $ lookup x cache
                      in getPos n lvl (map snd (removeDoubleLevels cache))

-- | Produces code for retrieving the value of a global variable.
getGlobal :: Ident -> Syms -> CodeS
getGlobal x []           = error ("unknown variable: " ++ x)
getGlobal x (env : envs) = case lookup x (vars env) of
  Nothing         -> lda (- 2) . getGlobal x envs
  Just (V offset) -> lda offset
  
-- | Produces code for retrieving the value of a global variable.
getGlobal' :: Ident -> Syms -> CodeS
getGlobal' x []           = error ("unknown variable: " ++ x)
getGlobal' x (env : envs) = case lookup x (vars env) of
  Nothing         -> getGlobal' x envs
  Just (V offset) -> lda offset

-- | Produces code for assigning a new value to a variable.
set :: Ident -> Syms -> CodeS
set x (local : global) = case lookup x (vars local) of
  Nothing         -> ldl (- 2) . setGlobal x global
  Just (V offset) -> stl offset

-- | Produces code for - the value of a variable.
set' :: Int -> Ident -> Syms -> [CachedVar] -> CodeS
set' n x envs@(local : global) inCache = if (elem x (map fst inCache)) 
   then ldl (getOffset n x inCache) .
        setGlobal' x envs
   else set x envs
  
-- | Produces code for assigning a new value to a global variable.
setGlobal :: Ident -> Syms -> CodeS
setGlobal x []           = error ("unknown variable: " ++ x)
setGlobal x (env : envs) = case lookup x (vars env) of
  Nothing         -> lda (- 2) . setGlobal x envs
  Just (V offset) -> sta offset

-- | Produces code for - the value of a global variable.
setGlobal' :: Ident -> Syms -> CodeS
setGlobal' x []           = error ("unknown variable: " ++ x)
setGlobal' x (env : envs) = case lookup x (vars env) of
  Nothing         -> setGlobal' x envs
  Just (V offset) -> sta offset
  
-- | Produces code for calling a function.
call :: Ident -> Syms -> CodeS
call f (local : global) = case lookup f (funs local) of
  Nothing             -> ldl (- 2) . callGlobal f global
  Just (F beginLabel) -> ldr MP . ldcL beginLabel . jsr

-- | Produces code for calling a global function.
callGlobal :: Ident -> Syms -> CodeS
callGlobal f []           = error ("unknown function: " ++ f)
callGlobal f (env : envs) = case lookup f (funs env) of
  Nothing             -> lda (- 2) . callGlobal f envs
  Just (F beginLabel) -> ldcL beginLabel . jsr

-- | Produces code for returning from a function.
return_ :: [CachedVar] -> Syms -> CodeS
return_ cachedvars e@(local : _) = let globals = removeDoubleLevels (removeLocals cachedvars e)
 in
  sts (- (length (vars local) + 3 + length globals)) .
  ldrr SP MP .
  str MP .
  sts (- length (params local)) .
  ajs (- (length (params local) - 1)) .
  ret
{-# LINE 207 "../AG.hs" #-}

{-# LINE 5 ".\\Base.ag" #-}

type Ident = String    -- ^ Type of identifiers.
{-# LINE 212 "../AG.hs" #-}
-- Decl --------------------------------------------------------
data Decl = FunDecl (Ident) (([Ident])) (Stmts)
          | VarDecl (Ident)
-- cata
sem_Decl :: Decl ->
            T_Decl
sem_Decl (FunDecl _f _xs _b) =
    (sem_Decl_FunDecl _f _xs (sem_Stmts _b))
sem_Decl (VarDecl _x) =
    (sem_Decl_VarDecl _x)
-- semantic domain
type T_Decl = ([Label]) ->
              Int ->
              Syms ->
              ( CodeS,Env,([Label]),Int,([Ident]))
data Inh_Decl = Inh_Decl {labels_Inh_Decl :: ([Label]),offset_Inh_Decl :: Int,syms_Inh_Decl :: Syms}
data Syn_Decl = Syn_Decl {codes_Syn_Decl :: CodeS,env_Syn_Decl :: Env,labels_Syn_Decl :: ([Label]),offset_Syn_Decl :: Int,usedvars_Syn_Decl :: ([Ident])}
wrap_Decl :: T_Decl ->
             Inh_Decl ->
             Syn_Decl
wrap_Decl sem (Inh_Decl _lhsIlabels _lhsIoffset _lhsIsyms) =
    (let ( _lhsOcodes,_lhsOenv,_lhsOlabels,_lhsOoffset,_lhsOusedvars) = sem _lhsIlabels _lhsIoffset _lhsIsyms
     in  (Syn_Decl _lhsOcodes _lhsOenv _lhsOlabels _lhsOoffset _lhsOusedvars))
sem_Decl_FunDecl :: Ident ->
                    ([Ident]) ->
                    T_Stmts ->
                    T_Decl
sem_Decl_FunDecl f_ xs_ b_ =
    (\ _lhsIlabels
       _lhsIoffset
       _lhsIsyms ->
         (let _bOlabels :: ([Label])
              _bOoffset :: Int
              _bOcachedvars :: ([CachedVar])
              _lhsOusedvars :: ([Ident])
              _lhsOenv :: Env
              _bOlocalVars :: Env
              _bOsyms :: Syms
              _lhsOcodes :: CodeS
              _lhsOlabels :: ([Label])
              _lhsOoffset :: Int
              _bIcodes :: CodeS
              _bIenv :: Env
              _bIlabels :: ([Label])
              _bIoffset :: Int
              _bIusedvars :: ([Ident])
              _beginLabel =
                  ({-# LINE 25 "CodeGeneration.ag" #-}
                   _lhsIlabels !! 0
                   {-# LINE 262 "../AG" #-}
                   )
              _endLabel =
                  ({-# LINE 26 "CodeGeneration.ag" #-}
                   _lhsIlabels !! 1
                   {-# LINE 267 "../AG" #-}
                   )
              _bOlabels =
                  ({-# LINE 27 "CodeGeneration.ag" #-}
                   drop 2 _lhsIlabels
                   {-# LINE 272 "../AG" #-}
                   )
              _bOoffset =
                  ({-# LINE 46 "CodeGeneration.ag" #-}
                   1
                   {-# LINE 277 "../AG" #-}
                   )
              _bOcachedvars =
                  ({-# LINE 78 "CodeGeneration.ag" #-}
                   sortBySnd $ generateCachedvars (nub _bIusedvars \\ (map fst $ _bIenv)) (_params     : _lhsIsyms)
                   {-# LINE 282 "../AG" #-}
                   )
              _cachedvars =
                  ({-# LINE 79 "CodeGeneration.ag" #-}
                   sortBySnd $ generateCachedvars (nub _bIusedvars \\ (map fst $ _bIenv)) (_params     : _lhsIsyms)
                   {-# LINE 287 "../AG" #-}
                   )
              _lhsOusedvars =
                  ({-# LINE 90 "CodeGeneration.ag" #-}
                   nub _bIusedvars
                   {-# LINE 292 "../AG" #-}
                   )
              _lhsOenv =
                  ({-# LINE 145 "CodeGeneration.ag" #-}
                   [(f_, F _beginLabel    )]
                   {-# LINE 297 "../AG" #-}
                   )
              _bOlocalVars =
                  ({-# LINE 154 "CodeGeneration.ag" #-}
                   vars _bIenv
                   {-# LINE 302 "../AG" #-}
                   )
              _params =
                  ({-# LINE 159 "CodeGeneration.ag" #-}
                   zipWith (\x i -> (x, V i)) xs_ [- (2 + length xs_) ..]
                   {-# LINE 307 "../AG" #-}
                   )
              _bOsyms =
                  ({-# LINE 183 "CodeGeneration.ag" #-}
                   (_params     ++ _bIenv) : _lhsIsyms
                   {-# LINE 312 "../AG" #-}
                   )
              _lhsOcodes =
                  ({-# LINE 227 "CodeGeneration.ag" #-}
                   bra _endLabel     .
                   label _beginLabel     .
                     ldr MP .
                     ldrr MP SP .
                     enterparams _params     .
                     enter _bIenv .
                     cache (length _bIenv) _cachedvars     (_params     : _lhsIsyms) .
                     _bIcodes .
                     exit _bIenv .
                     ldc 0 .
                     return_ _cachedvars     (_params     : _lhsIsyms) .
                   label _endLabel
                   {-# LINE 328 "../AG" #-}
                   )
              _lhsOlabels =
                  ({-# LINE 21 "CodeGeneration.ag" #-}
                   _bIlabels
                   {-# LINE 333 "../AG" #-}
                   )
              _lhsOoffset =
                  ({-# LINE 42 "CodeGeneration.ag" #-}
                   _bIoffset
                   {-# LINE 338 "../AG" #-}
                   )
              ( _bIcodes,_bIenv,_bIlabels,_bIoffset,_bIusedvars) =
                  b_ _bOcachedvars _bOlabels _bOlocalVars _bOoffset _bOsyms
          in  ( _lhsOcodes,_lhsOenv,_lhsOlabels,_lhsOoffset,_lhsOusedvars)))
sem_Decl_VarDecl :: Ident ->
                    T_Decl
sem_Decl_VarDecl x_ =
    (\ _lhsIlabels
       _lhsIoffset
       _lhsIsyms ->
         (let _lhsOoffset :: Int
              _lhsOusedvars :: ([Ident])
              _lhsOenv :: Env
              _lhsOcodes :: CodeS
              _lhsOlabels :: ([Label])
              _lhsOoffset =
                  ({-# LINE 45 "CodeGeneration.ag" #-}
                   _lhsIoffset + 1
                   {-# LINE 357 "../AG" #-}
                   )
              _lhsOusedvars =
                  ({-# LINE 91 "CodeGeneration.ag" #-}
                   []
                   {-# LINE 362 "../AG" #-}
                   )
              _lhsOenv =
                  ({-# LINE 144 "CodeGeneration.ag" #-}
                   [(x_, V _lhsIoffset    )]
                   {-# LINE 367 "../AG" #-}
                   )
              _lhsOcodes =
                  ({-# LINE 219 "CodeGeneration.ag" #-}
                   id
                   {-# LINE 372 "../AG" #-}
                   )
              _lhsOlabels =
                  ({-# LINE 21 "CodeGeneration.ag" #-}
                   _lhsIlabels
                   {-# LINE 377 "../AG" #-}
                   )
          in  ( _lhsOcodes,_lhsOenv,_lhsOlabels,_lhsOoffset,_lhsOusedvars)))
-- Decls -------------------------------------------------------
type Decls = [Decl]
-- cata
sem_Decls :: Decls ->
             T_Decls
sem_Decls list =
    (Prelude.foldr sem_Decls_Cons sem_Decls_Nil (Prelude.map sem_Decl list))
-- semantic domain
type T_Decls = ([Label]) ->
               Int ->
               Syms ->
               ( CodeS,Env,([Label]),Int,([Ident]))
data Inh_Decls = Inh_Decls {labels_Inh_Decls :: ([Label]),offset_Inh_Decls :: Int,syms_Inh_Decls :: Syms}
data Syn_Decls = Syn_Decls {codes_Syn_Decls :: CodeS,env_Syn_Decls :: Env,labels_Syn_Decls :: ([Label]),offset_Syn_Decls :: Int,usedvars_Syn_Decls :: ([Ident])}
wrap_Decls :: T_Decls ->
              Inh_Decls ->
              Syn_Decls
wrap_Decls sem (Inh_Decls _lhsIlabels _lhsIoffset _lhsIsyms) =
    (let ( _lhsOcodes,_lhsOenv,_lhsOlabels,_lhsOoffset,_lhsOusedvars) = sem _lhsIlabels _lhsIoffset _lhsIsyms
     in  (Syn_Decls _lhsOcodes _lhsOenv _lhsOlabels _lhsOoffset _lhsOusedvars))
sem_Decls_Cons :: T_Decl ->
                  T_Decls ->
                  T_Decls
sem_Decls_Cons hd_ tl_ =
    (\ _lhsIlabels
       _lhsIoffset
       _lhsIsyms ->
         (let _lhsOcodes :: CodeS
              _lhsOenv :: Env
              _lhsOusedvars :: ([Ident])
              _lhsOlabels :: ([Label])
              _lhsOoffset :: Int
              _hdOlabels :: ([Label])
              _hdOoffset :: Int
              _hdOsyms :: Syms
              _tlOlabels :: ([Label])
              _tlOoffset :: Int
              _tlOsyms :: Syms
              _hdIcodes :: CodeS
              _hdIenv :: Env
              _hdIlabels :: ([Label])
              _hdIoffset :: Int
              _hdIusedvars :: ([Ident])
              _tlIcodes :: CodeS
              _tlIenv :: Env
              _tlIlabels :: ([Label])
              _tlIoffset :: Int
              _tlIusedvars :: ([Ident])
              _lhsOcodes =
                  ({-# LINE 219 "CodeGeneration.ag" #-}
                   _hdIcodes . _tlIcodes
                   {-# LINE 431 "../AG" #-}
                   )
              _lhsOenv =
                  ({-# LINE 142 "CodeGeneration.ag" #-}
                   _hdIenv ++ _tlIenv
                   {-# LINE 436 "../AG" #-}
                   )
              _lhsOusedvars =
                  ({-# LINE 87 "CodeGeneration.ag" #-}
                   _hdIusedvars ++ _tlIusedvars
                   {-# LINE 441 "../AG" #-}
                   )
              _lhsOlabels =
                  ({-# LINE 21 "CodeGeneration.ag" #-}
                   _tlIlabels
                   {-# LINE 446 "../AG" #-}
                   )
              _lhsOoffset =
                  ({-# LINE 42 "CodeGeneration.ag" #-}
                   _tlIoffset
                   {-# LINE 451 "../AG" #-}
                   )
              _hdOlabels =
                  ({-# LINE 20 "CodeGeneration.ag" #-}
                   _lhsIlabels
                   {-# LINE 456 "../AG" #-}
                   )
              _hdOoffset =
                  ({-# LINE 41 "CodeGeneration.ag" #-}
                   _lhsIoffset
                   {-# LINE 461 "../AG" #-}
                   )
              _hdOsyms =
                  ({-# LINE 180 "CodeGeneration.ag" #-}
                   _lhsIsyms
                   {-# LINE 466 "../AG" #-}
                   )
              _tlOlabels =
                  ({-# LINE 20 "CodeGeneration.ag" #-}
                   _hdIlabels
                   {-# LINE 471 "../AG" #-}
                   )
              _tlOoffset =
                  ({-# LINE 41 "CodeGeneration.ag" #-}
                   _hdIoffset
                   {-# LINE 476 "../AG" #-}
                   )
              _tlOsyms =
                  ({-# LINE 180 "CodeGeneration.ag" #-}
                   _lhsIsyms
                   {-# LINE 481 "../AG" #-}
                   )
              ( _hdIcodes,_hdIenv,_hdIlabels,_hdIoffset,_hdIusedvars) =
                  hd_ _hdOlabels _hdOoffset _hdOsyms
              ( _tlIcodes,_tlIenv,_tlIlabels,_tlIoffset,_tlIusedvars) =
                  tl_ _tlOlabels _tlOoffset _tlOsyms
          in  ( _lhsOcodes,_lhsOenv,_lhsOlabels,_lhsOoffset,_lhsOusedvars)))
sem_Decls_Nil :: T_Decls
sem_Decls_Nil =
    (\ _lhsIlabels
       _lhsIoffset
       _lhsIsyms ->
         (let _lhsOusedvars :: ([Ident])
              _lhsOcodes :: CodeS
              _lhsOenv :: Env
              _lhsOlabels :: ([Label])
              _lhsOoffset :: Int
              _lhsOusedvars =
                  ({-# LINE 117 "CodeGeneration.ag" #-}
                   []
                   {-# LINE 501 "../AG" #-}
                   )
              _lhsOcodes =
                  ({-# LINE 219 "CodeGeneration.ag" #-}
                   id
                   {-# LINE 506 "../AG" #-}
                   )
              _lhsOenv =
                  ({-# LINE 142 "CodeGeneration.ag" #-}
                   []
                   {-# LINE 511 "../AG" #-}
                   )
              _lhsOlabels =
                  ({-# LINE 21 "CodeGeneration.ag" #-}
                   _lhsIlabels
                   {-# LINE 516 "../AG" #-}
                   )
              _lhsOoffset =
                  ({-# LINE 42 "CodeGeneration.ag" #-}
                   _lhsIoffset
                   {-# LINE 521 "../AG" #-}
                   )
          in  ( _lhsOcodes,_lhsOenv,_lhsOlabels,_lhsOoffset,_lhsOusedvars)))
-- Exp ---------------------------------------------------------
data Exp = Add (Exp) (Exp)
         | Call (Ident) (Exps)
         | Div (Exp) (Exp)
         | Eq (Exp) (Exp)
         | False_
         | Gt (Exp) (Exp)
         | Int (Int)
         | Lt (Exp) (Exp)
         | Mul (Exp) (Exp)
         | Sub (Exp) (Exp)
         | True_
         | Var (Ident)
-- cata
sem_Exp :: Exp ->
           T_Exp
sem_Exp (Add _e1 _e2) =
    (sem_Exp_Add (sem_Exp _e1) (sem_Exp _e2))
sem_Exp (Call _f _es) =
    (sem_Exp_Call _f (sem_Exps _es))
sem_Exp (Div _e1 _e2) =
    (sem_Exp_Div (sem_Exp _e1) (sem_Exp _e2))
sem_Exp (Eq _e1 _e2) =
    (sem_Exp_Eq (sem_Exp _e1) (sem_Exp _e2))
sem_Exp (False_) =
    (sem_Exp_False_)
sem_Exp (Gt _e1 _e2) =
    (sem_Exp_Gt (sem_Exp _e1) (sem_Exp _e2))
sem_Exp (Int _n) =
    (sem_Exp_Int _n)
sem_Exp (Lt _e1 _e2) =
    (sem_Exp_Lt (sem_Exp _e1) (sem_Exp _e2))
sem_Exp (Mul _e1 _e2) =
    (sem_Exp_Mul (sem_Exp _e1) (sem_Exp _e2))
sem_Exp (Sub _e1 _e2) =
    (sem_Exp_Sub (sem_Exp _e1) (sem_Exp _e2))
sem_Exp (True_) =
    (sem_Exp_True_)
sem_Exp (Var _x) =
    (sem_Exp_Var _x)
-- semantic domain
type T_Exp = ([CachedVar]) ->
             ([Label]) ->
             Env ->
             Syms ->
             ( String,CodeS,([Label]),([Ident]))
data Inh_Exp = Inh_Exp {cachedvars_Inh_Exp :: ([CachedVar]),labels_Inh_Exp :: ([Label]),localVars_Inh_Exp :: Env,syms_Inh_Exp :: Syms}
data Syn_Exp = Syn_Exp {ann_Syn_Exp :: String,codes_Syn_Exp :: CodeS,labels_Syn_Exp :: ([Label]),usedvars_Syn_Exp :: ([Ident])}
wrap_Exp :: T_Exp ->
            Inh_Exp ->
            Syn_Exp
wrap_Exp sem (Inh_Exp _lhsIcachedvars _lhsIlabels _lhsIlocalVars _lhsIsyms) =
    (let ( _lhsOann,_lhsOcodes,_lhsOlabels,_lhsOusedvars) = sem _lhsIcachedvars _lhsIlabels _lhsIlocalVars _lhsIsyms
     in  (Syn_Exp _lhsOann _lhsOcodes _lhsOlabels _lhsOusedvars))
sem_Exp_Add :: T_Exp ->
               T_Exp ->
               T_Exp
sem_Exp_Add e1_ e2_ =
    (\ _lhsIcachedvars
       _lhsIlabels
       _lhsIlocalVars
       _lhsIsyms ->
         (let _lhsOusedvars :: ([Ident])
              _lhsOcodes :: CodeS
              _lhsOann :: String
              _lhsOlabels :: ([Label])
              _e1Ocachedvars :: ([CachedVar])
              _e1Olabels :: ([Label])
              _e1OlocalVars :: Env
              _e1Osyms :: Syms
              _e2Ocachedvars :: ([CachedVar])
              _e2Olabels :: ([Label])
              _e2OlocalVars :: Env
              _e2Osyms :: Syms
              _e1Iann :: String
              _e1Icodes :: CodeS
              _e1Ilabels :: ([Label])
              _e1Iusedvars :: ([Ident])
              _e2Iann :: String
              _e2Icodes :: CodeS
              _e2Ilabels :: ([Label])
              _e2Iusedvars :: ([Ident])
              _lhsOusedvars =
                  ({-# LINE 107 "CodeGeneration.ag" #-}
                   _e1Iusedvars ++ _e2Iusedvars
                   {-# LINE 609 "../AG" #-}
                   )
              _ann =
                  ({-# LINE 201 "CodeGeneration.ag" #-}
                   _e1Iann ++ "+"  ++ _e2Iann
                   {-# LINE 614 "../AG" #-}
                   )
              _annote =
                  ({-# LINE 212 "CodeGeneration.ag" #-}
                   annote SP 0 0 "green" _ann
                   {-# LINE 619 "../AG" #-}
                   )
              _lhsOcodes =
                  ({-# LINE 262 "CodeGeneration.ag" #-}
                   _e1Icodes . _e2Icodes . add . _annote
                   {-# LINE 624 "../AG" #-}
                   )
              _lhsOann =
                  ({-# LINE 192 "CodeGeneration.ag" #-}
                   _ann
                   {-# LINE 629 "../AG" #-}
                   )
              _lhsOlabels =
                  ({-# LINE 21 "CodeGeneration.ag" #-}
                   _e2Ilabels
                   {-# LINE 634 "../AG" #-}
                   )
              _e1Ocachedvars =
                  ({-# LINE 58 "CodeGeneration.ag" #-}
                   _lhsIcachedvars
                   {-# LINE 639 "../AG" #-}
                   )
              _e1Olabels =
                  ({-# LINE 20 "CodeGeneration.ag" #-}
                   _lhsIlabels
                   {-# LINE 644 "../AG" #-}
                   )
              _e1OlocalVars =
                  ({-# LINE 152 "CodeGeneration.ag" #-}
                   _lhsIlocalVars
                   {-# LINE 649 "../AG" #-}
                   )
              _e1Osyms =
                  ({-# LINE 180 "CodeGeneration.ag" #-}
                   _lhsIsyms
                   {-# LINE 654 "../AG" #-}
                   )
              _e2Ocachedvars =
                  ({-# LINE 58 "CodeGeneration.ag" #-}
                   _lhsIcachedvars
                   {-# LINE 659 "../AG" #-}
                   )
              _e2Olabels =
                  ({-# LINE 20 "CodeGeneration.ag" #-}
                   _e1Ilabels
                   {-# LINE 664 "../AG" #-}
                   )
              _e2OlocalVars =
                  ({-# LINE 152 "CodeGeneration.ag" #-}
                   _lhsIlocalVars
                   {-# LINE 669 "../AG" #-}
                   )
              _e2Osyms =
                  ({-# LINE 180 "CodeGeneration.ag" #-}
                   _lhsIsyms
                   {-# LINE 674 "../AG" #-}
                   )
              ( _e1Iann,_e1Icodes,_e1Ilabels,_e1Iusedvars) =
                  e1_ _e1Ocachedvars _e1Olabels _e1OlocalVars _e1Osyms
              ( _e2Iann,_e2Icodes,_e2Ilabels,_e2Iusedvars) =
                  e2_ _e2Ocachedvars _e2Olabels _e2OlocalVars _e2Osyms
          in  ( _lhsOann,_lhsOcodes,_lhsOlabels,_lhsOusedvars)))
sem_Exp_Call :: Ident ->
                T_Exps ->
                T_Exp
sem_Exp_Call f_ es_ =
    (\ _lhsIcachedvars
       _lhsIlabels
       _lhsIlocalVars
       _lhsIsyms ->
         (let _lhsOusedvars :: ([Ident])
              _lhsOcodes :: CodeS
              _lhsOann :: String
              _lhsOlabels :: ([Label])
              _esOcachedvars :: ([CachedVar])
              _esOlabels :: ([Label])
              _esOlocalVars :: Env
              _esOsyms :: Syms
              _esIanns :: ([String])
              _esIcodes :: CodeS
              _esIlabels :: ([Label])
              _esIusedvars :: ([Ident])
              _lhsOusedvars =
                  ({-# LINE 106 "CodeGeneration.ag" #-}
                   _esIusedvars
                   {-# LINE 704 "../AG" #-}
                   )
              _ann =
                  ({-# LINE 200 "CodeGeneration.ag" #-}
                   f_ ++ "(" ++ concat (intersperse "," _esIanns) ++ ")"
                   {-# LINE 709 "../AG" #-}
                   )
              _annote =
                  ({-# LINE 212 "CodeGeneration.ag" #-}
                   annote SP 0 0 "green" _ann
                   {-# LINE 714 "../AG" #-}
                   )
              _lhsOcodes =
                  ({-# LINE 261 "CodeGeneration.ag" #-}
                   _esIcodes . call f_ _lhsIsyms
                   {-# LINE 719 "../AG" #-}
                   )
              _lhsOann =
                  ({-# LINE 192 "CodeGeneration.ag" #-}
                   _ann
                   {-# LINE 724 "../AG" #-}
                   )
              _lhsOlabels =
                  ({-# LINE 21 "CodeGeneration.ag" #-}
                   _esIlabels
                   {-# LINE 729 "../AG" #-}
                   )
              _esOcachedvars =
                  ({-# LINE 58 "CodeGeneration.ag" #-}
                   _lhsIcachedvars
                   {-# LINE 734 "../AG" #-}
                   )
              _esOlabels =
                  ({-# LINE 20 "CodeGeneration.ag" #-}
                   _lhsIlabels
                   {-# LINE 739 "../AG" #-}
                   )
              _esOlocalVars =
                  ({-# LINE 152 "CodeGeneration.ag" #-}
                   _lhsIlocalVars
                   {-# LINE 744 "../AG" #-}
                   )
              _esOsyms =
                  ({-# LINE 180 "CodeGeneration.ag" #-}
                   _lhsIsyms
                   {-# LINE 749 "../AG" #-}
                   )
              ( _esIanns,_esIcodes,_esIlabels,_esIusedvars) =
                  es_ _esOcachedvars _esOlabels _esOlocalVars _esOsyms
          in  ( _lhsOann,_lhsOcodes,_lhsOlabels,_lhsOusedvars)))
sem_Exp_Div :: T_Exp ->
               T_Exp ->
               T_Exp
sem_Exp_Div e1_ e2_ =
    (\ _lhsIcachedvars
       _lhsIlabels
       _lhsIlocalVars
       _lhsIsyms ->
         (let _lhsOusedvars :: ([Ident])
              _lhsOcodes :: CodeS
              _lhsOann :: String
              _lhsOlabels :: ([Label])
              _e1Ocachedvars :: ([CachedVar])
              _e1Olabels :: ([Label])
              _e1OlocalVars :: Env
              _e1Osyms :: Syms
              _e2Ocachedvars :: ([CachedVar])
              _e2Olabels :: ([Label])
              _e2OlocalVars :: Env
              _e2Osyms :: Syms
              _e1Iann :: String
              _e1Icodes :: CodeS
              _e1Ilabels :: ([Label])
              _e1Iusedvars :: ([Ident])
              _e2Iann :: String
              _e2Icodes :: CodeS
              _e2Ilabels :: ([Label])
              _e2Iusedvars :: ([Ident])
              _lhsOusedvars =
                  ({-# LINE 110 "CodeGeneration.ag" #-}
                   _e1Iusedvars ++ _e2Iusedvars
                   {-# LINE 785 "../AG" #-}
                   )
              _ann =
                  ({-# LINE 204 "CodeGeneration.ag" #-}
                   _e1Iann ++ "/"  ++ _e2Iann
                   {-# LINE 790 "../AG" #-}
                   )
              _annote =
                  ({-# LINE 212 "CodeGeneration.ag" #-}
                   annote SP 0 0 "green" _ann
                   {-# LINE 795 "../AG" #-}
                   )
              _lhsOcodes =
                  ({-# LINE 265 "CodeGeneration.ag" #-}
                   _e1Icodes . _e2Icodes . div . _annote
                   {-# LINE 800 "../AG" #-}
                   )
              _lhsOann =
                  ({-# LINE 192 "CodeGeneration.ag" #-}
                   _ann
                   {-# LINE 805 "../AG" #-}
                   )
              _lhsOlabels =
                  ({-# LINE 21 "CodeGeneration.ag" #-}
                   _e2Ilabels
                   {-# LINE 810 "../AG" #-}
                   )
              _e1Ocachedvars =
                  ({-# LINE 58 "CodeGeneration.ag" #-}
                   _lhsIcachedvars
                   {-# LINE 815 "../AG" #-}
                   )
              _e1Olabels =
                  ({-# LINE 20 "CodeGeneration.ag" #-}
                   _lhsIlabels
                   {-# LINE 820 "../AG" #-}
                   )
              _e1OlocalVars =
                  ({-# LINE 152 "CodeGeneration.ag" #-}
                   _lhsIlocalVars
                   {-# LINE 825 "../AG" #-}
                   )
              _e1Osyms =
                  ({-# LINE 180 "CodeGeneration.ag" #-}
                   _lhsIsyms
                   {-# LINE 830 "../AG" #-}
                   )
              _e2Ocachedvars =
                  ({-# LINE 58 "CodeGeneration.ag" #-}
                   _lhsIcachedvars
                   {-# LINE 835 "../AG" #-}
                   )
              _e2Olabels =
                  ({-# LINE 20 "CodeGeneration.ag" #-}
                   _e1Ilabels
                   {-# LINE 840 "../AG" #-}
                   )
              _e2OlocalVars =
                  ({-# LINE 152 "CodeGeneration.ag" #-}
                   _lhsIlocalVars
                   {-# LINE 845 "../AG" #-}
                   )
              _e2Osyms =
                  ({-# LINE 180 "CodeGeneration.ag" #-}
                   _lhsIsyms
                   {-# LINE 850 "../AG" #-}
                   )
              ( _e1Iann,_e1Icodes,_e1Ilabels,_e1Iusedvars) =
                  e1_ _e1Ocachedvars _e1Olabels _e1OlocalVars _e1Osyms
              ( _e2Iann,_e2Icodes,_e2Ilabels,_e2Iusedvars) =
                  e2_ _e2Ocachedvars _e2Olabels _e2OlocalVars _e2Osyms
          in  ( _lhsOann,_lhsOcodes,_lhsOlabels,_lhsOusedvars)))
sem_Exp_Eq :: T_Exp ->
              T_Exp ->
              T_Exp
sem_Exp_Eq e1_ e2_ =
    (\ _lhsIcachedvars
       _lhsIlabels
       _lhsIlocalVars
       _lhsIsyms ->
         (let _lhsOusedvars :: ([Ident])
              _lhsOcodes :: CodeS
              _lhsOann :: String
              _lhsOlabels :: ([Label])
              _e1Ocachedvars :: ([CachedVar])
              _e1Olabels :: ([Label])
              _e1OlocalVars :: Env
              _e1Osyms :: Syms
              _e2Ocachedvars :: ([CachedVar])
              _e2Olabels :: ([Label])
              _e2OlocalVars :: Env
              _e2Osyms :: Syms
              _e1Iann :: String
              _e1Icodes :: CodeS
              _e1Ilabels :: ([Label])
              _e1Iusedvars :: ([Ident])
              _e2Iann :: String
              _e2Icodes :: CodeS
              _e2Ilabels :: ([Label])
              _e2Iusedvars :: ([Ident])
              _lhsOusedvars =
                  ({-# LINE 112 "CodeGeneration.ag" #-}
                   _e1Iusedvars ++ _e2Iusedvars
                   {-# LINE 888 "../AG" #-}
                   )
              _ann =
                  ({-# LINE 206 "CodeGeneration.ag" #-}
                   _e1Iann ++ "==" ++ _e2Iann
                   {-# LINE 893 "../AG" #-}
                   )
              _annote =
                  ({-# LINE 212 "CodeGeneration.ag" #-}
                   annote SP 0 0 "green" _ann
                   {-# LINE 898 "../AG" #-}
                   )
              _lhsOcodes =
                  ({-# LINE 267 "CodeGeneration.ag" #-}
                   _e1Icodes . _e2Icodes . eq . _annote
                   {-# LINE 903 "../AG" #-}
                   )
              _lhsOann =
                  ({-# LINE 192 "CodeGeneration.ag" #-}
                   _ann
                   {-# LINE 908 "../AG" #-}
                   )
              _lhsOlabels =
                  ({-# LINE 21 "CodeGeneration.ag" #-}
                   _e2Ilabels
                   {-# LINE 913 "../AG" #-}
                   )
              _e1Ocachedvars =
                  ({-# LINE 58 "CodeGeneration.ag" #-}
                   _lhsIcachedvars
                   {-# LINE 918 "../AG" #-}
                   )
              _e1Olabels =
                  ({-# LINE 20 "CodeGeneration.ag" #-}
                   _lhsIlabels
                   {-# LINE 923 "../AG" #-}
                   )
              _e1OlocalVars =
                  ({-# LINE 152 "CodeGeneration.ag" #-}
                   _lhsIlocalVars
                   {-# LINE 928 "../AG" #-}
                   )
              _e1Osyms =
                  ({-# LINE 180 "CodeGeneration.ag" #-}
                   _lhsIsyms
                   {-# LINE 933 "../AG" #-}
                   )
              _e2Ocachedvars =
                  ({-# LINE 58 "CodeGeneration.ag" #-}
                   _lhsIcachedvars
                   {-# LINE 938 "../AG" #-}
                   )
              _e2Olabels =
                  ({-# LINE 20 "CodeGeneration.ag" #-}
                   _e1Ilabels
                   {-# LINE 943 "../AG" #-}
                   )
              _e2OlocalVars =
                  ({-# LINE 152 "CodeGeneration.ag" #-}
                   _lhsIlocalVars
                   {-# LINE 948 "../AG" #-}
                   )
              _e2Osyms =
                  ({-# LINE 180 "CodeGeneration.ag" #-}
                   _lhsIsyms
                   {-# LINE 953 "../AG" #-}
                   )
              ( _e1Iann,_e1Icodes,_e1Ilabels,_e1Iusedvars) =
                  e1_ _e1Ocachedvars _e1Olabels _e1OlocalVars _e1Osyms
              ( _e2Iann,_e2Icodes,_e2Ilabels,_e2Iusedvars) =
                  e2_ _e2Ocachedvars _e2Olabels _e2OlocalVars _e2Osyms
          in  ( _lhsOann,_lhsOcodes,_lhsOlabels,_lhsOusedvars)))
sem_Exp_False_ :: T_Exp
sem_Exp_False_ =
    (\ _lhsIcachedvars
       _lhsIlabels
       _lhsIlocalVars
       _lhsIsyms ->
         (let _lhsOusedvars :: ([Ident])
              _lhsOcodes :: CodeS
              _lhsOann :: String
              _lhsOlabels :: ([Label])
              _lhsOusedvars =
                  ({-# LINE 103 "CodeGeneration.ag" #-}
                   []
                   {-# LINE 973 "../AG" #-}
                   )
              _ann =
                  ({-# LINE 197 "CodeGeneration.ag" #-}
                   "False"
                   {-# LINE 978 "../AG" #-}
                   )
              _annote =
                  ({-# LINE 212 "CodeGeneration.ag" #-}
                   annote SP 0 0 "green" _ann
                   {-# LINE 983 "../AG" #-}
                   )
              _lhsOcodes =
                  ({-# LINE 258 "CodeGeneration.ag" #-}
                   ldc 0 . _annote
                   {-# LINE 988 "../AG" #-}
                   )
              _lhsOann =
                  ({-# LINE 192 "CodeGeneration.ag" #-}
                   _ann
                   {-# LINE 993 "../AG" #-}
                   )
              _lhsOlabels =
                  ({-# LINE 21 "CodeGeneration.ag" #-}
                   _lhsIlabels
                   {-# LINE 998 "../AG" #-}
                   )
          in  ( _lhsOann,_lhsOcodes,_lhsOlabels,_lhsOusedvars)))
sem_Exp_Gt :: T_Exp ->
              T_Exp ->
              T_Exp
sem_Exp_Gt e1_ e2_ =
    (\ _lhsIcachedvars
       _lhsIlabels
       _lhsIlocalVars
       _lhsIsyms ->
         (let _lhsOusedvars :: ([Ident])
              _lhsOcodes :: CodeS
              _lhsOann :: String
              _lhsOlabels :: ([Label])
              _e1Ocachedvars :: ([CachedVar])
              _e1Olabels :: ([Label])
              _e1OlocalVars :: Env
              _e1Osyms :: Syms
              _e2Ocachedvars :: ([CachedVar])
              _e2Olabels :: ([Label])
              _e2OlocalVars :: Env
              _e2Osyms :: Syms
              _e1Iann :: String
              _e1Icodes :: CodeS
              _e1Ilabels :: ([Label])
              _e1Iusedvars :: ([Ident])
              _e2Iann :: String
              _e2Icodes :: CodeS
              _e2Ilabels :: ([Label])
              _e2Iusedvars :: ([Ident])
              _lhsOusedvars =
                  ({-# LINE 113 "CodeGeneration.ag" #-}
                   _e1Iusedvars ++ _e2Iusedvars
                   {-# LINE 1032 "../AG" #-}
                   )
              _ann =
                  ({-# LINE 207 "CodeGeneration.ag" #-}
                   _e1Iann ++ ">"  ++ _e2Iann
                   {-# LINE 1037 "../AG" #-}
                   )
              _annote =
                  ({-# LINE 212 "CodeGeneration.ag" #-}
                   annote SP 0 0 "green" _ann
                   {-# LINE 1042 "../AG" #-}
                   )
              _lhsOcodes =
                  ({-# LINE 268 "CodeGeneration.ag" #-}
                   _e1Icodes . _e2Icodes . gt . _annote
                   {-# LINE 1047 "../AG" #-}
                   )
              _lhsOann =
                  ({-# LINE 192 "CodeGeneration.ag" #-}
                   _ann
                   {-# LINE 1052 "../AG" #-}
                   )
              _lhsOlabels =
                  ({-# LINE 21 "CodeGeneration.ag" #-}
                   _e2Ilabels
                   {-# LINE 1057 "../AG" #-}
                   )
              _e1Ocachedvars =
                  ({-# LINE 58 "CodeGeneration.ag" #-}
                   _lhsIcachedvars
                   {-# LINE 1062 "../AG" #-}
                   )
              _e1Olabels =
                  ({-# LINE 20 "CodeGeneration.ag" #-}
                   _lhsIlabels
                   {-# LINE 1067 "../AG" #-}
                   )
              _e1OlocalVars =
                  ({-# LINE 152 "CodeGeneration.ag" #-}
                   _lhsIlocalVars
                   {-# LINE 1072 "../AG" #-}
                   )
              _e1Osyms =
                  ({-# LINE 180 "CodeGeneration.ag" #-}
                   _lhsIsyms
                   {-# LINE 1077 "../AG" #-}
                   )
              _e2Ocachedvars =
                  ({-# LINE 58 "CodeGeneration.ag" #-}
                   _lhsIcachedvars
                   {-# LINE 1082 "../AG" #-}
                   )
              _e2Olabels =
                  ({-# LINE 20 "CodeGeneration.ag" #-}
                   _e1Ilabels
                   {-# LINE 1087 "../AG" #-}
                   )
              _e2OlocalVars =
                  ({-# LINE 152 "CodeGeneration.ag" #-}
                   _lhsIlocalVars
                   {-# LINE 1092 "../AG" #-}
                   )
              _e2Osyms =
                  ({-# LINE 180 "CodeGeneration.ag" #-}
                   _lhsIsyms
                   {-# LINE 1097 "../AG" #-}
                   )
              ( _e1Iann,_e1Icodes,_e1Ilabels,_e1Iusedvars) =
                  e1_ _e1Ocachedvars _e1Olabels _e1OlocalVars _e1Osyms
              ( _e2Iann,_e2Icodes,_e2Ilabels,_e2Iusedvars) =
                  e2_ _e2Ocachedvars _e2Olabels _e2OlocalVars _e2Osyms
          in  ( _lhsOann,_lhsOcodes,_lhsOlabels,_lhsOusedvars)))
sem_Exp_Int :: Int ->
               T_Exp
sem_Exp_Int n_ =
    (\ _lhsIcachedvars
       _lhsIlabels
       _lhsIlocalVars
       _lhsIsyms ->
         (let _lhsOusedvars :: ([Ident])
              _lhsOcodes :: CodeS
              _lhsOann :: String
              _lhsOlabels :: ([Label])
              _lhsOusedvars =
                  ({-# LINE 102 "CodeGeneration.ag" #-}
                   []
                   {-# LINE 1118 "../AG" #-}
                   )
              _ann =
                  ({-# LINE 196 "CodeGeneration.ag" #-}
                   show n_
                   {-# LINE 1123 "../AG" #-}
                   )
              _annote =
                  ({-# LINE 212 "CodeGeneration.ag" #-}
                   annote SP 0 0 "green" _ann
                   {-# LINE 1128 "../AG" #-}
                   )
              _lhsOcodes =
                  ({-# LINE 257 "CodeGeneration.ag" #-}
                   ldc n_ . _annote
                   {-# LINE 1133 "../AG" #-}
                   )
              _lhsOann =
                  ({-# LINE 192 "CodeGeneration.ag" #-}
                   _ann
                   {-# LINE 1138 "../AG" #-}
                   )
              _lhsOlabels =
                  ({-# LINE 21 "CodeGeneration.ag" #-}
                   _lhsIlabels
                   {-# LINE 1143 "../AG" #-}
                   )
          in  ( _lhsOann,_lhsOcodes,_lhsOlabels,_lhsOusedvars)))
sem_Exp_Lt :: T_Exp ->
              T_Exp ->
              T_Exp
sem_Exp_Lt e1_ e2_ =
    (\ _lhsIcachedvars
       _lhsIlabels
       _lhsIlocalVars
       _lhsIsyms ->
         (let _lhsOusedvars :: ([Ident])
              _lhsOcodes :: CodeS
              _lhsOann :: String
              _lhsOlabels :: ([Label])
              _e1Ocachedvars :: ([CachedVar])
              _e1Olabels :: ([Label])
              _e1OlocalVars :: Env
              _e1Osyms :: Syms
              _e2Ocachedvars :: ([CachedVar])
              _e2Olabels :: ([Label])
              _e2OlocalVars :: Env
              _e2Osyms :: Syms
              _e1Iann :: String
              _e1Icodes :: CodeS
              _e1Ilabels :: ([Label])
              _e1Iusedvars :: ([Ident])
              _e2Iann :: String
              _e2Icodes :: CodeS
              _e2Ilabels :: ([Label])
              _e2Iusedvars :: ([Ident])
              _lhsOusedvars =
                  ({-# LINE 111 "CodeGeneration.ag" #-}
                   _e1Iusedvars ++ _e2Iusedvars
                   {-# LINE 1177 "../AG" #-}
                   )
              _ann =
                  ({-# LINE 205 "CodeGeneration.ag" #-}
                   _e1Iann ++ "<"  ++ _e2Iann
                   {-# LINE 1182 "../AG" #-}
                   )
              _annote =
                  ({-# LINE 212 "CodeGeneration.ag" #-}
                   annote SP 0 0 "green" _ann
                   {-# LINE 1187 "../AG" #-}
                   )
              _lhsOcodes =
                  ({-# LINE 266 "CodeGeneration.ag" #-}
                   _e1Icodes . _e2Icodes . lt . _annote
                   {-# LINE 1192 "../AG" #-}
                   )
              _lhsOann =
                  ({-# LINE 192 "CodeGeneration.ag" #-}
                   _ann
                   {-# LINE 1197 "../AG" #-}
                   )
              _lhsOlabels =
                  ({-# LINE 21 "CodeGeneration.ag" #-}
                   _e2Ilabels
                   {-# LINE 1202 "../AG" #-}
                   )
              _e1Ocachedvars =
                  ({-# LINE 58 "CodeGeneration.ag" #-}
                   _lhsIcachedvars
                   {-# LINE 1207 "../AG" #-}
                   )
              _e1Olabels =
                  ({-# LINE 20 "CodeGeneration.ag" #-}
                   _lhsIlabels
                   {-# LINE 1212 "../AG" #-}
                   )
              _e1OlocalVars =
                  ({-# LINE 152 "CodeGeneration.ag" #-}
                   _lhsIlocalVars
                   {-# LINE 1217 "../AG" #-}
                   )
              _e1Osyms =
                  ({-# LINE 180 "CodeGeneration.ag" #-}
                   _lhsIsyms
                   {-# LINE 1222 "../AG" #-}
                   )
              _e2Ocachedvars =
                  ({-# LINE 58 "CodeGeneration.ag" #-}
                   _lhsIcachedvars
                   {-# LINE 1227 "../AG" #-}
                   )
              _e2Olabels =
                  ({-# LINE 20 "CodeGeneration.ag" #-}
                   _e1Ilabels
                   {-# LINE 1232 "../AG" #-}
                   )
              _e2OlocalVars =
                  ({-# LINE 152 "CodeGeneration.ag" #-}
                   _lhsIlocalVars
                   {-# LINE 1237 "../AG" #-}
                   )
              _e2Osyms =
                  ({-# LINE 180 "CodeGeneration.ag" #-}
                   _lhsIsyms
                   {-# LINE 1242 "../AG" #-}
                   )
              ( _e1Iann,_e1Icodes,_e1Ilabels,_e1Iusedvars) =
                  e1_ _e1Ocachedvars _e1Olabels _e1OlocalVars _e1Osyms
              ( _e2Iann,_e2Icodes,_e2Ilabels,_e2Iusedvars) =
                  e2_ _e2Ocachedvars _e2Olabels _e2OlocalVars _e2Osyms
          in  ( _lhsOann,_lhsOcodes,_lhsOlabels,_lhsOusedvars)))
sem_Exp_Mul :: T_Exp ->
               T_Exp ->
               T_Exp
sem_Exp_Mul e1_ e2_ =
    (\ _lhsIcachedvars
       _lhsIlabels
       _lhsIlocalVars
       _lhsIsyms ->
         (let _lhsOusedvars :: ([Ident])
              _lhsOcodes :: CodeS
              _lhsOann :: String
              _lhsOlabels :: ([Label])
              _e1Ocachedvars :: ([CachedVar])
              _e1Olabels :: ([Label])
              _e1OlocalVars :: Env
              _e1Osyms :: Syms
              _e2Ocachedvars :: ([CachedVar])
              _e2Olabels :: ([Label])
              _e2OlocalVars :: Env
              _e2Osyms :: Syms
              _e1Iann :: String
              _e1Icodes :: CodeS
              _e1Ilabels :: ([Label])
              _e1Iusedvars :: ([Ident])
              _e2Iann :: String
              _e2Icodes :: CodeS
              _e2Ilabels :: ([Label])
              _e2Iusedvars :: ([Ident])
              _lhsOusedvars =
                  ({-# LINE 109 "CodeGeneration.ag" #-}
                   _e1Iusedvars ++ _e2Iusedvars
                   {-# LINE 1280 "../AG" #-}
                   )
              _ann =
                  ({-# LINE 203 "CodeGeneration.ag" #-}
                   _e1Iann ++ "*"  ++ _e2Iann
                   {-# LINE 1285 "../AG" #-}
                   )
              _annote =
                  ({-# LINE 212 "CodeGeneration.ag" #-}
                   annote SP 0 0 "green" _ann
                   {-# LINE 1290 "../AG" #-}
                   )
              _lhsOcodes =
                  ({-# LINE 264 "CodeGeneration.ag" #-}
                   _e1Icodes . _e2Icodes . mul . _annote
                   {-# LINE 1295 "../AG" #-}
                   )
              _lhsOann =
                  ({-# LINE 192 "CodeGeneration.ag" #-}
                   _ann
                   {-# LINE 1300 "../AG" #-}
                   )
              _lhsOlabels =
                  ({-# LINE 21 "CodeGeneration.ag" #-}
                   _e2Ilabels
                   {-# LINE 1305 "../AG" #-}
                   )
              _e1Ocachedvars =
                  ({-# LINE 58 "CodeGeneration.ag" #-}
                   _lhsIcachedvars
                   {-# LINE 1310 "../AG" #-}
                   )
              _e1Olabels =
                  ({-# LINE 20 "CodeGeneration.ag" #-}
                   _lhsIlabels
                   {-# LINE 1315 "../AG" #-}
                   )
              _e1OlocalVars =
                  ({-# LINE 152 "CodeGeneration.ag" #-}
                   _lhsIlocalVars
                   {-# LINE 1320 "../AG" #-}
                   )
              _e1Osyms =
                  ({-# LINE 180 "CodeGeneration.ag" #-}
                   _lhsIsyms
                   {-# LINE 1325 "../AG" #-}
                   )
              _e2Ocachedvars =
                  ({-# LINE 58 "CodeGeneration.ag" #-}
                   _lhsIcachedvars
                   {-# LINE 1330 "../AG" #-}
                   )
              _e2Olabels =
                  ({-# LINE 20 "CodeGeneration.ag" #-}
                   _e1Ilabels
                   {-# LINE 1335 "../AG" #-}
                   )
              _e2OlocalVars =
                  ({-# LINE 152 "CodeGeneration.ag" #-}
                   _lhsIlocalVars
                   {-# LINE 1340 "../AG" #-}
                   )
              _e2Osyms =
                  ({-# LINE 180 "CodeGeneration.ag" #-}
                   _lhsIsyms
                   {-# LINE 1345 "../AG" #-}
                   )
              ( _e1Iann,_e1Icodes,_e1Ilabels,_e1Iusedvars) =
                  e1_ _e1Ocachedvars _e1Olabels _e1OlocalVars _e1Osyms
              ( _e2Iann,_e2Icodes,_e2Ilabels,_e2Iusedvars) =
                  e2_ _e2Ocachedvars _e2Olabels _e2OlocalVars _e2Osyms
          in  ( _lhsOann,_lhsOcodes,_lhsOlabels,_lhsOusedvars)))
sem_Exp_Sub :: T_Exp ->
               T_Exp ->
               T_Exp
sem_Exp_Sub e1_ e2_ =
    (\ _lhsIcachedvars
       _lhsIlabels
       _lhsIlocalVars
       _lhsIsyms ->
         (let _lhsOusedvars :: ([Ident])
              _lhsOcodes :: CodeS
              _lhsOann :: String
              _lhsOlabels :: ([Label])
              _e1Ocachedvars :: ([CachedVar])
              _e1Olabels :: ([Label])
              _e1OlocalVars :: Env
              _e1Osyms :: Syms
              _e2Ocachedvars :: ([CachedVar])
              _e2Olabels :: ([Label])
              _e2OlocalVars :: Env
              _e2Osyms :: Syms
              _e1Iann :: String
              _e1Icodes :: CodeS
              _e1Ilabels :: ([Label])
              _e1Iusedvars :: ([Ident])
              _e2Iann :: String
              _e2Icodes :: CodeS
              _e2Ilabels :: ([Label])
              _e2Iusedvars :: ([Ident])
              _lhsOusedvars =
                  ({-# LINE 108 "CodeGeneration.ag" #-}
                   _e1Iusedvars ++ _e2Iusedvars
                   {-# LINE 1383 "../AG" #-}
                   )
              _ann =
                  ({-# LINE 202 "CodeGeneration.ag" #-}
                   _e1Iann ++ "-"  ++ _e2Iann
                   {-# LINE 1388 "../AG" #-}
                   )
              _annote =
                  ({-# LINE 212 "CodeGeneration.ag" #-}
                   annote SP 0 0 "green" _ann
                   {-# LINE 1393 "../AG" #-}
                   )
              _lhsOcodes =
                  ({-# LINE 263 "CodeGeneration.ag" #-}
                   _e1Icodes . _e2Icodes . sub . _annote
                   {-# LINE 1398 "../AG" #-}
                   )
              _lhsOann =
                  ({-# LINE 192 "CodeGeneration.ag" #-}
                   _ann
                   {-# LINE 1403 "../AG" #-}
                   )
              _lhsOlabels =
                  ({-# LINE 21 "CodeGeneration.ag" #-}
                   _e2Ilabels
                   {-# LINE 1408 "../AG" #-}
                   )
              _e1Ocachedvars =
                  ({-# LINE 58 "CodeGeneration.ag" #-}
                   _lhsIcachedvars
                   {-# LINE 1413 "../AG" #-}
                   )
              _e1Olabels =
                  ({-# LINE 20 "CodeGeneration.ag" #-}
                   _lhsIlabels
                   {-# LINE 1418 "../AG" #-}
                   )
              _e1OlocalVars =
                  ({-# LINE 152 "CodeGeneration.ag" #-}
                   _lhsIlocalVars
                   {-# LINE 1423 "../AG" #-}
                   )
              _e1Osyms =
                  ({-# LINE 180 "CodeGeneration.ag" #-}
                   _lhsIsyms
                   {-# LINE 1428 "../AG" #-}
                   )
              _e2Ocachedvars =
                  ({-# LINE 58 "CodeGeneration.ag" #-}
                   _lhsIcachedvars
                   {-# LINE 1433 "../AG" #-}
                   )
              _e2Olabels =
                  ({-# LINE 20 "CodeGeneration.ag" #-}
                   _e1Ilabels
                   {-# LINE 1438 "../AG" #-}
                   )
              _e2OlocalVars =
                  ({-# LINE 152 "CodeGeneration.ag" #-}
                   _lhsIlocalVars
                   {-# LINE 1443 "../AG" #-}
                   )
              _e2Osyms =
                  ({-# LINE 180 "CodeGeneration.ag" #-}
                   _lhsIsyms
                   {-# LINE 1448 "../AG" #-}
                   )
              ( _e1Iann,_e1Icodes,_e1Ilabels,_e1Iusedvars) =
                  e1_ _e1Ocachedvars _e1Olabels _e1OlocalVars _e1Osyms
              ( _e2Iann,_e2Icodes,_e2Ilabels,_e2Iusedvars) =
                  e2_ _e2Ocachedvars _e2Olabels _e2OlocalVars _e2Osyms
          in  ( _lhsOann,_lhsOcodes,_lhsOlabels,_lhsOusedvars)))
sem_Exp_True_ :: T_Exp
sem_Exp_True_ =
    (\ _lhsIcachedvars
       _lhsIlabels
       _lhsIlocalVars
       _lhsIsyms ->
         (let _lhsOusedvars :: ([Ident])
              _lhsOcodes :: CodeS
              _lhsOann :: String
              _lhsOlabels :: ([Label])
              _lhsOusedvars =
                  ({-# LINE 104 "CodeGeneration.ag" #-}
                   []
                   {-# LINE 1468 "../AG" #-}
                   )
              _ann =
                  ({-# LINE 198 "CodeGeneration.ag" #-}
                   "True"
                   {-# LINE 1473 "../AG" #-}
                   )
              _annote =
                  ({-# LINE 212 "CodeGeneration.ag" #-}
                   annote SP 0 0 "green" _ann
                   {-# LINE 1478 "../AG" #-}
                   )
              _lhsOcodes =
                  ({-# LINE 259 "CodeGeneration.ag" #-}
                   ldc 1 . _annote
                   {-# LINE 1483 "../AG" #-}
                   )
              _lhsOann =
                  ({-# LINE 192 "CodeGeneration.ag" #-}
                   _ann
                   {-# LINE 1488 "../AG" #-}
                   )
              _lhsOlabels =
                  ({-# LINE 21 "CodeGeneration.ag" #-}
                   _lhsIlabels
                   {-# LINE 1493 "../AG" #-}
                   )
          in  ( _lhsOann,_lhsOcodes,_lhsOlabels,_lhsOusedvars)))
sem_Exp_Var :: Ident ->
               T_Exp
sem_Exp_Var x_ =
    (\ _lhsIcachedvars
       _lhsIlabels
       _lhsIlocalVars
       _lhsIsyms ->
         (let _lhsOusedvars :: ([Ident])
              _lhsOcodes :: CodeS
              _lhsOann :: String
              _lhsOlabels :: ([Label])
              _lhsOusedvars =
                  ({-# LINE 105 "CodeGeneration.ag" #-}
                   [x_]
                   {-# LINE 1510 "../AG" #-}
                   )
              _ann =
                  ({-# LINE 199 "CodeGeneration.ag" #-}
                   x_
                   {-# LINE 1515 "../AG" #-}
                   )
              _annote =
                  ({-# LINE 212 "CodeGeneration.ag" #-}
                   annote SP 0 0 "green" _ann
                   {-# LINE 1520 "../AG" #-}
                   )
              _lhsOcodes =
                  ({-# LINE 260 "CodeGeneration.ag" #-}
                   get' (length _lhsIlocalVars) x_ _lhsIsyms (removeLocals _lhsIcachedvars _lhsIsyms) . _annote
                   {-# LINE 1525 "../AG" #-}
                   )
              _lhsOann =
                  ({-# LINE 192 "CodeGeneration.ag" #-}
                   _ann
                   {-# LINE 1530 "../AG" #-}
                   )
              _lhsOlabels =
                  ({-# LINE 21 "CodeGeneration.ag" #-}
                   _lhsIlabels
                   {-# LINE 1535 "../AG" #-}
                   )
          in  ( _lhsOann,_lhsOcodes,_lhsOlabels,_lhsOusedvars)))
-- Exps --------------------------------------------------------
type Exps = [Exp]
-- cata
sem_Exps :: Exps ->
            T_Exps
sem_Exps list =
    (Prelude.foldr sem_Exps_Cons sem_Exps_Nil (Prelude.map sem_Exp list))
-- semantic domain
type T_Exps = ([CachedVar]) ->
              ([Label]) ->
              Env ->
              Syms ->
              ( ([String]),CodeS,([Label]),([Ident]))
data Inh_Exps = Inh_Exps {cachedvars_Inh_Exps :: ([CachedVar]),labels_Inh_Exps :: ([Label]),localVars_Inh_Exps :: Env,syms_Inh_Exps :: Syms}
data Syn_Exps = Syn_Exps {anns_Syn_Exps :: ([String]),codes_Syn_Exps :: CodeS,labels_Syn_Exps :: ([Label]),usedvars_Syn_Exps :: ([Ident])}
wrap_Exps :: T_Exps ->
             Inh_Exps ->
             Syn_Exps
wrap_Exps sem (Inh_Exps _lhsIcachedvars _lhsIlabels _lhsIlocalVars _lhsIsyms) =
    (let ( _lhsOanns,_lhsOcodes,_lhsOlabels,_lhsOusedvars) = sem _lhsIcachedvars _lhsIlabels _lhsIlocalVars _lhsIsyms
     in  (Syn_Exps _lhsOanns _lhsOcodes _lhsOlabels _lhsOusedvars))
sem_Exps_Cons :: T_Exp ->
                 T_Exps ->
                 T_Exps
sem_Exps_Cons hd_ tl_ =
    (\ _lhsIcachedvars
       _lhsIlabels
       _lhsIlocalVars
       _lhsIsyms ->
         (let _lhsOanns :: ([String])
              _lhsOcodes :: CodeS
              _lhsOusedvars :: ([Ident])
              _lhsOlabels :: ([Label])
              _hdOcachedvars :: ([CachedVar])
              _hdOlabels :: ([Label])
              _hdOlocalVars :: Env
              _hdOsyms :: Syms
              _tlOcachedvars :: ([CachedVar])
              _tlOlabels :: ([Label])
              _tlOlocalVars :: Env
              _tlOsyms :: Syms
              _hdIann :: String
              _hdIcodes :: CodeS
              _hdIlabels :: ([Label])
              _hdIusedvars :: ([Ident])
              _tlIanns :: ([String])
              _tlIcodes :: CodeS
              _tlIlabels :: ([Label])
              _tlIusedvars :: ([Ident])
              _lhsOanns =
                  ({-# LINE 210 "CodeGeneration.ag" #-}
                   _hdIann : _tlIanns
                   {-# LINE 1590 "../AG" #-}
                   )
              _lhsOcodes =
                  ({-# LINE 219 "CodeGeneration.ag" #-}
                   _hdIcodes . _tlIcodes
                   {-# LINE 1595 "../AG" #-}
                   )
              _lhsOusedvars =
                  ({-# LINE 87 "CodeGeneration.ag" #-}
                   _hdIusedvars ++ _tlIusedvars
                   {-# LINE 1600 "../AG" #-}
                   )
              _lhsOlabels =
                  ({-# LINE 21 "CodeGeneration.ag" #-}
                   _tlIlabels
                   {-# LINE 1605 "../AG" #-}
                   )
              _hdOcachedvars =
                  ({-# LINE 58 "CodeGeneration.ag" #-}
                   _lhsIcachedvars
                   {-# LINE 1610 "../AG" #-}
                   )
              _hdOlabels =
                  ({-# LINE 20 "CodeGeneration.ag" #-}
                   _lhsIlabels
                   {-# LINE 1615 "../AG" #-}
                   )
              _hdOlocalVars =
                  ({-# LINE 152 "CodeGeneration.ag" #-}
                   _lhsIlocalVars
                   {-# LINE 1620 "../AG" #-}
                   )
              _hdOsyms =
                  ({-# LINE 180 "CodeGeneration.ag" #-}
                   _lhsIsyms
                   {-# LINE 1625 "../AG" #-}
                   )
              _tlOcachedvars =
                  ({-# LINE 58 "CodeGeneration.ag" #-}
                   _lhsIcachedvars
                   {-# LINE 1630 "../AG" #-}
                   )
              _tlOlabels =
                  ({-# LINE 20 "CodeGeneration.ag" #-}
                   _hdIlabels
                   {-# LINE 1635 "../AG" #-}
                   )
              _tlOlocalVars =
                  ({-# LINE 152 "CodeGeneration.ag" #-}
                   _lhsIlocalVars
                   {-# LINE 1640 "../AG" #-}
                   )
              _tlOsyms =
                  ({-# LINE 180 "CodeGeneration.ag" #-}
                   _lhsIsyms
                   {-# LINE 1645 "../AG" #-}
                   )
              ( _hdIann,_hdIcodes,_hdIlabels,_hdIusedvars) =
                  hd_ _hdOcachedvars _hdOlabels _hdOlocalVars _hdOsyms
              ( _tlIanns,_tlIcodes,_tlIlabels,_tlIusedvars) =
                  tl_ _tlOcachedvars _tlOlabels _tlOlocalVars _tlOsyms
          in  ( _lhsOanns,_lhsOcodes,_lhsOlabels,_lhsOusedvars)))
sem_Exps_Nil :: T_Exps
sem_Exps_Nil =
    (\ _lhsIcachedvars
       _lhsIlabels
       _lhsIlocalVars
       _lhsIsyms ->
         (let _lhsOusedvars :: ([Ident])
              _lhsOanns :: ([String])
              _lhsOcodes :: CodeS
              _lhsOlabels :: ([Label])
              _lhsOusedvars =
                  ({-# LINE 116 "CodeGeneration.ag" #-}
                   []
                   {-# LINE 1665 "../AG" #-}
                   )
              _lhsOanns =
                  ({-# LINE 209 "CodeGeneration.ag" #-}
                   []
                   {-# LINE 1670 "../AG" #-}
                   )
              _lhsOcodes =
                  ({-# LINE 219 "CodeGeneration.ag" #-}
                   id
                   {-# LINE 1675 "../AG" #-}
                   )
              _lhsOlabels =
                  ({-# LINE 21 "CodeGeneration.ag" #-}
                   _lhsIlabels
                   {-# LINE 1680 "../AG" #-}
                   )
          in  ( _lhsOanns,_lhsOcodes,_lhsOlabels,_lhsOusedvars)))
-- Prog --------------------------------------------------------
data Prog = TopLevelDecls (Decls)
-- cata
sem_Prog :: Prog ->
            T_Prog
sem_Prog (TopLevelDecls _ds) =
    (sem_Prog_TopLevelDecls (sem_Decls _ds))
-- semantic domain
type T_Prog = ( Code,([Ident]))
data Inh_Prog = Inh_Prog {}
data Syn_Prog = Syn_Prog {code_Syn_Prog :: Code,usedvars_Syn_Prog :: ([Ident])}
wrap_Prog :: T_Prog ->
             Inh_Prog ->
             Syn_Prog
wrap_Prog sem (Inh_Prog) =
    (let ( _lhsOcode,_lhsOusedvars) = sem
     in  (Syn_Prog _lhsOcode _lhsOusedvars))
sem_Prog_TopLevelDecls :: T_Decls ->
                          T_Prog
sem_Prog_TopLevelDecls ds_ =
    (let _dsOlabels :: ([Label])
         _dsOoffset :: Int
         _lhsOusedvars :: ([Ident])
         _dsOsyms :: Syms
         _lhsOcode :: Code
         _dsIcodes :: CodeS
         _dsIenv :: Env
         _dsIlabels :: ([Label])
         _dsIoffset :: Int
         _dsIusedvars :: ([Ident])
         _dsOlabels =
             ({-# LINE 23 "CodeGeneration.ag" #-}
              [0 ..]
              {-# LINE 1716 "../AG" #-}
              )
         _dsOoffset =
             ({-# LINE 44 "CodeGeneration.ag" #-}
              1
              {-# LINE 1721 "../AG" #-}
              )
         _lhsOusedvars =
             ({-# LINE 89 "CodeGeneration.ag" #-}
              _dsIusedvars
              {-# LINE 1726 "../AG" #-}
              )
         _dsOsyms =
             ({-# LINE 182 "CodeGeneration.ag" #-}
              [_dsIenv]
              {-# LINE 1731 "../AG" #-}
              )
         _codes =
             ({-# LINE 221 "CodeGeneration.ag" #-}
              _dsIcodes .
              enter _dsIenv .
              call "main" [_dsIenv] .
              ajs (- 1) .
              exit _dsIenv
              {-# LINE 1740 "../AG" #-}
              )
         _lhsOcode =
             ({-# LINE 273 "CodeGeneration.ag" #-}
              Code (_codes     [])
              {-# LINE 1745 "../AG" #-}
              )
         ( _dsIcodes,_dsIenv,_dsIlabels,_dsIoffset,_dsIusedvars) =
             ds_ _dsOlabels _dsOoffset _dsOsyms
     in  ( _lhsOcode,_lhsOusedvars))
-- Stmt --------------------------------------------------------
data Stmt = Assign (Ident) (Exp)
          | Block (Stmts)
          | Call_ (Ident) (Exps)
          | Decl (Decl)
          | Empty
          | If (Exp) (Stmt) (Stmt)
          | Print (Exp)
          | Return (Exp)
-- cata
sem_Stmt :: Stmt ->
            T_Stmt
sem_Stmt (Assign _x _e) =
    (sem_Stmt_Assign _x (sem_Exp _e))
sem_Stmt (Block _b) =
    (sem_Stmt_Block (sem_Stmts _b))
sem_Stmt (Call_ _f _es) =
    (sem_Stmt_Call_ _f (sem_Exps _es))
sem_Stmt (Decl _d) =
    (sem_Stmt_Decl (sem_Decl _d))
sem_Stmt (Empty) =
    (sem_Stmt_Empty)
sem_Stmt (If _e _s1 _s2) =
    (sem_Stmt_If (sem_Exp _e) (sem_Stmt _s1) (sem_Stmt _s2))
sem_Stmt (Print _e) =
    (sem_Stmt_Print (sem_Exp _e))
sem_Stmt (Return _e) =
    (sem_Stmt_Return (sem_Exp _e))
-- semantic domain
type T_Stmt = ([CachedVar]) ->
              ([Label]) ->
              Env ->
              Int ->
              Syms ->
              ( CodeS,Env,([Label]),Int,([Ident]))
data Inh_Stmt = Inh_Stmt {cachedvars_Inh_Stmt :: ([CachedVar]),labels_Inh_Stmt :: ([Label]),localVars_Inh_Stmt :: Env,offset_Inh_Stmt :: Int,syms_Inh_Stmt :: Syms}
data Syn_Stmt = Syn_Stmt {codes_Syn_Stmt :: CodeS,env_Syn_Stmt :: Env,labels_Syn_Stmt :: ([Label]),offset_Syn_Stmt :: Int,usedvars_Syn_Stmt :: ([Ident])}
wrap_Stmt :: T_Stmt ->
             Inh_Stmt ->
             Syn_Stmt
wrap_Stmt sem (Inh_Stmt _lhsIcachedvars _lhsIlabels _lhsIlocalVars _lhsIoffset _lhsIsyms) =
    (let ( _lhsOcodes,_lhsOenv,_lhsOlabels,_lhsOoffset,_lhsOusedvars) = sem _lhsIcachedvars _lhsIlabels _lhsIlocalVars _lhsIoffset _lhsIsyms
     in  (Syn_Stmt _lhsOcodes _lhsOenv _lhsOlabels _lhsOoffset _lhsOusedvars))
sem_Stmt_Assign :: Ident ->
                   T_Exp ->
                   T_Stmt
sem_Stmt_Assign x_ e_ =
    (\ _lhsIcachedvars
       _lhsIlabels
       _lhsIlocalVars
       _lhsIoffset
       _lhsIsyms ->
         (let _lhsOusedvars :: ([Ident])
              _lhsOcodes :: CodeS
              _lhsOenv :: Env
              _lhsOlabels :: ([Label])
              _lhsOoffset :: Int
              _eOcachedvars :: ([CachedVar])
              _eOlabels :: ([Label])
              _eOlocalVars :: Env
              _eOsyms :: Syms
              _eIann :: String
              _eIcodes :: CodeS
              _eIlabels :: ([Label])
              _eIusedvars :: ([Ident])
              _lhsOusedvars =
                  ({-# LINE 93 "CodeGeneration.ag" #-}
                   x_ : _eIusedvars
                   {-# LINE 1818 "../AG" #-}
                   )
              _lhsOcodes =
                  ({-# LINE 240 "CodeGeneration.ag" #-}
                   _eIcodes . set' (length _lhsIlocalVars) x_ _lhsIsyms (removeLocals _lhsIcachedvars _lhsIsyms)
                   {-# LINE 1823 "../AG" #-}
                   )
              _lhsOenv =
                  ({-# LINE 142 "CodeGeneration.ag" #-}
                   []
                   {-# LINE 1828 "../AG" #-}
                   )
              _lhsOlabels =
                  ({-# LINE 21 "CodeGeneration.ag" #-}
                   _eIlabels
                   {-# LINE 1833 "../AG" #-}
                   )
              _lhsOoffset =
                  ({-# LINE 42 "CodeGeneration.ag" #-}
                   _lhsIoffset
                   {-# LINE 1838 "../AG" #-}
                   )
              _eOcachedvars =
                  ({-# LINE 58 "CodeGeneration.ag" #-}
                   _lhsIcachedvars
                   {-# LINE 1843 "../AG" #-}
                   )
              _eOlabels =
                  ({-# LINE 20 "CodeGeneration.ag" #-}
                   _lhsIlabels
                   {-# LINE 1848 "../AG" #-}
                   )
              _eOlocalVars =
                  ({-# LINE 152 "CodeGeneration.ag" #-}
                   _lhsIlocalVars
                   {-# LINE 1853 "../AG" #-}
                   )
              _eOsyms =
                  ({-# LINE 180 "CodeGeneration.ag" #-}
                   _lhsIsyms
                   {-# LINE 1858 "../AG" #-}
                   )
              ( _eIann,_eIcodes,_eIlabels,_eIusedvars) =
                  e_ _eOcachedvars _eOlabels _eOlocalVars _eOsyms
          in  ( _lhsOcodes,_lhsOenv,_lhsOlabels,_lhsOoffset,_lhsOusedvars)))
sem_Stmt_Block :: T_Stmts ->
                  T_Stmt
sem_Stmt_Block b_ =
    (\ _lhsIcachedvars
       _lhsIlabels
       _lhsIlocalVars
       _lhsIoffset
       _lhsIsyms ->
         (let _lhsOoffset :: Int
              _lhsOusedvars :: ([Ident])
              _lhsOenv :: Env
              _bOsyms :: Syms
              _lhsOcodes :: CodeS
              _lhsOlabels :: ([Label])
              _bOcachedvars :: ([CachedVar])
              _bOlabels :: ([Label])
              _bOlocalVars :: Env
              _bOoffset :: Int
              _bIcodes :: CodeS
              _bIenv :: Env
              _bIlabels :: ([Label])
              _bIoffset :: Int
              _bIusedvars :: ([Ident])
              _lhsOoffset =
                  ({-# LINE 47 "CodeGeneration.ag" #-}
                   _lhsIoffset
                   {-# LINE 1889 "../AG" #-}
                   )
              _lhsOusedvars =
                  ({-# LINE 98 "CodeGeneration.ag" #-}
                   _bIusedvars
                   {-# LINE 1894 "../AG" #-}
                   )
              _lhsOenv =
                  ({-# LINE 147 "CodeGeneration.ag" #-}
                   []
                   {-# LINE 1899 "../AG" #-}
                   )
              _bOsyms =
                  ({-# LINE 184 "CodeGeneration.ag" #-}
                   let local : global = _lhsIsyms
                   in  (local ++ _bIenv) : global
                   {-# LINE 1905 "../AG" #-}
                   )
              _lhsOcodes =
                  ({-# LINE 253 "CodeGeneration.ag" #-}
                   enter _bIenv .
                   _bIcodes .
                   exit _bIenv
                   {-# LINE 1912 "../AG" #-}
                   )
              _lhsOlabels =
                  ({-# LINE 21 "CodeGeneration.ag" #-}
                   _bIlabels
                   {-# LINE 1917 "../AG" #-}
                   )
              _bOcachedvars =
                  ({-# LINE 58 "CodeGeneration.ag" #-}
                   _lhsIcachedvars
                   {-# LINE 1922 "../AG" #-}
                   )
              _bOlabels =
                  ({-# LINE 20 "CodeGeneration.ag" #-}
                   _lhsIlabels
                   {-# LINE 1927 "../AG" #-}
                   )
              _bOlocalVars =
                  ({-# LINE 152 "CodeGeneration.ag" #-}
                   _lhsIlocalVars
                   {-# LINE 1932 "../AG" #-}
                   )
              _bOoffset =
                  ({-# LINE 41 "CodeGeneration.ag" #-}
                   _lhsIoffset
                   {-# LINE 1937 "../AG" #-}
                   )
              ( _bIcodes,_bIenv,_bIlabels,_bIoffset,_bIusedvars) =
                  b_ _bOcachedvars _bOlabels _bOlocalVars _bOoffset _bOsyms
          in  ( _lhsOcodes,_lhsOenv,_lhsOlabels,_lhsOoffset,_lhsOusedvars)))
sem_Stmt_Call_ :: Ident ->
                  T_Exps ->
                  T_Stmt
sem_Stmt_Call_ f_ es_ =
    (\ _lhsIcachedvars
       _lhsIlabels
       _lhsIlocalVars
       _lhsIoffset
       _lhsIsyms ->
         (let _lhsOusedvars :: ([Ident])
              _lhsOcodes :: CodeS
              _lhsOenv :: Env
              _lhsOlabels :: ([Label])
              _lhsOoffset :: Int
              _esOcachedvars :: ([CachedVar])
              _esOlabels :: ([Label])
              _esOlocalVars :: Env
              _esOsyms :: Syms
              _esIanns :: ([String])
              _esIcodes :: CodeS
              _esIlabels :: ([Label])
              _esIusedvars :: ([Ident])
              _lhsOusedvars =
                  ({-# LINE 94 "CodeGeneration.ag" #-}
                   _esIusedvars
                   {-# LINE 1967 "../AG" #-}
                   )
              _lhsOcodes =
                  ({-# LINE 241 "CodeGeneration.ag" #-}
                   _esIcodes .
                   call f_ _lhsIsyms .
                   ajs (- 1)
                   {-# LINE 1974 "../AG" #-}
                   )
              _lhsOenv =
                  ({-# LINE 142 "CodeGeneration.ag" #-}
                   []
                   {-# LINE 1979 "../AG" #-}
                   )
              _lhsOlabels =
                  ({-# LINE 21 "CodeGeneration.ag" #-}
                   _esIlabels
                   {-# LINE 1984 "../AG" #-}
                   )
              _lhsOoffset =
                  ({-# LINE 42 "CodeGeneration.ag" #-}
                   _lhsIoffset
                   {-# LINE 1989 "../AG" #-}
                   )
              _esOcachedvars =
                  ({-# LINE 58 "CodeGeneration.ag" #-}
                   _lhsIcachedvars
                   {-# LINE 1994 "../AG" #-}
                   )
              _esOlabels =
                  ({-# LINE 20 "CodeGeneration.ag" #-}
                   _lhsIlabels
                   {-# LINE 1999 "../AG" #-}
                   )
              _esOlocalVars =
                  ({-# LINE 152 "CodeGeneration.ag" #-}
                   _lhsIlocalVars
                   {-# LINE 2004 "../AG" #-}
                   )
              _esOsyms =
                  ({-# LINE 180 "CodeGeneration.ag" #-}
                   _lhsIsyms
                   {-# LINE 2009 "../AG" #-}
                   )
              ( _esIanns,_esIcodes,_esIlabels,_esIusedvars) =
                  es_ _esOcachedvars _esOlabels _esOlocalVars _esOsyms
          in  ( _lhsOcodes,_lhsOenv,_lhsOlabels,_lhsOoffset,_lhsOusedvars)))
sem_Stmt_Decl :: T_Decl ->
                 T_Stmt
sem_Stmt_Decl d_ =
    (\ _lhsIcachedvars
       _lhsIlabels
       _lhsIlocalVars
       _lhsIoffset
       _lhsIsyms ->
         (let _lhsOusedvars :: ([Ident])
              _lhsOcodes :: CodeS
              _lhsOenv :: Env
              _lhsOlabels :: ([Label])
              _lhsOoffset :: Int
              _dOlabels :: ([Label])
              _dOoffset :: Int
              _dOsyms :: Syms
              _dIcodes :: CodeS
              _dIenv :: Env
              _dIlabels :: ([Label])
              _dIoffset :: Int
              _dIusedvars :: ([Ident])
              _lhsOusedvars =
                  ({-# LINE 100 "CodeGeneration.ag" #-}
                   []
                   {-# LINE 2038 "../AG" #-}
                   )
              _lhsOcodes =
                  ({-# LINE 219 "CodeGeneration.ag" #-}
                   _dIcodes
                   {-# LINE 2043 "../AG" #-}
                   )
              _lhsOenv =
                  ({-# LINE 142 "CodeGeneration.ag" #-}
                   _dIenv
                   {-# LINE 2048 "../AG" #-}
                   )
              _lhsOlabels =
                  ({-# LINE 21 "CodeGeneration.ag" #-}
                   _dIlabels
                   {-# LINE 2053 "../AG" #-}
                   )
              _lhsOoffset =
                  ({-# LINE 42 "CodeGeneration.ag" #-}
                   _dIoffset
                   {-# LINE 2058 "../AG" #-}
                   )
              _dOlabels =
                  ({-# LINE 20 "CodeGeneration.ag" #-}
                   _lhsIlabels
                   {-# LINE 2063 "../AG" #-}
                   )
              _dOoffset =
                  ({-# LINE 41 "CodeGeneration.ag" #-}
                   _lhsIoffset
                   {-# LINE 2068 "../AG" #-}
                   )
              _dOsyms =
                  ({-# LINE 180 "CodeGeneration.ag" #-}
                   _lhsIsyms
                   {-# LINE 2073 "../AG" #-}
                   )
              ( _dIcodes,_dIenv,_dIlabels,_dIoffset,_dIusedvars) =
                  d_ _dOlabels _dOoffset _dOsyms
          in  ( _lhsOcodes,_lhsOenv,_lhsOlabels,_lhsOoffset,_lhsOusedvars)))
sem_Stmt_Empty :: T_Stmt
sem_Stmt_Empty =
    (\ _lhsIcachedvars
       _lhsIlabels
       _lhsIlocalVars
       _lhsIoffset
       _lhsIsyms ->
         (let _lhsOusedvars :: ([Ident])
              _lhsOcodes :: CodeS
              _lhsOenv :: Env
              _lhsOlabels :: ([Label])
              _lhsOoffset :: Int
              _lhsOusedvars =
                  ({-# LINE 99 "CodeGeneration.ag" #-}
                   []
                   {-# LINE 2093 "../AG" #-}
                   )
              _lhsOcodes =
                  ({-# LINE 219 "CodeGeneration.ag" #-}
                   id
                   {-# LINE 2098 "../AG" #-}
                   )
              _lhsOenv =
                  ({-# LINE 142 "CodeGeneration.ag" #-}
                   []
                   {-# LINE 2103 "../AG" #-}
                   )
              _lhsOlabels =
                  ({-# LINE 21 "CodeGeneration.ag" #-}
                   _lhsIlabels
                   {-# LINE 2108 "../AG" #-}
                   )
              _lhsOoffset =
                  ({-# LINE 42 "CodeGeneration.ag" #-}
                   _lhsIoffset
                   {-# LINE 2113 "../AG" #-}
                   )
          in  ( _lhsOcodes,_lhsOenv,_lhsOlabels,_lhsOoffset,_lhsOusedvars)))
sem_Stmt_If :: T_Exp ->
               T_Stmt ->
               T_Stmt ->
               T_Stmt
sem_Stmt_If e_ s1_ s2_ =
    (\ _lhsIcachedvars
       _lhsIlabels
       _lhsIlocalVars
       _lhsIoffset
       _lhsIsyms ->
         (let _eOlabels :: ([Label])
              _lhsOusedvars :: ([Ident])
              _lhsOcodes :: CodeS
              _lhsOenv :: Env
              _lhsOlabels :: ([Label])
              _lhsOoffset :: Int
              _eOcachedvars :: ([CachedVar])
              _eOlocalVars :: Env
              _eOsyms :: Syms
              _s1Ocachedvars :: ([CachedVar])
              _s1Olabels :: ([Label])
              _s1OlocalVars :: Env
              _s1Ooffset :: Int
              _s1Osyms :: Syms
              _s2Ocachedvars :: ([CachedVar])
              _s2Olabels :: ([Label])
              _s2OlocalVars :: Env
              _s2Ooffset :: Int
              _s2Osyms :: Syms
              _eIann :: String
              _eIcodes :: CodeS
              _eIlabels :: ([Label])
              _eIusedvars :: ([Ident])
              _s1Icodes :: CodeS
              _s1Ienv :: Env
              _s1Ilabels :: ([Label])
              _s1Ioffset :: Int
              _s1Iusedvars :: ([Ident])
              _s2Icodes :: CodeS
              _s2Ienv :: Env
              _s2Ilabels :: ([Label])
              _s2Ioffset :: Int
              _s2Iusedvars :: ([Ident])
              _elseLabel =
                  ({-# LINE 29 "CodeGeneration.ag" #-}
                   _lhsIlabels !! 0
                   {-# LINE 2162 "../AG" #-}
                   )
              _fiLabel =
                  ({-# LINE 30 "CodeGeneration.ag" #-}
                   _lhsIlabels !! 1
                   {-# LINE 2167 "../AG" #-}
                   )
              _eOlabels =
                  ({-# LINE 31 "CodeGeneration.ag" #-}
                   drop 2 _lhsIlabels
                   {-# LINE 2172 "../AG" #-}
                   )
              _lhsOusedvars =
                  ({-# LINE 97 "CodeGeneration.ag" #-}
                   _eIusedvars ++ _s1Iusedvars ++ _s2Iusedvars
                   {-# LINE 2177 "../AG" #-}
                   )
              _lhsOcodes =
                  ({-# LINE 246 "CodeGeneration.ag" #-}
                   _eIcodes .
                   brf _elseLabel     .
                   _s1Icodes .
                   bra _fiLabel     .
                   label _elseLabel     .
                     _s2Icodes .
                   label _fiLabel
                   {-# LINE 2188 "../AG" #-}
                   )
              _lhsOenv =
                  ({-# LINE 142 "CodeGeneration.ag" #-}
                   _s1Ienv ++ _s2Ienv
                   {-# LINE 2193 "../AG" #-}
                   )
              _lhsOlabels =
                  ({-# LINE 21 "CodeGeneration.ag" #-}
                   _s2Ilabels
                   {-# LINE 2198 "../AG" #-}
                   )
              _lhsOoffset =
                  ({-# LINE 42 "CodeGeneration.ag" #-}
                   _s2Ioffset
                   {-# LINE 2203 "../AG" #-}
                   )
              _eOcachedvars =
                  ({-# LINE 58 "CodeGeneration.ag" #-}
                   _lhsIcachedvars
                   {-# LINE 2208 "../AG" #-}
                   )
              _eOlocalVars =
                  ({-# LINE 152 "CodeGeneration.ag" #-}
                   _lhsIlocalVars
                   {-# LINE 2213 "../AG" #-}
                   )
              _eOsyms =
                  ({-# LINE 180 "CodeGeneration.ag" #-}
                   _lhsIsyms
                   {-# LINE 2218 "../AG" #-}
                   )
              _s1Ocachedvars =
                  ({-# LINE 58 "CodeGeneration.ag" #-}
                   _lhsIcachedvars
                   {-# LINE 2223 "../AG" #-}
                   )
              _s1Olabels =
                  ({-# LINE 20 "CodeGeneration.ag" #-}
                   _eIlabels
                   {-# LINE 2228 "../AG" #-}
                   )
              _s1OlocalVars =
                  ({-# LINE 152 "CodeGeneration.ag" #-}
                   _lhsIlocalVars
                   {-# LINE 2233 "../AG" #-}
                   )
              _s1Ooffset =
                  ({-# LINE 41 "CodeGeneration.ag" #-}
                   _lhsIoffset
                   {-# LINE 2238 "../AG" #-}
                   )
              _s1Osyms =
                  ({-# LINE 180 "CodeGeneration.ag" #-}
                   _lhsIsyms
                   {-# LINE 2243 "../AG" #-}
                   )
              _s2Ocachedvars =
                  ({-# LINE 58 "CodeGeneration.ag" #-}
                   _lhsIcachedvars
                   {-# LINE 2248 "../AG" #-}
                   )
              _s2Olabels =
                  ({-# LINE 20 "CodeGeneration.ag" #-}
                   _s1Ilabels
                   {-# LINE 2253 "../AG" #-}
                   )
              _s2OlocalVars =
                  ({-# LINE 152 "CodeGeneration.ag" #-}
                   _lhsIlocalVars
                   {-# LINE 2258 "../AG" #-}
                   )
              _s2Ooffset =
                  ({-# LINE 41 "CodeGeneration.ag" #-}
                   _s1Ioffset
                   {-# LINE 2263 "../AG" #-}
                   )
              _s2Osyms =
                  ({-# LINE 180 "CodeGeneration.ag" #-}
                   _lhsIsyms
                   {-# LINE 2268 "../AG" #-}
                   )
              ( _eIann,_eIcodes,_eIlabels,_eIusedvars) =
                  e_ _eOcachedvars _eOlabels _eOlocalVars _eOsyms
              ( _s1Icodes,_s1Ienv,_s1Ilabels,_s1Ioffset,_s1Iusedvars) =
                  s1_ _s1Ocachedvars _s1Olabels _s1OlocalVars _s1Ooffset _s1Osyms
              ( _s2Icodes,_s2Ienv,_s2Ilabels,_s2Ioffset,_s2Iusedvars) =
                  s2_ _s2Ocachedvars _s2Olabels _s2OlocalVars _s2Ooffset _s2Osyms
          in  ( _lhsOcodes,_lhsOenv,_lhsOlabels,_lhsOoffset,_lhsOusedvars)))
sem_Stmt_Print :: T_Exp ->
                  T_Stmt
sem_Stmt_Print e_ =
    (\ _lhsIcachedvars
       _lhsIlabels
       _lhsIlocalVars
       _lhsIoffset
       _lhsIsyms ->
         (let _lhsOusedvars :: ([Ident])
              _lhsOcodes :: CodeS
              _lhsOenv :: Env
              _lhsOlabels :: ([Label])
              _lhsOoffset :: Int
              _eOcachedvars :: ([CachedVar])
              _eOlabels :: ([Label])
              _eOlocalVars :: Env
              _eOsyms :: Syms
              _eIann :: String
              _eIcodes :: CodeS
              _eIlabels :: ([Label])
              _eIusedvars :: ([Ident])
              _lhsOusedvars =
                  ({-# LINE 95 "CodeGeneration.ag" #-}
                   _eIusedvars
                   {-# LINE 2301 "../AG" #-}
                   )
              _lhsOcodes =
                  ({-# LINE 244 "CodeGeneration.ag" #-}
                   _eIcodes . trap 0
                   {-# LINE 2306 "../AG" #-}
                   )
              _lhsOenv =
                  ({-# LINE 142 "CodeGeneration.ag" #-}
                   []
                   {-# LINE 2311 "../AG" #-}
                   )
              _lhsOlabels =
                  ({-# LINE 21 "CodeGeneration.ag" #-}
                   _eIlabels
                   {-# LINE 2316 "../AG" #-}
                   )
              _lhsOoffset =
                  ({-# LINE 42 "CodeGeneration.ag" #-}
                   _lhsIoffset
                   {-# LINE 2321 "../AG" #-}
                   )
              _eOcachedvars =
                  ({-# LINE 58 "CodeGeneration.ag" #-}
                   _lhsIcachedvars
                   {-# LINE 2326 "../AG" #-}
                   )
              _eOlabels =
                  ({-# LINE 20 "CodeGeneration.ag" #-}
                   _lhsIlabels
                   {-# LINE 2331 "../AG" #-}
                   )
              _eOlocalVars =
                  ({-# LINE 152 "CodeGeneration.ag" #-}
                   _lhsIlocalVars
                   {-# LINE 2336 "../AG" #-}
                   )
              _eOsyms =
                  ({-# LINE 180 "CodeGeneration.ag" #-}
                   _lhsIsyms
                   {-# LINE 2341 "../AG" #-}
                   )
              ( _eIann,_eIcodes,_eIlabels,_eIusedvars) =
                  e_ _eOcachedvars _eOlabels _eOlocalVars _eOsyms
          in  ( _lhsOcodes,_lhsOenv,_lhsOlabels,_lhsOoffset,_lhsOusedvars)))
sem_Stmt_Return :: T_Exp ->
                   T_Stmt
sem_Stmt_Return e_ =
    (\ _lhsIcachedvars
       _lhsIlabels
       _lhsIlocalVars
       _lhsIoffset
       _lhsIsyms ->
         (let _lhsOusedvars :: ([Ident])
              _lhsOcodes :: CodeS
              _lhsOenv :: Env
              _lhsOlabels :: ([Label])
              _lhsOoffset :: Int
              _eOcachedvars :: ([CachedVar])
              _eOlabels :: ([Label])
              _eOlocalVars :: Env
              _eOsyms :: Syms
              _eIann :: String
              _eIcodes :: CodeS
              _eIlabels :: ([Label])
              _eIusedvars :: ([Ident])
              _lhsOusedvars =
                  ({-# LINE 96 "CodeGeneration.ag" #-}
                   _eIusedvars
                   {-# LINE 2370 "../AG" #-}
                   )
              _lhsOcodes =
                  ({-# LINE 245 "CodeGeneration.ag" #-}
                   _eIcodes . return_ _lhsIcachedvars _lhsIsyms
                   {-# LINE 2375 "../AG" #-}
                   )
              _lhsOenv =
                  ({-# LINE 142 "CodeGeneration.ag" #-}
                   []
                   {-# LINE 2380 "../AG" #-}
                   )
              _lhsOlabels =
                  ({-# LINE 21 "CodeGeneration.ag" #-}
                   _eIlabels
                   {-# LINE 2385 "../AG" #-}
                   )
              _lhsOoffset =
                  ({-# LINE 42 "CodeGeneration.ag" #-}
                   _lhsIoffset
                   {-# LINE 2390 "../AG" #-}
                   )
              _eOcachedvars =
                  ({-# LINE 58 "CodeGeneration.ag" #-}
                   _lhsIcachedvars
                   {-# LINE 2395 "../AG" #-}
                   )
              _eOlabels =
                  ({-# LINE 20 "CodeGeneration.ag" #-}
                   _lhsIlabels
                   {-# LINE 2400 "../AG" #-}
                   )
              _eOlocalVars =
                  ({-# LINE 152 "CodeGeneration.ag" #-}
                   _lhsIlocalVars
                   {-# LINE 2405 "../AG" #-}
                   )
              _eOsyms =
                  ({-# LINE 180 "CodeGeneration.ag" #-}
                   _lhsIsyms
                   {-# LINE 2410 "../AG" #-}
                   )
              ( _eIann,_eIcodes,_eIlabels,_eIusedvars) =
                  e_ _eOcachedvars _eOlabels _eOlocalVars _eOsyms
          in  ( _lhsOcodes,_lhsOenv,_lhsOlabels,_lhsOoffset,_lhsOusedvars)))
-- Stmts -------------------------------------------------------
type Stmts = [Stmt]
-- cata
sem_Stmts :: Stmts ->
             T_Stmts
sem_Stmts list =
    (Prelude.foldr sem_Stmts_Cons sem_Stmts_Nil (Prelude.map sem_Stmt list))
-- semantic domain
type T_Stmts = ([CachedVar]) ->
               ([Label]) ->
               Env ->
               Int ->
               Syms ->
               ( CodeS,Env,([Label]),Int,([Ident]))
data Inh_Stmts = Inh_Stmts {cachedvars_Inh_Stmts :: ([CachedVar]),labels_Inh_Stmts :: ([Label]),localVars_Inh_Stmts :: Env,offset_Inh_Stmts :: Int,syms_Inh_Stmts :: Syms}
data Syn_Stmts = Syn_Stmts {codes_Syn_Stmts :: CodeS,env_Syn_Stmts :: Env,labels_Syn_Stmts :: ([Label]),offset_Syn_Stmts :: Int,usedvars_Syn_Stmts :: ([Ident])}
wrap_Stmts :: T_Stmts ->
              Inh_Stmts ->
              Syn_Stmts
wrap_Stmts sem (Inh_Stmts _lhsIcachedvars _lhsIlabels _lhsIlocalVars _lhsIoffset _lhsIsyms) =
    (let ( _lhsOcodes,_lhsOenv,_lhsOlabels,_lhsOoffset,_lhsOusedvars) = sem _lhsIcachedvars _lhsIlabels _lhsIlocalVars _lhsIoffset _lhsIsyms
     in  (Syn_Stmts _lhsOcodes _lhsOenv _lhsOlabels _lhsOoffset _lhsOusedvars))
sem_Stmts_Cons :: T_Stmt ->
                  T_Stmts ->
                  T_Stmts
sem_Stmts_Cons hd_ tl_ =
    (\ _lhsIcachedvars
       _lhsIlabels
       _lhsIlocalVars
       _lhsIoffset
       _lhsIsyms ->
         (let _lhsOcodes :: CodeS
              _lhsOenv :: Env
              _lhsOusedvars :: ([Ident])
              _lhsOlabels :: ([Label])
              _lhsOoffset :: Int
              _hdOcachedvars :: ([CachedVar])
              _hdOlabels :: ([Label])
              _hdOlocalVars :: Env
              _hdOoffset :: Int
              _hdOsyms :: Syms
              _tlOcachedvars :: ([CachedVar])
              _tlOlabels :: ([Label])
              _tlOlocalVars :: Env
              _tlOoffset :: Int
              _tlOsyms :: Syms
              _hdIcodes :: CodeS
              _hdIenv :: Env
              _hdIlabels :: ([Label])
              _hdIoffset :: Int
              _hdIusedvars :: ([Ident])
              _tlIcodes :: CodeS
              _tlIenv :: Env
              _tlIlabels :: ([Label])
              _tlIoffset :: Int
              _tlIusedvars :: ([Ident])
              _lhsOcodes =
                  ({-# LINE 219 "CodeGeneration.ag" #-}
                   _hdIcodes . _tlIcodes
                   {-# LINE 2474 "../AG" #-}
                   )
              _lhsOenv =
                  ({-# LINE 142 "CodeGeneration.ag" #-}
                   _hdIenv ++ _tlIenv
                   {-# LINE 2479 "../AG" #-}
                   )
              _lhsOusedvars =
                  ({-# LINE 87 "CodeGeneration.ag" #-}
                   _hdIusedvars ++ _tlIusedvars
                   {-# LINE 2484 "../AG" #-}
                   )
              _lhsOlabels =
                  ({-# LINE 21 "CodeGeneration.ag" #-}
                   _tlIlabels
                   {-# LINE 2489 "../AG" #-}
                   )
              _lhsOoffset =
                  ({-# LINE 42 "CodeGeneration.ag" #-}
                   _tlIoffset
                   {-# LINE 2494 "../AG" #-}
                   )
              _hdOcachedvars =
                  ({-# LINE 58 "CodeGeneration.ag" #-}
                   _lhsIcachedvars
                   {-# LINE 2499 "../AG" #-}
                   )
              _hdOlabels =
                  ({-# LINE 20 "CodeGeneration.ag" #-}
                   _lhsIlabels
                   {-# LINE 2504 "../AG" #-}
                   )
              _hdOlocalVars =
                  ({-# LINE 152 "CodeGeneration.ag" #-}
                   _lhsIlocalVars
                   {-# LINE 2509 "../AG" #-}
                   )
              _hdOoffset =
                  ({-# LINE 41 "CodeGeneration.ag" #-}
                   _lhsIoffset
                   {-# LINE 2514 "../AG" #-}
                   )
              _hdOsyms =
                  ({-# LINE 180 "CodeGeneration.ag" #-}
                   _lhsIsyms
                   {-# LINE 2519 "../AG" #-}
                   )
              _tlOcachedvars =
                  ({-# LINE 58 "CodeGeneration.ag" #-}
                   _lhsIcachedvars
                   {-# LINE 2524 "../AG" #-}
                   )
              _tlOlabels =
                  ({-# LINE 20 "CodeGeneration.ag" #-}
                   _hdIlabels
                   {-# LINE 2529 "../AG" #-}
                   )
              _tlOlocalVars =
                  ({-# LINE 152 "CodeGeneration.ag" #-}
                   _lhsIlocalVars
                   {-# LINE 2534 "../AG" #-}
                   )
              _tlOoffset =
                  ({-# LINE 41 "CodeGeneration.ag" #-}
                   _hdIoffset
                   {-# LINE 2539 "../AG" #-}
                   )
              _tlOsyms =
                  ({-# LINE 180 "CodeGeneration.ag" #-}
                   _lhsIsyms
                   {-# LINE 2544 "../AG" #-}
                   )
              ( _hdIcodes,_hdIenv,_hdIlabels,_hdIoffset,_hdIusedvars) =
                  hd_ _hdOcachedvars _hdOlabels _hdOlocalVars _hdOoffset _hdOsyms
              ( _tlIcodes,_tlIenv,_tlIlabels,_tlIoffset,_tlIusedvars) =
                  tl_ _tlOcachedvars _tlOlabels _tlOlocalVars _tlOoffset _tlOsyms
          in  ( _lhsOcodes,_lhsOenv,_lhsOlabels,_lhsOoffset,_lhsOusedvars)))
sem_Stmts_Nil :: T_Stmts
sem_Stmts_Nil =
    (\ _lhsIcachedvars
       _lhsIlabels
       _lhsIlocalVars
       _lhsIoffset
       _lhsIsyms ->
         (let _lhsOusedvars :: ([Ident])
              _lhsOcodes :: CodeS
              _lhsOenv :: Env
              _lhsOlabels :: ([Label])
              _lhsOoffset :: Int
              _lhsOusedvars =
                  ({-# LINE 115 "CodeGeneration.ag" #-}
                   []
                   {-# LINE 2566 "../AG" #-}
                   )
              _lhsOcodes =
                  ({-# LINE 219 "CodeGeneration.ag" #-}
                   id
                   {-# LINE 2571 "../AG" #-}
                   )
              _lhsOenv =
                  ({-# LINE 142 "CodeGeneration.ag" #-}
                   []
                   {-# LINE 2576 "../AG" #-}
                   )
              _lhsOlabels =
                  ({-# LINE 21 "CodeGeneration.ag" #-}
                   _lhsIlabels
                   {-# LINE 2581 "../AG" #-}
                   )
              _lhsOoffset =
                  ({-# LINE 42 "CodeGeneration.ag" #-}
                   _lhsIoffset
                   {-# LINE 2586 "../AG" #-}
                   )
          in  ( _lhsOcodes,_lhsOenv,_lhsOlabels,_lhsOoffset,_lhsOusedvars)))