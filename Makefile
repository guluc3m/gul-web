OUT=html

all: html css
html: index.html
css: announce.css general.css css.css

%.html: %.rb %.erb
	ruby $< > ${OUT}/$@	
 
css.css: css.rb css.erb 
	ruby $< > ${OUT}/$@

%.css: 
	cp css/$@ ${OUT}
 
clean: 
	rm ${OUT}/*html
