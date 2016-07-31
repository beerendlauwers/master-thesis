-- |A simple module for pretty-printing a 'Picture' 'ATerm'.
module PpPicture where

import CCO.Component  (Component, component, printer, ioWrap)
import CCO.Picture    (Picture)
import CCO.Tree       (ATerm, Tree (toTree), parser)
import Control.Arrow  ((>>>))

-- |Converts an 'ATerm' to a 'Picture' and pretty-prints it.
main :: IO ()
main = ioWrap (parser >>> (component toTree :: Component ATerm Picture) >>> printer)