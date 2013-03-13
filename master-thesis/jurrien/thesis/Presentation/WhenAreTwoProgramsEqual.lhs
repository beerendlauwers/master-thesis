%Flexibility? -> normalisation
%Doelen! 

%----------------------------------------------------------------------------
%
%  Title       :  Teachers and students in charge
%  Author      :  Johan Jeuring
%  Copyright   :  (c) Open Universiteit 2012
%  Created     :  15 September 2012
%
%  Purpose     :  To be presented at EC-TEL 2012
% 
%----------------------------------------------------------------------------
\documentclass[fleqn]{beamer}

\usepackage{etex}
\usepackage[british]{babel}
\usepackage{pdfsync,booktabs,hyperref,tikz,tabularx} 
\usepackage{tikz-qtree}
\usepackage[absolute,overlay]{textpos}
%include InferringContracts.fmt
\usepackage[applemac]{inputenc}
\usepackage{palatino, euler}
%\usepackage{mathpazo}

\newcommand{\askelle}{{\sc Ask-Elle}}

\tikzstyle{dot}=[inner sep=0pt]

\usetheme[ showpagenr=false,
           highcontrast=false,
           sectionpages=false,
           tocnrs=false
         ]{ou}

\setbeamercovered{transparent}
\colorlet{oupurple}{oured} 

%\usepackage{lmodern}

%%% Some commands
\renewcommand{\foot}{%
  \raggedleft 
  \sffamily
  \textcolor{oured}{\textbf{[}}%
  {WG2.1~\#69:~}%
  \textcolor{oured}{\textbf{Inferring contracts}}%
  \textcolor{oured}{\textbf{]}}}
\setlength{\footpos}{12.5cm - \widthof{\tiny\foot} / 2}

\newcommand{\inbox}[2]{\begin{shadowblock}{}{}#1\vspace{1mm}\end{shadowblock}}
\newcommand{\inboxtitle}[2]{\begin{shadowblock}{#1}{}#2\vspace{0mm}\end{shadowblock}}
\renewcommand{\emph}[1]{\textcolor{oupurple}{#1}}
\newcommand{\srv}[1]{\makebox[2.8cm][l]{\emph{#1}}}
\newcommand{\shift}[2]{\makebox[#1][l]{#2}}


%%% Shadow is adjustable
%\setlength{\shadowsize}{3pt}  % 5pt is default

%%% Use vertical bar for code
%include colorcode.fmt
\barhs
\colorlet{codecolor}{oured}
\setlength{\coderulewidth}{2pt}


\title{When are two programs equal?}
\author[Johan~Jeuring]{Johan~Jeuring}
\institute[Utrecht University and Open Universiteit Nederland]
{
  Open Universiteit Nederland and Utrecht University
}

\date{IFIP WG2.1 Meeting \#69, Ottawa, Canada\\~\\October 2012}

\subject{When are two programs equal?}

\begin{document}

\frontmatter

\frame{\titlepage}

\mainmatter

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\frame{\frametitle{|range|}

Write a function which enumerates all numbers contained in a given range.

> range :: Int -> Int -> [Int]

For example, |range 2 5| gives

> [2,3,4,5]

}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%format range1
%format range2
%format range3
%format range4
%format range5
%format range6
%format range7

\frame{\frametitle{Some solutions for |range|}

> range1 x y  = if x==y then [x] else x:range1 (x+1) y
> range2 x y  = if y==x then [x] else x:range2 (x+1) y
> range3 x y  = if x/=y then x:range3 (x+1) y else [x] 
> range4 x y  = if y/=x then x:range4 (x+1) y else [x] 
> range5 x y  = if x/=y then x:range5 (1+x) y else [x] 
>   -- and the 3 variants
> range6 x    = \y -> if x==y then [x] else x:range6 (x+1) y 
>   -- and the 7 variants
> range7      = \x -> \y ->  if x==y 
>                            then [x] 
>                            else x:range7 (x+1) y 
>   -- and the 7 variants

}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\frame{\frametitle{A procedure for determining equality}

\begin{itemize}
\item A procedure for determining whether or not two programs are equal is necessarily going to have some limitations
\item But surely each pair of |range| programs can pass the test
\item How can determine many of these equalities?
\item What program transformations can I specify to steer this procedure?
\end{itemize}

}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\frame{\frametitle{I need a normal form!}

\begin{itemize}
\item Remove syntactic sugar 
\item Normalization by Evaluation normalizes based on types, so a function of type |a -> b -> c| always has the form |\x -> \y -> ....|
\item Normal forms for integer expressions, boolean expressions, string expressions, taking into account algebraic properties of the operators
\item Inlining?

> let duplicate x = [x,x] in concatMap duplicate 
> concatMap (\x -> [x,x]) 

\item Fusion? |map f . map g = map (f . g)|

\end{itemize}

}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\frame{\frametitle{Problems}

\begin{itemize}
\item High-level: how can I determine equality of (functional) programs?
\item What is a normal form of a program?
\item What sequence of steps do I use for determining a normal form of a program?
\item How can I influence the computation of a normal form of a program?
\end{itemize}

}


\end{document}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

