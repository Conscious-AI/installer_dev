@echo off

::Dependencies for audio_processing
pip install -r ../../audio_processing/requirements.txt

::Dependencies for command_operations
pip install -r ../../command_operations/requirements.txt

::Dependencies for command_recognizer
pip install -r ../../command_recognizer/requirements.txt -f https://download.pytorch.org/whl/torch_stable.html

::Dependencies for local_server
pip install -r ../../local_server/requirements.txt

::Dependencies for windows-service
pip install -r ../../windows-service/requirements.txt

exit