function Write-Message {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $false, ValueFromPipeline = $false, HelpMessage = 'Message type (impact color indication)')]
        [ValidateSet(IgnoreCase = $true, 'Info', 'Ok', 'Warning', 'Error', 'Debug')]
        [string]$Type = 'INFO',

        [Parameter(Mandatory = $false, ValueFromPipeline = $false, HelpMessage = 'Write timestamp to console')]
        [switch]$Time = $false,

        [Parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 0)]
        [string]$Message
    )
    
    process {
        [ConsoleColor]$markBackground = switch ( $Type ) {
            'Warning' { [ConsoleColor]::Yellow }
            'Error' { [ConsoleColor]::Red }
            'Debug' { [ConsoleColor]::DarkCyan }
            'Ok' { [ConsoleColor]::Green }
            default { [ConsoleColor]::DarkGray }
        }

        [ConsoleColor]$markForeground = switch ( $Type ) {
            'Warning' { [ConsoleColor]::Black }
            'Error' { [ConsoleColor]::White }
            'Debug' { [ConsoleColor]::Cyan }
            'Ok' { [ConsoleColor]::Black }
            default { [ConsoleColor]::Gray }
        }

        [string]$mark = switch ( $Type ) {
            'Warning' { '[WRN]' }
            'Error' { '[ERR]' }
            'Debug' { '[DBG]' }
            'Ok' { '[OK ]' }
            'Info' { '[INF]' }
            default { "[$Type]" }
        }

        Write-Host $mark -NoNewline -ForegroundColor $markForeground -BackgroundColor $markBackground

        if ($Time) {
            Write-Host -NoNewline -ForegroundColor DarkGray (Get-Date).ToString(' HH:mm:ss')
        }

        Write-Host " $Message"
    }
}

function Write-Exception {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, HelpMessage = 'Exception to show')]
        [Exception]$Exception,
        [Parameter(Mandatory = $false, ValueFromPipeline = $false, HelpMessage = 'Write timestamp to console')]
        [switch]$Time = $false
    )
    
    process {
        Write-Message -Type Error -Time $Time "$($Exception.GetType()): $($Exception.Message)"
    }
}