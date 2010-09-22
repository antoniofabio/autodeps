#!/usr/bin/env Rscript

fileNames <- commandArgs(trailingOnly=TRUE)
dropExt <- function(x) gsub(".(.*)\\..*", "\\1", x)
baseNames <- dropExt(basename(fileNames))
getRunTime <- Vectorize(function(x) {
  if(file.exists(x)) {
    return(suppressWarnings(as.numeric(gsub("^.*\\d+\\.\\d+.*\\d+\\.\\d+.*?(\\d+\\.\\d+).*",
                                            "\\1",
                                            system(paste("tail -n 1 ", x), intern=TRUE)
                                            ))))
  } else {
    return(NA)
  }
})
allTargetCmds <- grep("^R CMD BATCH.*", system("make -n all", intern=TRUE), value=TRUE)
stringIn <- Vectorize(function(a) any(grepl(a, allTargetCmds)))
df <- data.frame(script=baseNames,
                 time=round(getRunTime(fileNames)/60, digits=1),
                 uptodate=!stringIn(fileNames))
rownames(df) <- seq_len(nrow(df))
colnames(df)[2] <- "time (minutes)"
print(df)

allPresentFiles <- fileNames[file.exists(fileNames)]
allTouchedFiles <- c()
if(length(allPresentFiles)>0) {
  cmd <- paste("lsof", paste(allPresentFiles, collapse=" "),
               "| awk -F\" \" '/^R/ { print $2, $9 }'")
  lsofOutput <- system(cmd, intern=TRUE)
  if(length(lsofOutput)>0) {
    f <- textConnection(lsofOutput)
    d <- unique(read.delim(f, sep=" ", header=FALSE, as.is=TRUE))
    close(f)
    allTouchedFiles <- unique(d[[2]])
    pids <- d[[1]]
    nms <- dropExt(basename(d[[2]]))
    df <- data.frame(pid=pids)
    rownames(df) <- nms
    df <- df[sort(rownames(df)),,drop=FALSE]
    message("=currently running=")
    print(df)
  }
}
