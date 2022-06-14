#!/bin/bash

PATH=/opt/homebrew/bin:/usr/sbin:$PATH

STATUS=""

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
  fi
  sleep 2
done
