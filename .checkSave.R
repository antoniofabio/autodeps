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
  saves <- parsedFile[isSave(parsedFile)]
  return(sapply(saves, "[[", "file", USE.NAMES=FALSE))
}

whatIsSaved <- Vectorize(checkSave)(fileNames)
names(whatIsSaved) <- fileNames

whatIsNA <- sapply(whatIsSaved, is.na)
if(any(whatIsNA)) {
  message("= can't parse correctly =")
  writeLines(paste(fileNames[whatIsNA], collapse=", "))
  whatIsSaved <- whatIsSaved[!whatIsNA]
  fileNames <- fileNames[!whatIsNA]
  names(whatIsSaved) <- fileNames
}

howManySaves <- sapply(whatIsSaved, length)
if(sum(howManySaves==0) > 0) {
  message("= not saving anything =")
  writeLines(paste(fileNames[howManySaves == 0], collapse=", "))
}

if(sum(howManySaves>1) > 0) {
  message("= saving more than one .RData file =")
  for(sourceName in names(whatIsSaved)) {
    message(sourceName, ": ", paste(fileNames[howManySaves > 1], collapse=", "))
  }
}

savesOne <- howManySaves == 1
savesOne.src <- fileNames[savesOne]
savesOne.observed <- whatIsSaved[savesOne]
savesOne.expected <- gsub("(.*)\\.R$", "\\1.RData", savesOne.src)
savesOne.bad <- savesOne.observed != savesOne.expected
if(any(savesOne.bad)) {
  message("= nonstandard output filenames =")
  df <- data.frame(source = savesOne.src, observed = savesOne.observed,
                   expected = savesOne.expected)
  df <- df[savesOne.bad,]
  print(df, row.names=FALSE)
}
