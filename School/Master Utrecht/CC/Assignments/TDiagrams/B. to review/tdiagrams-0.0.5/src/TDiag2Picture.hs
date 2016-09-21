import CCO.Component  (Component, component, printer, ioWrap)
import CCO.Feedback   (Feedback)
import CCO.Picture    (Picture)
import CCO.Diag       (Diag)
import CCO.Tree       (ATerm, Tree (toTree, fromTree), parser)
import Control.Arrow  ((>>>), arr)
import CCO.Diag.AG

draw :: CoDiag -> Picture
draw d = draw_Syn_CoRoot $ wrap_CoRoot (sem_CoRoot $ CoRoot d) Inh_CoRoot

main = ioWrap (parser 
               >>> (component toTree :: Component ATerm CoDiag)
               >>> arr Main.draw
               >>> component (return . fromTree) 
               >>> printer
              )
