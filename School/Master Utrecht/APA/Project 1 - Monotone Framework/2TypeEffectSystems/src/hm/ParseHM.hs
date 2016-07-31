module ParseHM where

import CCO.Component    (printer, ioWrap)
import CCO.HM.Parser    (parser)
import CCO.Tree         (fromTree)
import Control.Arrow    (arr, (>>>))

main = ioWrap (parser >>> arr fromTree >>> printer)