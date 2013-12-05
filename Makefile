OUT=html
RSS=html/rss

all: html css fortunes
html: stories rss index
index: index.html index.json
css: general.css bootstrap-responsive.css bootstrap.css

%.html: %.rb %.erb
	ruby $< > ${OUT}/$@	

%.json: %.rb %.erb
	ruby $< --json > ${OUT}/$@
 
rss: index.rb rss.erb
	ruby index.rb --rss > ${RSS}

%.css: 
	mkdir -p ${OUT}/css
	cp css/$@ ${OUT}/css

#	WIP -> Compressing css.
#
#compress-css:
#	yui-compress > .min.css

stories:
	bash makestories.sh

fortunes:
	mkdir -p html/fortunes
	cp fortunes/* html/fortunes

clean: 
	rm -f ${OUT}/*.html

test:
	ruby webserver.rb 

.PHONY: stories fortunes test
