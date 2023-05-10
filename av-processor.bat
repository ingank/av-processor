@echo off

rem av-processor.bat
rem 
rem Diese Batchdatei unterstuetzt dich beim Herunterladen und
rem Konvertieren von Videos und Audio-Dateien. Im gleichen Verzeichnis
rem muessen sich die Programme "yt-dlp.exe" und "ffmpeg.exe" befinden.
rem 
rem Zu konvertierende Dateien muessen vorher in den Ordner "IN" kopiert werden.
rem Heruntergeladene Dateien landen im Ordner "IN".
rem Konvertierte Dateien landen im Ordner "OUT".

:MENU
cls
echo ============
echo AV-PROCESSOR
echo ============
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
if "%choice%" EQU "1" goto ONESHOTVIDEO
if "%choice%" EQU "2" goto PLAYLISTVIDEOS
if "%choice%" EQU "3" goto ONESHOTFLAC
if "%choice%" EQU "4" goto PLAYLISTFLAC
if "%choice%" EQU "5" goto CONVERTAUDIO
if "%choice%" EQU "e" goto END
goto MENU

:ONESHOTVIDEO
cls
echo =========================
echo EINZELVIDEO HERUNTERLADEN
echo =========================
echo.
echo Der Link wird als Einzelvideo behandelt.
echo Playlisten werden ignoriert. Nur ein Video wird heruntergeladen.
echo.
echo Durch Eingabe von ^"e^" kommst du zurueck ins Hauptmenue.
echo.
set /p url="YouTube-Link: "
if "%url%" EQU "e" goto MENU
mkdir "IN" 2>nul
.\yt-dlp ^
--no-playlist ^
--no-keep-video ^
--continue ^
--ignore-errors ^
--write-description ^
--write-thumbnail ^
--convert-thumbnails png ^
--paths .\IN "%url%"
goto ONESHOTVIDEO

:PLAYLISTVIDEOS
cls
echo ============================
echo PLAYLISTVIDEOS HERUNTERLADEN
echo ============================
echo.
echo Der Link wird als Playlist behandelt.
echo Alle Videos einer Playlist werden heruntergeladen.
echo.
echo Durch Eingabe von ^"e^" kommst du zurueck ins Hauptmenue.
echo.
set /p url="YouTube-Link: "
if "%url%" EQU "e" goto MENU
mkdir "IN" 2>nul
.\yt-dlp ^
--yes-playlist ^
--no-keep-video ^
--continue ^
--ignore-errors ^
--write-description ^
--write-thumbnail ^
--convert-thumbnails png ^
--paths .\IN "%url%"
goto PLAYLISTVIDEOS

:ONESHOTFLAC
cls
echo =====================================
echo FLAC EINES EINZELVIDEOS HERUNTERLADEN
echo =====================================
echo.
echo Der Link wird als Einzelvideo behandelt.
echo Playlisten werden ignoriert.
echo Die Audiospur des Videos wird als .flac Datei gespeichert.
echo.
echo Durch Eingabe von ^"e^" kommst du zurueck ins Hauptmenue.
echo.
set /p url="YouTube-Link: "
if "%url%" EQU "e" goto MENU
mkdir "IN" 2>nul
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
goto ONESHOTFLAC

:PLAYLISTFLAC
cls
echo =================================================
echo ALLE VIDEOS EINER PLAYLIST ALS FLAC HERUNTERLADEN
echo =================================================
echo.
echo Der Link wird als Playlist behandelt. Von allen Videos der Playlist
echo werden die Audiospuren in .flac Dateien gespeichert.
echo.
echo Durch Eingabe von ^"e^" kommst du zurueck ins Hauptmenue.
echo.
set /p url="YouTube-Link: "
if "%url%" EQU "e" goto MENU
mkdir "IN" 2>nul
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
goto PLAYLISTFLAC

:CONVERTAUDIO
cls
echo ===================
echo AUDIOFORMAT WANDELN
echo ===================
echo.
echo Alle gleichartiegen Dateien im Ordner ^"IN^" werden konvertiert.
echo Die kovertierten Dateien landen im Ordner ^"OUT^".
echo.
echo Bitte triff deine Wahl fuer das Quellformat!
echo.
echo 1 - flac
echo 2 - mp3
echo 3 - wav
echo 4 - aiff
echo 5 - aifc
echo e - zurueck zum Hauptmenue
echo.
set /p choice="Deine Wahl: "
if "%choice%" EQU "1" set inf=flac
if "%choice%" EQU "2" set inf=mp3
if "%choice%" EQU "3" set inf=wav
if "%choice%" EQU "4" set inf=aiff
if "%choice%" EQU "5" set inf=aifc
if "%choice%" EQU "e" goto MENU
echo.
echo Bitte triff jetzt deine Wahl fuer das Ausgabeformat!
echo.
echo 1 - flac
echo 2 - mp3
echo 3 - wav
echo e - zurueck zum Hauptmenue
echo.
set /p choice="Deine Wahl: "
if "%choice%" EQU "1" set outf=flac
if "%choice%" EQU "2" set outf=mp3
if "%choice%" EQU "3" set outf=wav
if "%choice%" EQU "e" goto MENU
mkdir "OUT" 2>nul
cd IN
if "%outf%" == "mp3" (
    for %%f in ("*.%inf%") do (  .\..\ffmpeg -i "%%f" -ab 320k ".\..\OUT\%%~nf.mp3" )
) else (
    for %%f in ("*.%inf%") do (  .\..\ffmpeg -i "%%f" ".\..\OUT\%%~nf.%outf%" )
)
cd ..
goto CONVERTAUDIO

:END
