#!/bin/bash

set -e

PATH=opt/homwbrew/bin:$PATH
DEFHOME=$HOME/.lima/default
QMPSOCK=$DEFHOME/qmp.sock
QMPPORT="UNIX-CONNECT:$QMPSOCK"

if [ ! -w $QMPSOCK ]; then
    "Socket not found: $QMPSOCK"
    exit 1
fi

#Commands
#capabilities negotiation
CMD_NEGO='{ "execute": "qmp_capabilities" }'
CMD_MOUNT_RD4='{"execute":"device_add", "arguments":{"driver":"usb-host", "bus":"usb-bus.0", "vendorid":"0x9ac4","productid":"0x4b8f"}}'

echo "Mounting devices..."
echo -e "${CMD_NEGO}\n${CMD_MOUNT_RD4}" | socat - $QMPPORT

echo "Mount finished"

