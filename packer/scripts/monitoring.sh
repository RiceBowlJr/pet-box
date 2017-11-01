#!/bin/bash

#--[ Environment variables ]----------------------------------------------------
NETDATA_API_KEY=$2
NETDATA_MASTER_IP=$3

#--[ Netdata Slave/Master ]-----------------------------------------------------
curl -Ss https://my-netdata.io/kickstart-static64.sh
bash kickstart-static64.sh
if [ "$1" == "slave" ]
then
  cp /tmp/stream.conf-slave /opt/netdata/etc/netdata/stream.conf
  cp /tmp/netdata.conf-slave /opt/netdata/etc/netdata/netdata.conf
  sed -e --in-place "s/change-me-api-key/$NETDATA_API_KEY/d" /opt/netdata/etc/netdata/stream.conf
  sed -e --in-place "s/change-me-master-ip/$NETDATA_MASTER_IP/d" /opt/netdata/etc/netdata/stream.conf
elif [ "$1" == "master" ]
then
  cp /tmp/stream.conf-master /opt/netdata/etc/netdata/stream.conf
  sed -e --in-place "s/change-me-api-key/$NETDATA_API_KEY/d" /opt/netdata/etc/netdata/stream.conf
else
  printf "\n\n\tYou have entered a wrong argument, use 'slave' or 'master' instead of $1\n\n"
fi

#--[ Caddy Reverse proxy for Master NetData ]-----------------------------------
if [ "$1" == "master" ]
then
  mkdir -p /etc/caddy /etc/ssl/caddy
  chown www-data /etc/caddy /etc/ssl/caddy
  curl -Ss https://getcaddy.com > /tmp/caddy.sh
  bash /tmp/caddy.sh personal
  mv /tmp/Caddyfile /etc/caddy/
  mv /tmp/caddy.service /etc/systemd/system/
fi
