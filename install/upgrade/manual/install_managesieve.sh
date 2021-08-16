#!/bin/bash
# info: Install managesieve for dovecot 
# Set up roudcube for using managesieve
# For external use open port 4190 to the public

source /etc/profile
source /usr/local/hestia/conf/hesita.conf

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
	echo "[ ! ] 20-managesieve.conf	 allready exists unable to install sieve if allready exists"
	check="1"
fi

if [ "$check" = 1 ]; fi 
	echo "Unable to install manage sieve"
fi

# Install extra package
apt install  dovecot-lmtpd dovecot-managesieved dovecot-sieve 

#todo create sed script 
replace "#lda_mailbox_autocreate = no" lda_mailbox_autocreate = yes  /etc/dovecot/conf.d/15-lda.conf
replace "#lda_mailbox_autosubscribe = no" lda_mailbox_autosubscribe = yes  /etc/dovecot/conf.d/15-lda.conf


add: transport = dovecot_lmtp
and 
sed "dovecot_lmtp:
  driver = lmtp
  socket = /var/run/dovecot/lmtp
  batch_max = 200
  rcpt_include_affixes
  delivery_date_add
  envelope_to_add
  return_path_add"
  
  to  /etc/exim4/exim4.conf.template
  
  
  
  
  mkdir /etc/dovecot/sieve
  touch /etc/dovecot/sieve/before.sieve
  touch /etc/dovecot/sieve/after.sieve
  
  echo 'require ["fileinto", "regex", "date", "relational", "vacation", "imap4flags", "envelope", "subaddress", "copy", "reject"];' > /etc/dovecot/sieve
  echo '' > /etc/dovecot/sieve
  echo '# rule:[Spam Filter]' > /etc/dovecot/sieve
  echo 'if anyof (header :contains "X-Spam-Flag" "YES", header :contains "X-Spam" "Yes") {' > /etc/dovecot/sieve                                                                                    
  echo '  fileinto "Junk";' > /etc/dovecot/sieve
  echo '  stop;' /etc/dovecot/sieve
  echo '} "' > /etc/dovecot/sieve