.PHONY : tests/*.hm

tests/*.hm:
	@echo
	@echo "Testing $@"
	@cat $@
	-@cat $@ | dist/build/parse-hm/parse-hm | dist/build/hm2systemf/hm2systemf | dist/build/pp-systemf/pp-systemf
