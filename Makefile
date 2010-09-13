R_OPTS := --no-save

.PHONY: all show-dependencies clean status
.DEFAULT_GOAL := all

#OLD_SHELL := $(SHELL)
#SHELL = $(warning [$@ ($^) ($?)])$(OLD_SHELL)

sources := $(filter-out ./autodeps.R ./showGraph.R,$(shell find . -name "*.R"))
reports := 
targets :=

include Makefile.config

rdataFiles := $(sources:.R=.RData)
depFiles := $(join $(dir $(sources)),$(patsubst %.R,.%.d, $(notdir $(sources)))) $(join $(dir $(reports)),$(patsubst %.Rnw,.%.d, $(notdir $(reports))))
routFiles := $(join $(dir $(sources)),$(patsubst %.R,.%.Rout, $(notdir $(sources))))
all: $(rdataFiles) $(reports:.Rnw=.pdf) $(targets)

show-dependencies:
	@cat $(depFiles)|./showGraph.R

clean:
	@rm -rf $(shell find . -name ".*.d") *.aux *.log
	@rm -rf $(filter-out $(routFiles),$(shell find . -name ".*.Rout"))

status:
	@lsof $(shell find . -name ".*.Rout") |grep ^R
	@tail -n 1 $(routFiles)

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
