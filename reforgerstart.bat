@echo off
:: DEFINE the following variables where applicable to your install.
:: Make sure your ConfigFolder has your account name and not Administrator if you are not using the built-in Windows admin account!
SET SteamLogin=anonymous
SET ReforgerBranch=1874900
SET ReforgerServerPath="C:\Servers\ArmaReforger\Server"
SET SteamCMDPath="C:\Servers\ArmaReforger\SteamCMD"
SET ConfigFolder="C:\Servers\ArmaReforger\Server"

:: Start Arma Reforger Server
start "" /B ArmaReforgerServer.exe -config %ConfigFolder%\config.json -maxFPS 30 -autoreload 60 -logStats 90000 -AILimit 32 -createDB -generateShaders -logFS -checkInstance -nds 1 -nwkResolution 500 -rpl-timeout-ms 10000 -staggeringBudget 5000 -streamingBudget 500 -streamsDelta 200 -disableCrashReporter -jobsysShortWorkerCount 15 -jobsysLongWorkerCount 15 -silentCrashReport

: Start monitoring player count
:MONITOR
set "PLAYER_COUNT="
set "SERVER_FPS="
for /f %%i in ('powershell -command "(Get-Content 'C:\Users\opc\Documents\My Games\ArmaReforger\profile\ServerAdminTools_Stats.json' | ConvertFrom-Json).players"') do set "PLAYER_COUNT=%%i"
for /f %%i in ('powershell -command "(Get-Content 'C:\Users\opc\Documents\My Games\ArmaReforger\profile\ServerAdminTools_Stats.json' | ConvertFrom-Json).fps"') do set "SERVER_FPS=%%i"
title Arma Reforger Server - Players: %PLAYER_COUNT%, FPS: %SERVER_FPS%
timeout /t 10 >nul
goto MONITOR
