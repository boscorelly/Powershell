$regkey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
$proxy = "10.34.62.1:3128"

Push-Location
 
Set-Location $regkey

if ( (Get-ItemProperty . ProxyEnable) -ne '0' ) {
    Set-ItemProperty . ProxyEnable -Value 1
    Set-ItemProperty . ProxyServer -Value $proxy 
}

Pop-Location