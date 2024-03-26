#
# Copyright (c) 2022, FusionAuth, All Rights Reserved
#

# Spit out some help
If ($args.Length -eq 1 -and ($args[0].equals("-h") -or $args[0].equals("--help")))
{
  Write-Host "This script starts up the fusionauth-app service and optionally the fusionauth-search service. This is part of the FastPath install."
  Write-Host ""
  Write-Host "Usage:"
  Write-Host "  startup.ps1 [options]"
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

    $BASE_DIR = (Get-Item $command).Directory.Parent.FullName
    $CONFIG_DIR = "$($BASE_DIR)\config"
    $JAVA_DIR = "$($BASE_DIR)\java"
    $LOG_DIR = "$($BASE_DIR)\logs"

    createDirectory $CONFIG_DIR
    createDirectory $LOG_DIR

    downloadJava $JAVA_DIR

    startSearch
    startApp
    # Wait briefly to display script output from startApp before new prompt
    Start-Sleep 2
}

function createDirectory()
{
  Param([string]$directory)

  If (!(Test-Path "$directory"))
  {
    New-Item -ItemType Directory -Path "$directory" -Force
  }
}

# Download Java
function downloadJava()
{
    Param([string]$JAVA_DIR)

    $JavaVersion = "17.0.8.1"
    $JavaRevision = "1"
    $JavaFileURL = "https://github.com/adoptium/temurin17-binaries/releases/download/jdk-${JavaVersion}%2B${JavaRevision}/OpenJDK17U-jdk_x64_windows_hotspot_${JavaVersion}_${JavaRevision}.zip"
    $JavaPath = "${JAVA_DIR}\jdk-${JavaVersion}+${JavaRevision}"
    $JavaZipFile = "${JAVA_DIR}\jdk-${JavaVersion}+${JavaRevision}.zip"
    Set-Item env:JAVA_HOME -Value "${JavaPath}"

    # Check and install java if it is missing
    If (!(Test-Path "${JAVA_DIR}") -or !(Test-Path "${JavaPath}"))
    {
        createDirectory "${JAVA_DIR}"

        $webClient = new-Object System.Net.WebClient
        $webClient.DownloadFile("${JavaFileURL}", "${JavaZipFile}")
        Expand-Archive -Path "${JavaZipFile}" -DestinationPath "${JAVA_DIR}"
        Remove-Item "${JavaZipFile}"
    }
}

function startApp()
{
    $APP_MARKER = "fusionAuthApp87AFBG16"
    If (Test-Path "${BASE_DIR}\fusionauth-app\bin\start.ps1")
    {
        If (Get-WmiObject Win32_Process -Filter "name = 'java.exe'" | Where-Object CommandLine -CMatch "-D${APP_MARKER}")
        {
            Write-Host "Starting fusionauth-app ... skipped, already running."
        }
        Else
        {
            Start-Process `
                PowerShell `
                -ArgumentList "-ExecutionPolicy ByPass -File ${BASE_DIR}\fusionauth-app\bin\start.ps1" `
                -NoNewWindow
        }
    }
    Else
    {
        Write-Host "Starting fusionauth-app ... skipped, not installed"
    }
}

function startSearch()
{
    $SEARCH_MARKER = "fusionAuthSearchEngine87AFBG16"
    Write-Host -NoNewline "Starting fusionauth-search ... "
    If (Test-Path "${BASE_DIR}\fusionauth-search\elasticsearch\bin\elasticsearch.bat")
    {
        If (Get-WmiObject Win32_Process -Filter "name = 'java.exe'" | Where-Object CommandLine -CMatch "-D${SEARCH_MARKER}")
        {
            Write-Host "skipped, already running."
        }
        Else
        {
            Start-Process `
                cmd `
                -ArgumentList "/c ${BASE_DIR}\fusionauth-search\elasticsearch\bin\elasticsearch.bat 2>&1" `
                -WorkingDirectory "${BASE_DIR}\fusionauth-search" `
                -WindowStyle "Hidden" `
                | Out-File ${LOG_DIR}\fusionauth-search.log -Append
            Write-Host "done."
            Write-Host "  --> Logging to ${LOG_DIR}\fusionauth-search.log"
        }
    }
    Else
    {
        Write-Host "skipped, not installed"
    }
}

main