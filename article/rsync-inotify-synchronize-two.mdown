# Rsync+inotify实现文件实时同步(二)

## Inotify

client:192.168.8.159 
server:192.168.8.157 

### Inotify概念
使用Rsync进行数据同步，只能满足对数据实时性要求不高的环境，即使使用计划任务也仅可以实现定期的数据同步。而且使用rsync在进行对数据同步前需要对所有的文件进行比对，然后进行差异数据同步。由于数据的变化随时都可能发生，如果多台主机之间要求当数据发生变化后进行实时同步，就需要结合Inotify工具,inotify为用户态应用程序提供了文件系统事件通知机制。所以Inotify可以实时了解文件系统发生的所有变化

### Inotify部署

部署在rsync client

#### 安装

```
[root@elk shell]# yum install automake libtool
[root@docker ~]# wget -r -nd -P soft/ http://github.com/downloads/rvoicilas/inotify-tools/inotify-tools-3.14.tar.gz
[root@docker inotify-tools]# tar zxf inotify-tools-3.14.tar.gz -C /opt
[root@docker inotify-tools] cd /opt/inotify-tools-3.14/;./configure
[root@docker inotify-tools] make && make install
```
#### 监控数据

inotify-tools 提供了2个应用程序，分别是inotifywait和inotifywatch

用法：
```
inotifywait [-hcmrq] [-e <event>] [-t <seconds>] [--format <fmt>] [--timefmt <fmt>] <file>...
```

#### Rsync 与 Inotify 双剑合璧

单一的rsync工具仅可以进行数据同步，单一的Inotify仅可以实现实时文件监控，2者的结合可以满足企业对数据中心实时数据同步的要求。

[Rsync参考](https://www.hafang.top/article/rsync-inotify-synchronize-one)


脚本如下
```
#!/bin/bash
# This rsync script based on inotify

SRC=/data/command
DEST=command
#Clinet1=192.168.8.157
Clinet2=192.168.8.157
User=chenfan
Passfile=/etc/rsync.pass
Logfile="/var/log/inotify_$(date +%Y%m%d)"
[ -e $Passfile ] || exit 2

# inotify
inotifywait -mrq --timefmt '%y-%m-%d %H:%M' --format '%T %w%f %e' \
--event modify,create,move,delete,attrib $SRC | while read line; do
echo "$line" > $Logfile 2>&1

# rsync
rsync -avzr --delete --progress --password-file=$Passfile $SRC \
${User}@{$Clinet2,$Clinet1}::$DEST >> $Logfile 2>&1
done &
```

报错：
服务端的目录属主属组不正确,报错如下：

```
sending incremental file list
command/
rsync: recv_generator: mkdir "command" (in command) failed: Permission denied (13)
*** Skipping any contents from this failed directory ***

sent 272 bytes  received 15 bytes  574.00 bytes/sec
total size is 360631  speedup is 1256.55
rsync error: some files/attrs were not transferred (see previous errors) (code 23) at main.c(1052) [sender=3.0.9]

```
解决办法
```
将client和server的目录权限修改一样 
chown -r nobody. files_name
setfacl -m u:nobody:rw file_name
```