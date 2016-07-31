all: src/Attributes.hs
	cabal build

configure:
	cabal configure
  
src/Attributes.hs: src/Datatypes.ag src/Scope.ag src/Flow.ag src/Transfer.ag src/Attributes.ag
	uuagc -Hdcfws -P src/ src/Attributes.ag	
	
clean:
	cabal clean	
