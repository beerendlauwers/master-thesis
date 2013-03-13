#-----------------------------------------------------------------------------
# directories and files

ifndef file
   file := InferringContracts
endif

main		:= main
objects		:= Main.o

#-----------------------------------------------------------------------------
# commands and programs

ghc		:= ghc
ghcflags	:= -Wall -O
flags		:= --poly
spell           := ispell -d british -t -l -p
LHS2TEX         := lhs2TeX
PDFLATEX        := pdflatex
LATEX           := latex
BIBTEX          := bibtex
ACROREAD	:= /opt/Acrobat7/acroread
PDFNUP		:= /opt/local/bin/pdfnup

#-----------------------------------------------------------------------------
# main target

pdf : $(file).pdf

#-----------------------------------------------------------------------------
# static pattern rules

$(objects) : %.o : %.lhs
	$(ghc) -c $(ghcflags) $< -o $@

#-----------------------------------------------------------------------------
# pattern rules

%.tex : %.lhs $(file).fmt 
	$(LHS2TEX) --file-directives --poly -slatex $< > $@

%.hs : %.lhs $(file).fmt
	$(LHS2TEX) --newcode -shscode $< > $@

%_GH.ghs : %.lhs $(file).fmt
	$(LHS2TEX) --newcode -sghcode $< > $@

%_hsdrift.hs : %.lhs $(file).fmt
	$(LHS2TEX) --newcode -shsdrift $< > $@

%Rules.hs : %.lhs $(file).fmt
	$(LHS2TEX) --newcode -sdrift $< > $@

%.hs : %.ghs
	gh $<

%.ps : %.dvi
	dvips -o $@ $<

%.pdf : %.tex
	$(PDFLATEX) $<

%.hi : %.o
	@:

#-----------------------------------------------------------------------------
# rules

.PHONY 	: pdf edit xdvi gv acro ghci print spell spellupdate links clean realclean

edit :
	emacs $(file).fmt $(file).lhs &

$(file).dvi : $(file).tex
	$(LATEX) $(file)
	if grep -s '^LaTeX Warning: Citation .* undefined' $(file).log; \
	then $(BIBTEX) $(file); $(LATEX) $(file); \
	fi
	while grep -s "Warning.*Rerun" $(<:.tex=.log); \
	  do $(LATEX) $<; done;

xdvi : $(file).dvi
	xdvi -s 6 $(file).dvi &

gv : $(file).ps
	gv -spartan $(file).ps &

acro : $(file).pdf
	$(ACROREAD) $(file).pdf &

ghci: $(file).lhs
	ghci -fglasgow-exts -pgmL lhs2TeX -optL--pre -optL-shscode $(file).lhs

gh-ghci: $(file)_GH.hs
	gh-ghci $<

hs-drift: $(file)_hsdrift.hs
	ghci -fglasgow-exts $<

drift: $(file)Rules.hs
	cp $< DrIFT-2.1.2/src/$< | cd DrIFT-2.1.2/ | sudo make install

kpdf : $(file).pdf
	kpdf $(file).pdf &

pdfview : $(file).pdf
	open $(file).pdf

pdf-bib : $(file).pdf
	$(BIBTEX) $(file); $(PDFLATEX) $(file); $(BIBTEX) $(file); $(PDFLATEX) $(file)

spell: $(file).tex
	egrep -v '$\%' $(file).tex | $(spell) $(file).spell | sort | uniq

spellupdate: $(file).tex
	egrep -v '$\%' $(file).tex | $(spell)  $(file).spell | sort | uniq > $(file).spell

$(main) : $(objects)
	$(ghc) $(ghcflags) -o $(main) $(objects)

links:
	ln -s $(HOME)/local/abbr.bib
	ln -s $(HOME)/local/rh.bib
	ln -s $(HOME)/local/lhs2TeX.fmt
	ln -s $(HOME)/local/lhs2TeX.sty
	ln -s $(HOME)/local/FuncMP.mp

clean	:
	rm -f *~ *% *.aux *.bbl *.blg *.log *.toc *.out *.nav *.snm *.rel
	rm -f main $(file).tex Main.tex $(file).[1-9]* *.mpx $(file).ptb

realclean : clean
	rm -f *.dvi *.ps $(file)*.pdf *.pdfsync
	rm -f abbr.bib rh.bib lhs2TeX.fmt lhs2TeX.sty FuncMP.mp

notes:		$(file).tex
		echo '\PassOptionsToClass{notes=show}{beamer}\include{$(file)}' > notes.tex
		$(PDFLATEX) notes.tex
		mv notes.pdf $(file)-notes.pdf
		rm -f notes.*

handout:	$(file).tex
		echo '\PassOptionsToClass{handout}{beamer}\include{$(file)}' > handout.tex
		$(PDFLATEX) handout.tex
		$(PDFNUP) --nup "2x3" --offset ".25cm .25cm" --delta ".25cm .5cm" --frame true --scale 0.9 --outfile $(file)-handout.pdf  handout.pdf 
		rm -f handout.*
