echo "auto
.Rhistory
.*.d
.*.Rout
*.RData
*.pdf
report.R
figures
*.aux
*.log
" > .gitignore
git init
git add .gitignore autodeps.R showGraph.R report.R Makefile Makefile.config
git commit -m "initial commit"
