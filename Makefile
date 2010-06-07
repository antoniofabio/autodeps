R_OPTS := --no-save

all: bau/analysis.RData
sources := bau/analysis.R

%.d: %.R
	Rscript autodeps.R $< > $@

%.RData: %.R
	R CMD BATCH $(R_OPTS) $< $(basename $<).Rout

include $(sources:.R=.d)
