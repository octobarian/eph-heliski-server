#
# Copyright (c) 2022, FusionAuth, All Rights Reserved
#

# Spit out some help
If ($args.Length -eq 1 -and ($args[0].equals("-h") -or $args[0].equals("--help")))
{
  Write-Host "This script shuts down all running FusionAuth processes on the current machine."
  Write-Host ""
  Write-Host "Usage:"
  Write-Host "  shutdown.ps1 [options]"
  Write-Host ""
  Write-Host "OPTIONS:"
  Write-Host "  --help     Display this message"
  Exit 0
}

function main()
{
    $command = [Environment]::GetCommandLineArgs()
    # If running interactive in PS, use $PSCommandPath
    If ($command -like "*PowerShell*")
    {
        $command = $PSCommandPath
    }

    stopApp "fusionauth-app" "fusionAuthApp87AFBG16"
    stopApp "fusionauth-search" "fusionAuthSearchEngine87AFBG16"
}

function stopApp()
{
    Param([string]$appName, [string]$marker)
    Write-Host -NoNewLine "Stopping ${appName} ... "
    $appProcess = Get-WmiObject Win32_Process -Filter "name = 'java.exe'" | Where-Object CommandLine -CMatch "-D${marker}"
    If ($appProcess)
    {
        $processId = $appProcess.ProcessId
        Stop-Process -Id $processId
        Write-Host "done. [${processId}]"
    }
    Else
    {
        Write-Host "skipped, not running."
    }
}

main