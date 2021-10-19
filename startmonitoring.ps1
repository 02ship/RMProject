### SET FOLDER TO WATCH + FILES TO WATCH + SUBFOLDERS YES/NO
    $watcher = New-Object System.IO.FileSystemWatcher
    $watcher.Path = "C:\RMProject\PDFs"
    $watcher.Filter = "*.pdf"
###    $watcher.IncludeSubdirectories = $true
    $watcher.EnableRaisingEvents = $true  

### DEFINE ACTIONS AFTER AN EVENT IS DETECTED
    $action = { $path = $Event.SourceEventArgs.FullPath
                $name = $Event.SourceEventArgs.Name
                $changeType = $Event.SourceEventArgs.ChangeType
                $name = $name.TrimEnd(".pdf")
                $logline = "$(Get-Date), $changeType, $path"
                Add-content "C:\RMProject\PDFs\log.txt" -value $logline
                Start-Process C:\RMProject\irfan2.bat -NoNewWindow -Wait
                New-Item C:\RMProject\commandfile.txt
                Add-Content C:\RMProject\commandfile.txt "report=F:\Montana Reports\Invoice_for_RM.rpt"
                Add-Content C:\RMProject\commandfile.txt "printer=NPI8E3F7D (HP LaserJet P2055x)"
                Add-Content C:\RMProject\commandfile.txt ("{?HeaderRef}=" + $name.ToString())
                Add-Content C:\RMProject\commandfile.txt "{?IsCopy}=False"
                Add-Content C:\RMProject\commandfile.txt ("{?QR_path}=C:\RMProject\jpgs\" + $name.ToString() + ".bmp")
                Start-Process C:\RMProject\invoicegen.bat -NoNewWindow -Wait
                Remove-Item C:\RMProject\commandfile.txt
              }    
### DECIDE WHICH EVENTS SHOULD BE WATCHED 
    Register-ObjectEvent $watcher "Created" -Action $action
###    Register-ObjectEvent $watcher "Changed" -Action $action
###    Register-ObjectEvent $watcher "Deleted" -Action $action
    while ($true) {sleep 5}