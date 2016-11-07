fontsize = 10pt
margin = 1in
formats = resume.pdf resume.html resume.docx resume.rtf

resume : $(formats)

clean :
	rm -f $(formats)

resume.pdf : README.md
	pandoc -f markdown_github README.md  \
	--variable=fontsize:$(fontsize) \
	--variable=margin-left:$(margin) \
	--variable=margin-right:$(margin) \
	--variable=margin-top:$(margin) \
	--variable=margin-bottom:$(margin) \
	--variable=indent \
	--variable=subparagraph \
	-o resume.pdf

resume.html : README.md
	pandoc -f markdown_github README.md  \
		-t html5 -o resume.html

resume.docx : README.md
	pandoc -f markdown_github README.md  \
		-t docx -o resume.docx

resume.rtf : README.md
	pandoc -f markdown_github README.md  \
		-t rtf -o resume.rtf
