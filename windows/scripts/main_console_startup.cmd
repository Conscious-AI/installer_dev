@echo off

::Absolute DIR
set "cur_dir=%~dp0%"
for %%a in ("%cur_dir%\..") do set "console_dir=%%~dpa"

::Creating a symbolic link of the main console to run at windows startup
mklink "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\CAI Main Console" "%console_dir%\main_console\main_console.exe"

exit