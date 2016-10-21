#!/bin/sh
run-parts -a save /usr/share/netfilter-persistent/plugins.d
run-parts -a flush /usr/share/netfilter-persistent/plugins.d
certbot renew --quiet 
run-parts -a start /usr/share/netfilter-persistent/plugins.d
openssl pkcs12 -passout file:/root/jenkins-ssl-pass -export -in /etc/letsencrypt/live/ci.commonwl.org/fullchain.pem -inkey /etc/letsencrypt/live/ci.commonwl.org/privkey.pem -out /etc/letsencrypt/live/pkcs12 -name ci.commonwl.org
keytool -noprompt -importkeystore -deststorepass `cat /root/jenkins-ssl-pass` -destkeypass `cat /root/jenkins-ssl-pass` -destkeystore /etc/letsencrypt/live/ci.commonwl.org/keystore -srckeystore /etc/letsencrypt/live/pkcs12 -srcstoretype PKCS12 -srcstorepass `cat /root/jenkins-ssl-pass` -alias ci.commonwl.org 2>&1 | grep -v 'Warning: Overwriting existing alias ci.commonwl.org in destination keystore'
service jenkins restart

