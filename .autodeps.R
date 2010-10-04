#!/usr/bin/env Rscript
fileName <- commandArgs(trailingOnly=TRUE)

subfolder <- dirname(fileName)
parsedFile <- tryCatch(parse(fileName),
                       error=function(e) {
                         message("can't parse R source file ", shQuote(fileName))
                         message(e)
                         message("")
                         quit("no", status=1)
                       })
isIt <- function(e, what) as.character(e[[1]])==what
isSave <- function(e) isIt(e, "save")
isLoad <- function(e) isIt(e, "load")

tryEval <- function(expr) tryCatch(eval(expr), error=function(ignore) NULL)

whatIsSaved <- lapply(Filter(isSave, parsedFile), function(x) tryEval(as.list(x)$file))
whatIsSaved <- unlist(Filter(is.character, whatIsSaved))

whatIsLoaded <- lapply(Filter(isLoad, parsedFile), function(x) tryEval(x[[2]]))
whatIsLoaded <- unlist(Filter(is.character, whatIsLoaded))

##genearate Makefile targets
cat(paste(whatIsSaved, collapse=" "), ": ", fileName, " ",
    paste(whatIsLoaded, collapse=" "), "\n", sep="")
