$windowsTerminalSettingFile = "$Env:LOCALAPPDATA\\Packages\\Microsoft.WindowsTerminal_8wekyb3d8bbwe\\LocalState\\settings.json"

if (-not(Test-Path -Path $windowsTerminalSettingFile -PathType Leaf)) {
    Start-Process "ms-windows-store://pdp/?ProductId=9N0DX20HK701"
    Read-Host "Please Install Windows Terminal and Launch it, press enter when you ready"
}
if (-not(Test-Path -Path $windowsTerminalSettingFile -PathType Leaf)) {
    Write-Output "Please Install Windows Terminal and Launch it first"
    Exit 1
}

$url = "http://mirrors.dotsrc.org/msys2/distrib/"
$file = "msys2-x86_64-latest.sfx.exe"

$packageFile = "$Env:Temp/$file"

Write-Output "Downloading $url+$file to $packageFile"
(New-Object System.Net.WebClient).DownloadFile($url+$file, $packageFile)

Push-Location $Env:LOCALAPPDATA

Invoke-Expression "$packageFile -y"

$nsswitchFile =  "$Env:LOCALAPPDATA/msys64/etc/nsswitch.conf"
((Get-Content $nsswitchFile -Raw) -replace 'db_home: cygwin desc','db_home: windows') | Set-Content $nsswitchFile

$binPath = "$Env:LOCALAPPDATA\msys64\usr\bin"
if($Env:Path -NotMatch ($binPath -replace '\\', '\\')) {
    $Env:Path = "$binPath;$Env:Path"
}

$Env:Path

bash -c "pacman-key --init"
bash -c "pacman-key --populate msys2"
bash -c "pacman -S python3 --noconfirm"

$initPathPy = "$Env:LOCALAPPDATA/msys64/init-path.py"
Write-Output "import os" > $initPathPy
Write-Output "BIN_PATH = '/usr/local/bin:/usr/bin:/bin:/opt/bin:'" >> $initPathPy
Write-Output "print(BIN_PATH+os.environ.get('PATH').replace(BIN_PATH,''))" os >> $initPathPy

# $bashrc = "$Env:LOCALAPPDATA/msys64/etc/bash.bashrc"
# PATH=$(/usr/bin/python $LOCALAPPDATA/msys64/init-path.py) >>>>>>>>>> $bashrc

# $fishConfig = "$Env:LOCALAPPDATA/msys64/etc/fish/config.fish"
# set -x PATH (/usr/bin/python $LOCALAPPDATA/msys64/init-path.py) >>>>>>>> $fishConfig 

# TODO 0: confirm and install other shell (bash, zsh, fish, ...)

# TODO 1: update $windowsTerminalSettingFile
#    {
#        "guid": "{61c54bbd-c2c6-5271-96e7-009a87ff44ba}",
#        "name": "MSYS Bash",
#        "commandline": "%LOCALAPPDATA%\\msys64\\usr\\bin\\bash.exe",
#        "icon": "%LOCALAPPDATA%\\msys64\\msys2.ico",
#        "hidden": false,
#        "startingDirectory": "%USERPROFILE%"
#    },
#    {
#        "guid": "{61c54bbd-c2c6-5271-96e7-009a87ff44bb}",
#        "name": "MSYS Fish",
#        "commandline": "%LOCALAPPDATA%\\msys64\\usr\\bin\\fish.exe",
#        "icon": "%LOCALAPPDATA%\\msys64\\msys2.ico",
#        "hidden": false,
#        "startingDirectory": "%USERPROFILE%"
#    },

# TODO 2: confirm and update vscode terminal setting
# "terminal.integrated.shell.windows": "${env:LOCALAPPDATA}\\msys64\\usr\\bin\\fish.exe",

Pop-Location

Write-Output "Deleting $packageFile"
Remove-Item $packageFile

Read-Host
