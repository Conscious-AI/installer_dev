@echo off

SET DIR=%~dp0%
cd /D %DIR%

::Installing chocolatey
echo Installing chocolatey...
start /wait install_choco_script.cmd

::Installing python
echo Installing python...
start /wait choco_python_script.cmd

::Installing pipenv
echo Installing pipenv...
start /wait pip_pipenv_script.cmd