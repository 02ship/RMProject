### COPY ITEMS FROM WATCH FOLDER TO BACKUP
Set-Location "C:\RoyalMail\Click&Drop\Labels"
Move-Item -Path .\*.pdf -Destination "C:\RoyalMail\LabelBackup"
### DELETE ITEMS FROM BACKUP FOLDER AFTER 7 DAYS
Get-ChildItem -path C:\RoyalMail\LabelBackup | where {$_.Lastwritetime -lt (date).adddays(-7)} | remove-item
### EMPTY JPGS FOLDER BEFORE RUNNIGN WATCH SCRIPT
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
                Add-content "C:\RoyalMail\log.txt" -value $logline
###                Start-Process C:\RoyalMail\RMProject\magick.bat $name.ToString() -NoNewWindow -Wait
                Start-Process C:\RoyalMail\RMProject\irfan3.bat -NoNewWindow -Wait
                New-Item C:\RoyalMail\commandfile.txt -ItemType "file"
                Add-Content C:\RoyalMail\commandfile.txt "report=C:\RoyalMail\RMProject\Longform_Invoice_for_RM.rpt"
                Add-Content C:\RoyalMail\commandfile.txt "format=Acrobat File"
                Add-Content C:\RoyalMail\commandfile.txt ("disk=C:\RoyalMail\invoices\" + $name.ToString() + ".pdf")
                Add-Content C:\RoyalMail\commandfile.txt ("{?HeaderRef}=" + $name.ToString())
                Add-Content C:\RoyalMail\commandfile.txt "{?IsCopy}=False"
                Add-Content C:\RoyalMail\commandfile.txt ("{?QR_path}=C:\RoyalMail\RMProject\jpgs\" + $name.ToString() + ".jpg")
                Start-Process C:\RoyalMail\RMProject\invoicegen.bat -NoNewWindow -Wait
                Remove-Item C:\RoyalMail\commandfile.txt
                Start-Process C:\RoyalMail\RMProject\autoprintlongform.bat ('C:\RoyalMail\invoices\' + $name.ToString() + '.pdf') -NoNewWindow -Wait
                Remove-Item ("C:\RoyalMail\RMProject\jpgs\" + $name.ToString() + ".jpg")
                Move-Item -Path ('C:\RoyalMail\invoices\' + $name.ToString() + '.pdf') -Destination ('C:\RoyalMail\invoices\archive\' + $name.ToString() + '.pdf')
              }    
### DECIDE WHICH EVENTS SHOULD BE WATCHED 
    Register-ObjectEvent $watcher "Created" -Action $action
###    Register-ObjectEvent $watcher "Changed" -Action $action
###    Register-ObjectEvent $watcher "Deleted" -Action $action
    while ($true) {sleep 5}