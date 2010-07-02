R_OPTS := --no-save

.PHONY: all show-dependencies

#OLD_SHELL := $(SHELL)
#SHELL = $(warning [$@ ($^) ($?)])$(OLD_SHELL)

sources := $(filter-out ./autodeps.R,$(shell find . -name "*.R"))

include Makefile.config

rdataFiles := $(sources:.R=.RData)
depFiles := $(join $(dir $(sources)),$(patsubst %.R,.%.d, $(notdir $(sources))))
all: $(rdataFiles)

show-dependencies:
	@echo =Dependencies chain=
	@cat `find . -name ".*.d"`|./showGraph.R

.%.d: %.R
	@Rscript autodeps.R $< > $@

%.RData: %.R
	R CMD BATCH $(R_OPTS) $< $(dir $<).$(notdir $(basename $<)).Rout

include $(depFiles)
