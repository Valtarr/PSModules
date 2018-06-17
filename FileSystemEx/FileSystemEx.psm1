Import-Module ConsoleEx

function Get-LastWriteTimeOrMin ($ItemPath) {
    if (-Not (Test-Path $ItemPath)) {
        return [DateTime]::MinValue
    }
    return (((Get-ChildItem $ItemPath -Recurse).LastWriteTime) | Measure-Object -Maximum).Maximum
}

function Backup-NewerItem ($Source, $Backup) {
    Write-Message "Backup: $Source"

    if (-Not (Test-Path $Source)) {
        Write-Message -Type ERR 'Path not found'
        return
    }

    $destination = [io.path]::ChangeExtension($Backup, '.zip')
    Write-Message -Type INF -Message "Destination: $destination"

    $dataModified = Get-LastWriteTimeOrMin $Source
    $destinationModified = Get-LastWriteTimeOrMin $destination
    if ($dataModified -le $destinationModified) {
        Write-Message -Type WARN 'Backup is actual. Skipping.'
        return
    }

    Compress-Archive -Path $saves -DestinationPath $destination -Force    

    Write-Message -Type OK 'Backuped'
}
