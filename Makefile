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

###\\\
# Buildable targets --->
###///

options 	:= -a toc -a toclevels="1"
options 	:= 

all:		html pdf docx

again:
		(touch $(ADOCFILES) ; make all)

pdf:		$(PDFFILES)

html:		$(HTMLFILES)

docx:		$(DOCXFILES)

.PHONY:		all pdf html

clean:
		rm -f html/*html
		rm -f pdf/*pdf
		rm -f docx/*docx

###\\\
# Some suffix rules --->
###///

%.pdf:  	adoc/%.adoc
		asciidoctor-pdf $^ $(options) -o pdf/$@

%.html: 	adoc/%.adoc
		asciidoctor $^ $(options) -o html/$@

%.docx:		adoc/%.adoc
		asciidoctor $^ --backend docbook -o - | pandoc  --reference-doc=custom-reference.docx  --from docbook --to docx -o docx/$@


