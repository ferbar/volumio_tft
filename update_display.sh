#!/bin/bash

	state=$(curl -s localhost:3000/api/v1/getstate)
	status=$(echo "$state" | jq -r '.status')
	title=$(echo "$state" | jq -r '.title')
	artist=$(echo "$state" | jq -r '.artist')
	echo "$status $title $artist"
#	convert -density 90 -pointsize 16 label:"$status
#$title" /tmp/info.gif
#	fbi -T 1 -d /dev/fb1 /tmp/info.gif
	time nice -n 19 /usr/bin/fb_cairo "$status" "$title" "$artist"
