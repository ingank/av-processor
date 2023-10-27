# AV-PROCESSOR

Hot batchprocessing for the incredible **yt-dlp**.  
Liquid Transcoder for audio/video files.

## Useful Links
The right place to download yt-dlp.exe:  
https://github.com/yt-dlp/yt-dlp/releases  

The right place to download ffmpeg.exe:  
https://ffmpeg.org/download.html

## Pay Attention
In order for the quality of the mp3 files to be optimal, `ffmpeg.exe` should be compiled with option
```
--enable-libmp3lame
```
To check this, `ffmpeg.exe` can be called without parameters.  
The user output then shows the compiled-in external plugins.
