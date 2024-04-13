@echo off

:: Set the window title
title Arma Reforger Server Automatic Restart

REM Set the program name to kill
set "servername=ArmaReforgerServer.exe"

REM Set restart times (in format HH:MM)
set "restart_time=23:59"

:loop
REM Get current local time
for /f "tokens=1-3 delims=:." %%a in ('powershell Get-Date -Format HH:mm:ss.fff') do (
    set "hours=%%a"
    set "minutes=%%b"
)

REM Get hours and minutes from restart_time
for /f "tokens=1,2 delims=:" %%c in ("%restart_time%") do (
    set "restart_hours=%%c"
    set "restart_minutes=%%d"
)

REM Calculate time until next restart
set /a "current_time=hours*60+minutes"
set /a "restart_time_minutes=restart_hours*60+restart_minutes"

REM Calculate time until next restart
if %current_time% LSS %restart_time_minutes% (
    set /a "next_restart_time=restart_time_minutes-current_time"
) else (
    set /a "next_restart_time=(24*60+restart_time_minutes)-current_time"
)

REM Determine the closest restart time
set "closest_restart_time=%restart_time%"
set /a "hours_until_next_restart=next_restart_time / 60"
set /a "minutes_until_next_restart=next_restart_time %% 60"

REM Display countdown timer
echo INFO: Server will be restarted @ %restart_time%, current time is %hours%:%minutes%, time until restart: %hours_until_next_restart% hours %minutes_until_next_restart% minutes
timeout /t 60 >nul

REM Check if it's time to restart the process
if %hours% equ %restart_hours% (
    if %minutes% equ %restart_minutes% (
        taskkill /im %servername% /f
        echo NOTE: %servername% server has been restarted on %restart_time% UTC
    )
)

REM Repeat loop
goto loop
