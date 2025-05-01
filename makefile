.SUFFIXES: .tex .pdf .view

DOCS = fits
VCS_STAMP = gitid.tex
STILTS = java -jar $(STILTS_JAR)
STILTS_JAR = stilts.jar

PDFLATEX = pdflatex

build: $(DOCS:=.pdf)

view: fits.view

fits.pdf: $(VCS_STAMP)

skysim10.fits:
	stilts tpipe in=:skysim:10000 \
               cmd='addcol source_id (int)($$0==1?NULL:$$0)' \
               cmd='keepcols "source_id ra dec"' \
               cmd='addcol name \"ABBBBBBBBCBB\"' \
               cmd='addcol spectrum sequence(1024)' \
               ofmt='fits(primary=basic,var=true)' \
               out=$@

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


