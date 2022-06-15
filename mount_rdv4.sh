#!/bin/bash

DEFHOME=$HOME/.lima/default
QMPSOCK=$DEFHOME/qmp.sock
QMPPORT="UNIX-CONNECT:$QMPSOCK"
CMD_NEGO='{ "execute": "qmp_capabilities" }'
CMD_MOUNT_RD4='{"execute":"device_add", "arguments":{"driver":"usb-host", "bus":"usb-bus.0", "vendorid":"0x9ac4","productid":"0x4b8f"}}'
#capabilities negotiation
echo -e "${CMD_NEGO}\n${CMD_MOUNT_RD4}" | socat - $QMPPORT

