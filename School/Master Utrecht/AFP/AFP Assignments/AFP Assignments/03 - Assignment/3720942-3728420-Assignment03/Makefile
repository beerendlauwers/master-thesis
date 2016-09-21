LHS = assignment3.lhs Trie.lhs exercise5.lhs
TEX = $(LHS:.lhs=.tex)

all: $(TEX)
	latexmk -pdf $<

clean:
	latexmk -C
	rm $(TEX)

$(TEX): %.tex: %.lhs
	lhs2TeX -o $@ $^
