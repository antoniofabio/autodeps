#!/usr/bin/env Rscript

f <- file("stdin")
d <- unique(read.delim(f, sep=" ", header=FALSE, as.is=TRUE))
pids <- d[[1]]
nms <- gsub("^\\.(.*)\\.Rout$", "\\1", basename(d[[2]]))
df <- data.frame(pid=pids)
rownames(df) <- nms
print(df)
