#!/bin/zsh
source ~/.zshrc

#set -e
#trap 'handle_error $? $LINENO' EXIT
#handle_error() {
#  if [ "$1" != "0" ]; then
#    # error handling goes here
#    echo "Exit with error $1 occurred on $2"
#  fi
#}

INSHOME=$HOME/.lima/default

STATUS=""

check_status () {
  STATUS=$(limactl list default --json | jq .status)
  local t="STATUS=$STATUS"
  # remove double quote
  eval $t
}

wait_ssh_ready () {
  while true; do
    nc -z 127.0.0.1 60022 &> /dev/null
    if [ $? = 0 ]; then
      return 0
    fi
    sleep 2
  done
}

wait_instance_ready () {
  while true; do
    local ready=$(tail -n1 ~/.lima/default/ha.stdout.log | jq .status.running)
    if [ true = $ready ]; then
      return 0
    fi
    sleep 2
  done
}

check_status

if [ "Stopped" = $STATUS ]; then
  # restart it
  echo "Instance stopped. Starting instance"
  limactl start &
  disown
  sleep 1
fi

#echo "Wait for ssh ready"
wait_ssh_ready

#echo "Wait for instance ready"
wait_instance_ready

#echo "Starting shell"
lima

