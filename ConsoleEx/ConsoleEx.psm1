function Write-Message {
    Param(
        [Parameter(Mandatory = $false, ValueFromPipeline = $false, HelpMessage = 'Message type (color highlight)')]
        [ValidateSet('INF', 'OK', 'WARN', 'ERR', 'DBG')]
        [String]$Type = 'INF',

        [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 0, HelpMessage = 'Text message to write to host')]
        [String]$Message
    )
    
    if($Type -eq 'INF'){ Write-Host '[INF ]' -BackgroundColor DarkGray -ForegroundColor Black -NoNewline}
    if($Type -eq 'DBG'){ Write-Host '[DBG ]' -BackgroundColor Cyan -ForegroundColor Black -NoNewline}
    if($Type -eq 'WARN'){ Write-Host '[WARN]' -BackgroundColor Yellow -ForegroundColor Black -NoNewline}
    if($Type -eq 'ERR'){ Write-Host '[ERR ]' -BackgroundColor Red -ForegroundColor White -NoNewline}
    if($Type -eq 'OK'){ Write-Host '[OK  ]' -BackgroundColor Green -ForegroundColor Black -NoNewline}

    Write-Host " $Message"
}
