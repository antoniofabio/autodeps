#! /usr/bin/Rscript
library(igraph)

contents <- strsplit(readLines(file("stdin")), ":")

spaceSplit <- function(x) {
  ans <- unlist(strsplit(x, " +"))
  return(ans[ans != ""])
}

childs <- lapply(sapply(contents, "[", 1), spaceSplit)
parents <- lapply(sapply(contents, "[", 2), spaceSplit)
allNodes <- union(unlist(childs), unlist(parents))
nodesId <- seq_along(allNodes)-1
names(nodesId) <- allNodes
## normalize child nodes: one element per list element:
normalizeParents <- function(C, P) {
  ans <- mapply(function(Ci, Pi) lapply(seq_along(Ci), function(ignore) Pi),
                C, P, SIMPLIFY=FALSE)
  return(Reduce(append, ans))
}
normalizeChilds <- function(C) unlist(C)
C1 <- normalizeParents(parents, childs)
P1 <- normalizeChilds(parents)
names(C1) <- P1
e <- numeric(0)
for(n in names(C1)) {
  c1n <- C1[[n]]
  for(m in c1n) {
    e <- append(e, c(nodesId[n], nodesId[m]))
  }
}
L <- topological.sort(graph(e, directed=TRUE))
cat(allNodes[L+1], sep="\n")
