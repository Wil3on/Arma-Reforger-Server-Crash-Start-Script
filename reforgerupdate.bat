@echo off
    :: DEFINE the following variables where applicable to your install
    SET SteamLogin=anonymous
    SET ReforgerBranch=1874900
    SET ReforgerServerPath="C:\Servers\ArmaReforger\Server"
    SET SteamCMDPath="C:\Servers\ArmaReforger\SteamCMD"
    :: Set the window title
    title Arma Reforger Server Update
    :: _______________________________________________________________
 
echo.
echo        Checking for ArmA Reforger server update
echo        ArmA Reforger Server Dir: %ReforgerServerPath%
echo        SteamCMD Dir: %SteamCMDPath%
echo.
%SteamCMDPath%\steamcmd.exe +force_install_dir %ReforgerServerPath% +login %SteamLogin% +"app_update %ReforgerBranch%" +quit
echo .
echo     Your ArmA Reforger server is up to date!
echo     key "ENTER" to exit
pause
