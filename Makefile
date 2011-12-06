OUT=html

all: html css
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

clean: 
	rm ${OUT}/*html

.PHONY: stories
