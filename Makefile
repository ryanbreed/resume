fontsize = 10pt
margin = 1in

resume : resume.pdf resume.html

clean :
	rm -f resume.pdf resume.html resume.docx

resume.pdf : README.md
	pandoc -f markdown_github README.md  --variable=fontsize:$(fontsize) \
	--variable=margin-left:$(margin) \
	--variable=margin-right:$(margin) \
	--variable=margin-top:$(margin) \
	--variable=margin-bottom:$(margin) \
	--variable=indent \
	--variable=subparagraph \
	-o resume.pdf

resume.html : README.md
	pandoc -f markdown_github README.md  \
		-t html5 \
		-o resume.html
