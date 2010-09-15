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
depFiles := $(join $(dir $(sources)),$(patsubst %.R,.%.d, $(notdir $(sources)))) \
	$(join $(dir $(reports)),$(patsubst %.Rnw,.%.Rnw.d, $(notdir $(reports))))
routFiles := $(join $(dir $(sources)),$(patsubst %.R,.%.Rout, $(notdir $(sources))))
all: $(rdataFiles) $(reports:.Rnw=.pdf) $(targets)

show-dependencies:
	@cat $(depFiles)|./showGraph.R

clean:
	@rm -rf $(shell find . -name ".*.d") *.aux *.log
	@rm -rf $(filter-out $(routFiles),$(shell find . -name ".*.Rout"))

status:
	@echo = currently running =
	@lsof $(routFiles) | awk -F" " '/^R/ { print $$2, $$9 }' | ./status.R
	@echo = already finished =
	@tail -n 1 $(routFiles)

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
