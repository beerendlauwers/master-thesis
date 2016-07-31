LHS = assignment4.lhs PosParser.lhs Splittable.lhs StackLanguage.lhs
TEX = $(LHS:.lhs=.tex)

all: $(TEX)
	latexmk -pdf $<

clean:
	latexmk -C
	rm $(TEX)

$(TEX): %.tex: %.lhs
	lhs2TeX -o $@ $^
