LHSFILES=$(wildcard *.lhs)
PROJNAME=typed-contracts
OUTPUTDIR=output

default: dist/package.conf.inplace

$(OUTPUTDIR)/Contract.hs: src/Contract.lhs
	lhs2TeX --newcode -s full Contract.lhs -o Contract.hs

$(OUTPUTDIR)/Contract.tex: src/Contract.lhs
	lhs2TeX src/Contract.lhs -o $(OUTPUTDIR)/Contract.tex

dist/setup-config: $(PROJNAME).cabal
	cabal configure

dist/package.conf.inplace: $(LHSFILES) dist/setup-config
	cabal build

install: dist/installed

dist/installed: $(LHSFILES) $(PROJNAME).cabal
	cabal install
	touch dist/installed

clean:
	cabal clean
	rm -f $(OUTPUTDIR)/*.hs $(OUTPUTDIR)/*.tex

.PHONY: clean install
