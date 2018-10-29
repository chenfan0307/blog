# Rsync实现文件实时同步(一)

# Rsync概念

Rsync(remote sync)是Unix平台下的一款神奇的数据镜像备份软件，rsync可以根据数据的变化进行差异备份，从而减少数据流量，提高工作效率。rsync可以使用ssh安全隧道进行加密数据传输。rsync服务器定义源数据,rsync客户端仅在源数据发生改变后才会从服务器上复制数据到本地，如果源数据在服务器端北删除，那么客户端的数据也会被删除，这样来保证数据的同步。它使用的端口是 `873` 

# 搭建Rsync

## Rsync Server

rsync 主要的配置之文件是三个
- rsyncd.conf # 主配置文件
- rsyncd.secrets # 密码文件
- rsyncd.motd # 服务器信息文件

系统默认是已经安装了的,配置文件如下

```linux
[root@elk shell]# vi /etc/rsyncd.conf

motd file = /etc/rsyncd.motd 	# 传输过程中，服务器提示信息
transfer logging = yes		    # 开启日志传输功能
log file = /var/log/rsyncd.log  # 配置日志文件名称和路径
pid file = /var/run/rsyncd.pid  # 设置rsync进程号保存文件名称
lock file = /var/run/rsync.lock # 设置锁文件名称

prot = 837 						# 设置端口为837
address = 192.168.8.157			# 设置服务器IP

uid = nobody					# 数据传输时所用的账户名称或ID，默认就好
gid = nobody		
use chroot = no 				# yes,就会将根目录映射到path参数路径，对客户端而言，系统的根就是path参数所指定的路径
read only = yes 				# 是否允许客户端上传数据，设置为只读
max connections = 10			# 设置最大并发连接数
timeout = 900					
ignore errors					# 忽略一些IO的错误
list false						# 客户端请求显示模块列表时，本模块是否显示
auth users = chenfan
secrets file = /etc/rsyncd.secrets

# [ftp]
#        path = /home/ftp
#        comment = ftp export area
[command]
path = /data/command
exclude = test/ 				# 忽略目录 test
host allow = 192.168.8.0/24
host deny = *
```

```shell
[root@elk shell]# echo "chenfan:docker" >>/etc/rsyncd.secrets
[root@elk shell]# chmod 600 /etc/rsyncd.secrets
[root@elk shell]# echo "Welcome To Access" >>/etc/rsyncd.motd
```
## Rsync Clinet

客户端数据同步

```
[root@docker ~]# history
    1  rpm -qa rsync
    2  rsync -vzrtopg --progress chenfan@192.168.8.157::command /data

rsync 常用参数:
	-a 		# 保留全局属性
	-v 		# 显示详细信息
	-z		# 对传输过程的参数进行压缩
	--progress	# 显示进度条
	--delete	# 删除那些仅在目标路径中已经有的文件(源路径中没有的)
	--password-file # 指定密码文件


[root@elk shell]# echo "docker" >> /etc/rsync.pass
[root@elk shell]# chmod 600 /etc/rsync.pass

参考脚本
#!/bin/bash
# This script does backup through rsync.

Red="\033[1,31m"
End="\033[0m"
SRC=command
DEST=/data
Server=192.168.8.157
User=chenfan
Password=/etc/rsync.pass
[ -d ${DEST} ] || mkdir -p $DEST
[ -f ${Password} ] || {
        echo "${Red}You should input a user:pass for rsync.pass${End}"
        exit 2
}

rsync -avzr --progress --password-file=${Password} ${User}@${Server}::$SRC $DEST/$(date +%F)
```

效果如下
```
[root@docker data]# sh rsync_back.sh 
Welcome to Access

receiving incremental file list
created directory /data/2018-03-15
./
shell/
shell/iptables.sh
         675 100%  659.18kB/s    0:00:00 (xfer#1, to-check=2/5)
shell/rsync_back.sh
         403 100%    9.15kB/s    0:00:00 (xfer#2, to-check=1/5)
shell/svn.sh
         774 100%   17.58kB/s    0:00:00 (xfer#3, to-check=0/5)

sent 124 bytes  received 1250 bytes  916.00 bytes/sec
total size is 1852  speedup is 1.35
```