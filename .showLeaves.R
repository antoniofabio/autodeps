#!/usr/bin/env Rscript
f <- file("stdin")
input <- readLines(f)
close(f)

contents <- strsplit(input, ":")

spaceSplit <- function(x) {
  ans <- unlist(strsplit(x, " +"))
  return(ans[ans != ""])
}

childs <- lapply(sapply(contents, "[", 1), spaceSplit)
parents <- lapply(sapply(contents, "[", 2), spaceSplit)
allNodes <- union(unlist(childs), unlist(parents))

leaves <- c()
for(node in allNodes) {
  if(!any(sapply(parents, function(x) node %in% x))) {
    leaves <- c(leaves, node)
  }
}

writeLines(leaves)
