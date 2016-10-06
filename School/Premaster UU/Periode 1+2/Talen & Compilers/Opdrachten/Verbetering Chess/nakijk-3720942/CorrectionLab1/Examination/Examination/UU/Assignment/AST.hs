module Examination.UU.Assignment.AST where

import Data.Map

data Assignment = Assignment 
    {
            assignmentName  :: String
        ,   questions       :: Questions
    }
    deriving Show 
    
data Question = Question 
    {
            qName   :: String
        ,   weight  :: Int   
    }
    deriving Show
        
type Questions = [ Question ]
