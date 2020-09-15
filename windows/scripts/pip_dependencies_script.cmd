@echo off

::Dependencies for command_recognizer
pip install -r ../../command_recognizer/requirements.txt -f https://download.pytorch.org/whl/torch_stable.html

::Dependencies for local_server
pip install -r ../../local_server/requirements.txt

exit