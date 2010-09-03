echo "auto
.Rhistory
.*.d
.*.Rout
*.RData
*.pdf
report.R
report.tex
figures
*.aux
*.log
" > .gitignore
git init
git add -f .gitignore autodeps.R showGraph.R report.Rnw Makefile Makefile.config
git commit -m "initial commit"
