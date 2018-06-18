$modulesDirectory = "$($env:USERPROFILE)\Documents\WindowsPowerShell\Modules"
New-Item -ItemType Directory -Path $modulesDirectory -Force | Out-Null
Get-ChildItem $PSScriptRoot -Directory |
Copy-Item -Recurse -Force -Destination $modulesDirectory