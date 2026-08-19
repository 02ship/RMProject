if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) { Start-Process powershell.exe "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs; exit }
### COPY ITEMS FROM WATCH FOLDER TO BACKUP
Set-Location "C:\RoyalMail\Click&Drop\Labels"
Move-Item -Path .\*.pdf -Destination "C:\RoyalMail\LabelBackup"
### DELETE ITEMS FROM BACKUP FOLDER AFTER 7 DAYS
Get-ChildItem -path C:\RoyalMail\LabelBackup | where {$_.Lastwritetime -lt (date).adddays(-7)} | remove-item
### EMPTY JPGS FOLDER BEFORE RUNNING WATCH SCRIPT
Set-Location "C:\RoyalMail\RMProject\jpgs"
Remove-Item *.jpg
### SET FOLDER + FILES TO WATCH + SUBFOLDERS YES/NO
    $watcher = New-Object System.IO.FileSystemWatcher
    $watcher.Path = "C:\RoyalMail\Click&Drop\Labels"
    $watcher.Filter = "*.pdf"
###    $watcher.IncludeSubdirectories = $true
    $watcher.EnableRaisingEvents = $true  

### DEFINE ACTIONS AFTER AN EVENT IS DETECTED
    $action = { $path = $Event.SourceEventArgs.FullPath
                $name = $Event.SourceEventArgs.Name
                $changeType = $Event.SourceEventArgs.ChangeType
                $name = $name.TrimEnd(".pdf")
                $logline = "$(Get-Date), $changeType, $path"
                $specialthanks = Get-Content -Path "C:/RoyalMail/RMProject/specialthankscustomers.csv"
                $specialthanks = $specialthanks -join '|'
                Write-Host $specialthanks
                Add-content "C:\RoyalMail\log.txt" -value $logline
                Start-Process C:\RoyalMail\RMProject\irfan3.bat -NoNewWindow -Wait
                $crystalReportsNinjaArguments = @(
                    '-F', 'C:\RoyalMail\RMProject\Longform_Invoice_for_RM.rpt',
                    '-E', 'pdf',
                    '-O', "C:\RoyalMail\invoices\$name.pdf",
                    '-a', "HeaderRef:$name",
                    '-a', 'IsCopy:False',
                    '-a', "SpecialThanks:$specialthanks"
                )
                & 'C:\RoyalMail\CrystalReportsNinja\Deployment\CrystalReportsNinja.exe' @crystalReportsNinjaArguments
                if ($LASTEXITCODE -ne 0) { throw "CrystalReportsNinja failed with exit code $LASTEXITCODE" }
                Start-Process C:\RoyalMail\RMProject\autoprintlongform.bat ('C:\RoyalMail\invoices\' + $name.ToString() + '.pdf') -NoNewWindow -Wait
              }    
### DECIDE WHICH EVENTS SHOULD BE WATCHED 
    Register-ObjectEvent $watcher "Created" -Action $action
###    Register-ObjectEvent $watcher "Changed" -Action $action
###    Register-ObjectEvent $watcher "Deleted" -Action $action
    while ($true) {sleep 5}