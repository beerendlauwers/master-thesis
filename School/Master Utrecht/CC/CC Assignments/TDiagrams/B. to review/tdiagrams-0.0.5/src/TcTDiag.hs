import CCO.Component  (Component, component, printer, ioWrap)
import CCO.Feedback   (Feedback)
import CCO.Diag       (Diag)
import CCO.Tree       (ATerm, Tree (toTree, fromTree), parser)
import Control.Arrow  ((>>>), arr)
import CCO.Diag.AG

check :: Diag -> Feedback CoDiag
check d = check_Syn_Root $ wrap_Root (sem_Root $ Root d) Inh_Root

main = ioWrap (parser
               >>> (component toTree :: Component ATerm Diag)
               >>> component Main.check
               >>> arr fromTree
               >>> printer
              )
