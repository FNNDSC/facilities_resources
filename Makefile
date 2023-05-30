#
# Makefile - asciidoc to friends
#
#
# HISTORY
#
# May 2023
# Resurrect from old LaTeX document build and revamp
#

SHELL = /bin/sh

###\\\
# Truth --->
###///
ADOCDIR		=  adoc
ADOCFILES	:= $(wildcard adoc/*.adoc)
ADOCDIRNAMES	:= $(basename $(ADOCFILES))
ADOCBASENAMES	:= $(subst adoc/,,$(ADOCDIRNAMES))

###\\\
# Re-Truth --->
###///

PDFDIR          = pdf
PDFFILES	:= $(addsuffix .pdf,$(ADOCBASENAMES))

DOCXDIR         = docx
DOCXFILES       := $(addsuffix .docx,$(ADOCBASENAMES))

HTMLDIR         = html
HTMLFILES       := $(addsuffix .html,$(ADOCBASENAMES))

TEXDIR          = tex
TEXFILES        := $(addsuffix .tex,$(ADOCBASENAMES))

TEXPDFDIR       = tex-pdf
TEXPDFFILES     := $(addsuffix .tpdf,$(ADOCBASENAMES))

###\\\
# Buildable targets --->
###///

options 	:= -a toc -a toclevels="1"
options 	:= 

all:		html tex pdf docx tex-pdf

again:
		(touch $(ADOCFILES) ; make all)

pdf:		$(PDFFILES)

tex-pdf:        $(TEXPDFFILES)

html:		$(HTMLFILES)

docx:		$(DOCXFILES)

tex:            $(TEXFILES)

.PHONY:		all pdf tex html

clean:
		rm -f html/*html
		rm -f pdf/*pdf
		rm -f docx/*docx
		rm -f tex/*tex
		rm -f tex-pdf/*

###\\\
# Some suffix rules --->
###///

%.pdf:  	adoc/%.adoc
		asciidoctor-pdf $^ $(options) -o pdf/$@

%.tpdf:  	tex/%.tex
		xelatex $(options) -output-directory=tex-pdf $^
		xelatex $(options) -output-directory=tex-pdf $^
		rm tex-pdf/*aux
		rm tex-pdf/*log
		rm tex-pdf/*out

%.html: 	adoc/%.adoc
		asciidoctor $^ $(options) -o html/$@

%.docx:		adoc/%.adoc
		asciidoctor $^ --backend docbook -o - | pandoc  --reference-doc=custom-reference.docx  --from docbook --to docx -o docx/$@

%.tex:		adoc/%.adoc
		asciidoctor-latex $^ $(options) -o tex/$@


