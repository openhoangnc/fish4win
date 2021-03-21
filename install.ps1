$url = "http://mirrors.dotsrc.org/msys2/distrib/"
$file = "msys2-x86_64-latest.sfx.exe"

$packageFile = "$Env:Temp/$file"

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

Pop-Location

Remove-Item $packageFile

Read-Host
