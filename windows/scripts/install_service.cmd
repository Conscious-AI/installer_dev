@echo off

::Installing CAI Service
python ..\..\windows-service\CAIService.py --startup auto install

exit