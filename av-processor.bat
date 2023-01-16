@echo off

:START
cls
echo ============
echo AV-PROCESSOR
echo ============
echo.
echo Diese Batchdatei unterstuetzt dich beim Herunterladen und
echo Konvertieren von Videos und Audio-Dateien. Im gleichen Verzeichnis
echo muessen sich die Programme ^"yt-dlp.exe^" und ^"ffmpeg.exe^" befinden.
echo.
echo Zu konvertierende Dateien muessen vorher in den Ordner ^"IN^" kopiert werden.
echo Heruntergeladene Dateien landen automatisch im Ordner ^"IN^".
echo Konvertierte Dateien landen im Ordner ^"OUT^".
echo.
echo Bitte triff deine Wahl:
echo.
echo 1 - Einzelvideo herunterladen
echo 2 - Alle Videos einer Playlist herunterladen
echo 3 - Audio eines Einzelvideos als .flac Datei herunterladen
echo 4 - Audios aller Videos einer Playlist als .flac Dateien herunterladen
echo 5 - Audiodateien im Ordner ^"IN^" in ein anderes Format umwandeln
echo e - Programm beenden
echo.
set /p choice="Deine Wahl: "
echo.
if "%choice%" EQU "1" GOTO ONESHOTVIDEO
if "%choice%" EQU "2" GOTO PLAYLISTVIDEOS
if "%choice%" EQU "3" GOTO ONESHOTFLAC
if "%choice%" EQU "4" GOTO PLAYLISTFLAC
if "%choice%" EQU "5" GOTO CONVERTAUDIO
if "%choice%" EQU "e" GOTO END
GOTO START

:ONESHOTVIDEO
mkdir "IN" 2>nul
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
--paths .\IN "%url%"
echo.
echo.
GOTO LOOP_OSV

:PLAYLISTVIDEOS
mkdir "IN" 2>nul
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
--paths .\IN "%url%"
echo.
echo.
GOTO LOOP_PLV

:ONESHOTFLAC
mkdir "IN" 2>nul
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
--paths .\IN ^
--extract-audio --audio-format flac "%url%"
echo.
echo.
GOTO LOOP_OSF

:PLAYLISTFLAC
mkdir "IN" 2>nul
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
--paths .\IN ^
--extract-audio --audio-format flac "%url%"
echo.
echo.
GOTO LOOP_PLF

:CONVERTAUDIO
echo Bitte gib das Quellformat an:
echo.
echo 1 - flac
echo 2 - mp3
echo 3 - wav
echo 4 - aiff
echo 5 - aifc
echo e - Programm beenden
echo.
set /p choice="Deine Wahl: "
echo.
if "%choice%" EQU "1" set inf=flac
if "%choice%" EQU "2" set inf=mp3
if "%choice%" EQU "3" set inf=wav
if "%choice%" EQU "4" set inf=aiff
if "%choice%" EQU "5" set inf=aifc
if "%choice%" EQU "e" GOTO END

echo Bitte gib das gewuenschte Ausgabeformat an:
echo.
echo 1 - flac
echo 2 - mp3
echo 3 - wav
echo e - Programm beenden
echo.
set /p choice="Deine Wahl: "
echo.
if "%choice%" EQU "1" set outf=flac
if "%choice%" EQU "2" set outf=mp3
if "%choice%" EQU "3" set outf=wav
if "%choice%" EQU "e" GOTO END

mkdir "OUT" 2>nul
cd IN
if "%outf%" == "mp3" (
    for %%f in ("*.%inf%") do (  .\..\ffmpeg -i "%%f" -ab 320k ".\..\OUT\%%~nf.mp3" )
) else (
    for %%f in ("*.%inf%") do (  .\..\ffmpeg -i "%%f" ".\..\OUT\%%~nf.%outf%" )
)
cd ..

:END
