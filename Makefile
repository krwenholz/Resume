SRC = $(wildcard *.md)

PDFS=$(SRC:.md=.pdf)
HTML=$(SRC:.md=.html)
LATEX_TEMPLATE=./pandoc-templates/default.latex

all:   clean docker_setup $(PDFS) $(HTML)

docker_setup:
	docker build --tag pandoc/latex-resume:1.0 .
	mkdir -p .tmp

pdf:   clean $(PDFS)
html:  clean $(HTML)

%.html: %.md
	docker run --rm --name resume -v ${PWD}:/usr/src/myapp -w /usr/src/myapp python:3.7-alpine python resume.py html $(GRAVATAR_OPTION) < $< > .tmp/resume.html.md
	docker run --rm --volume "`pwd`:/data" --user `id -u`:`id -g` pandoc/latex-resume:1.0  .tmp/resume.html.md -t html -c resume.css -o $@

%.pdf:  %.md $(LATEX_TEMPLATE)
	docker run --rm --name resume -v ${PWD}:/usr/src/myapp -w /usr/src/myapp python:3.7-alpine python resume.py tex < $< > .tmp/resume.tex.md
	docker run --rm --volume "`pwd`:/data" --user `id -u`:`id -g` pandoc/latex-resume:1.0 .tmp/resume.tex.md $(PANDOCARGS) --variable subparagraph --template=$(LATEX_TEMPLATE) -H header.tex -o $@

ifeq ($(OS),Windows_NT)
  # on Windows
  RM = cmd //C del
else
  # on Unix
  RM = rm -f
endif

clean:
	$(RM) *.html *.pdf

$(LATEX_TEMPLATE):
	git submodule update --init
