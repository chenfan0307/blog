#!/bin/bash
# auto install zabbix agent 
# ansible all -m copy -a "src=/tmp/auto_install_zabbix_agent.sh dest=/tmp/auto_install_zabbix_agent.sh mode=0755"
# ansible all -m shell -a "sh -x /tmp/auto_install_zabbix_agent.sh"

# yum install agent
# zabbix-agent=`rpm -qa | grep zabbix-agent`
# [ ${zabbix-agent} -ge 0 ] && echo "[zabbix]
# name=Zabbix Official Repository - $basearch
# baseurl=http://repo.zabbix.com/zabbix/3.4/rhel/7/$basearch/
# enabled=1
# gpgcheck=1
# gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-ZABBIX-A14FE591

# name=Zabbix Official Repository non-supported - $basearch 
# baseurl=http://repo.zabbix.com/non-supported/rhel/7/$basearch/
# enabled=1
# gpgkey=file:///etc/pki/rpm-gpg/RPM-GPG-KEY-ZABBIX
# gpgcheck=1"> /etc/yum.repos.d/zabbix.repo;yum install zabbix-agent || echo "zabbix-agent have install now"
rpm -qa | grep zabbix-agent

if [ $? -eq 0]; then
	echo "Zabbix-agent have install"
else
	rpm -i https://mirrors.tuna.tsinghua.edu.cn/zabbix/zabbix/3.4/rhel/7/x86_64/zabbix-agent-3.4.11-1.el7.x86_64.rpm
	yum install zabbix-agent-3.4.11-1.el7.x86_64.rpm -y
fi

mv /etc/zabbix/zabbix_agentd.conf{,.bak}
# read -p "pls input (zabbix-server|zabbix-proxy) ip:" ip
# read -p "pls input zabbix-agent hostname:" name

grep system.uname /etc/zabbix/zabbix_agentd.conf

if [ $? -eq 0 ]; then
	echo "The configuration file exists"
else
	echo -e "PidFile=/var/run/zabbix/zabbix_agentd.pid
LogFile=/var/log/zabbix/zabbix_agentd.log
LogFileSize=0
Timeout=30
Server=****
ServerActive=****
Hostname=`hostname`
HostMetadataItem=system.uname
EnableRemoteCommands=0
Include=/etc/zabbix/zabbix_agentd.d/*.conf
UnsafeUserParameters=1" >/etc/zabbix/zabbix_agentd.conf
fi

# wget agent.tgz 
wget -c https://raw.githubusercontent.com/chenfan0307/blog/master/zabbix/zabbix-agent.tgz 

tar zxf zabbix-agent.tgz -C /etc/zabbix/zabbix_agentd.d; rm -f zabbix-agent.tgz 

# bak /etc/sudoers
cp /etc/sudoers{,.bak$(date +%F-%H:%M:%S)}
grep 'zabbix' /etc/sudoers
[ $? -eq 0  ] || echo "zabbix  ALL=(root)    NOPASSWD:/usr/bin/docker,/usr/bin/python,/etc/zabbix/zabbix_agentd.d/docker_discover.py,/usr/sbin/ethtool" >> /etc/sudoers

# disabled firewalld and selinux
systemctl disable firewalld.service; systemctl stop firewalld.service
sed -i "7s#enforcing#disabled#" /etc/selinux/config

# start zabbix-agent
setfacl -m u:zabbix:rwx /var/run/zabbix
setfacl -m u:Zabbix:rwx /var/log/zabbix
systemctl start zabbix-agent; systemctl enable zabbix-agent

[ -f /etc/yum.repos.d/zabbix.repo ] && rm -f /etc/yum.repos.d/zabbix.repo
