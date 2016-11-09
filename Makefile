resumes = resume.pdf resume.html resume.docx resume.tex resume.md README.md
covers = cover-*.md cover-*.pdf cover-*.docx cover-*.html
resume_source = -f markdown_github resume.md

ifndef JOB_TITLE
JOB_TITLE=JOBTITLE
export JOB_TITLE
endif

resume : $(resumes)

templates/resume-template.docx :
	make -C templates

templates : templates/resume-template.docx

clean :
	make -C templates clean
	rm -f $(resumes) $(covers)

resume.md : templates data/resume.yaml
	erubis -f data/resume.yaml templates/resume-template.md.erb > resume.md

resume.pdf : resume.md
	pandoc $(resume_source) \
	--template=templates/resume-template.latex \
	--variable=indent \
	--variable=subparagraph \
	-o resume.pdf

resume.html : resume.md
	pandoc $(resume_source) \
	  --template=templates/resume-template.html5 \
		-t html5 -s -o resume.html

resume.docx : resume.md
	pandoc $(resume_source) \
	  --reference-docx=templates/resume-template.docx \
		-t docx -o resume.docx

resume.tex: resume.md
	pandoc $(resume_source) \
	  --template=templates/resume-template.latex \
	  -s -t latex -o resume.tex

README.md : resume.md templates
	cp resume.md README.md

cover-%.md : templates
	JOB_FLAVOR=$* erubis -f data/resume.yaml templates/cover-template.md.erb > $@

cover-%.pdf : cover-%.md
	pandoc -f markdown_github $< \
	--template=templates/cover-template.latex \
	-o $@

cover-%.docx : cover-%.md
	pandoc -f markdown_github $< \
		--reference-docx=templates/resume-template.docx \
		-t docx -o $@
