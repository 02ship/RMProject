### SET FOLDER TO WATCH + FILES TO WATCH + SUBFOLDERS YES/NO
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
                Start-Process C:\RoyalMail\RMProject\irfan2.bat -NoNewWindow -Wait
                New-Item C:\RoyalMail\commandfile.txt -ItemType "file"
                Add-Content C:\RoyalMail\commandfile.txt "report=C:\RoyalMail\RMProject\Invoice_for_RM.rpt"
                Add-Content C:\RoyalMail\commandfile.txt "format=Acrobat File"
                Add-Content C:\RoyalMail\commandfile.txt ("disk=C:\RoyalMail\invoices\" + $name.ToString() + ".pdf")
                Add-Content C:\RoyalMail\commandfile.txt ("{?HeaderRef}=" + $name.ToString())
                Add-Content C:\RoyalMail\commandfile.txt "{?IsCopy}=False"
                Add-Content C:\RoyalMail\commandfile.txt ("{?QR_path}=C:\RoyalMail\RMProject\jpgs\" + $name.ToString() + ".jpg")
                Start-Process C:\RoyalMail\RMProject\invoicegen.bat -NoNewWindow -Wait
                Remove-Item C:\RoyalMail\commandfile.txt
                Start-Process C:\RoyalMail\RMProject\autoprint.bat ('C:\RoyalMail\invoices\' + $name.ToString() + '.pdf') -NoNewWindow -Wait
                Move-Item -Path ('C:\RoyalMail\invoices\' + $name.ToString() + '.pdf') -Destination ('C:\RoyalMail\invoices\archive\' + $name.ToString() + '.pdf')
                Remove-Item ("C:\RoyalMail\RMProject\jpgs\" + $name.ToString() + ".jpg")
              }    
### DECIDE WHICH EVENTS SHOULD BE WATCHED 
    Register-ObjectEvent $watcher "Created" -Action $action
###    Register-ObjectEvent $watcher "Changed" -Action $action
###    Register-ObjectEvent $watcher "Deleted" -Action $action
    while ($true) {sleep 5}