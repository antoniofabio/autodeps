R_OPTS := --no-save

all: bau/analysis.RData
sources := bau/analysis.R
depFiles := $(join $(dir $(sources)),$(patsubst %.R,.%.d, $(notdir $(sources))))

.%.d: %.R
	Rscript autodeps.R $< > $@

%.RData: %.R
	R CMD BATCH $(R_OPTS) $< $(dir $<).$(notdir $(basename $<)).Rout

include $(depFiles)
