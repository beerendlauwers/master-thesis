module Examination.UU.Review.AST where

import Examination.UU.Assignment.AST 

import Data.Map

data Review = Review
    {
 --           assignment :: String
 --       ,   reviewer   :: String
 --      ,   reviewee   :: String
           qgrades    :: QGrades
    }
    deriving Show
    
type QGrades = Map String QGrade
    
data QGrade = QGrade
    {
            grade      :: Int
        ,   remarks    :: Remarks
    }
    deriving Show
        
type Remarks = [Remark]

data Remark = Remark
    {
            mod     :: Modality  
        ,   remark  :: String
        ,   remarkcontent :: [RemarkContent] 
    }
    deriving Show
    
data RemarkContent = Comment { comment :: String } | Code { code :: String } deriving Show    

data Modality = Positive | Negative | Neutral

instance Show Modality where
    show Positive = "+"
    show Negative = "-"
    show Neutral  = "~"
