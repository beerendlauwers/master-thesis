all: HMTyping.hs

clean: 
	rm HMTyping.hs Dim/DimData.hs

DimData.hs: Dim/DimData.ag
	uuagc -Hd Dim/DimData.ag

HMTyping.hs: HMTyping.ag DimData.hs
	uuagc -Hsfwc HMTyping.ag