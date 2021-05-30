#!/bin/bash

# Hestia Control Panel upgrade script for target version 1.4.2

#######################################################################################
#######                      Place additional commands below.                   #######
#######################################################################################

# Optimize loading firewall rules
if [ "$FIREWALL_SYSTEM" = "iptables" ]; then
    echo "[ * ] Fix the issue of loading firewall rules..."
    # stop firewall then delete the rules so all rules are missing then regenerate them
    $BIN/v-stop-firewall
    rm -f /etc/iptables.rules
    rm -f /usr/lib/networkd-dispatcher/routable.d/50-ifup-hooks /etc/network/if-pre-up.d/iptables
    $BIN/v-update-firewall
    $BIN/v-stop-firewall
    $BIN/v-update-firewall
fi
