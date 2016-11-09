formats = resume.pdf resume.html resume.docx resume.tex resume.md README.md
source = -f markdown_github resume.md

resume : $(formats)

templates/resume-template.docx :
	make -C templates

templates : templates/resume-template.docx

clean :
	make -C templates clean
	rm -f $(formats)

resume.md : templates data/resume.yaml
	erubis -f data/resume.yaml templates/resume-template.md.erb > resume.md

resume.pdf : resume.md templates
	pandoc $(source) \
	--template=templates/resume-template.latex \
	--variable=indent \
	--variable=subparagraph \
	-o resume.pdf

resume.html : resume.md templates
	pandoc $(source) \
	  --template=templates/resume-template.html5 \
		-t html5 -s -o resume.html

resume.docx : resume.md templates
	pandoc $(source) \
	  --reference-docx=templates/resume-template.docx \
		-t docx -o resume.docx

resume.tex: resume.md templates
	pandoc $(source) \
	  --template=templates/resume-template.latex \
	  -s -t latex -o resume.tex

README.md : resume.md templates
	cp resume.md README.md
