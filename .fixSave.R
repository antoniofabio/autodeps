#!/usr/bin/env Rscript

##
## Fix the last 'save' statement in an R script.
## The '.RData' filename should match the '.R' filename which generates it.
##

options(keep.source=TRUE)

fileName <- commandArgs(trailingOnly=TRUE)[1]
parsedFile <- tryCatch(parse(fileName),
                       error=function(e) {
                         message("can't parse R source file ", shQuote(fileName))
                         message(e)
                         message("")
                         quit("no", status=1)
                       })
isIt <- Vectorize(function(e, what) as.character(e[[1]])==what)
isSave <- function(e) isIt(e, "save")

last <- function(x) x[length(x)]

saveStatementLine <- last(which(isSave(parsedFile)))
saveStatement <- as.list(parsedFile[[saveStatementLine]])
saveStatement$file <- gsub("(.*)\\.R$", "\\1.RData", fileName)

ref <- attr(parsedFile[saveStatementLine], "srcref")[[1]]
stopifnot(!is.null(ref))
contents <- readLines(fileName)
contents[seq(ref[1], ref[3])] <- ""
contents[ref[1]] <- deparse(as.call(saveStatement))

writeLines(contents, con=fileName)
