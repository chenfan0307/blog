#!/bin/bash
# install zabbix_proxy

if [ -d "/usr/local/zabbix/" ];then
    echo "zabbix is install"
    exit 1
else
    echo "zabbix in not install"
fi

my_gcc=`rpm -qa gcc`
if [[ -n "$my_gcc" ]];then
    echo "$my_gcc"
else
    yum -y install gcc
fi

my_gcc_c=`rpm -qa gcc-c++`
if [[ -n "$my_gcc_c" ]];then
    echo "$my_gcc_c"
else
    yum -y install gcc-c++
fi

mysql_devel=`rpm -qa mysql-devel`
if [[ -n "$mysql_devel" ]];then
    echo "$mysql_devel"
else
    yum install mysql-devel -y
fi

snmp_devel=`rpm -qa net-snmp-devel`
if [[ -n "$snmp_devel" ]];then
    echo "$snmp_devel"
else
    yum install net-snmp-devel -y
fi

libxml2_devel=`rpm -qa libxml2-devel`
if [[ -n "$libxml2_devel" ]];then
    echo "$libxml2_devel"
else
    yum install libxml2-devel -y
fi

libcurl=`rpm -qa libcurl-devel`
if [[ -n "$libcurl" ]];then
    echo "$libcurl"
else
    yum install libcurl-devel -y
fi

rpm -qa | grep wget
[ $? -ne 0 ] && yum install wget 

useradd -M -s /sbin/nologin
wget -c  https://jaist.dl.sourceforge.net/project/zabbix/ZABBIX%20Latest%20Stable/3.4.10/zabbix-3.4.10.tar.gz -P /usr/local/src/
tar -zxvf /usr/local/src/zabbix-3.4.10.tar.gz
cd /usr/local/src/zabbix-3.4.10
./configure --prefix=/usr/local/zabbix --enable-proxy --enable-agent --with-mysql --with-net-snmp --with-libcurl --with-libxml2
make 
make install


