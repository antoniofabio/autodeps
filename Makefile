R_OPTS := --no-save

.PHONY: all show-dependencies clean status
.DEFAULT_GOAL := all

#OLD_SHELL := $(SHELL)
#SHELL = $(warning [$@ ($^) ($?)])$(OLD_SHELL)

sources := $(wildcard *.R)
reports := $(wildcard *.Rnw)
targets :=

depFiles := $(join $(dir $(sources)),$(patsubst %.R,.%.d, $(notdir $(sources)))) \
	$(join $(dir $(reports)),$(patsubst %.Rnw,.%.Rnw.d, $(notdir $(reports))))
rdataFiles := $(shell cat $(depFiles) | ./.collectTargets.R)
routFiles := $(join $(dir $(sources)),$(patsubst %.R,.%.Rout, $(notdir $(sources))))
all: $(rdataFiles) $(reports:.Rnw=.pdf) $(targets)

show-dependencies:
	@cat $(depFiles)|./showGraph.R

clean:
	@rm -rf $(shell find . -name ".*.d") *.aux *.log
	@rm -rf $(filter-out $(routFiles),$(shell find . -name ".*.Rout"))

status:
	@./.status.R $(routFiles)

.%.d: %.R
	@Rscript autodeps.R $< > $@

.%.Rnw.d: %.Rnw
	@./.rnwDeps.R $< > $@

%.RData: %.R .%.d
	R CMD BATCH $(R_OPTS) $< $(dir $<).$(notdir $(basename $<)).Rout

%.tex: %.Rnw .%.Rnw.d
	R CMD Sweave $(notdir $<)
%.aux: %.tex
	pdflatex $(notdir $<)
%.pdf: %.tex %.aux
	pdflatex $(notdir $<)

include $(depFiles)
