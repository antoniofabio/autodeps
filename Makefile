R_OPTS := --no-save

.PHONY: all show-dependencies
.DEFAULT_GOAL := all

#OLD_SHELL := $(SHELL)
#SHELL = $(warning [$@ ($^) ($?)])$(OLD_SHELL)

sources := $(filter-out ./autodeps.R,$(shell find . -name "*.R"))
reports := 
targets :=

include Makefile.config

rdataFiles := $(sources:.R=.RData)
depFiles := $(join $(dir $(sources)),$(patsubst %.R,.%.d, $(notdir $(sources))))
all: $(rdataFiles) $(targets)

show-dependencies:
	@cat `find . -name ".*.d"`|./showGraph.R

.%.d: %.R
	@Rscript autodeps.R $< > $@

%.RData: %.R .%.d
	R CMD BATCH $(R_OPTS) $< $(dir $<).$(notdir $(basename $<)).Rout

%.R: %.Rnw
	R CMD Stangle $<

%.tex: %.Rnw %.R .%.d
	R CMD Sweave $(notdir $<)
%.aux: %.tex
	pdflatex $(notdir $<)
%.pdf: %.tex %.aux
	pdflatex $(notdir $<)

include $(depFiles)
include $(join $(dir $(reports)),$(patsubst %.Rnw,.%.d, $(notdir $(reports))))
