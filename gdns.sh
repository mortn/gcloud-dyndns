#!/bin/bash
# vim: set ts=4:ss=4
# File: /usr/local/bin/gdns.sh
# Google Cloud DNS dynamic IP updater for installation on my Linux router/gw
# Depends on gcloud being installed and configured (https://cloud.google.com/sdk/docs/quickstarts)
set -e

project=my-google-project
zoneid=example-com
zone=example.com
arec=www2.$zone

# Quick+solid way to get current WAN IP, but this doens't work 
# if traffic is routed+NAT'ed through another gateway
myip=$(dig +short myip.opendns.com @resolver1.opendns.com)

# Fetch ipv4 address from interface named "wan". This is where the A record should point.
ifip=$(ip -4 -o a s wan | sed 's/.*inet \(.*\)\/.*$/\1/')

# Fetch current A record fast
curarec=$(dig +short $arec|head -1)

if [ "$curarec" != "$ifip" ]; then
    logger "Current record $curarec seems different from IF IP $ifip"
    GDNS="/usr/bin/gcloud dns --project=$project record-sets transaction"
    $GDNS start -z $zoneid
    if $(dig +noall +answer $arec|head -1|grep -wq "A") ; then
        echo "Remove existing A record"
        $GDNS remove --name=$arec. --ttl=300 --type=A $curarec -z $zoneid
    fi
    $GDNS add --name=$arec. --ttl=300 --type=A $ifip -z $zoneid
    $GDNS execute -z $zoneid
else
    logger "Current record $curarec equals $ifip"
fi
