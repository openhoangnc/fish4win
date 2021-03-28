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

# folder using by fish
bash -c "mkdir /dev/shm"

# update WindowsTerminal Setting
bash -c "wget https://github.com/openhoangnc/fish4win/raw/main/wt-setting.py && python wt-setting.py && rm wt-setting.py"

# update vscode terminal setting
if (Test-Path -Path "$Env:APPDATA\\Code\\User\\settings.json" -PathType Leaf) {
    bash -c "wget https://github.com/openhoangnc/fish4win/raw/main/vscode-setting.py && python vscode-setting.py && rm vscode-setting.py"
}

Pop-Location

Write-Output "Deleting $packageFile"
Remove-Item $packageFile

Write-Output "All done!"
Read-Host

# TODO: uninstaller
# 1. Delete $Env:LOCALAPPDATA\msys64 folder
# 2. Remove $windowsTerminalSettingFile entries
# 3. Remove vscode settings.json "terminal.integrated.shell.windows"