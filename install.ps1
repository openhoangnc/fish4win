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

$binPath = "$Env:LOCALAPPDATA\msys64\usr\bin"
if($Env:Path -NotMatch ($binPath -replace '\\', '\\')) {
    $Env:Path = "$binPath;$Env:Path"
}
bash -c "pacman-key --init"
bash -c "pacman-key --populate msys2"
bash -c "pacman -S python3 diffutils patch fish --noconfirm"

bash -c "cd /etc && wget https://github.com/openhoangnc/fish4win/raw/main/init-path.py"
bash -c "cd / && wget https://github.com/openhoangnc/fish4win/raw/main/configs.patch && patch -p0 -N < configs.patch && rm configs.patch"
bash -c "mkdir /etc/shm"

# TODO 1: update $windowsTerminalSettingFile
#    {
#        "guid": "{335dd601-c909-4a68-90a2-ba1d962c612d}",
#        "name": "MSYS2 Bash",
#        "commandline": "%LOCALAPPDATA%\\msys64\\usr\\bin\\bash.exe",
#        "icon": "%LOCALAPPDATA%\\msys64\\msys2.ico",
#        "hidden": false,
#        "startingDirectory": "%USERPROFILE%"
#    },
#    {
#        "guid": "{2733b63c-5398-444b-badb-fe795f96f984}",
#        "name": "MSYS2 Fish",
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

Write-Output "All done!"
Read-Host
