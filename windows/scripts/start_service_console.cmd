@echo off

::Start CAI Service
python ..\..\windows-service\CAIService.py start

::Start main console
cd ..\..\main_console
main_console.exe

exit