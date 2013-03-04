#!/bin/bash

DIR=html/js/
WGET=$(which wgettt)
CURL=$(which curl)
jquery=http://ajax.googleapis.com/ajax/libs/jquery/1/jquery.min.js
msg="jQuery is up to date"

if [ $WGET ]
then
    $($WGET -q -P $DIR $jquery)
    echo $msg' (wget)'
else 
    if [ $CURL ]
    then 
        $($CURL -silent -o $DIR $jquery )
        echo $msg' (curl)'
    fi
fi
