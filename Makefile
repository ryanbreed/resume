fontsize = 10pt
margin = 1in
formats = resume.pdf resume.html resume.docx resume.tex

resume : $(formats)

templates/resume-template.docx :
	make -C templates resume-template.docx

resume_templates :
	make -C templates

clean :
	make -C templates clean
	rm -f $(formats)

resume.pdf : README.md resume_templates
	pandoc -f markdown_github README.md  \
	--template=templates/resume-template.latex \
	--variable=fontsize:$(fontsize) \
	--variable=margin-left:$(margin) \
	--variable=margin-right:$(margin) \
	--variable=margin-top:$(margin) \
	--variable=margin-bottom:$(margin) \
	--variable=indent \
	--variable=subparagraph \
	-o resume.pdf

resume.html : README.md resume_templates
	pandoc -f markdown_github README.md  \
	  --template=templates/resume-template.html5 \
		-t html5 -s -o resume.html

resume.docx : README.md templates/resume-template.docx
	pandoc -f markdown_github README.md  \
	  --reference-docx=templates/resume-template.docx \
		-t docx -o resume.docx

resume.tex: README.md resume_templates
	pandoc -f markdown_github README.md  \
	  --template=templates/resume-template.latex \
	  -s -t latex -o resume.tex
