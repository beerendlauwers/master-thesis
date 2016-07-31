import CCO.Component    (component, printer, ioWrap)
import CCO.HM2SystemF   (hm2systemf)
import CCO.Tree         (parser, fromTree, toTree)
import Control.Arrow    (arr, (>>>))

main = ioWrap (parser >>> component toTree >>> component hm2systemf >>> arr fromTree >>> printer)