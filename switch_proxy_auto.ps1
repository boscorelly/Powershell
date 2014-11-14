# Free for use, not for resale
# Copyright : Camille Ollié
# Rev : 1.0 - 14 Nov 2014

Write-Host "Retreiving local config
"

# Define proxy regkey, last bits and port
$regkey = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings"
$endproxy = "254:3128"

# Configure places
$place1 = "10.134.62"
$place2 = ""

# Get and explode ip address
$GetIP = (Get-WmiObject -class win32_NetworkAdapterConfiguration -Filter 'ipenabled = "true"').ipaddress[0]
$LocalIP = ("$GetIP").Substring(0,9)

Write-Host "Configuring proxy values
"

# Switch depending on ip
if ( $LocalIP -eq "10.134.62" ) {
    Write-Host "--> Matching Lattes ($LocalIP) <--
    "
    Push-Location
    Set-Location $regkey
    Set-ItemProperty . ProxyEnable -Value 1
    Set-ItemProperty . ProxyServer -Value "10.134.62.254:3128"
    Pop-Location
} else {
    Write-Host "--> Not matching anything, disabling <--
    "
    Push-Location
    Set-Location $regkey
    Set-ItemProperty . ProxyEnable -Value 0
    Pop-Location
}

Write-Host "Proxy configured"