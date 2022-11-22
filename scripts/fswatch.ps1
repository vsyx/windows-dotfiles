if ($args.count -lt 1) {
    Write-Error 'At least one path must be provided'
    Exit
}

#$Path = (Resolve-Path $args[0]).Path 
$Path = $args[0]
$FileFilter = '*'  
$IncludeSubfolders = $true

# specify the file or folder properties you want to monitor:
$AttributeFilter = [IO.NotifyFilters]::FileName, [IO.NotifyFilters]::LastWrite 

try
{
  $watcher = New-Object -TypeName System.IO.FileSystemWatcher -Property @{
    Path = $Path
    Filter = $FileFilter
    IncludeSubdirectories = $IncludeSubfolders
    NotifyFilter = $AttributeFilter
  }

  $action = {
    $ChangeType = $details.ChangeType
    $Timestamp = $event.TimeGenerated

    Write-Host $ChangeType $Timestamp
  }

  $handlers = . {
    Register-ObjectEvent -InputObject $watcher -EventName Changed  -Action $action 
    Register-ObjectEvent -InputObject $watcher -EventName Created  -Action $action 
    Register-ObjectEvent -InputObject $watcher -EventName Deleted  -Action $action 
    Register-ObjectEvent -InputObject $watcher -EventName Renamed  -Action $action 
  }
  $handlers.GetType()

  # monitoring starts now:
  $watcher.EnableRaisingEvents = $true
  Write-Host "Watching for changes to $Path"

  do
  {
    Wait-Event 
    Write-Host "." -NoNewline
  } while ($true)
}
finally
{
  $watcher.EnableRaisingEvents = $false
  $handlers | ForEach-Object {
    Unregister-Event -SourceIdentifier $_.Name
  }
  $handlers | Remove-Job
  $watcher.Dispose()
}
