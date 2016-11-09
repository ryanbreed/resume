formats = resume.pdf resume.html resume.docx resume.tex resume.md README.md
covers = cover.md cover.pdf
source = -f markdown_github resume.md
cover_source = -f markdown_github cover.md

resume : $(formats)

templates/resume-template.docx :
	make -C templates

templates : templates/resume-template.docx

clean :
	make -C templates clean
	rm -f $(formats) $(covers)

resume.md : templates data/resume.yaml
	erubis -f data/resume.yaml templates/resume-template.md.erb > resume.md

resume.pdf : resume.md
	pandoc $(source) \
	--template=templates/resume-template.latex \
	--variable=indent \
	--variable=subparagraph \
	-o resume.pdf

resume.html : resume.md
	pandoc $(source) \
	  --template=templates/resume-template.html5 \
		-t html5 -s -o resume.html

resume.docx : resume.md
	pandoc $(source) \
	  --reference-docx=templates/resume-template.docx \
		-t docx -o resume.docx

resume.tex: resume.md
	pandoc $(source) \
	  --template=templates/resume-template.latex \
	  -s -t latex -o resume.tex

README.md : resume.md templates
	cp resume.md README.md

cover.md : templates
	erubis -f data/resume.yaml templates/cover-template.md.erb > cover.md

cover.pdf : cover.md
	pandoc $(cover_source) \
	--template=templates/resume-template.latex \
	-o cover.pdf
