if ( (Test-Path HKLM:\SYSTEM\CurrentControlSet\services\W32Time\Parameters) -eq 'True' ) {

     Push-Location
 
     Set-Location HKLM:\SYSTEM\CurrentControlSet\services\W32Time\Parameters
 
     if ( (Get-ItemProperty . NtpServer) -ne '10.134.62.1,0x1' ) {

        Set-ItemProperty . NtpServer "10.134.62.1,0x1"

    }

    Pop-Location

    Restart-Service "W32Time"
 }

