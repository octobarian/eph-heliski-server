#
# Copyright (c) 2022, FusionAuth, All Rights Reserved
#

# Spit out some help
If ($args.Length -eq 1 -and ($args[0].equals("-h") -or $args[0].equals("--help")))
{
  Write-Host "This script starts the fusionauth-app service, which contains the entire FusionAuth product."
  Write-Host ""
  Write-Host "Usage:"
  Write-Host "  start.ps1 [options]"
  Write-Host ""
  Write-Host "OPTIONS:"
  Write-Host "  --debug    Start FusionAuth in debug mode. Intended for the FusionAuth dev team."
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

  $BASE_DIR = (Get-Item $command).Directory.Parent.Parent.FullName
  $APP_DIR = "$($BASE_DIR)\fusionauth-app"
  $CONFIG_DIR = "$($BASE_DIR)\config"
  $DATA_DIR = "$($BASE_DIR)\data"
  $JAVA_DIR = "$($BASE_DIR)\java"
  $LOG_DIR = "$($BASE_DIR)\logs"
  $PLUGIN_DIR = "$($BASE_DIR)\plugins"
  $MARKER = "fusionAuthApp87AFBG16"

  createDirectory $CONFIG_DIR
  createDirectory $DATA_DIR
  createDirectory $LOG_DIR

  downloadJava $JAVA_DIR

  Set-Item env:JAVA_OPTS -Value " -Dfusionauth.home.directory=${APP_DIR} -Dfusionauth.config.directory=${CONFIG_DIR} -Dfusionauth.data.directory=${DATA_DIR} -Dfusionauth.log.directory=${LOG_DIR} -Dfusionauth.plugin.directory=${PLUGIN_DIR} -Djava.awt.headless=true -Dcom.sun.org.apache.xml.internal.security.ignoreLineBreaks=true --add-exports=java.base/sun.security.x509=ALL-UNNAMED --add-exports=java.base/sun.security.util=ALL-UNNAMED --add-opens=java.base/java.net=ALL-UNNAMED -D${MARKER}"

  # Process config file
  $memory = resolveConfigurationProperty "${CONFIG_DIR}\fusionauth.properties" "" fusionauth-app.memory FUSIONAUTH_MEMORY FUSIONAUTH_APP_MEMORY
  If ($null -ne $memory)
  {
    Set-Item env:JAVA_OPTS -Value "${env:JAVA_OPTS} -Xmx${memory} -Xms${memory} "
  }

  $additionalJavaArgs = resolveConfigurationProperty "${CONFIG_DIR}\fusionauth.properties" "" fusionauth-app.additional-java-args FUSIONAUTH_ADDITIONAL_JAVA_ARGS FUSIONAUTH_APP_ADDITIONAL_JAVA_ARGS
  If ($null -ne $additionalJavaArgs)
  {
    Set-Item env:JAVA_OPTS -Value "${env:JAVA_OPTS} ${additionalJavaArgs} "
  }

  # TODO The following SHA-1 algorithms were removed in Java 17. If clients want to use them, it is up to them.
  # TODO See start.sh

  # Start it up
  Write-Host "Starting fusionauth-app..."
  Write-Host "  --> Logging to ${LOG_DIR}\fusionauth-app.log"

  $CLASSPATH = ""
  $JARS = Get-ChildItem "${APP_DIR}\lib" | Select-Object -ExpandProperty Name
  ForEach ($JAR in $JARS)
  {
    $CLASSPATH = "${CLASSPATH};lib\${JAR}"
  }
  $CLASSPATH = $CLASSPATH.Substring(1)

  If ($args.Length -gt 0 -and $args[0].equals("--debug"))
  {

    Write-Host "Starting with debug enabled"

    $JPDA_ADDRESS = If (Test-Path env:JPDA_ADDRESS) { env:JPDA_ADDRESS } Else { "5005" }
    $JPDA_SUSPEND = If (Test-Path env:JPDA_SUSPEND) { env:JPDA_SUSPEND } Else { "n" }

    # Append JAVA_OPTS
    Set-Item env:JAVA_OPTS -Value "${env:JAVA_OPTS} -agentlib:jdwp=transport=dt_socket,server=y,suspend=${JPDA_SUSPEND},address=*:${JPDA_ADDRESS}"
  }

  Start-Process "${env:JAVA_HOME}\bin\java" `
               -ArgumentList "-cp ${CLASSPATH} ${env:JAVA_OPTS} io.fusionauth.app.FusionAuthMain 2>&1" `
               -WorkingDirectory "${APP_DIR}" `
               -WindowStyle "Hidden" | Out-File ${LOG_DIR}\fusionauth-app.log -Append
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

# Returns the first available configuration value. It checks for a value in the following order:
# 1) environment variable at $newEnv
# 2) environment variable at $oldEnv
# 3) value of $newConfig property in $configFilePath
# 4) value of $oldConfig property in $configFilePath
function resolveConfigurationProperty()
{
    Param([string]$configFilePath, [string]$oldConfig, [string]$newConfig, [string]$oldEnv, [string]$newEnv)

    $configValue = [System.Environment]::GetEnvironmentVariable($newEnv)
    If ($null -ne $configValue)
    {
        return $configValue
    }
    $configValue = [System.Environment]::GetEnvironmentVariable($oldEnv)
    If ($null -ne $configValue)
    {
        Write-Host "You are using a deprecated environment variable of [${oldEnv}]. The new variable name is [${newEnv}]"
        return $configValue
    }
    If (Test-Path -Path $configFilePath -PathType leaf)
    {
        $props = ConvertFrom-StringData (Get-Content $configFilePath -Raw)
        If ($null -ne $props.$newConfig)
        {
            return $props.$newConfig
        }
        If ($null -ne $props.$oldConfig)
        {
            Write-Host "You are using a deprecated configuration property of [${oldConfig}] in [fusionauth.properties]. The new variable name is [${newConfig}]"
            return $props.$oldConfig
        }
    }

    return $null
}

main
