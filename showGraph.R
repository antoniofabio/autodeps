#! /usr/bin/Rscript
if(!require(igraph)) {
  message("the `igraph' R package is needed to handle the dependencies graph")
  quit(save="no", status=0)
}

contents <- strsplit(readLines(file("stdin")), ":")

spaceSplit <- function(x) {
  ans <- unlist(strsplit(x, " +"))
  return(ans[ans != ""])
}

childs <- lapply(sapply(contents, "[", 1), spaceSplit)
parents <- lapply(sapply(contents, "[", 2), spaceSplit)
allNodes <- union(unlist(childs), unlist(parents))

graphVec <- numeric(0)
for(i in seq_along(parents)) {
  pi <- parents[[i]]
  ci <- childs[[i]]
  for(pp in pi) for(cc in ci) {
    graphVec <- append(graphVec,
                         c(match(pp, allNodes),
                           match(cc, allNodes)))
  }
}
graphVec <- graphVec-1

L <- topological.sort(graph(graphVec, directed=TRUE))
cat(allNodes[L+1], sep="\n")
