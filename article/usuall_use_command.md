# 个人常用命令

```
hostnamectl --static set-hostname devops

yum install bash-completion ntp

cat test.tgz | ssh test 'tar -xzf - -C /data/'

cat nginx.conf | egrep -v "#|^$" >> nginx.conf

awk -F "/"  '{print $3}' chenfan | sort | uniq -c|sort -rn

awk -F "/" '{++S[$3]} END {for (key in S) print key,S[$key]}' chenfan|sort -rn 

netstat -antp '/^tcp/ {++S[$NF]} END{for (key in S) print S[$key],key}'

netstat -anlp | grep 80 | grep tcp|awk '{print $5}' | awk -F: '{print $1}' |sort|uniq -c |sort -rn|head -20

清理redis热缓存  6179-非持久缓存   6180-持久缓存  #只需要在cacheo1上执行即可

/usr/local/redis/bin/redis-cli -p 6179 -a password KEYS "course_info_*"|xargs /usr/local/redis/bin/redis-cli -p 6179 -a password DEL

pkill -9 -t pts/1

localectl set-locale LANG=字符集

journalctl 是查看/var/log/message的日志

journalctl -f = tailf /var/log/message
查看指定服务所产生的日志
journalctl -u filewarld.service 

防止日志输出内容太多导致rsyslog丢失日志
echo "$SystemLogRateLimitInterval 60" >> /etc/rsyslog.conf
echo "$SystemLogRateLimitBurst 3000" >> /etc/rsyslog.conf

提供临时下载
nc -l 10083 </data/sofware/bind.tgz
wget http://192.168.1.242:10083/bind.tgz

在远程主机上执行一段脚本
ssh user@server bash </path/to/local/script.sh

测试硬盘得到读写
写：time dd if=/dev/zero of=/data/test2 bs=1024 count=500

读：time dd if=/data/test2 of=/dev/null

lsof -i:80 | grep -v "ID" | awk '{print "kill -9", $2}' |sh

ps -ef | awk '{if($2 == "Z"){print $4}}' | kill -9

ping www.baidu.com | awk '{print $0 "\t" strftime("%Y-%m-%d %H:%M:%S", systime())}' >>/tmp/a.log &


wget -p /data/to/directory https://path.to.the/file
```

```
whatis command # 简要命令说明
wahtis -w command # 正则匹配
info command # 详细文档
```

```
paste文本拼接

echo colin > file1
echo 1 > file2
paste file2 file1 -d ", "
 output -> 1, colin 
```


### losf

```
 * -a  列出打开文件存在的进程
 * -c  列出指定进程所打开的文件
 * -g  列出GID进程详情
 * -i  列出符合条件的进程
 * -p  列出指定进程号打开的文件

- tips1 查找文件相关的进程

lsof /bin/bash

- tips2 列出某程序进程所打开的文件信息

lsof -c docker

- tips3 列出某个用户以及某个进程打开的文件信息

lsof -u chenfan -c docker

- tips4 列出所有的网络连接

lsof -i "tcp|udp" 

- tips5 列出谁在使用某个端口

lsof -i:3306
```

```
du -sh * /etc | sort -rn | head -n 10

mpstat 5 5 判断cpu负载 检查%idle是否小于5%
```

### iostat

iostat -mx 1 5  检查磁盘i/o的使用率(%util)是否超过100%


### vmstat



### sar

```
sar -q -f /var/log/sa/sa12 -s 05:00:00 -e 12:00:00
```

`BASH快捷输入或删除`
```
ctrl -u 删除光标到行首的所有字符，删除全行
ctrl -w 删除当前光标到前面的最近一个空格之间的字符
ctrl -h 删除光标前边的字符
ctrl -r 匹配最近的一个文件，然后输出
```
