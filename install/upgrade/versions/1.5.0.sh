#!/bin/bash

# Hestia Control Panel upgrade script for target version 1.4.0

#######################################################################################
#######                      Place additional commands below.                   #######
#######################################################################################

# Enhance Vsftpd security
if [ "$FTP_SYSTEM" = "vsftpd" ]; then
    echo "[ ! ] Hardening Vsftpd TLS configuration..."
    if [ -e /etc/vsftpd.conf ]; then
        rm -f /etc/vsftpd.conf
    fi
    cp -f $HESTIA_INSTALL_DIR/vsftpd/vsftpd.conf /etc/
    chmod 644 /etc/vsftpd.conf
fi

# Migrate the system SFTP jail
echo "[ ! ] Migrating SFTP Chroot Jail..."
if grep -q '^# Hestia SFTP Chroot' /etc/ssh/sshd_config; then
    $BIN/v-delete-sys-sftp-jail
    $BIN/v-add-sys-sftp-jail
else
    rm -f /etc/cron.d/hestia-sftp
fi

# Migrate existing users to SFTP / FTP jail
echo "[ ! ] Migrating users to SFTP / FTP Jail..."
add_chroot_jail admin
for user in $(getent group hestia-users | cut -f 4 -d : | tr ',' ' '); do
    add_chroot_jail $user
done