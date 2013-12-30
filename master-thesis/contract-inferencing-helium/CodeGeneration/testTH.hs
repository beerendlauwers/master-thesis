{-# LANGUAGE TemplateHaskell #-}

module TestTH where

import Language.Haskell.TH
import Data.Maybe

t f x = f x

val = 5

test var = 
 $(do
    res <- reify (mkName var)
    let str = pprint res
--    str <- runIO (show res)
    return $ LitE (StringL str)
  )
