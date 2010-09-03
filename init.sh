echo ".Rhistory
.*.d
.*.Rout
*.RData
report.R
" > .gitignore
git init
git add .gitignore autodeps.R showGraph.R report.R Makefile Makefile.config
git commit -m "initial commit"
