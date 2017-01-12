# =======================================================
# NAME: maintenance_preventive.ps1
# AUTHOR: Camille Ollié, Solutek
# DATE: 11/14/2016
#
# KEYWORDS: YYY, XXXXXXXXX , AAAAAA
# VERSION 0.2
# 11/14/2016 ajout de la fonction de date
# 11/14/2016 ajout de la fonction de verification des MàJ
# 11/14/2016 ajout de la fonction de vérification de l'espace disque
# COMMENTS: Desription des traitements
#
# =======================================================

$date = Get-Date -format yyyy-M-d

$ErrorActionPreference="SilentlyContinue"
Stop-Transcript | out-null
$ErrorActionPreference = "Continue"
Start-Transcript -path c:\_maintenance_$date.txt

# Etat des disques
write-host "`r"
write-host "Disk state"
write-host "`r`r"
gwmi win32_volume -Filter 'drivetype = 3' | select driveletter, @{LABEL='Free Space';EXPRESSION={"{0:N2}" -f ($_.freespace/1GB) } }, @{LABEL='Capacity';EXPRESSION={"{0:N2}" -f ($_.capacity/1GB) } }

# Etat des mises a jour

write-host "`r`r"
write-host "Updates to apply"
write-host "`r`r`r"

$update = new-object -com Microsoft.update.Session
$searcher = $update.CreateUpdateSearcher()
$pending = $searcher.Search("IsInstalled=0")

foreach($entry in $pending.Updates)
{
    Write-host $entry.Title`r
}

# Installation des mises a jour

#$installupd = New-Object -ComObject "Microsoft.Update.UpdateColl"

# Etat des logs

write-host "`r`r"
write-host "Get logs errors"
write-host "`r`r`r"

write-host "System"
write-host "`r`r"
Get-WinEvent -FilterHashtable @{ logname='system'; level=1,2,3; StartTime=((get-date).date).AddDays(-30); EndTime=(get-date).date; } -Oldest | where {$_.Id -ne 4098 -or 0} | ConvertTo-Html LevelDisplayName,TimeCreated,Id,Message

write-host "Application"

Get-WinEvent -FilterHashtable @{ logname='application'; level=2,3; StartTime=((get-date).date).AddDays(-30); EndTime=(get-date).date; } -Oldest | where {$_.Id -ne 4098 -or 0} | ConvertTo-Html LevelDisplayName,TimeCreated,Id,Message

# Fin du script

write-host "`r`r"
Stop-Transcript