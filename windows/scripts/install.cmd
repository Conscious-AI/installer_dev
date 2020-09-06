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

exit