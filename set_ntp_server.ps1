$ntpserver = "10.134.62.1"
$hklmsvc = "HKLM:\SYSTEM\CurrentControlSet\services\W32Time\Parameters"
$hklmsrv = "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\DateTime\Servers"

if ( (Test-Path $hklmsvc) -eq 'True' ) {
     Push-Location
     Set-Location $hklmsvc
 
     if ( (Get-ItemProperty . NtpServer) -ne "$ntpserver,0x1" ) {
        Write-Host "Configuring NTP service."
        Set-ItemProperty . NtpServer "$ntpserver,0x1"
    }

    Pop-Location

 }

if ( (Get-ItemProperty -Path $hklmsrv) -notmatch $ntpserver) {
    Write-Host "Server not found. Adding."
    Push-Location
    Set-Location $hklmsrv
    Set-ItemProperty . 50 -Value "$ntpserver"
}

if ( (Get-ItemProperty . "(default)") -ne "50") { 
    Write-Host "Setting default NTP Server."
    Set-ItemProperty . "(default)" "50"
}

Pop-Location

Stop-Service "W32Time"
Start-Service "W32Time"
