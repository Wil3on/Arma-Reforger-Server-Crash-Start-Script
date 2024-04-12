@echo off
setlocal enabledelayedexpansion

:: Set the window title
title Server_Crash_Detection

:: Set the log directory path
set "log_dir=C:\Users\mike\Documents\My Games\ArmaReforger\logs"

:: Set the server_start.bat file path (must be in same directory where iscrasshedcheck.bat file located! NOTE: don't change directory, just leave filename!)
set "startserver=server_start.bat"

:: Set the iscrasshedcheck.bat file path (currently where you run this script, NOTE: don't change directory, just leave filename!)
set "startCrash_Detection=iscrasshedcheck.bat"

:: Set timer, how often script checks crash state in seconds.
set "countdown_time=30"

:loop

:: Get the latest folder in the log directory
for /f "delims=" %%a in ('dir /b /ad /o-d "%log_dir%"') do (
    set "latest_folder=%%a"
    goto :found_latest
)

:found_latest
:: Print the latest folder name with color formatting
echo Latest logs folder: !latest_folder!

:: Reset color to default
color

:: Check if the console.txt file exists in the latest folder
if exist "%log_dir%\!latest_folder!\console.log" (
    echo INFO: Searching for any possible crash related words "Resource leaks" in console.txt...
    :: Search for the phrases "Resource leaks" and "Another keyword" in the console.txt file. NOTE: You can add another words to check crash state, just add another C:"myword" to line!
    findstr /C:"Resource leaks" /C:"LocoCrash" "%log_dir%\!latest_folder!\console.log" > nul
    if !errorlevel! equ 0 (
        echo ALERT ATTENTION: Crash related words has been found. Restarting Server in %countdown_time% seconds...
        for /l %%i in (%countdown_time%,-1,1) do (
            echo ATTENTION: Restarting server in %%i seconds...
            timeout /t 1 /nobreak > nul 
        )
        start "" /b taskkill /f /im ArmaReforgerServer.exe
        start "" /b taskkill /f /fi "windowtitle eq ReforgerServer"
        start "" /b taskkill /f /fi "windowtitle eq Crash_Detection"
        start "" "%startserver%"
        start "" "%startCrash_Detection%"
    ) else (
        echo NOTE: Any possible crash related words has NOT been found yet, server is ONLINE!
        :: Check if ArmaReforgerServer is running
        tasklist /FI "IMAGENAME eq ArmaReforgerServer.exe" | find /I "ArmaReforgerServer.exe" > nul
        if errorlevel 1 (
            echo ATTENTION: Server is not running. Starting server...
            start "" "%startserver%"
        ) else (
            echo INFO: Server is running.
        )
        
        echo Waiting 30 seconds before retrying check...
        timeout /t 30 /nobreak > nul

    )
) else (
    echo ERROR: console.txt file not found in the latest log folder.
)

goto loop

:end
endlocal

