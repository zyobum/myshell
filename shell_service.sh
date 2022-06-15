#!/bin/bash

set -e

PATH=/opt/homebrew/bin:/usr/sbin:$PATH

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
    echo "Mount devices: $MOUNTDEV"
    date > $OUT
    $MOUNTDEV &> $OUT
  fi
  sleep 2
done
