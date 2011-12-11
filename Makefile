OUT=html

all: html css fortunes
html: index.html stories
css: announce.css general.css css.css story.css twitter.css

%.html: %.rb %.erb
	ruby $< > ${OUT}/$@	
 
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

.PHONY: stories fortunes
