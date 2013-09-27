module TypeOf where

import Control.Monad

import Language.Haskell.TH
import Language.Haskell.TH.Syntax

getStaticType :: Name -> Q Exp
getStaticType x = do result <- reify x 
                     liftString $ doReify result
 where doReify (VarI nm _ _ _) = show nm
       doReify _ = undefined
