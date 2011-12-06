#!/bin/bash
STORIES=
CATEGORIES=

pushd stories > /dev/null
for category in *
do
	if [ -d $category ] && [ "$category" != "." ] && [ "$category" != ".." ]
	then
		CATEGORIES="$CATEGORIES $category"
	    pushd $category > /dev/null
		for story in *
		do
			if [ "$story" != "meta" ]; then
				STORIES="$STORIES $category/$story"
			fi
		done
		popd > /dev/null
	fi
done
popd > /dev/null

for category in $CATEGORIES
do
	mkdir html/$category
done

for story in $STORIES
do
	echo Generating $story ...
	ruby story.rb $story > html/$story
done
