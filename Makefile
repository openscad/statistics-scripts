sources = $(shell cat allfiles.txt)
#sources = $(shell cat testfiles.txt)
#sources = unpacked/10113/Parametric_glassvasemug/glass.scad

all:
	@echo Specify version

refactor: 
	$(MAKE) -e version=refactor process

master:
	$(MAKE) -e version=master process

2013.06:
	$(MAKE) -e version=2013.06 process

process: $(sources:unpacked/%.scad=results-$(version)/%.png)

results-$(version)/%.png: unpacked/%.scad
#	@echo "Processing $< to $@"
	@./process.sh $(version) "$<"

clean:
	rm -rf results-2013.06
	rm -rf results-master
	rm -rf results-refactor

.PHONY: 2013.06 master refactor process
