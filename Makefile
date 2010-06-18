R_OPTS := --no-save

.PHONY: all show_dependencies

#OLD_SHELL := $(SHELL)
#SHELL = $(warning [$@ ($^) ($?)])$(OLD_SHELL)

all: bau/analysis.RData
R_sources := $(filter-out ./autodeps.R,$(shell find . -name "*.R"))
sources := bau/analysis.R
depFiles := $(join $(dir $(sources)),$(patsubst %.R,.%.d, $(notdir $(sources))))

show_dependencies:
	@cat `find . -name ".*.d"`

.%.d: %.R
	Rscript autodeps.R $< > $@

%.RData: %.R
	R CMD BATCH $(R_OPTS) $< $(dir $<).$(notdir $(basename $<)).Rout

include $(depFiles)
