.PHONY : hws solns clean

# MATHJAX = /usr/share/javascript/mathjax/MathJax.js
MATHJAX = https://cdn.mathjax.org/mathjax/latest/MathJax.js
PANDOC_OPTS = 
PANDOC_HTML_OPTS =  --to html --from markdown-implicit_figures --self-contained --standalone --section-divs --template /usr/local/lib/R/site-library/rmarkdown/rmd/h/default.html --variable 'theme:bootstrap' --include-in-header resources/header-scripts.html --mathjax --variable 'mathjax-url:$(MATHJAX)?config=TeX-AMS-MML_HTMLorMML' --no-highlight --variable highlightjs=/usr/local/lib/R/site-library/rmarkdown/rmd/h/highlight 

all : hws solns

clean :
	-rm *.aux *.log *.out

# mds : $(patsubst %.Rmd,%.md,$(wildcard *.Rmd))
# htmls : $(patsubst %.md,%.html,$(wildcard *.md) $(mds))

hws : $(patsubst %.gpp.Rmd,%.html,$(wildcard *.gpp.Rmd))
solns : $(patsubst %.gpp.Rmd,%.solutions.html,$(wildcard *.gpp.Rmd))
pdfs : $(patsubst %.gpp.Rmd,%.pdf,$(wildcard *.gpp.Rmd))

%.Rmd : %.gpp.Rmd
	gpp -T $< > $@

%.solutions.Rmd : %.gpp.Rmd
	# see https://randomdeterminism.wordpress.com/2012/06/01/how-i-stopped-worring-and-started-using-markdown-like-tex/
	# BUT:  wrap things to appear in solutions in
	#       \ifdef{SOLUTIONS}
	#		\endif
	gpp -T -DSOLUTIONS $< > $@

%.md : %.Rmd
	cd $$(dirname $<); Rscript -e 'knitr::knit(basename("$<"),output=basename("$@"))'

%.html : %.md
	pandoc $< $(PANDOC_HTML_OPTS) $(PANDOC_OPTS) --output $@

%.pdf : %.md
	pandoc $< --to latex $(PANDOC_OPTS) --output $@

