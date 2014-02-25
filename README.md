Transcoder
==========

On the fly transcoder from basic formats to WEBM, OGG and MP4


Run by using 

```
	$ ./transcoder.sh
```

Directory structure should be created on clone, if not directories will autocreate

By placing a video into `drop/` and running video will be created in webm, mp4 and 
ogg formats then placed in the `export/` directory. If a created format is already
being supplied, the other formats will be created and the origin file will be moved.

__WARNING__ this using background tasks and can or will be CPU intensive for larger files

Associated CRONTAB will look something like this

```
## CRONTAB

* * * * * [ $(ls -1 /some_path/transcoder/drop/*.{asf,asx,avi,flv,m4v,mkv,mov,mp4,mpg,ogg,rm,swf,vob,webm,wmv} 2>/dev/null | wc -l) != 0 ] && bash /{whatever_path}/transcoder.sh
```

