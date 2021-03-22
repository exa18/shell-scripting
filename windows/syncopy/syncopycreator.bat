@echo off
setlocal

rem *** SETTINGS

set prg=sync
set task=SyncWithRemote
set dest=remote:Storage

set appfile=setappdata.zip
set destdir=USERPROFILE

rem *** Preparation

set dir=%~dp0
set ap=%prg%.bat
set filter=%prg%.txt
set p=%dir%%ap%
set f=%dir%%filter%

set un=%USERNAME%
echo *** Sync Creator // User: %un% ***
echo ***

rem *** Collect input settings

set t=%time: =0%
set hh=%t:~0,5%
set /P tt=Input time HHMM ( %hh:~0,2%%hh:~3,5% ) : 
if /I !%tt%!==!! goto :empty
	set hh=%tt:~0,2%:%tt:~2,4%
:empty

if NOT exist "%p%" goto :emptyn1
	set /p tt=Want continue installation (y/n) ? 
	if /I !%tt%!==!y! goto :install
	echo.
	echo *** Begin configuration
:emptyn1

set /p tt=Input directory from %dest% : 
if /I !%tt%!==!! goto :empty2
	set un=%tt%
:empty2

echo.
echo Sync all from %USERPROFILE% to %dest%/%un%/%destdir%

set cuser=
set /p tt=OR input folder name on Desktop : 
if /I !%tt%!==!! goto :empty3
	if NOT exist "%USERPROFILE%\Desktop\%tt%" goto empty3
		set cuser=\Desktop\%tt%
		set destdir=%tt%
		echo ... source changed to %USERPROFILE%%cuser%
:empty3

rem *** Create filter file

echo - ~*>%f%
echo - *.db>>%f%
echo - AppData/**>>%f%

rem *** Create file (loop)

echo @echo off> %p%
echo if exist "%%USERPROFILE%%%cuser%\%appfile%" del /q "%%USERPROFILE%%%cuser%\%appfile%">> %p%
echo tar -czf "%%USERPROFILE%%%cuser%\%appfile%" "%%USERPROFILE%%\AppData">> %p%
echo rclone sync "\\?\%%USERPROFILE%%%cuser%" "%dest%/%un%/%destdir%" --no-update-modtime --ignore-errors --delete-excluded --ignore-size --copy-links --skip-links --filter-from %filter% -u -P>> %p%

:nextadd
echo.
set /p tt=Want add another entry (y/n) ? 
if /I !%tt%!==!y! goto :locadd
	goto :emptyadd
:locadd

	set /p tt=Input source directory (format: e:\mydata\source): 
	if /I !%tt%!==!! goto :emptyadd
	if NOT exist "%tt%" goto :nextadd
		set locfolder=%tt%
	set /p tt=Input remote directory for %un% (name only) : 
	if /I !%tt%!==!! goto :nextadd
		set remfolder=%tt%

	echo ... added entry %remfolder%
	echo rclone sync "\\?\%locfolder%" "%dest%/%un%/%remfolder%" --no-update-modtime --ignore-errors --delete-excluded --ignore-size --copy-links --skip-links --filter-from %filter% -u -P>> %p%

	goto :nextadd

:emptyadd

rem *** Copy files and create schedule

echo.
set /p tt=Ready to install (y/n) ? 
if /I !%tt%!==!y! goto :install
	goto :EOF
:install

xcopy /Y "%dir%%prg%.*" "%ProgramFiles%\"
del /q "%dir%%prg%.*"
SCHTASKS /DELETE /TN "\%task%"
SCHTASKS /CREATE /SC DAILY /TN "\%task%" /TR "%ProgramFiles%\%ap%" /ST %hh%
