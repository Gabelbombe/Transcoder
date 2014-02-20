#!/bin/bash
# Video transcoder

# CPR : Jd Daniel
# MOD : 2014-02-20 @ 10:51:25
# VER : Beta 1

# proto: cd drop ; types=(asf asx avi flv m4v mov mp4 mpg rm swf vob wmv); for i in "${types[@]}"; do touch "video.${i}"; done;


inp="drop"
out="export"


## test for reqs of exit
for requires in ffmpeg; do
	hash $requires 2>/dev/null || { 
		echo >&2 "I require $requires to run but it's not installed.  Aborting."; exit 1; 
	}
done



## dectypes
declare -r fpath=$( cd "$(dirname "$0")/$inp" ; pwd -P )
declare -r types="asf\|asx\|avi\|flv\|m4v\|mov\|mp4\|mpg\|ogg\|rm\|swf\|vob\|webm\|wmv"
declare -r allow=( mp4 ogg webm )
##

[ '' != "$(ls ${arcdir})" ] && { "$fpath is empty, finished..."; exit 0; }

	## start video conversion
	cd $fpath ; for video in $(find . -type f -iregex ".*\(${types}\)" -printf '%P\0 '); do

		ext=$(echo $video |awk -NF '.' '{print $2}')

		case "${allow[@]}" in *"$ext"* ) mv "$video" "$fpath/$out/" ; continue ;; esac

		echo -e "$ext"

	done