import json
import os
vscodeSettingFile = f'{os.environ.get("APPDATA")}\\Code\\User\\settings.json'
settingFile = open(vscodeSettingFile)
setting = json.load(settingFile)
settingFile.close()

setting["terminal.integrated.shell.windows"] = '${env:LOCALAPPDATA}\\msys64\\usr\\bin\\fish.exe'

with open(vscodeSettingFile, "w") as outfile:
    json.dump(setting, outfile, indent=4)
