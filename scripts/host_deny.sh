#!/bin/bash
# This script for ossec to deny host 
# crontab -e " */10 * * * * /var/ossec/active/bin/deny_host.sh > /dev/null 2>&1 "

cat /var/log/secure | awk '/Failed/{print $(NF-3)}' | sort | uniq -c | awk '{print $1, $2}' > /tmp/ip.txt

for i in `cat /tmp/ip.txt | awk '{if($1>=6){print $2}}'`; do
	grep $i /etc/hosts.deny > /dev/null
	if [ $? -eq 0 ]; then
		 echo "OK" > /dev/null
	else
		echo "sshd:$i:deny" >> /etc/hosts.deny
		iptables -I INPUT -p all -s $i -j DROP; sleep 1
	fi
done
