#! /usr/bin/Rscript
f <- file("stdin")
input <- readLines(f)
close(f)
if(!require(igraph, quietly=TRUE)) {
  message("the `igraph' R package is needed to handle the dependencies graph")
  cat(input, sep="\n")
  quit(save="no", status=0)
}

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
g <- set.graph.attribute(g, "label", value=allNodes)

L <- allNodes[topological.sort(g) + 1]
L <- grep(".*\\.R$", L, invert=TRUE, value=TRUE)
c1 <- sapply(childs, paste, collapse=" ")
p1 <- sapply(parents, paste, collapse=" ")

for(l in L) {
  l1 <- gsub("(.*)\\.RData", "\\1", l)
  cat(sprintf("\033[0;1;36;40m%s\033[0m", l1), ": ")
  lgr <- which(l == c1)
  if(length(lgr)>0) {
    p11 <- parents[[lgr]]
    p11.R <- gsub("(.)\\.R$", "\\1",
                  grep(".*\\.R$", p11, value=TRUE))
    p11.RData <- gsub("(.)\\.RData$", "\\1",
                      grep(".*\\.RData$", p11, value=TRUE))
    p11.col <- c(sprintf("\033[0;0;32;40m%s\033[0m", p11.R),
                 sprintf("\033[0;0;36;40m%s\033[0m", p11.RData))
    cat(p11.col)
  }
  cat('\n')
}
