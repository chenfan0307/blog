#!/bin/bash
# zabbix agent 

# yum install agent
zabbix-agent=`rpm -qa | grep zabbix-agent`
[ $? -ne 0 ] && rpm -ivh http://repo.zabbix.com/zabbix/3.4/rhel/7/x86_64/zabbix-release-3.4-2.el7.noarch.rpm; yum install zabbix-agent -y || echo "zabbix-agent have install now"

# input ip and hostname for zabbix-agent
mv /etc/zabbix/zabbix_agentd.conf{,.bak}
read -p "pls input (zabbix-server|zabbix-proxy) ip:" ip
# read -p "pls input zabbix-agent hostname:" name


echo -e "PidFile=/var/run/zabbix/zabbix_agentd.pid
LogFile=/var/log/zabbix/zabbix_agentd.log
LogFileSize=0
Timeout=25
Server=$ip
ServerActive=$ip
Hostname=`hostname`
HostMetadataItem=system.uname
EnableRemoteCommands=0
Include=/etc/zabbix/zabbix_agentd.d/*.conf
UnsafeUserParameters=1" >/etc/zabbix/zabbix_agentd.conf

# disabled firewalld
systemctl disable firewalld.service; systemctl stop firewalld.service
sed -i "7s#enforcing#disabled#" /etc/selinux/config

# install pip for docker_status
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
python get-pip.py
pip install docker simplejson 

# wget angentd.tagz for monitory
touch /tmp/docker_status.log
chmod 766 /tmp/docker_status.log
# wget -c https://github.com/chenfan0307/blog/blob/master/zabbix/conf/zabbix-agentd.tar.gz -P /etc/zabbix/zabbix_agentd.d/
# cd /etc/zabbix/zabbix_agentd.d/
# tar zxf zabbix-agentd.tar.gz 

# back /etc/sudoers
cp /etc/sudoers{,.bak}
echo zabbix  ALL=\(root\)   NOPASSWD:/usr/bin/docker,/usr/bin/python,/etc/zabbix/zabbix_agentd.d/docker_discover.py >>/etc/sudoers

# start zabbix-agent
setfacl -m u:zabbix:rwx /var/run/zabbix
systemctl start zabix-agent; systemctl enable zabbix-agent


