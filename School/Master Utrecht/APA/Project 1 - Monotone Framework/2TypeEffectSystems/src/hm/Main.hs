module Main where

import HMTyping
import CCO.Tree         (parser, fromTree, toTree)
import CCO.Feedback (Feedback)
import CCO.Component    (component, printer, ioWrap)
import Control.Arrow    (arr, (>>>))
import HMType
import qualified CCO.HM.Parser as PA    (parser)

main :: IO ()
main = ioWrap (parser >>> component toTree >>> component hmtype >>> arr fromTree >>> printer)