.SUFFIXES: .tex .pdf .view

DOCS = fits
VCS_STAMP = gitid.tex
STILTS = java -jar $(STILTS_JAR)
STILTS_JAR = stilts.jar

PDFLATEX = env TEXINPUTS=:/mbt/local/share/texslides pdflatex

build: $(DOCS:=.pdf)

view: fits.view

fits.pdf: $(VCS_STAMP)

$(STILTS_JAR):
	curl -OL http://www.starlink.ac.uk/stilts/stilts.jar

$(VCS_STAMP):
	echo -n '{\\tt ' >$@
	pwd | sed 's%.*/%%' >>$@
	echo -n '{\\jobname}.tex ' >>$@
	echo -n `git log -1 --pretty="format:%h %ci" | sed "s/ [+-].*//"`>>$@
	echo '}' >>$@

clean:
	rm -f $(VCS_STAMP)
	rm -f $(DOCS:=.aux) $(DOCS:=.log) $(DOCS:=.out) $(DOCS:=.pdf)

veryclean: clean
	rm -f $(STILTS_JAR)

.tex.pdf:
	$(PDFLATEX) $< && \
        $(PDFLATEX) $< || \
        rm -f $@

.pdf.view:
	test -f $< && \
        okular $< 2>/dev/null


