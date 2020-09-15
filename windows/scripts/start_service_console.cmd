@echo off

::Start CAI Service
python ..\windows-service\CAIService.py start

::Start main console
..\main_console\main_console.exe