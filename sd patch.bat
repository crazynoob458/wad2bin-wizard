@echo off
if not "%os%"=="Windows_NT" goto not_windows_nt
set MainFolder=%appdata%\RiiConnect24Patcher
set TempStorage=%appdata%\RiiConnect24Patcher\internet\temp
if not exist "%MainFolder%" md "%MainFolder%"
if not exist "%TempStorage%" md "%TempStorage%"
setlocal enableextensions
setlocal enableDelayedExpansion
cd /d "%~dp0"
echo 	Starting up...
echo	The program is starting...
if exist temp.bat del /q temp.bat
::if exist update_assistant.bat del /q update_assistant.bat
:script_start
echo 	.. Setting up the variables
:: Window size (Lines, columns)
set mode=128,37
mode %mode%
set s=NUL

set user_name=%userprofile:~9%
set /a dolphin=0
set /a exitmessage=1
set /a errorcopying=0
set /a tempncpatcher=0
set /a tempiospatcher=0
set /a tempevcpatcher=0
set /a tempsdcardapps=0
set /a wiiu_return=0
set /a sdcardstatus=0
set /a troubleshoot_auto_tool_notification=0
set sdcard=NUL
set tempgotonext=begin_main
set direct_install_del_done=0
set direct_install_bulk_files_error=0

set mm=0
set ss=0
set cc=0
set hh=0

cls

goto detect_sd_card

:direct_install_sdcard_main_menu
clear
echo wad2bin, original code by kcrpl, darkmattercore standalone installer by crazynoob458
echo -----------------------------------------------------------------------------------------------------------------------------
echo before we go please check that your wii keys are stored in the sd card
echo press any keys to continue
pause>NUL
clear
if %sdcard%==NUL set call :detect_sd_card

set /a file_not_exist=0

cls
echo wad2bin, original code by kcrpl, darkmattercore standalone installer by crazynoob458
echo -----------------------------------------------------------------------------------------------------------------------------
echo Welcome %username%^^! What can I get you?
echo Wads will be installed on drive: %sdcard%
if %direct_install_del_done%==1 echo.
if %direct_install_del_done%==1 echo :------------------------------------------:
if %direct_install_del_done%==1 echo : Deleting bogus WAD files is done^^!        :
if %direct_install_del_done%==1 echo :------------------------------------------:
set /a direct_install_del_done=0

echo.
echo 1. Install a single WAD file to your SD Card.
echo 2. Install many WAD files at once.
echo 3. Reconfigure keys (use this when changing a Wii etc.)
echo.
echo 4. Delete all bogus WAD files from your SD Card.
echo 5. Exit.
echo.
set /p s=Choose: 
if %s%==1 goto direct_install_single
if %s%==2 goto direct_install_bulk
if %s%==3 goto direct_install_sdcard_configuration
if %s%==4 goto direct_install_delete_bogus
if %s%==5 goto begin_main
goto direct_install_sdcard_main_menu
:direct_install_bulk
cls
echo wad2bin, original code by kcrpl, darkmattercore standalone installer by crazynoob458
echo -----------------------------------------------------------------------------------------------------------------------------
if not exist "wad2bin" md wad2bin
if %direct_install_bulk_files_error%==1 echo :-------------------------------------------------------:
if %direct_install_bulk_files_error%==1 echo : Could not find any .WAD files inside wad2bin folder.  :
if %direct_install_bulk_files_error%==1 echo :-------------------------------------------------------:
if %direct_install_bulk_files_error%==1 echo.
set /a direct_install_bulk_files_error=0

echo We're now going to install a lot of WAD files to your SD Card.
echo I created a folder called wad2bin next to the RiiConnect24 Patcher.bat. Please put all of the files that you want to
echo install in that folder.
echo.
echo Are the files all in place?
echo.
echo 1. Yes, start installing.
echo 2. No, go back.
set /p s=Choose: 
if %s%==1 goto direct_install_bulk_scan
if %s%==2 goto direct_install_sdcard_main_menu

goto direct_install_bulk

:direct_install_bulk_scan
if exist "wad2bin\*.wad" goto direct_install_bulk_install
set /a direct_install_bulk_files_error=1
goto direct_install_bulk

:direct_install_bulk_install
set /a file_counter=0
for %%f in ("wad2bin\*.wad") do set /a file_counter+=1
set /a patching_file=1

for %%f in ("wad2bin\*.wad") do (

cls
echo wad2bin, original code by kcrpl, darkmattercore standalone installer by crazynoob458
echo -----------------------------------------------------------------------------------------------------------------------------

echo Instaling file [!patching_file!] out of [%file_counter%]
echo File name: %%~nf
call wad2bin.exe "%MainFolder%\WiiKeys\keys.txt" "%MainFolder%\WiiKeys\device.cert" "%%f" %sdcard%:\>NUL
	set /a temperrorlev=!errorlevel!
	if not !temperrorlev!==0 goto direct_install_single_fail

move /Y "%sdcard%:\*_bogus.wad" "%sdcard%:\WAD\">NUL

set /a patching_file=!patching_file!+1
)
echo.
echo Installation complete^^! 
echo  Now, please start your WAD Manager (Wii Mod Lite, if you installed RiiConnect24) and please install the WAD file called
echo  (numbers)_bogus.wad on your Wii.
echo.
echo  NOTE: You will get a -1022 error - don't worry! The WAD is empty but all we need is the TMD and ticket.
echo  After you're done installing the WAD, you can later plug in the SD Card in and choose the option to delete bogus WAD's
echo  in the main menu.
echo.
echo Press any key to go back.

pause>NUL
goto direct_install_sdcard_main_menu
:direct_install_delete_bogus
cls
echo wad2bin, original code by kcrpl, darkmattercore standalone installer by crazynoob458
echo -----------------------------------------------------------------------------------------------------------------------------

echo Are you sure you want to delete all bogus files?
echo If you still didn't install them, you won't be able to open any installed channels by you.
echo.
echo Are you sure you want to delete them?
echo.
echo 1. Yes
echo 2. No, go back.
set /p s=Choose: 
if %s%==1 del /q "%sdcard%:\WAD\*_bogus.wad"&set /a direct_install_del_done=1&goto direct_install_sdcard_main_menu
if %s%==2 goto direct_install_sdcard_main_menu
goto direct_install_delete_bogus
:direct_install_single
cls
echo wad2bin, original code by kcrpl, darkmattercore standalone installer by crazynoob458
echo -----------------------------------------------------------------------------------------------------------------------------

if %file_not_exist%==1 echo :---------------------------------------------:
if %file_not_exist%==1 echo : The file specified does not exist.          :
if %file_not_exist%==1 echo :---------------------------------------------:
if %file_not_exist%==1 echo.
set /a file_not_exist=0

echo We're now going to install a single WAD file to your SD Card.
echo If you're trying to install many WAD files at once, please type in stop and select the second option.
echo.
echo Please drag^&drop the file here and press ENTER.
echo NOTE: If you're manually typing in the path and it has spaces in it - please put it in quotes " "
echo.
set /p wad_path=Path: 
if %wad_path%==stop goto direct_install_sdcard_main_menu

if not exist %wad_path% set /a file_not_exist=1&goto direct_install_single

goto direct_install_single-install

:direct_install_single-install
cls
echo wad2bin, original code by kcrpl, darkmattercore standalone installer by crazynoob458
echo -----------------------------------------------------------------------------------------------------------------------------

echo Please wait... installing the WAD to your SD Card.

call wad2bin.exe "%MainFolder%\WiiKeys\keys.txt" "%MainFolder%\WiiKeys\device.cert" %wad_path% %sdcard%:\ >NUL
echo .. Done!
	set /a temperrorlev=%errorlevel%
	if not %temperrorlev%==0 goto direct_install_single_fail
	
move /Y "%sdcard%:\*_bogus.wad" "%sdcard%:\WAD\">NUL

echo.
echo Installation complete^^! 
echo  Now, please start your WAD Manager (Wii Mod Lite, if you installed RiiConnect24) and please install the WAD file called
echo  (numbers)_bogus.wad on your Wii.
echo.
echo  NOTE: You will get a -1022 error - don't worry! The WAD is empty but all we need is the TMD and ticket.
echo  After you're done installing the WAD, you can later plug the SD Card in and choose the option to delete bogus WAD's
echo  in the main menu.
echo.
echo Press any key to go back.

pause>NUL
goto direct_install_sdcard_main_menu

:direct_install_single_fail
cls
echo %header%                                                                
echo.                 
echo.                 
echo.                 
echo.                 
echo.                 
echo.                 
echo.                 
echo.                 
echo.                 
echo.                 
echo.                 
echo.
echo ---------------------------------------------------------------------------------------------------------------------------
echo    /---\   ERROR             
echo   /     \  Installing WAD file(s) has failed.
echo  /   ^^!   \ 
echo  --------- wad2bin returned error code: %temperrorlev%
echo            Please contact KcrPL#4625 on Discord or mail us at support@riiconnect24.net
echo.
echo       Press any key to return to main menu.
echo ---------------------------------------------------------------------------------------------------------------------------
pause>NUL
goto direct_install_sdcard_main_menu

:detect_sd_card
echo wad2bin, original code by kcrpl, darkmattercore standalone installer by crazynoob458
echo -----------------------------------------------------------------------------------------------------------------------------
set sdcard=NUL
echo Drive letter must be IN CAPS
set /p e=What is the drive letter?: 
set sdcard=%e%
goto direct_install_sdcard_main_menu
:not_windows_nt
echo dude why are you trying to run this in ms-DOS?
echo dont
echo just dont
echo git gud
echo buy a good pc