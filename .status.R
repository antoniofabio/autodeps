#!/usr/bin/env Rscript

fileNames <- commandArgs(trailingOnly=TRUE)
dropExt <- function(x) gsub(".(.*)\\..*", "\\1", x)
baseNames <- dropExt(basename(fileNames))

allPresentFiles <- fileNames[file.exists(fileNames)]
cmd <- paste("lsof", paste(allPresentFiles, collapse=" "),
             "| awk -F\" \" '/^R/ { print $2, $9 }'")
lsofOutput <- system(cmd, intern=TRUE)
f <- textConnection(lsofOutput)
d <- unique(read.delim(f, sep=" ", header=FALSE, as.is=TRUE))
allTouchedFiles <- unique(d[[2]])
close(f)
pids <- d[[1]]
nms <- dropExt(basename(d[[2]]))
df <- data.frame(pid=pids)
rownames(df) <- nms
if(nrow(df)>0) {
  message("=currently running=")
  print(df)
}

notYetExecuted <- baseNames[!file.exists(fileNames)]
if(length(notYetExecuted) > 1) {
  message("")
  message("=not yet executed=")
  message(paste(notYetExecuted, collapse=" "))
}

exId <- file.exists(fileNames) & (!(fileNames %in% allTouchedFiles))
alreadyExecuted <- baseNames[exId]
if(length(alreadyExecuted) > 0) {
  message("")
  message("=completed=")
  fn <- fileNames[exId]
  lastLine <- Vectorize(function(x) system(paste("tail -n 1 ", x), intern=TRUE))
  lastLines <- lastLine(fn)
  fn.times <- suppressWarnings(as.numeric(gsub("^.*\\d+\\.\\d+.*\\d+\\.\\d+.*?(\\d+\\.\\d+).*",
                                               "\\1", lastLines)))
  df <- data.frame(time=round(fn.times/60, digits=1))
  rownames(df) <- alreadyExecuted
  colnames(df) <- "time (minutes)"
  df <- df[sort(rownames(df)),,drop=FALSE]
  print(df)
}
