#
# Copyright (c) 2022, FusionAuth, All Rights Reserved
#

$appProcess = Get-WmiObject Win32_Process -Filter "name = 'java.exe'" | Where-Object CommandLine -CMatch "-DfusionAuthApp87AFBG16"
If ($null -ne $appProcess)
{
    $processId = $appProcess.ProcessId
    Stop-Process -Id $processId
    Write-Host "Stopped the FusionAuth process. [${processId}]"
}
Else
{
    Write-Host "Not running"
}