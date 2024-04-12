@echo off
    :: DEFINE the following variables where applicable to your install.
	:: Make sure your ConfigFolder has your account name and not Administrator if you are not using the built-in Windows admin account!
    SET SteamLogin=anonymous
    SET ReforgerBranch=1874900
    SET ReforgerServerPath="C:\Servers\ArmaReforger\Server"
    SET SteamCMDPath="C:\Servers\ArmaReforger\SteamCMD"
    SET ConfigFolder="C:\Servers\ArmaReforger\Server"
    :: _______________________________________________________________
 
echo.
echo        Checking for ArmA Reforger server update
echo        ArmA Reforger Server Dir: %ReforgerServerPath%
echo        SteamCMD Dir: %SteamCMDPath%
echo	    Config Dir: %ConfigFolder%
echo.
%SteamCMDPath%\steamcmd.exe +force_install_dir %ReforgerServerPath% +login %SteamLogin% +"app_update %ReforgerBranch%" +quit
echo .
echo     Your ArmA Reforger server is up to date!
ArmaReforgerServer.exe -config %ConfigFolder%\config.json -maxFPS 60 -autoreload 10 -logStats 90000 -AILimit 32 -createDB -generateShaders -logFS -checkInstance
pause