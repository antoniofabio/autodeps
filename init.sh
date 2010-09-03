echo "auto
.Rhistory
.*.d
.*.Rout
*.RData
report.R
figures
" > .gitignore
git init
git add .gitignore autodeps.R showGraph.R report.R Makefile Makefile.config
git commit -m "initial commit"
