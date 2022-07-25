#!/bin/bash

set -e
BREW_M1_PATH=/opt/homebrew/bin
BREW_X86_PATH=/usr/local/bin

if [ -d "$BREW_M1_PATH" ]; then
  BREW_PATH=$BREW_M1_PATH
else
  BREW_PATH=$BREW_X86_PATH
fi

PATH=$BREW_PATH:/usr/sbin:$PATH

STATUS=""

DEFHOME="$HOME/.lima/default"
QMP_SOCK="$DEFHOME/qmp.sock"
DIR="$(dirname "$0")"
MOUNTDEV="$DIR/mount_dev.sh"
OUT="/tmp/myshell_mount.out"

check_status () {
  STATUS=$(limactl list default --json | jq .status)
  local t="STATUS=$STATUS"
  # remove double quote
  eval $t
}


while true ; do
  check_status
  if [ "Stopped" = $STATUS ]; then
    # restart it
    echo "Instance stopped. Starting instance"
    limactl start
    #echo "Mount devices: $MOUNTDEV"
    #date > $OUT
    #$MOUNTDEV &> $OUT
  fi
  sleep 2
done
