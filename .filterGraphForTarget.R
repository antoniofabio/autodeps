#!/usr/bin/env Rscript
if(!require(igraph, quietly=TRUE)) {
  message("the `igraph' R package is needed to handle the dependencies graph")
  cat(input, sep="\n")
  quit(save="no", status=0)
}

TARGET <- commandArgs(trailingOnly=TRUE)

ff <- dir(".", pattern = "\\..*\\.d$", all.files = TRUE)
input <- c()
for(f in ff) input <- c(input, readLines(f))

contents <- strsplit(input, ":")

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

g <- graph(graphVec-1, directed=TRUE)
g <- set.vertex.attribute(g, "label", value=allNodes)

c1 <- sapply(childs, paste, collapse=" ")
p1 <- sapply(parents, paste, collapse=" ")

family <- function(x) {
  i <- match(x, c1)
  if(is.finite(i)) {
    return(unique(c(x, unlist(lapply(as.list(strsplit(p1[[i]], " ")[[1]]), family)))))
  }
  return(x)
}

out <- get.vertex.attribute(subgraph(g, match(family(TARGET), allNodes) - 1), "label")
out <- grep("\\.R$", out, value = TRUE)

writeLines(sub("(.*)\\.R$", ".\\1.d", out))
