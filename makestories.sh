#!/bin/bash
STORIES=
CATEGORIES=
RSS=rss.dat
LAST=last.dat
rm $RSS
LAST_UPDATED=$(git log -n1 --pretty=format:%cD)
echo "$LAST_UPDATED" > $LAST

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
	mkdir -p html/$category
done

for story in $STORIES
do
    DATE=$(git log -n1 --pretty=format:%cD -- stories/$story)
	echo $story=$DATE >> $RSS
	echo Generating $story ...
	ruby story.rb $story > html/$story
done
