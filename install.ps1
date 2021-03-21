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

# TODO 0: confirm and install other shell (bash, zsh, fish, ...)
# TODO 1: update $windowsTerminalSettingFile
# TODO 2: confirm and update vscode terminal setting

Pop-Location

Write-Output "Deleting $packageFile"
Remove-Item $packageFile

Read-Host
