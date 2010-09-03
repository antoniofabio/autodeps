R_OPTS := --no-save

.PHONY: all show-dependencies
.DEFAULT_GOAL := all

#OLD_SHELL := $(SHELL)
#SHELL = $(warning [$@ ($^) ($?)])$(OLD_SHELL)

sources := $(filter-out ./autodeps.R,$(shell find . -name "*.R"))
targets :=

include Makefile.config

rdataFiles := $(sources:.R=.RData)
depFiles := $(join $(dir $(sources)),$(patsubst %.R,.%.d, $(notdir $(sources))))
all: $(rdataFiles) $(targets)

show-dependencies:
	@cat `find . -name ".*.d"`|./showGraph.R

.%.d: %.R
	@Rscript autodeps.R $< > $@

%.RData: %.R
	R CMD BATCH $(R_OPTS) $< $(dir $<).$(notdir $(basename $<)).Rout

report/%.tex: report/%.Rnw
	cd report; R CMD Sweave $(notdir $<)
report/%.aux: report/%.tex
	cd report; pdflatex $(notdir $<)
report/%.pdf: report/%.tex report/%.aux
	cd report; pdflatex $(notdir $<)

include $(depFiles)
