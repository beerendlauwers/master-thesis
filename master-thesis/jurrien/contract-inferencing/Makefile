MAINHS   = dist/build/ContractInferencing.hs
CONFRES  = dist/setup-config
SETUP    = runghc Setup.hs
CABAL    = contract-inferencing.cabal
DEFAULT  = build
AGS      = $(wildcard src/*.ag)

default: $(DEFAULT)

$(CONFRES): $(CABAL)
	$(SETUP) configure --user

build: $(MAINHS)

$(MAINHS): $(CONFRES) $(AGS)
	$(SETUP) build

install: $(CONFRES)
	$(SETUP) install

test: $(MAINHS)
	ghci -Wall $(MAINHS)

clean:
	cabal clean

.PHONY: clean
