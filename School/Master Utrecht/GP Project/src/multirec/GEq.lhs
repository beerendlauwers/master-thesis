\begin{code}
module GEq where

import Generics.MultiRec
import qualified Generics.MultiRec.Eq as MREq
import BinTreeDatatype
import BinTreeReps
import CompanyDatatypes
import CompanyReps

equalBTreeInt :: BinTree Int -> BinTree Int -> Bool
equalBTreeInt = MREq.eq BinTree

equalCompany :: Company -> Company -> Bool
equalCompany = MREq.eq Company
\end{code}
