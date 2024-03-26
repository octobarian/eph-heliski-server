#!/usr/bin/env bash

#
# Copyright (c) 2022, FusionAuth, All Rights Reserved
#
set -e

# Spit out some help
if [[ ${1} == "-h" || ${1} == "--help" ]]; then
  echo "This script shuts down all running FusionAuth processes on the current machine."
  echo ""
  echo "Usage:"
  echo "  shutdown.sh [options]"
  echo ""
  echo "OPTIONS:"
  echo "  --help    Display this message"
  exit 0
fi

echo "Stopping all running FusionAuth processes... "
if pgrep -f "java.*fusionauth" > /dev/null 2>&1; then
  if ! pkill -f "java.*fusionauth" > /dev/null 2>&1; then
    echo "Failed to stop FusionAuth processes."
  fi
fi

echo "Done"
