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
                $name = $name.TrimEnd(".pdf")
                $logline = "$(Get-Date), $changeType, $path"
                Add-content "F:\PaulShields\PDFs\log.txt" -value $logline
                Start-Process F:\PaulShields\RMProject\irfan2.bat -NoNewWindow -Wait
                New-Item F:\PaulShields\commandfile.txt
                Add-Content F:\PaulShields\commandfile.txt "report=F:\Montana Reports\Invoice_for_RM.rpt"
                Add-Content F:\PaulShields\commandfile.txt "printer=iR C3380"
                Add-Content F:\PaulShields\commandfile.txt ("{?HeaderRef}=" + $name.ToString())
                Add-Content F:\PaulShields\commandfile.txt "{?IsCopy}=False"
                Add-Content F:\PaulShields\commandfile.txt ("{?QR_path}=F:\PaulShields\jpgs\" + $name.ToString() + ".bmp")
                Start-Process F:\PaulShields\RMProject\invoicegen.bat -NoNewWindow -Wait
                Remove-Item F:\PaulShields\commandfile.txt
###                Start-Process F:\PaulShields\RMProject\invoicegen.bat $name -NoNewWindow -Wait
              }    
### DECIDE WHICH EVENTS SHOULD BE WATCHED 
    Register-ObjectEvent $watcher "Created" -Action $action
###    Register-ObjectEvent $watcher "Changed" -Action $action
###    Register-ObjectEvent $watcher "Deleted" -Action $action
###    Register-ObjectEvent $watcher "Renamed" -Action $action
    while ($true) {sleep 5}