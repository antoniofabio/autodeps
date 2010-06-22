load("bau/info.RData")
load("bau/X.RData")

x <- 1:3

save(x, file="bau/analysis.RData")

save(x, file=paste("an", 1, ".RData", sep=""))

if(FALSE) {
  save(file="maramao") ## ignored
}

save(x, file="what"+"is"+"that?") ## this is ignored too

## these are ignored too:
load(marameo)
load(123)
v <- "123"
load(v)
