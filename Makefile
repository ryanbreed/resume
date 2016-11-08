formats = resume.pdf resume.html resume.docx resume.tex resume.md

resume : $(formats)

templates/resume-template.docx :
	make -C templates

templates : templates/resume-template.docx

clean :
	make -C templates clean
	rm -f $(formats)

resume.md : templates data/resume.yaml
	erubis -f data/resume.yaml templates/README-template.md.erb > resume.md

resume.pdf : README.md templates
	pandoc -f markdown_github README.md  \
	--template=templates/resume-template.latex \
	--variable=indent \
	--variable=subparagraph \
	-o resume.pdf

resume.html : README.md templates
	pandoc -f markdown_github README.md  \
	  --template=templates/resume-template.html5 \
		-t html5 -s -o resume.html

resume.docx : README.md templates
	pandoc -f markdown_github README.md  \
	  --reference-docx=templates/resume-template.docx \
		-t docx -o resume.docx

resume.tex: README.md templates
	pandoc -f markdown_github README.md  \
	  --template=templates/resume-template.latex \
	  -s -t latex -o resume.tex
