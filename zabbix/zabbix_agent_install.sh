#!/bin/bash
# zabbix agent 

# yum install agent
zabbix-agent=`rpm -qa | grep zabbix-agent`
[ ${zabbix-agent} -ne 0 ] && rpm -ivh http://repo.zabbix.com/zabbix/3.4/rhel/7/x86_64/zabbix-release-3.4-2.el7.noarch.rpm; yum install zabbix-agent -y || echo "zabbix-agent have install now"

# input ip and hostname for zabbix-agent
mv /etc/zabbix/zabbix_agentd.conf{,.bak}
read -p "pls input (zabbix-server|zabbix-proxy) ip:" ip
# read -p "pls input zabbix-agent hostname:" name


echo -e "PidFile=/var/run/zabbix/zabbix_agentd.pid
LogFile=/var/log/zabbix/zabbix_agentd.log
LogFileSize=0
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

# start zabbix-agent
setfacl -m u:zabbix:rwx /var/run/zabbix
systemctl start zabix-agent; systemctl enable zabbix-agent

# app status and elstablished
echo -e "
#!/bin/bash
# this script is for monitor app
port=$1
# 判断系统是否存在某端口
state_mon() {
# netstat -natup | grep $1
netstat -natup | grep "$port" | awk '{print $4}'|awk -F: '{print $2}'| grep "$port" | tail
-1
}
# 过滤统计系统建立连接状态数
state_estab() {
netstat -natup | grep ":$port" | grep ESTABLISHED | wc -l
}
$2">/etc/zabbix/zabbix_agentd.d/appestab_monitory.sh

chmod 755 /etc/zabbix/zabbix_agentd.d/appestab_monitory.sh

echo -e "
# ./app_monitory.sh state_estab 3306 [mysql建立established连接数]
# ./app_monitory.sh state_mon 3306 [判断是否开启3306端口]
UserParameter=app.status[*],/etc/zabbix/zabbix_agentd.d/appestab_monitory.sh $1 $2">/etc/zabbix/zabbix_agentd.d/app_monitory.conf
