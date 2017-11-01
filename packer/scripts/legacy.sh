#!/bin/bash

#--[ Environment variables ]----------------------------------------------------
EMBY_VERSION=3.2.35.0
TRANSMISSION_PASSWD=$1

#--[ Emby Server ]--------------------------------------------------------------
wget -O /tmp/emby-server-deb_{$EMBY_VERSION}_amd64.deb https://github.com/MediaBrowser/Emby/releases/download/3.2.35.0/emby-server-deb_{$EMBY_VERSION}_amd64.deb
dpkg -i /tmp/emby-server-deb_{$EMBY_VERSION}_amd64.deb && \
  printf "\n\nInstalling Emby Server ---------------------------------------------------[ OK ]\n"

#--[ Transmission Daemon ]------------------------------------------------------
apt-get install -y transmission-daemon
systemctl stop transmission-daemon.service
cp /tmp/transmission-settings.json /etc/transmission-daemon/settings.json
sed -e --in-place "s/change-me-at-boot/$TRANSMISSION_PASSWD/d" /etc/transmission-daemon/settings.json && printf "\n\nChanging transmission password -------------------------------------------[ OK ]\n"
systemctl start transmission-daemon.service
systemctl status transmission-daemon.service

#--[ Caddy Reverse proxy ]------------------------------------------------------
mkdir -p /etc/caddy /etc/ssl/caddy
chown www-data /etc/caddy /etc/ssl/caddy
curl -Ss https://getcaddy.com > /tmp/caddy.sh
bash /tmp/caddy.sh personal
cp /tmp/Caddyfile /etc/caddy/
cp /tmp/monitoring-files/caddy.service /etc/systemd/system/
cp /tmp/monitoring-files/caddy-sysvinit /etc/init.d/caddy && chmod u+x /etc/init.d/caddy
printf "\n\nInstalling Caddy Reverse Proxy -------------------------------------------[ OK ]\n"

