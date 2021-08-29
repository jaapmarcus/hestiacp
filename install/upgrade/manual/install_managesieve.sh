#!/bin/bash
# info: Install managesieve for dovecot 
# Set up roudcube for using managesieve
# For external use open port 4190 to the public

source /etc/profile
source /usr/local/hestia/conf/hestia.conf 

check="0"
if [ "$IMAP_SYSTEM" = "dovecot" ]; then 
  echo "[ * ] Check Dovecot is installed"
else
  echo "[ ! ] No install of dovecot found"
  check="1"
fi

if [ -f "/etc/dovecot/conf.d/90-sieve.conf" ]; then 
  echo "[ ! ] 90-sieve.conf allready exists unable to install sieve if allready exists"
  check="1"
fi

if [ -f "/etc/dovecot/conf.d/20-lmtp.conf" ]; then 
  echo "[ ! ] 20-lmtp.conf allready exists unable to install sieve if allready exists"
  check="1"
fi

if [ -f "/etc/dovecot/conf.d/20-managesieve.conf" ]; then 
  echo "[ ! ] 20-managesieve.conf allready exists unable to install sieve if allready exists"
  check="1"
fi

echo ""
if [[ "$check" = 1 ]]; then
 echo "Unable to install manage sieve"
 exit 1;
fi

# Install extra packages for sieve support
apt install  dovecot-lmtpd dovecot-managesieved dovecot-sieve
# Remove lda.conf
rm -f /etc/dovecot/conf.d/15-lda.conf

cp -f $HESTIA/install/deb/dovecot-sieve/conf.d/* /etc/dovecot/conf.d/
sed -i  "s/transport = local_delivery/transport = dovecot_lmtp/g" /etc/exim4/exim4.conf.template

## dovecot_lmtp
insert='dovecot_lmtp:\n\  driver = lmtp\n\  socket = /var/run/dovecot/lmtp\n\  batch_max = 200\n\  rcpt_include_affixes\n\  delivery_date_add\n\  envelope_to_add\n\  return_path_add\n'

#insert=$(sed 's/^//g; s/\\n/\\n/g; s/.$//' <<< $insert)

line=$(expr $(sed -n '/begin transports/=' /etc/exim4/exim4.conf.template) + 2)
sed -i "${line}i $insert" /etc/exim4/exim4.conf.template
  
 mkdir -p /etc/dovecot/sieve
 touch /etc/dovecot/sieve/before.sieve
 touch /etc/dovecot/sieve/after.sieve
  
echo 'require ["fileinto", "regex", "date", "relational", "vacation", "imap4flags", "envelope", "subaddress", "copy", "reject"];' > /etc/dovecot/sieve/default.sieve
echo '' >> /etc/dovecot/sieve/default.sieve
echo '# rule:[Spam Filter]' >> /etc/dovecot/sieve/default.sieve
echo 'if anyof (header :contains "X-Spam-Flag" "YES", header :contains "X-Spam" "Yes") {' >> /etc/dovecot/sieve/default.sieve                                                                                 
echo '  fileinto "Junk";' >> /etc/dovecot/sieve/default.sieve
echo '  stop;' >> /etc/dovecot/sieve/default.sieve
echo '} "' >> /etc/dovecot/sieve/default.sieve

mkdir -p /etc/roundcube/plugins/managesieve/

echo "<?php"  >>  /etc/roundcube/plugins/managesieve/config.inc.php
echo "// Dovecot managedsieve TCP port" >>  /etc/roundcube/plugins/managesieve/config.inc.php
echo "\$rcmail_config['managesieve_port'] = 4190;"  >>  /etc/roundcube/plugins/managesieve/config.inc.php
echo "// Default contents of filters script (eg. default spam filter)" >>  /etc/roundcube/plugins/managesieve/config.inc.php
echo "\$rcmail_config['managesieve_default'] = '/etc/dovecot/sieve/default.sieve';" >> /etc/roundcube/plugins/managesieve/config.inc.php

ln -s /etc/roundcube/plugins/managesieve/config.inc.php /var/lib/roundcube/plugins/managesieve/config.inc.php
sed -i "s/'password'/'password','managesieve'/g" /etc/roundcube/config.inc.php