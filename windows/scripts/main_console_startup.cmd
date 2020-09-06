@echo off

::Creating a symbolic link of the main console to run at windows startup
mklink "%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\CAI Main Console" "..\main_console\main_console.exe"