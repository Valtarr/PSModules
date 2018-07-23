function SetDebug {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0, HelpMessage = 'Enables/disables current scope Debugging')]
        [bool]$Enabled
    )
    process {
        Set-Variable -Name 'IsDebugEnabled' -Value $Enabled -Scope 1
    }
}

function Write-FramedText {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [string]$Text,
        [Parameter(Mandatory = $false)]
        [int]$Ident = 0
    )
    process {
        Write-Host (" " * $Ident) -NoNewline; Write-Host "$([char]0x2554)$([char]0x2550)" -NoNewline; Write-Host ("$([char]0x2550)" * $Text.Length) -NoNewline; Write-Host "$([char]0x2550)$([char]0x2557)"
        Write-Host (" " * $Ident) -NoNewline; Write-Host "$([char]0x2551) " -NoNewline; Write-Host $Text -NoNewline;                Write-Host " $([char]0x2551)"
        Write-Host (" " * $Ident) -NoNewline; Write-Host "$([char]0x255A)$([char]0x2550)" -NoNewline; Write-Host ("$([char]0x2550)" * $Text.Length) -NoNewline; Write-Host "$([char]0x2550)$([char]0x255D)"
    }
}

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
        if ( $Type -eq 'Debug' -and -not $IsDebugEnabled) { return }

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