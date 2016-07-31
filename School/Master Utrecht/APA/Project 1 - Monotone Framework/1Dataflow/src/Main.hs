{-# LANGUAGE StandaloneDeriving #-} 

module Main where

import CCO.Component
import CCO.Printing
import CCO.Feedback
import Convert
import Attributes
import HJS.Parser.JavaScriptParser
--import Debug.Trace

deriving instance Show Syn_Root

main = ioWrap (component $ \input -> do
  p <- either (errorMessage.text.show) return $ parseProgram input
  trace_ input
  trace_ $ show p
  let r = wrap_Root (sem_Root (Root (JSProgram (map cSourceElement p)))) Inh_Root
  trace_ $ show r
  return $ dotfile_Syn_Root r)
