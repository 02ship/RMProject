### SET FOLDER TO WATCH + FILES TO WATCH + SUBFOLDERS YES/NO
    $watcher = New-Object System.IO.FileSystemWatcher
    $watcher.Path = "F:\PaulShields\PDFs"
    $watcher.Filter = "*.pdf"
###    $watcher.IncludeSubdirectories = $true
    $watcher.EnableRaisingEvents = $true  

### DEFINE ACTIONS AFTER AN EVENT IS DETECTED
    $action = { $path = $Event.SourceEventArgs.FullPath
                $name = $Event.SourceEventArgs.Name
                $changeType = $Event.SourceEventArgs.ChangeType
                $logline = "$(Get-Date), $changeType, $path, $name"
                Add-content "F:\PaulShields\PDFs\log.txt" -value $logline
                Start-Process F:\PaulShields\RMProject\invoicegen.bat -NoNewWindow -Wait
                Start-Process F:\PaulShields\RMProject\irfan2.bat -NoNewWindow -Wait
              }    
### DECIDE WHICH EVENTS SHOULD BE WATCHED 
    Register-ObjectEvent $watcher "Created" -Action $action
###    Register-ObjectEvent $watcher "Changed" -Action $action
###    Register-ObjectEvent $watcher "Deleted" -Action $action
###    Register-ObjectEvent $watcher "Renamed" -Action $action
    while ($true) {sleep 5}