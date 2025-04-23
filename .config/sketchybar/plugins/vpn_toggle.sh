#!/bin/sh

source "$CONFIG_DIR/config/colors.sh"

function cisco_connect() {
  CON_STR="connect \"vpn-robinson.plusline.de\"\n\nmschneider\n$(/usr/bin/security find-generic-password -w -a "vpn-robinson.plusline.de" -s mschneider)\n"

  echo $CON_STR | /opt/cisco/secureclient/bin/vpn -s
}

sketchybar --set vpn_status icon="" icon.color="$COLOR_WARNING"

STATUS="$(/opt/cisco/secureclient/bin/vpn state | grep 'Connected')"
if [[ "$STATUS" != "" ]]; then
  /opt/cisco/secureclient/bin/vpn disconnect
else
  cisco_connect
fi
