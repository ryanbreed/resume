resumes = resume.pdf resume.html resume.docx resume.tex resume.md README.md
ksas = ksa.pdf ksa.html ksa.docx ksa.tex ksa.md
covers = cover-*.md cover-*.pdf cover-*.docx cover-*.html
resume_source = -f gfm resume.md
ksa_source = -f gfm ksa.md
flavors = sre security architect data shotgun

ifndef DATAFILE
DATAFILE=data/resume.yaml
export DATAFILE
endif

ifndef JOB_TITLE
JOB_TITLE=JOBTITLE
export JOB_TITLE
endif

ifndef FLAVOR
FLAVOR=shotgun
export FLAVOR
endif

resume : $(resumes)

templates/resume-template.docx :
	make -C templates

templates : templates/resume-template.docx

clean :
	make -C templates clean
	rm -f $(resumes) $(covers) $(ksas)
	osascript -e 'tell application "Preview" to (close every window whose name contains "resume")'
	osascript -e 'tell application "Preview" to (close every window whose name contains "ksa")'

resume.md : templates $(DATAFILE)
	bundle exec erubis -f $(DATAFILE) templates/resume-template.md.erb > resume.md

ksa.md : templates $(DATAFILE)
	bundle exec erubis -f $(DATAFILE) templates/ksa-template.md.erb > ksa.md


resume.pdf : resume.md
	pandoc $(resume_source) \
	--template=templates/resume-template.latex \
	--variable=indent \
	--variable=subparagraph \
	-o resume.pdf

ksa.pdf : ksa.md
	pandoc $(ksa_source) \
	--template=templates/resume-template.latex \
	--variable=indent \
	--variable=subparagraph \
	-o ksa.pdf

title = title:Ryan Breed
title += $(shell date +%Y/%m/%d)


resume.html : resume.md
	pandoc $(resume_source) \
	  --template=templates/resume-template.html5 \
		--metadata='$(title)' \
		-t html5 -s -o resume.html

resume.docx : resume.md
	pandoc $(resume_source) \
	  --reference-doc=templates/resume-template.docx \
		-t docx -o resume.docx

resume.tex: resume.md
	pandoc $(resume_source) \
	  --template=templates/resume-template.latex \
	  -s -t latex -o resume.tex

README.md : templates
	FLAVOR=shotgun bundle exec erubis -f $(DATAFILE) templates/resume-template.md.erb > README.md

covers: cover-data.docx cover-sre.docx cover-security.docx

cover-%.md : templates
	JOB_FLAVOR=$* bundle exec erubis -f $(DATAFILE) templates/cover-template.md.erb > $@

cover-%.pdf : cover-%.md
	pandoc -f gfm $< \
	--template=templates/cover-template.latex \
	-o $@

cover-%.docx : cover-%.md
	pandoc -f gfm $< \
		--reference-doc=templates/resume-template.docx \
		-t docx -o $@

.PHONY: clean setup

setup:
	bundle install --path=vendor/bundle
