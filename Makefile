fontsize = 10pt
margin = 1in
layout_variables = 	--variable=fontsize:$(fontsize) \
	--variable=margin-left:$(margin) \
	--variable=margin-right:$(margin) \
	--variable=margin-top:$(margin) \
	--variable=margin-bottom:$(margin) \

formats = resume.pdf resume.html resume.docx resume.tex

resume : $(formats)

templates/resume-template.docx :
	make -C templates
  
templates : templates/resume-template.docx

clean :
	make -C templates clean
	rm -f $(formats)

resume.pdf : README.md templates
	pandoc -f markdown_github README.md  \
	--template=templates/resume-template.latex \
	$(layout_variables) \
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
	$(layout_variables) \
	  -s -t latex -o resume.tex
