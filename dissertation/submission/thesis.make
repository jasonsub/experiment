#!/bin/bash

#latex thesis.tex
#latex thesis.tex
#bibtex thesis.aux
#latex thesis.tex
#latex thesis.tex
#dvipdf thesis.dvi

pdflatex --shell-escape thesis_xiaojun.tex
pdflatex --shell-escape thesis_xiaojun.tex
bibtex thesis_xiaojun.aux
pdflatex --shell-escape thesis_xiaojun.tex
pdflatex --shell-escape thesis_xiaojun.tex
