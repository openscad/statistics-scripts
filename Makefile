versions = 2013.06 2014.03 master
types = preview render

version = master
type = preview

sources = $(shell cat scadfiles-$(type).txt)
#sources = $(shell cat testfiles.txt)
#sources = unpacked/10113/Parametric_glassvasemug/glass.scad

lp:=(
rp:=)

all: preview

preview:
	$(MAKE) -e type=preview comparison

render:
	$(MAKE) -e type=render comparison

master: 
	$(MAKE) -e version=master type=preview process

master-render: 
	$(MAKE) -e version=master type=render process-render

2014.03:
	$(MAKE) -e version=2014.03 process

2013.06:
	$(MAKE) -e version=2013.06 process

process: $(sources:unpacked/%.scad=results-$(version)/$(type)/%.png)

results-$(version)/$(type)/%.png: unpacked/%.scad
#	@echo "Processing $< to $@"
	@./process.sh $(type) $(version) "$<" "$@"

comparison: comparison-$(type).csv comparison-$(type).html

#   unpacked/%.scad -> comparison/type/%
#   comparison/% -> comparison/%.csv 
times-$(type).csv: $(patsubst %,%.csv,$(patsubst unpacked/%.scad,comparison/$(type)/%,$(sources)))
	@echo Creating times-$(type).csv
	@echo "Thing ID, 2013.06, 2014.03, master, changed" > $@
	@cat $(subst $(rp),\$(rp),$(subst $(lp),\$(lp),$^)) >> $@

comparison/%.csv: comparison/%.html $(foreach v, $(versions), results-$(v)/%-time.txt)
	@./collect-times.sh $(subst $(rp),\$(rp),$(subst $(lp),\$(lp),$^)) > "$@"

# $* is the stem of the match
comparison/%.html: $(foreach v, $(versions), results-$(v)/%.png)
	@echo "$*" | cut -d'/' -f 2     # thingid
	@mkdir -p `dirname "$@"`
	@./collect-html.sh $(subst $(rp),\$(rp),$(subst $(lp),\$(lp),$^)) > $(subst $(rp),\$(rp),$(subst $(lp),\$(lp),$@))

 #   unpacked/%.scad -> comparison/type/%
#   comparison/% -> comparison/%.html 
comparison-$(type).html: $(patsubst %,%.html,$(patsubst unpacked/%.scad,comparison/$(type)/%,$(sources)))
	@echo Creating comparison-$(type).html
	@./create-html.sh "$(versions)" $(subst $(rp),\$(rp),$(subst $(lp),\$(lp),$^)) > $@

#   unpacked/%.scad -> comparison/type/%
#   comparison/% -> comparison/%.html 
comparison-$(type).csv: times-$(type).csv
	@echo Creating comparison-$(type).csv
	@./createcsv.py $^ $@


clean:
	rm -rf results-2013.06
	rm -rf results-2014.03
	rm -rf results-master
	rm -rf comparison
	rm -f times.csv
	rm -f comparison.html

.PHONY: 2013.06 2014.03 master process comparison
