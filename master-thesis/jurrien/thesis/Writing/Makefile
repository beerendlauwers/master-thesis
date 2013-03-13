LHS := StutterheimThesis
BIB := bibliography

default: thesis

$(LHS).pdf: $(LHS).lhs $(BIB).bib $(LHS).bbl
	make pdf

$(LHS).bbl: $(BIB).bib
	make pdf
	bibtex $(LHS)
	make pdf

$(LHS).tex: $(LHS).lhs
	lhs2TeX $(LHS).lhs --poly -o $(LHS).tex

pdf: $(LHS).tex
	pdflatex $(LHS).tex

thesis: $(LHS).pdf

clean:
	rm -f *.aux *.bbl *.log *.out *.blg *.ptb *.tex $(LHS).pdf $(LHS).pag $(LHS).run.xml *.bcf

.PHONY: clean pdf default thesis
