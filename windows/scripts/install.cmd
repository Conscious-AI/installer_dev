@echo off

SET DIR=%~dp0%
cd /D %DIR%

::Installing chocolatey
echo | set /p=CAI: INSTALLER: 1. Installing chocolatey...
start /B /wait install_choco_script.cmd

::Installing python
echo | set /p=CAI: INSTALLER: 2. Installing python...
start /B /wait choco_python_script.cmd

::Installing git
echo | set /p=CAI: INSTALLER: 3. Installing git for windows...
start /B /wait choco_git_script.cmd

::Downloading project repos
echo | set /p=CAI: INSTALLER: 4. Downloading project repositories...
start /B /wait git_clone_script.cmd

::Installing dependencies
echo | set /p=CAI: INSTALLER: 5. Installing required project dependencies...
start /B /wait pip_dependencies_script.cmd

::Downloading pre-trained models
echo | set /p=CAI: INSTALLER: 6: Downloading pre-trained models...
start /B /wait download_pretrained_models.cmd

::Installing CAI Service
echo | set /p=CAI: INSTALLER: 7: Installing CAI Service...
start /B /wait install_service.cmd

::Starting trainer
echo | set /p=CAI: INSTALLER: 8: Starting trainer...
waitfor NULL /t 2 2>NUL
start /B /wait start_trainer.cmd

::Starting CAI service and main console
echo | set /p=CAI: INSTALLER: 9: Finishing up...
start /B /wait main_console_startup.cmd
start /B start_service_console.cmd >nul 2>&1

:: All done !
echo. & echo. & echo.
echo -------------------------------------------------------------------------- All Done ! -------------------------------------------------------------------------
echo. & echo.

exit