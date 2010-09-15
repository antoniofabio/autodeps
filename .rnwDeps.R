#!/usr/bin/env Rscript

sink(tempfile())
fileName <- commandArgs(trailingOnly=TRUE)
dropExt <- function(x) gsub("(.*)\\..*", "\\1", x)
fileTex <- paste(dropExt(basename(fileName)), ".tex", sep="")
fileR <- paste(dropExt(basename(fileName)), ".R", sep="")
Stangle(fileName)
output <- system(paste("Rscript autodeps.R", fileR), intern=TRUE)
output <- output[length(output)] #discard eventual warning messages etc.
output <- paste(fileTex, output, "\n", sep="")
sink()

cat(output)
