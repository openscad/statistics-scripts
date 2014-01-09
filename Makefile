sources = $(shell cat scadfiles.txt)
#sources = $(shell cat testfiles.txt)
#sources = unpacked/10113/Parametric_glassvasemug/glass.scad

versions = 2013.06 master refactor

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
	@./process.sh $(version) $< $@

comparison: times.csv comparison.html

times.csv: $(patsubst %,%.csv,$(patsubst unpacked/%.scad,comparison/%,$(sources)))
	@echo Creating times.csv
	@cat $^ > $@

comparison.html: $(patsubst %,%.html,$(patsubst unpacked/%.scad,comparison/%,$(sources)))
	@echo Creating comparison.html
	@./create-html.sh "$(versions)" $^ > $@

comparison/%.csv: comparison/%.html $(foreach v, $(versions), results-$(v)/%-time.txt)
	@./collect-times.sh $^ > $@

comparison/%.html: $(foreach v, $(versions), results-$(v)/%.png)
	@echo $* | cut -d'/' -f 1
	@mkdir -p `dirname $@`
	@./collect-html.sh $^ > $@

# Create missing png's to satisfy rules
#%.png:
#	@touch $@

clean:
	rm -rf results-2013.06
	rm -rf results-master
	rm -rf results-refactor
	rm -rf comparison
	rm -f times.csv
	rm -f comparison.html

.PHONY: 2013.06 master refactor process comparison
