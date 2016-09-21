#!/bin/bash

#latex thesis.tex
#latex thesis.tex
#bibtex thesis.aux
#latex thesis.tex
#latex thesis.tex
#dvipdf thesis.dvi

pdflatex --shell-escape thesis.tex
pdflatex --shell-escape thesis.tex
bibtex thesis.aux
pdflatex --shell-escape thesis.tex
pdflatex --shell-escape thesis.tex
