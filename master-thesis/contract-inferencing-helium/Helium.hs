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
-- This module serves as a wrapper for the Helium compiler.
--
-----------------------------------------------------------------------------

module Domain.FP.Helium 
   ( -- * Compile functions
     compile, unsafeCompile, compile', compile_, compilePrelude
   , compileWithExtraEnv, extractTypes, extractImportEnv, compile__, compile___
   , compile'', compile'''
     -- * Helium syntax data types
   , module Syntax.UHA_Syntax, module Syntax.UHA_Range
     -- * Pretty printing
   , ppModule, ppBody, ppRhs, ppDeclaration, ppExpression, ppAlternative, ppFunctionBinding, ppPattern
     -- * Miscellaneous functions
   , patternVars, phaseDesugarer
   ) where

import Main.PhaseLexer
import Main.PhaseParser
import Main.PhaseResolveOperators
import Main.PhaseStaticChecks
import Main.PhaseTypingStrategies ()
import Main.PhaseTypeInferencer
import Main.PhaseDesugarer
import Syntax.UHA_Syntax
import Syntax.UHA_Utils
import Syntax.UHA_Range (noRange)
import qualified Syntax.UHA_Pretty as PP
--import Data.IORef
import ModuleSystem.DictionaryEnvironment
import StaticAnalysis.Messages.Messages
import StaticAnalysis.Messages.HeliumMessages
import System.IO.Unsafe (unsafePerformIO )
import Main.CompileUtils hiding (doPhaseWithExit)
import Control.Monad.Trans
import StaticAnalysis.Messages.Warnings (Warning(Shadow))
import qualified Text.PrettyPrint.Leijen as PPL

import qualified Domain.FP.HeliumImportEnvs as H
import Domain.FP.HeliumInstances ()
import qualified Data.Map as M
import Data.Maybe

-- | a Module pretty printer
ppModule :: Module -> String
ppModule m = show $
  PP.text_Syn_Module (PP.wrap_Module (PP.sem_Module m) PP.Inh_Module)
ppRhs :: RightHandSide -> String
ppRhs r = show $
  PP.text_Syn_RightHandSide (PP.wrap_RightHandSide (PP.sem_RightHandSide r) PP.Inh_RightHandSide) PPL.empty
ppBody :: Body -> String
ppBody b = show $
  PP.text_Syn_Body (PP.wrap_Body (PP.sem_Body b) PP.Inh_Body)
ppDeclaration :: Declaration -> String
ppDeclaration d = show $
  PP.text_Syn_Declaration (PP.wrap_Declaration (PP.sem_Declaration d) PP.Inh_Declaration)
ppExpression :: Expression -> String
ppExpression e = show $
  PP.text_Syn_Expression (PP.wrap_Expression (PP.sem_Expression e) PP.Inh_Expression)
ppAlternative :: Alternative -> String
ppAlternative a = show $
  PP.text_Syn_Alternative (PP.wrap_Alternative (PP.sem_Alternative a) PP.Inh_Alternative)
ppFunctionBinding :: FunctionBinding -> String
ppFunctionBinding f = show $
  PP.text_Syn_FunctionBinding (PP.wrap_FunctionBinding (PP.sem_FunctionBinding f) PP.Inh_FunctionBinding)
ppPattern :: Pattern -> String
ppPattern p = show $
  PP.text_Syn_Pattern (PP.wrap_Pattern (PP.sem_Pattern p) PP.Inh_Pattern)

filterImportEnvs :: [Name] -> [ImportEnvironment] -> [ImportEnvironment]
filterImportEnvs ns env = map f env
  where
    f :: ImportEnvironment -> ImportEnvironment
    f env = env { typeEnvironment = M.filterWithKey p (typeEnvironment env) }
    p :: Name -> tpScheme -> Bool
    p n _ = n `notElem` ns

toplevelNames :: Module -> [Name]
toplevelNames (Module_Module _ _ _ b) = 
    case b of
      Body_Hole _ _    -> []
      Body_Body _ _ ds -> mapMaybe declName ds
  where
    declName d = case d of
      Declaration_FunctionBindings _ fbs -> listToMaybe $ mapMaybe fbName fbs
      Declaration_PatternBinding _ p _   -> patName p
      _ -> Nothing
      
    fbName fb = case fb of
      FunctionBinding_Hole _ _                  -> Nothing
      FunctionBinding_FunctionBinding _ lhs rhs -> Just $ lhsName lhs
    
    patName p = case p of
      Pattern_Variable _ n       -> Just n
      Pattern_Parenthesized _ p' -> patName p'
      _                          -> Nothing
    
    lhsName lhs = case lhs of
      LeftHandSide_Function _ n _ -> n
      LeftHandSide_Infix _ _ op _ -> op
      LeftHandSide_Parenthesized _ lhs' _ -> lhsName lhs'
      

-- | the compiler/parser
unsafeCompile :: String -> Module
unsafeCompile = either (error "Helium compilation error!") id . compile

compile :: String -> Either String Module
compile = fmap (\(_,_,_,_,m) -> m) . compile' False

compileWithExtraEnv :: String -> ImportEnvironment -> 
                       Either String
                       ( DictionaryEnvironment
                       , ImportEnvironment
                       , TypeEnvironment
                       , [Warning]
                       , Module
                       )
compileWithExtraEnv = compile'' False

extractTypes :: Either String
             ( DictionaryEnvironment
             , ImportEnvironment
             , TypeEnvironment
             , [Warning]
             , Module
             ) -> TypeEnvironment
extractTypes (Right a) = (\(_,_,t,_,_) -> t) a
extractTypes (Left  a) = error a

extractImportEnv :: Either String
                    ( DictionaryEnvironment
                    , ImportEnvironment
                    , TypeEnvironment
                    , [Warning]
                    , Module
                    ) -> ImportEnvironment
extractImportEnv (Right a) = (\(_,i,_,_,_) -> i) a
extractImportEnv (Left  a) = error a


compile'' :: Bool -> String
         -> ImportEnvironment
         -> Either String
             ( DictionaryEnvironment
             , ImportEnvironment
             , TypeEnvironment
             , [Warning]
             , Module
             )
compile'' isPrelude txt extraEnv = unsafePerformIO $ do
   ea <- run $ compile__ isPrelude txt [Overloading, UseTutor] extraEnv []
   case ea of
      Left ms -> return $ Left $ unlines ms
      Right a -> return $ Right a 

compilePrelude :: String -> Either String Module
compilePrelude = fmap (\(_,_,_,_,m) -> m) . compile' True

-- | Helium compiler
--compile' :: String -> Either String Module
compile' :: Bool -> String 
         -> Either String
             ( DictionaryEnvironment
             , ImportEnvironment
             , TypeEnvironment
             , [Warning]
             , Module
             )
compile' isPrelude txt = unsafePerformIO $ do
   ea <- run $ compile_ isPrelude txt [Overloading, UseTutor] []
   case ea of
      Left ms -> return $ Left $ unlines ms
      Right a -> return $ Right a 

newtype Compile a = C { run :: IO (Either [String] a) }

instance Monad Compile where
   return = C . return . Right
   C m >>= f = C $ do 
      ea <- m
      case ea of 

         Left err -> return (Left err)
         Right a  -> do
            let C m2 = f a
            m2

instance MonadIO Compile where
   liftIO m = C $ do
      a <- m
      return (Right a)

-- | Adjusted code from Compile
compile_ :: Bool -> String -> [Option] -> t
         -> Compile ( DictionaryEnvironment
                    , ImportEnvironment
                    , TypeEnvironment
                    , [Warning]
                    , Module
                    )
compile_ isPrelude contents options doneModules = compile__ isPrelude contents options emptyEnvironment doneModules


-- | Like compile_ but with an extra ImportEnvironment parameter.
compile__ :: Bool -> String -> [Option] -> ImportEnvironment -> t
         -> Compile ( DictionaryEnvironment
                    , ImportEnvironment
                    , TypeEnvironment
                    , [Warning]
                    , Module
                    )
compile__ isPrelude contents options extraEnv doneModules =
    do
        let fullName = "Prelude"
        
        -- Phase 1: Lexing
        (lexerWarnings, tokens) <- 
            doPhaseWithExit $
               phaseLexer fullName contents options
        
        -- Phase 2: Parsing
        parsedModule <- 
            doPhaseWithExit $
               phaseParser fullName tokens options
        
        -- Phase 3: Importing
        -- We have a static import environment
        -- (indirectionDecls, importEnvs) <-
        --      liftIO $ phaseImport fullName parsedModule lvmPath options
        
        let when :: Bool -> (a -> a) -> a -> a
            when p f a = if p then f a else a
            ns = toplevelNames parsedModule
            -- Need local definitions to shadow top-level definitions:
            nonShadowedExtraEnvDefs = filterImportEnvs ns [extraEnv]
            importEnvs = nonShadowedExtraEnvDefs ++ when isPrelude (filterImportEnvs ns) H.importEnvs

        
        -- Phase 4: Resolving operators
        resolvedModule <- 
            doPhaseWithExit $
               phaseResolveOperators parsedModule importEnvs options
        
        -- Phase 5: Static checking
        (localEnv, typeSignatures, staticWarnings) <-
            doPhaseWithExit $
               phaseStaticChecks fullName resolvedModule importEnvs options 

        let localEnv' = localEnv
        
        -- Phase 6: Kind inferencing (skipped)
        let combinedEnv = foldr combineImportEnvironments localEnv' importEnvs
        -- Phase 7: Type Inference Directives (skipped)
        let beforeTypeInferEnv = combinedEnv
        
        -- Phase 8: Type inferencing
        let newOptions = if null [() | Shadow _ _ <- staticWarnings]
                            then options
                            else NoOverloadingTypeCheck : options
        (dictionaryEnv, afterTypeInferEnv, toplevelTypes, typeWarnings) <- 
            doPhaseWithExit $ 
               phaseTypeInferencer "." fullName resolvedModule localEnv' beforeTypeInferEnv newOptions
        
        return  (dictionaryEnv, afterTypeInferEnv, toplevelTypes, typeWarnings, resolvedModule)

compile''' :: Bool -> String
         -> ImportEnvironment
         -> Either String
             ( String
             )
compile''' isPrelude txt extraEnv = unsafePerformIO $ do
   ea <- run $ compile___ isPrelude txt [Overloading, UseTutor] extraEnv []
   case ea of
      Left ms -> return $ Left $ unlines ms
      Right a -> return $ Right a 

-- | Like compile_ but with an extra ImportEnvironment parameter.
compile___ :: Bool -> String -> [Option] -> ImportEnvironment -> t
         -> Compile ( String
                    )
compile___ isPrelude contents options extraEnv doneModules =
    do
        let fullName = "Prelude"
        
        -- Phase 1: Lexing
        (lexerWarnings, tokens) <- 
            doPhaseWithExit $
               phaseLexer fullName contents options
        
        -- Phase 2: Parsing
        parsedModule <- 
            doPhaseWithExit $
               phaseParser fullName tokens options
        
        -- Phase 3: Importing
        -- We have a static import environment
        -- (indirectionDecls, importEnvs) <-
        --      liftIO $ phaseImport fullName parsedModule lvmPath options
        
        let when :: Bool -> (a -> a) -> a -> a
            when p f a = if p then f a else a
            ns = toplevelNames parsedModule
            importEnvs = when isPrelude (filterImportEnvs ns) (extraEnv:H.importEnvs)

        return( show ((filterImportEnvs ns) [extraEnv]) ++ "\n\n\n" ++ show ns )
        
{-
        -- Phase 4: Resolving operators
        resolvedModule <- 
            doPhaseWithExit $
               phaseResolveOperators parsedModule importEnvs options
        
        -- Phase 5: Static checking
        (localEnv, typeSignatures, staticWarnings) <-
            doPhaseWithExit $
               phaseStaticChecks fullName resolvedModule importEnvs options 

        let localEnv' = localEnv
        
        -- Phase 6: Kind inferencing (skipped)
        let combinedEnv = foldr combineImportEnvironments localEnv' importEnvs
        -- Phase 7: Type Inference Directives (skipped)
        let beforeTypeInferEnv = combinedEnv
        
        -- Phase 8: Type inferencing
        let newOptions = if null [() | Shadow _ _ <- staticWarnings]
                            then options
                            else NoOverloadingTypeCheck : options
        (dictionaryEnv, afterTypeInferEnv, toplevelTypes, typeWarnings) <- 
            doPhaseWithExit $ 
               phaseTypeInferencer "." fullName resolvedModule localEnv' beforeTypeInferEnv newOptions
        
        return  (dictionaryEnv, afterTypeInferEnv, toplevelTypes, typeWarnings, resolvedModule)
-}

-- | Adjusted code from CompileUtils
doPhaseWithExit :: HasMessage err => Phase err a -> Compile a
doPhaseWithExit phase = C $
   do result <- phase
      case result of
         Left errs ->
            --showErrorsAndExit errs nrOfMsgs
            return (Left (map showMessage errs))
         Right a ->
            return (Right a)
            
{-
-- | Parsing just type signatures
parseType :: String -> Compile Type
parseType content =
  do let fullName = "Prelude"
     (lexerWarnings, tokens) <- 
        doPhaseWithExit $
           phaseLexer fullName contents []
     
     doPhaseWithExit $
               phaseParser fullName tokens options

phaseTypeParser :: String -> [Token] -> Phase ParseError Module
phaseTypeParser fullName tokens = do
    enterNewPhase "Parsing" []
    case runHParser Parser.type_ fullName tokens True of
        Left parseError -> do
            return (Left [parseError])
        Right m ->
            return (Right m)
-}
