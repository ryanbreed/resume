resumes = resume.pdf resume.html resume.docx resume.tex resume.md README.md
covers = cover-*.md cover-*.pdf cover-*.docx cover-*.html
resume_source = -f gfm resume.md
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

ifndef RENDER_DATE
	RENDER_DATE=$(( date +%Y/%m/%d))
	export RENDER_DATE
endif

resume : $(resumes)

templates/resume-template.docx :
	make -C templates

templates : templates/resume-template.docx

clean :
	make -C templates clean
	rm -f $(resumes) $(covers)

resume.md : templates $(DATAFILE)
	bundle exec erubis -f $(DATAFILE) templates/resume-template.md.erb > resume.md

resume.pdf : resume.md
	pandoc $(resume_source) \
	--template=templates/resume-template.latex \
	--variable=indent \
	--variable=subparagraph \
	-o resume.pdf

resume.html : resume.md
	pandoc $(resume_source) \
	  --template=templates/resume-template.html5 \
		--metadata="title:FIXME" \
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
