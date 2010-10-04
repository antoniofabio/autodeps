#!/usr/bin/env Rscript

fileNames <- commandArgs(trailingOnly=TRUE)
fileNames <- fileNames[file.exists(fileNames)]
input <- vector(mode="character")
for(f in fileNames) {
  input <- c(input, readLines(f))
}

contents <- strsplit(input, ":")
targets <- setdiff(sapply(contents, "[", 1), "")
cat(paste(targets, collapse=" "))
