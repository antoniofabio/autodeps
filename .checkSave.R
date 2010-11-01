#!/usr/bin/env Rscript

fileNames <- commandArgs(trailingOnly=TRUE)

checkSave <- function(fileName) {
  parsedFile <- tryCatch(parse(fileName),
                         error=function(e) NULL)
  if(is.null(parsedFile)) {
    return(NA)
  }
  isIt <- Vectorize(function(e, what) as.character(e[[1]])==what)
  isSave <- function(e) isIt(e, "save")
  return(sum(isSave(parsedFile)))
}

howManySaves <- Vectorize(checkSave)(fileNames)
names(howManySaves) <- fileNames

if(any(is.na(howManySaves))) {
  message("= can't parse correctly =")
  writeLines(paste(fileNames[is.na(howManySaves)], collapse=", "))
  fileNames <- fileNames[!is.na(howManySaves)]
  howManySaves <- howManySaves[!is.na(howManySaves)]
}

if(sum(howManySaves==0) > 0) {
  message("= not saving anything =")
  writeLines(paste(fileNames[howManySaves == 0], collapse=", "))
}

if(sum(howManySaves>1) > 0) {
  message("= saving more than one .RData file =")
  writeLines(paste(fileNames[howManySaves > 1], collapse=", "))
}
