module Examination.UU.Assignment.Parser where

import ParseLib.Abstract
import Examination.UU.Assignment.AST

import Data.Char

pQuestionId :: Parser Char String
pQuestionId = greedy (satisfy isAlphaNum)
