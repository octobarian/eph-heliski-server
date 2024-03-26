#!/usr/bin/env bash

#
# Copyright (c) 2022-2023, FusionAuth, All Rights Reserved
#
set -e

# Spit out some help
if [[ ${1} == "-h" || ${1} == "--help" ]]; then
  echo "This script starts the fusionauth-app service, which contains the entire FusionAuth product."
  echo ""
  echo "Usage:"
  echo "  start.sh [options]"
  echo ""
  echo "OPTIONS:"
  echo "  --debug    Start FusionAuth in debug mode (mostly used by the FusionAuth dev team)"
  echo "  --help     Display this message"
  exit 0
fi

# Magic sauce
SOURCE="${BASH_SOURCE[0]}"
while [[ -h ${SOURCE} ]]; do # resolve $SOURCE until the file is no longer a symlink
  SCRIPT_DIR="$(cd -P "$(dirname "${SOURCE}")" >/dev/null && pwd)"
  SOURCE="$(readlink "${SOURCE}")"
  [[ ${SOURCE} != /* ]] && SOURCE="${SCRIPT_DIR}/${SOURCE}" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
SCRIPT_DIR="$(cd -P "$(dirname "${SOURCE}")" > /dev/null && pwd)"
cd "${SCRIPT_DIR}/../.."
BASE_DIR=$(pwd)
cd fusionauth-app
APP_DIR=$(pwd)
CONFIG_DIR=${BASE_DIR}/config
DATA_DIR=${BASE_DIR}/data
JAVA_DIR=${BASE_DIR}/java
LOG_DIR=${BASE_DIR}/logs
PLUGIN_DIR=${BASE_DIR}/plugins
MARKER="fusionAuthApp87AFBG16"
OS=$(uname -s)

JAVA_OPTS=" -Dfusionauth.home.directory=${APP_DIR} -Dfusionauth.config.directory=${CONFIG_DIR} -Dfusionauth.data.directory=${DATA_DIR} -Dfusionauth.log.directory=${LOG_DIR} -Dfusionauth.plugin.directory=${PLUGIN_DIR} -Djava.awt.headless=true -Dcom.sun.org.apache.xml.internal.security.ignoreLineBreaks=true --add-exports=java.base/sun.security.x509=ALL-UNNAMED --add-exports=java.base/sun.security.util=ALL-UNNAMED --add-opens=java.base/java.net=ALL-UNNAMED -D${MARKER}"
JAVA_OPTS=$(echo "${JAVA_OPTS}" | tr -d '\r')

if [[ ! -d ${CONFIG_DIR} ]]; then
  mkdir "${CONFIG_DIR}"
fi

if [[ ! -d ${DATA_DIR} ]]; then
  mkdir "${DATA_DIR}"
fi

if [[ ! -d ${LOG_DIR} ]]; then
  mkdir "${LOG_DIR}"
fi

if [[ ! -d ${JAVA_DIR} ]]; then
  mkdir -p "${JAVA_DIR}"
fi

# If we are in a non interactive shell then hide the progress but show errors
CURL_OPTS="-fSL --progress-bar"
if ! tty -s; then
  CURL_OPTS="-sSL"
fi

# shellcheck disable=SC2034
downloadJava() {
  # Declare the version and the platform and arch dependent URLs
  JAVA_VERSION=17.0.8.1+1
  BASE_URL_PATH=https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.8.1%2B1/
  Linux_aarch64_Filename=OpenJDK17U-jdk_aarch64_linux_hotspot_17.0.8.1_1.tar.gz
  Linux_x86_64_Filename=OpenJDK17U-jdk_x64_linux_hotspot_17.0.8.1_1.tar.gz
  Darwin_x86_64_Filename=OpenJDK17U-jdk_x64_mac_hotspot_17.0.8.1_1.tar.gz
  Darwin_arm64_Filename=OpenJDK17U-jdk_aarch64_mac_hotspot_17.0.8.1_1.tar.gz

  # Build a the URL
  ARCH=$(uname -m)
  FILENAME="${OS}_${ARCH}_Filename"
  DOWNLOAD_URL="${BASE_URL_PATH}${!FILENAME}"

  # Ensure both the 'current' and 'jdk-${JAVA_VERSION}' exist, this tells us Java is setup and at the correct version
  if [[ ! -e "${JAVA_DIR}/current" || ! -d "${JAVA_DIR}/jdk-${JAVA_VERSION}" ]]; then
    if [[ ${OS} == "Darwin" ]]; then
      if [[ -e ~/dev/java/current17 ]]; then
        # Development, just sym link to our current version of Java, because only 'current' will exist in dev, we'll always rebuild the symlink.
        cd "${JAVA_DIR}"
        rm -f current
        # Use the same version that we'll be packaging with Docker during development
        ln -s ~/dev/java/current17-jlinked current
      else
        curl ${CURL_OPTS} "${DOWNLOAD_URL}" -o "${JAVA_DIR}/openjdk-macos-${JAVA_VERSION}.tar.gz"
        tar xfz "${JAVA_DIR}/openjdk-macos-${JAVA_VERSION}.tar.gz" -C "${JAVA_DIR}"
        cd "${JAVA_DIR}"
        rm -f current
        ln -s jdk-${JAVA_VERSION}/Contents/Home current
        rm openjdk-macos-${JAVA_VERSION}.tar.gz
      fi
    elif [[ ${OS} == "Linux" ]]; then
      curl ${CURL_OPTS} "${DOWNLOAD_URL}" -o "${JAVA_DIR}/openjdk-linux-${JAVA_VERSION}.tar.gz"
      tar xfz "${JAVA_DIR}/openjdk-linux-${JAVA_VERSION}.tar.gz" -C "${JAVA_DIR}"
      cd "${JAVA_DIR}"
      rm -f current
      ln -s jdk-${JAVA_VERSION} current
      rm openjdk-linux-${JAVA_VERSION}.tar.gz
    fi
  fi
}

appendToVariable() {
  local varName=$1
  local value=$2
  if [[ -n ${!varName} ]]; then
    export "${varName}"="${!varName} ${value}"
  else
    export "${varName}"="${value}"
  fi
}

# Arguments are: (envVarName, cmdOption, oldName, newName, oldEnvName, newEnvName)
resolveConfigurationProperty() {
  local envVarName=$1
  local cmdOption=$2
  local oldName=$3
  local newName=$4
  local oldEnvName=$5
  local newEnvName=$6

  if [[ -n ${!newEnvName} ]]; then
    appendToVariable "${envVarName}" "${cmdOption}${!newEnvName}"
    return
  elif [[ -n ${oldEnvName} && -n ${!oldEnvName} ]]; then
    echo "You are using a deprecated environment variable of [${oldEnvName}]. The new variable name is [${newEnvName}]"
    appendToVariable "${envVarName}" "${cmdOption}${!oldEnvName}"
    return
  elif [[ -f "${CONFIG_DIR}/fusionauth.properties" ]]; then
    if [[ -n ${newName} ]]; then
      newValue=$(grep "^${newName//[.]/\.}" "${CONFIG_DIR}/fusionauth.properties" | tr -d '\r' | cut -d'=' -f2-)
      if [[ -n ${newValue} ]]; then
        appendToVariable "${envVarName}" "${cmdOption}${newValue}"
        return
      fi
    fi
    if [[ -n ${oldName} ]]; then
      oldValue=$(grep "^${oldName//[.]/\.}" "${CONFIG_DIR}/fusionauth.properties" | tr -d '\r' | cut -d'=' -f2-)
      if [[ -n ${oldValue} ]]; then
        echo "You are using a deprecated configuration property of [${oldName}] in [fusionauth.properties]. The new variable name is [${newName}]"
        appendToVariable "${envVarName}" "${cmdOption}${oldValue}"
        return
      fi
    fi
  fi
}

# Download Java if necessary
if [[ ${FUSIONAUTH_USE_GLOBAL_JAVA} != 1 ]]; then
  downloadJava

  # Set JAVA_HOME
  JAVA_HOME=${JAVA_DIR}/current
fi

# The following SHA-1 algorithms were removed in Java 17. If clients want to use them, it is up to them.
# https://github.com/FusionAuth/fusionauth-site/issues/1202
if [[ ${OS} == "Darwin" ]]; then
  sed -i '' -E '/^.*disallowAlg.*xmldsig.*$/d' "${JAVA_HOME}/conf/security/java.security"
else
  sed -i -E '/^.*disallowAlg.*xmldsig.*$/d' "${JAVA_HOME}/conf/security/java.security"
fi

resolveConfigurationProperty JAVA_OPTS -Xmx "" fusionauth-app.memory FUSIONAUTH_MEMORY FUSIONAUTH_APP_MEMORY
resolveConfigurationProperty JAVA_OPTS -Xms "" fusionauth-app.memory FUSIONAUTH_MEMORY FUSIONAUTH_APP_MEMORY
resolveConfigurationProperty JAVA_OPTS "" "" fusionauth-app.additional-java-args FUSIONAUTH_ADDITIONAL_JAVA_ARGS FUSIONAUTH_APP_ADDITIONAL_JAVA_ARGS

# Start it up
echo "Starting fusionauth-app..."
echo "  --> Logging to ${LOG_DIR}/fusionauth-app.log"
cd "${APP_DIR}"

CLASSPATH=""
for file in lib/*; do
  CLASSPATH=${CLASSPATH}:${file}
done
CLASSPATH=${CLASSPATH:1}

if [[ ${1} == "--debug" ]]; then
  echo "Starting with debug enabled"
  JPDA_ADDRESS=${JPDA_ADDRESS:-5005}
  JPDA_SUSPEND=${JPDA_SUSPEND:-n}
  JAVA_OPTS="${JAVA_OPTS} -agentlib:jdwp=transport=dt_socket,server=y,suspend=${JPDA_SUSPEND},address=*:${JPDA_ADDRESS}"
fi

# shellcheck disable=SC2086
exec "${JAVA_HOME}/bin/java" -cp "${CLASSPATH}" ${JAVA_OPTS} io.fusionauth.app.FusionAuthMain <&- >> "${LOG_DIR}/fusionauth-app.log" 2>&1
