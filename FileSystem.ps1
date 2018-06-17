function Get-LastWriteTimeOrMin ($folderPath) {
    if (-Not (Test-Path $folderPath)) {
        return [DateTime]::MinValue
    }
    return (((Get-ChildItem $folderPath -Recurse).LastWriteTime) | Measure-Object -Maximum).Maximum
}

function Backup-Item ($name, $dataPath) {
    Write-Message "Backup $dataPath"

    if (-Not (Test-Path $dataPath)) {
        Write-Message -Type ERR 'Path not found'
        return
    }

    $destination = "$PSScriptRoot\$name.zip"

    $dataModified = Get-LastWriteTimeOrMin $dataPath
    $destinationModified = Get-LastWriteTimeOrMin $destination
    if ($dataModified -le $destinationModified) {
        Write-Message -Type WARN 'Backup is actual. Skipping.'
        return
    }

    Compress-Archive -Path $saves -DestinationPath $destination -Force    

    Write-Message -Type OK 'Backuped'
}
