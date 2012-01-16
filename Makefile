OUT=html
RSS=html/rss

all: html css fortunes
html: stories rss index.html 
css: announce.css general.css css.css story.css twitter.css

%.html: %.rb %.erb
	ruby $< > ${OUT}/$@	
 
rss: index.rb rss.erb
	ruby index.rb --rss > ${RSS}

css.css: css.rb css.erb 
	ruby $< > ${OUT}/$@

%.css: 
	cp css/$@ ${OUT}

stories:
	bash makestories.sh

fortunes:
	mkdir -p html/fortunes
	cp fortunes/* html/fortunes

clean: 
	rm ${OUT}/*html

test:
	ruby webserver.rb 

.PHONY: stories fortunes test
