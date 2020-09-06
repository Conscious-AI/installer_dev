@echo off

::Enabling auto confirmation of installation
choco feature enable -n allowGlobalConfirmation

::Installing latest python
choco install python

exit