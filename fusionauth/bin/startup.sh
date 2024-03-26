#!/usr/bin/env bash

#
# Copyright (c) 2022-2023, FusionAuth, All Rights Reserved
#
set -e

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
  OS=$(uname -s)
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

# Magic sauce
SOURCE="${BASH_SOURCE[0]}"
while [[ -h ${SOURCE} ]]; do # resolve $SOURCE until the file is no longer a symlink
  SCRIPT_DIR="$(cd -P "$(dirname "${SOURCE}")" >/dev/null && pwd)"
  SOURCE="$(readlink "${SOURCE}")"
  [[ ${SOURCE} != /* ]] && SOURCE="${SCRIPT_DIR}/${SOURCE}" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
SCRIPT_DIR="$(cd -P "$(dirname "${SOURCE}")" > /dev/null && pwd)"
cd "${SCRIPT_DIR}/.."
BASE_DIR=$(pwd)
JAVA_DIR=${BASE_DIR}/java
LOG_DIR=${BASE_DIR}/logs

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

# Spit out some help
if [[ ${1} == "-h" || ${1} == "--help" ]]; then
  echo "This script starts up the fusionauth-app service and optionally the fusionauth-search service. This is part of the FastPath install."
  echo ""
  echo "Usage:"
  echo "  startup.sh [options]"
  echo ""
  echo "OPTIONS:"
  echo "  --help    Display this message"
  exit 0
fi

# Download Java if necessary
if [[ ${FUSIONAUTH_USE_GLOBAL_JAVA} != 1 ]]; then
  downloadJava
fi

echo -e "Starting fusionauth-search ... \c"
if [[ -f ${BASE_DIR}/fusionauth-search/elasticsearch/bin/elasticsearch ]]; then
  if pgrep -f fusionAuthSearchEngine87AFBG16 > /dev/null; then
    echo "skipped, already running."
  else
    nohup "${BASE_DIR}/fusionauth-search/elasticsearch/bin/elasticsearch" <&- >> "${LOG_DIR}/fusionauth-search.log" 2>&1 &
    disown
    echo "done."
    echo "  --> Logging to ${LOG_DIR}/fusionauth-search.log"
  fi
else
  echo " skipped, not installed"
fi

echo -e "Starting fusionauth-app ... \c"
if [[ -f ${BASE_DIR}/fusionauth-app/bin/start.sh ]]; then
  if pgrep -f fusionAuthApp87AFBG16 > /dev/null; then
    echo "skipped, already running."
  else
    nohup "${BASE_DIR}/fusionauth-app/bin/start.sh" <&- >> "${LOG_DIR}/fusionauth-app.log" 2>&1 &
    disown
    echo "done."
    echo "  --> Logging to ${LOG_DIR}/fusionauth-app.log"
  fi
else
  echo " skipped, not installed"
fi
