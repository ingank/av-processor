@echo off

:START
cls
echo =============
echo YT-DLP-HELPER
echo =============
echo.
echo YouTube Downloder (Plus) Helferlein.
echo.
echo Dieses Batch-Script unterstuetzt dich beim Herunterladen
echo und Konvertieren von YouTube-Videos. Im gleichen Verzeichnis
echo muessen sich die Programme ^"yt-dlp.exe^" und ^"ffmpeg.exe^" befinden.
echo Die heruntergeladenen Dateien werden im Ordner ^"DOWNLOADS^" gespeichert.
echo Konvertierte Dateien des Formats MP3 landen im Ordner ^"MP3S^".
echo.
echo Bitte triff deine Wahl:
echo.
echo 1 - Einzelvideo (Keine Playlist) herunterladen
echo 2 - Alle Videos einer Playlist herunterladen
echo 3 - Audio eines Einzelvideos in eine .flac Datei schreiben
echo 4 - Audio der Videos einer Playlist als .flac Dateien schreiben
echo 5 - Alle .flac Dateien im Ordner ^"DOWNLOADS^" in MP3 wandeln
echo e - Script beenden
echo.
set /p choice="Deine Wahl: "
echo.
if "%choice%" EQU "1" GOTO ONESHOTVIDEO
if "%choice%" EQU "2" GOTO PLAYLISTVIDEOS
if "%choice%" EQU "3" GOTO ONESHOTFLAC
if "%choice%" EQU "4" GOTO PLAYLISTFLAC
if "%choice%" EQU "e" GOTO END
GOTO START

:ONESHOTVIDEO
mkdir "DOWNLOADS" 2>nul
echo Die Videos werden als Einzelvideo heruntergeladen.
echo Playlisten werden ignoriert.
echo.
:LOOP_OSV
echo.
set /p url="YouTube-Link: "
echo.
.\yt-dlp ^
--no-playlist ^
--no-keep-video ^
--continue ^
--ignore-errors ^
--write-description ^
--write-thumbnail ^
--convert-thumbnails png ^
--paths .\DOWNLOADS "%url%"
echo.
echo.
GOTO LOOP_OSV

:PLAYLISTVIDEOS
mkdir "DOWNLOADS" 2>nul
echo Der Link wird als Playlist behandelt.
echo Alle Videos der Playlist werden heruntergeladen.
echo.
:LOOP_PLV
echo.
set /p url="YouTube-Link: "
echo.
.\yt-dlp ^
--yes-playlist ^
--no-keep-video ^
--continue ^
--ignore-errors ^
--write-description ^
--write-thumbnail ^
--convert-thumbnails png ^
--paths .\DOWNLOADS "%url%"
echo.
echo.
GOTO LOOP_PLV

:ONESHOTFLAC
mkdir "DOWNLOADS" 2>nul
echo Die Audiospur eines Einzelvideos wird heruntergeladen
echo und in einer .flac Datei gespeichert. Playlisten werden ignoriert.
echo.
:LOOP_OSF
echo.
set /p url="YouTube-Link: "
echo.
.\yt-dlp ^
--no-playlist ^
--no-keep-video ^
--continue ^
--ignore-errors ^
--write-description ^
--write-thumbnail ^
--convert-thumbnails png ^
--paths .\DOWNLOADS ^
--extract-audio --audio-format flac "%url%"
echo.
echo.
GOTO LOOP_OSF

:PLAYLISTFLAC
mkdir "DOWNLOADS" 2>nul
echo Der Link wird als Playlist behandelt. Von allen Videos der Playlist
echo werden die Audiospuren in .flac Dateien gespeichert.
echo.
:LOOP_PLF
echo.
set /p url="YouTube-Link: "
echo.
.\yt-dlp ^
--yes-playlist ^
--no-keep-video ^
--continue ^
--ignore-errors ^
--write-description ^
--write-thumbnail ^
--convert-thumbnails png ^
--paths .\DOWNLOADS ^
--extract-audio --audio-format flac "%url%"
echo.
echo.
GOTO LOOP_PLF

:COVERTMP3
mkdir "MP3S" 2>nul
for %%f in (.\DOWNLOADS\*.flac) do (  ffmpeg -i "%%f" -ab 320k ".\MP3S\%%f.mp3" )

:END
