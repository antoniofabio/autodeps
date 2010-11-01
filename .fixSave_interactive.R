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
whatIsSaved <- whatIsSaved[!whatIsNA]
fileNames <- fileNames[!whatIsNA]
names(whatIsSaved) <- fileNames

howManySaves <- sapply(whatIsSaved, length)

savesOne <- howManySaves == 1
savesOne.src <- fileNames[savesOne]
savesOne.observed <- whatIsSaved[savesOne]
savesOne.expected <- gsub("(.*)\\.R$", "\\1.RData", savesOne.src)
savesOne.bad <- savesOne.observed != savesOne.expected
if(all(!savesOne.bad)) {
  quit("no")
}
df <- data.frame(source = savesOne.src, observed = savesOne.observed,
                 expected = savesOne.expected)
df <- df[savesOne.bad,]

for(fileName in df$savesOne.src) {
  answer <- readline(sprintf("fix file '%s'? (y/n)", fileName))
  if(answer == "y") {
    cmd <- sprintf("./.fixSave.R %s", fileName)
    system(cmd)
  }
}
