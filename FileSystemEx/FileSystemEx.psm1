Import-Module ConsoleEx

function Get-LastWriteTimeOrMin ([string]$ItemPath) {
    if (-Not (Test-Path $ItemPath)) {
        return [DateTime]::MinValue
    }
    return (((Get-ChildItem $ItemPath -Recurse).LastWriteTime) | Measure-Object -Maximum).Maximum
}

function Backup-NewerItem ([string]$Source, [string]$Backup) {
    Write-Message "Backup: $Source"

    if (-Not (Test-Path $Source)) {
        Write-Message -Type Error 'Path not found'
        return
    }

    $destination = [IO.Path]::ChangeExtension($Backup, '.zip')
    Write-Message "Destination: $destination"

    $dataModified = Get-LastWriteTimeOrMin $Source
    $destinationModified = Get-LastWriteTimeOrMin $destination
    if ($dataModified -le $destinationModified) {
        Write-Message -Type Warning 'Backup is actual. Skipping.'
        return
    }

    Compress-Archive -Path $saves -DestinationPath $destination -Force    

    Write-Message -Type Ok 'Backuped'
}
