fileName <- commandArgs(trailingOnly=TRUE)

subfolder <- dirname(fileName)
parsedFile <- parse(fileName)
isIt <- function(e, what) as.character(e[[1]])==what
isLoad <- function(e) isIt(e, "load")
isSave <- function(e) isIt(e, "save")

whatIsLoaded <- sapply(Filter(isLoad, parsedFile), "[[", 2)
whatIsSaved <- sapply(Filter(isSave, parsedFile), function(x) as.list(x)$file)

##genearate Makefile targets
if(FALSE) {
  cat(paste(file.path(subfolder, whatIsSaved), collapse=" "), ": ", fileName, " ",
      paste(file.path(subfolder, whatIsLoaded), collapse=" "), "\n", sep="")
}
cat(paste(whatIsSaved, collapse=" "), ": ", fileName, " ",
    paste(whatIsLoaded, collapse=" "), "\n", sep="")
