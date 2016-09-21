-- | This module provides the 'File Input - File Output mode' functionality. It calls the 'parseBibTexString', 'ioCheckBibTex' and 'prettyPrint' functions to produce HTML that is then written into a provided file location.
module Main where

import ParseBib hiding(main)
import BibTex
import Bib2HTML hiding(main)
import PPHTML hiding(main)

import CCO.Tree
import CCO.Feedback

import System.IO
import System.Environment

-- |Given two file paths as arguments, read the contents of the first file, run the 'run' function on it, and write the result into the second file.
main :: IO()
main = do args <- getArgs
          case args of 
            []    -> error "No file specified"
            (inputFile:outputFile:_) -> do 
                        inputText <- readFile inputFile
                        prettyBibTex <- run inputText
                        writeFile outputFile prettyBibTex
                        
-- |Given a 'String', run 'parseBibTexString', 'ioCheckBibTex' and 'prettyPrint', respectively, to produce pretty-printed HTML.
run :: String -> IO String
run x = do strBibTex <- parseBibTexString x
           htmlATerm <- ioCheckBibTex strBibTex
           return $ prettyPrint htmlATerm