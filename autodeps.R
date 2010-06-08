#!/usr/bin/Rscript
fileName <- commandArgs(trailingOnly=TRUE)

subfolder <- dirname(fileName)
parsedFile <- parse(fileName)
isIt <- function(e, what) as.character(e[[1]])==what
isSave <- function(e) isIt(e, "save")
isLoad <- function(e) isIt(e, "load")

whatIsSaved <- sapply(Filter(isSave, parsedFile), function(x) as.list(x)$file)
if(length(whatIsSaved)==0)
  quit("no")

whatIsLoaded <- sapply(Filter(isLoad, parsedFile), "[[", 2)

##genearate Makefile targets
cat(paste(whatIsSaved, collapse=" "), ": ", fileName, " ",
    paste(whatIsLoaded, collapse=" "), "\n", sep="")
