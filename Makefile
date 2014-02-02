sources = $(shell cat scadfiles.txt)
sources-render = $(shell cat scadfiles-render.txt)
#sources = $(shell cat testfiles.txt)
#sources = unpacked/10113/Parametric_glassvasemug/glass.scad

versions = 2013.06 master refactor
types = preview render

version = refactor
type = preview

all: preview

preview:
	$(MAKE) -e type=preview comparison

render:
	$(MAKE) -e type=render comparison

refactor: 
	$(MAKE) -e version=refactor type=preview process

refactor-render: 
	$(MAKE) -e version=refactor type=render process-render

master:
	$(MAKE) -e version=master process

2013.06:
	$(MAKE) -e version=2013.06 process

process: $(sources-render:unpacked/%.scad=results-$(version)/$(type)/%.png)

results-$(version)/$(type)/%.png: unpacked/%.scad
#	@echo "Processing $< to $@"
	@./process.sh $(type) $(version) $< $@

comparison: times-$(type).csv comparison-$(type).html

#   unpacked/%.scad -> comparison/type/%
#   comparison/% -> comparison/%.csv 
times-$(type).csv: $(patsubst %,%.csv,$(patsubst unpacked/%.scad,comparison/$(type)/%,$(sources)))
	@echo Creating times-$(type).csv
	@echo "Thing ID, 2013.06, master, refactor, changed" > $@
	@cat $^ >> $@

#   unpacked/%.scad -> comparison/type/%
#   comparison/% -> comparison/%.html 
comparison-$(type).html: $(patsubst %,%.html,$(patsubst unpacked/%.scad,comparison/$(type)/%,$(sources)))
	@echo Creating comparison-$(type).html
	@./create-html.sh "$(versions)" $^ > $@

comparison/%.csv: comparison/%.html $(foreach v, $(versions), results-$(v)/%-time.txt)
	@./collect-times.sh $^ > $@

# $* is the stem of the match
comparison/%.html: $(foreach v, $(versions), results-$(v)/%.png)
	@echo $* | cut -d'/' -f 2     # thingid
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
