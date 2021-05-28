#!/bin/bash

# Hestia Control Panel upgrade script for target version 1.4.2

#######################################################################################
#######                      Place additional commands below.                   #######
#######################################################################################

if [ -f "/usr/lib/networkd-dispatcher/routable.d/50-ifup-hooks" ]; then
    echo "[ * ] Fix issues with Ubuntu 20.04 and Netplan"
    rm "/usr/lib/networkd-dispatcher/routable.d/50-ifup-hooks"
    $BIN/v-update-firewall
fi