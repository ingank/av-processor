@echo off

:START
cls
echo =============
echo YT-DLP-HELPER
echo =============
echo.
echo YouTube Downloder (Plus) Helferlein.
echo.
echo Dieses Batch-Script unterstuetzt dich beim Herunterladen von YouTube-Videos.
echo Im gleichen Verzeichnis muss sich das Programm yt-dlp.exe befinden.
echo Die heruntergeladenen Dateien werden im Ordner ^"DOWNLOADS^" gespeichert.
echo.
echo In welchem Modus sollen die Videos heruntergeladen werden?
echo.
echo 1 - Einzelvideo (Keine Playlist)
echo 2 - Alle Videos einer Playlist
echo 3 - Audio eines Einzelvideos in eine .flac Datei schreiben
echo 4 - Audio der Videos einer Playlist als .flac Dateien schreiben
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
echo Die Videos werden als Einzelvideo heruntergeladen. Playlisten werden ignoriert.
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
echo Der Link wird als Playlist behandelt. Alle Videos der Playlist werden heruntergeladen.
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
mkdir "DOWNLOADS" 2>nul
echo Die Audiospur eines Einzelvideos wird heruntergeladen und in einer .flac Datei gespeichert. Playlisten werden ignoriert.
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
echo Der Link wird als Playlist behandelt. Von allen Videos der Playlist werden die Audiospuren in .flac Dateien gespeichert.
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

:END
