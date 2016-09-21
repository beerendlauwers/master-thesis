-- |A simple module for parsing a file into a 'Diag' 'ATerm'.
module ParseTDiag where

import CCO.Component  (printer, ioWrap)
import CCO.Diag       (parser)
import CCO.Tree       (Tree (fromTree))
import Control.Arrow  (Arrow (arr), (>>>))

-- |Parses input to a 'Diag', produces an 'ATerm' for it and prints that out.
main :: IO ()
main = ioWrap (parser >>> arr fromTree >>> printer)