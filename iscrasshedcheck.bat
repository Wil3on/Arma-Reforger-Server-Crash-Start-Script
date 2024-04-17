@echo off
setlocal enabledelayedexpansion

:: Set the window title
title Crash_Detection

:: Set the log directory path
set "log_dir=C:\Users\opc\Documents\My Games\ArmaReforger\logs"
set "startserver=reforgerstart.bat"
set "startCrash_Detection=iscrasshedcheck.bat"
set "countdown_time=30"

:: Read crash keywords from crashkeywords.txt
set "keyword_file=crashkeywords.txt"

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
    :: Read crash keywords from file and search for each keyword in console.txt
    echo INFO: Searching for any possible crash related words in console.txt...
    for /f "usebackq delims=" %%k in ("%keyword_file%") do (
        echo INFO: Searching for keyword: %%k
        findstr /C:"%%k" "%log_dir%\!latest_folder!\console.log" > nul
        if !errorlevel! equ 0 (
            echo ALERT ATTENTION: Crash related words '%%k' have been found. Restarting Server in %countdown_time% seconds...
            for /l %%i in (%countdown_time%,-1,1) do (
                echo ATTENTION: Restarting Arma Reforger server in %%i seconds...
                timeout /t 1 /nobreak > nul 
            )
            start "" /b taskkill /f /im ArmaReforgerServer.exe
            start "" /b taskkill /f /fi "windowtitle eq ReforgerServer"
            start "" /b taskkill /f /fi "windowtitle eq Crash_Detection"
            start "" "%startserver%"
            start "" "%startCrash_Detection%"
            goto :end_loop
        )
    )
    echo NOTE: No crash related words have been found. Server is ONLINE!
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

) else (
    echo ERROR: console.txt file not found in the latest log folder.
)

:end_loop
goto loop

:end
endlocal
