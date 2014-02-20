#!/bin/bash
# Video transcoder

# CPR : Jd Daniel
# MOD : 2014-02-20 @ 10:51:25
# VER : Beta 1

# proto: cd drop ; types=(asf asx avi flv m4v mov mp4 mpg rm swf vob wmv); for i in "${types[@]}"; do touch "video.${i}"; done;

# dectypes
declare -r fpath=$( cd "$(dirname "$0")/drop" ; pwd -P )
declare -r types="asf\|asx\|avi\|flv\|m4v\|mov\|mp4\|mpg\|ogg\|rm\|swf\|vob\|webm\|wmv"
declare -r allow="mp4 ogg webm"r

	cd $fpath 

	for video in $(find . -type f -iregex ".*\(${types}\)" -printf '%P\0 '); do

		echo -e "$video"

	done