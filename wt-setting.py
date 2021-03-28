import json
import os
import re
wtSettingFile = f'{os.environ.get("LOCALAPPDATA")}\\Packages\\Microsoft.WindowsTerminal_8wekyb3d8bbwe\\LocalState\\settings.json'
settingFile = open(wtSettingFile)
setting = settingFile.read()

rxLoad = re.compile(r'"list":[^\[]*\[', re.MULTILINE)
if '"guid": "{335dd601-c909-4a68-90a2-ba1d962c612d}"' not in setting:
    setting = rxLoad.sub(r"""
    "list": [
      {
        "guid": "{335dd601-c909-4a68-90a2-ba1d962c612d}",
        "name": "MSYS2 Bash",
        "commandline": "%LOCALAPPDATA%\\\\msys64\\\\usr\\\\bin\\\\bash.exe",
        "icon": "%LOCALAPPDATA%\\\\msys64\\\\msys2.ico",
        "hidden": false,
        "startingDirectory": "%USERPROFILE%"
      },""", setting)


if '"guid": "{2733b63c-5398-444b-badb-fe795f96f984}"' not in setting:
    setting = rxLoad.sub(r"""
    "list": [
      {
        "guid": "{2733b63c-5398-444b-badb-fe795f96f984}",
        "name": "MSYS2 Fish",
        "commandline": "%LOCALAPPDATA%\\\\msys64\\\\usr\\\\bin\\\\fish.exe",
        "icon": "%LOCALAPPDATA%\\\\msys64\\\\msys2.ico",
        "hidden": false,
        "startingDirectory": "%USERPROFILE%"
      },""", setting)


setting = re.sub(
    r'"defaultProfile":[^,]+,', '"defaultProfile": "{2733b63c-5398-444b-badb-fe795f96f984}",', setting)

with open(wtSettingFile, "w") as f:
    f.write(setting)
    f.close()
