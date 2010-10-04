R_OPTS := --no-save

.PHONY: all show-dependencies clean status
.DEFAULT_GOAL := all

#OLD_SHELL := $(SHELL)
#SHELL = $(warning [$@ ($^) ($?)])$(OLD_SHELL)

print-%: ; @echo $* is $($*)

# get only existing files from the list
filter-existing=$(shell for f in $1; do if [ -e $f ]; then echo $f; fi; done)

sources := $(wildcard *.R)
reports := $(wildcard *.Rnw)
targets :=

depFiles := $(join $(dir $(sources)),$(patsubst %.R,.%.d, $(notdir $(sources)))) \
	$(join $(dir $(reports)),$(patsubst %.Rnw,.%.Rnw.d, $(notdir $(reports))))
rdataFiles := $(shell ./.collectTargets.R $(depFiles))
routFiles := $(join $(dir $(sources)),$(patsubst %.R,.%.Rout, $(notdir $(sources))))
all: $(depFiles) $(rdataFiles) $(reports:.Rnw=.pdf) $(targets)

show-dependencies: $(depFiles)
	@cat $(depFiles)|./.showGraph.R

clean:
	@rm -rf $(shell find . -name ".*.d") *.aux *.log

status:
	@./.status.R $(routFiles)

.%.d: %.R
	@./.autodeps.R $< > $@

.%.Rnw.d: %.Rnw
	@./.rnwDeps.R $< > $@

%.RData: %.R
	R CMD BATCH $(R_OPTS) $< $(dir $<).$(notdir $(basename $<)).Rout

%.tex: %.Rnw
	R CMD Sweave $(notdir $<)
%.aux: %.tex
	pdflatex $(notdir $<)
%.pdf: %.tex %.aux
	pdflatex $(notdir $<)

include $(depFiles)
