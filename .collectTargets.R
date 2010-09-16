#! /usr/bin/Rscript
f <- file("stdin")
input <- readLines(f)
close(f)

contents <- strsplit(input, ":")
targets <- setdiff(sapply(contents, "[", 1), "")
cat(paste(targets, collapse=" "))
