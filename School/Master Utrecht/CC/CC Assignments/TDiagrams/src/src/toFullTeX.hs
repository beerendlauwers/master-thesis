-- |A simple module used for outputting a working LaTeX document.
module ToFullTeX where

import CCO.Component

-- |Given a 'String', generates a simple LaTeX document.
main :: IO ()
main = ioWrap $ component 
    (\str -> return $ 
    "\\documentclass[10pt,a4paper]{article}\n\\usepackage[latin1]{inputenc}\n\\usepackage{amsmath}\n\\usepackage{a4wide}\n\\usepackage{amsfonts}\n\\usepackage{amssymb}\n\n\\begin{document}\n\n"++str++"\n\\end{document}\n" 
    )