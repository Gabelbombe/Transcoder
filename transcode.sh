    #!/bin/bash
    # Video transcoder

    # CPR : Jd Daniel
    # MOD : 2014-02-20 @ 10:51:25
    # VER : Beta 1

    # proto: cd drop ; types=(asf asx avi flv m4v mov mp4 mpg rm swf vob wmv); for i in "${types[@]}"; do touch "video.${i}"; done;

    inp="drop"
    out="export"

    ## test for reqs of exit
    for requires in ffmpeg parallel; do
        hash $requires 2>/dev/null || {
            echo >&2 "I require $requires to run but it's not installed.  Aborting."; exit 1;
        }
    done

    monitor ()
    {
        pid="$1"


    }

    ## dectypes
    declare -r fpath=$( cd "$(dirname "$0")" ; pwd -P )
    declare -r types="asf\|asx\|avi\|flv\|m4v\|mkv\|mov\|mp4\|mpg\|ogg\|rm\|swf\|vob\|webm\|wmv"
    declare -r allow=( mp4 ogg webm )
    ##

        for dir in "$inp" "$out"; do
            [ -d "$fpath/$dir" ] || { mkdir -p "$fpath/$dir"; } # create if not available
        done

        [ -z "$(ls $fpath/$inp)" ] && { "$fpath is empty, finished..."; exit 0; } # exit when empty


        ## start video conversion
        cd $fpath ; while IFS= read -r video; do

            skip=0 #reset skip flag
            name=$(echo "$video" |awk -NF '.' '{print $1}')
            exts=$(echo "$video" |awk -NF '.' '{print $2}')

            # assign predetermined pos
            for (( i = 0; i < ${#allow[@]}; i++ )); do
               if [ "${allow[$i]}" = "${exts}" ]; then
                   skip=$(($i + 1));
               fi
            done

            pids=()
            [[ $skip = 1 ]] ||
            {
                ffmpeg -y -i "$inp/$video" -vb 1500k -vcodec libx264 -vpre slow -vpre baseline -g 30 "$out/${name}.mp4" &
                pids+="$! "
            }

            [[ $skip = 2 ]] ||
            {
                ffmpeg -y -i "$inp/$video" -vb 1500k -vcodec libvpx -acodec libvorbis -ab 160000 -f webm -g 30 "$out/${name}.webm" &
                pids+="$! "
            }

            [[ $skip = 3 ]] ||
            {
                ffmpeg -y -i "$inp/$video" -vb 1500k -vcodec libtheora -acodec libvorbis -ab 160000 -g 30 "$out/${name}.ogg" &
                pids+="$! "
            }

            for job in `jobs -p`; do
                echo "Job: $job"
                wait $job || let "FAIL+=1"
            done


            [ "0" == "$FAIL" ] && echo "YAY!" || echo "FAIL! ($FAIL)"


            for ext in "${allow[@]}"; do
                [ -a "$inp/$name.$ext" ] && cp "$inp/$name.$ext" "$out/"
            done

        done <<< $(find "$fpath/$inp" -type f -iregex ".*\(${types}\)" -printf '%P\0 ')

    exit