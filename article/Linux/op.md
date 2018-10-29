# 运维必会面试题

1.你对现在运维工程师的理解和以及对其工作的认识

运维工程师是保障公司的安全及服务器的稳定性，和服务高效，安全的防护员。运维工程师的一个小的失误，会对公司及客户造成极大的影响，因此运维工程师不但需要严谨，而且需要极富创新精神，利用一些自动化的工具，让工作可以通过脚本和操作界面操作，降低误操作率

2.统计出Apache日志访问IP和每个地址的访问次数,按照访问量统计出前10

```
awk '{print $1}' file | uniq -c|sort -rn | head -10
```

3.将/var/log中的前一天的Boot日志打包到/tmp目录
```
#!/bin/bash
#

set -e

Yeasterday=`date +%Y%m%d -d '-1 day'`
Log_Dir=/var/log
Bak_Dir=/tmp
Log_File=boot.log

[ -f $Log_Dir/$Log_File-$Yeasterday ] && {
		tar czf $Log_Dir/$Log_File.$Yeasterday.tar.gz $Log_Dir/$Log_File.$Yeasterday;
		mv $Log_Dir/$Log_File.$Yeasterday.tar.gz $Bak_Dir
    } || echo "The file is not exist"
```


4.将本机80端口转向8080端口，使用iptables

```
iptabls -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 8080
```

需要注意的是需要打开ip_forward功能 
echo '1' > /proc/sys/net/ipv4/ip_forward

5.如何备份Mysql中的test库，并且恢复test库

```
mysqldum -u user -p passowrd  -h host -P port test > /tmp/test.sql

mysql -u user -p password -h host -P port test < /tmp/test.sql
```


6.你任务系统调优方面都包括哪些工作，以linux为例，请简明阐述

```
不用root 用普通用户sudo提权，限制登录主机区域，密码输入次数超过5次直接加入denyhost
更改ssh的远程端口
精简开机启动服务
锁定关键文件
清理/etc/issue /etc/motd提示信息
调整文件描述符的数量等
```

7.简述tcp/ip 三次握手和 四次断开

```
三次握手
client向server发送一个请求 syn的tcp连接
server接收到client的请求报文后，返回一个ack+syn的信息给client
client接收到ack+syn的信息后就发送一个ack给server，连接就建立了

四次断开
client向服务器发出一个请求断开的请求 fyn
server接收到fyn报文后，等待关闭。就发送一个ack给client
server在发送一个fin给client，是否断开连接
client在接收到server的fin后，就会发送一个ack给server，连接断开

tcp的状态

closed 初始状态
listen 监听状态
syn_rcvd 表示接收到sysn报文，接收到client的ack后就会进入established建立连接状态
fin_wait 等待对方的fin报文
time_wait等

```

8.简述 Linux开机的流程

```
先是通电poweron，然后加载bios的mbr,系统找到mbr后会将其复制到boot leader 物理内存中，然后就加载kernel，boot,加载完后就启动初始化进程/sbin/init，初始化系统化环境变量,init会读取/etc/inittab文件来确定运行级别，再加载开机启动程序/etc/init.d,后面就是用户登录，再进入Login shell
```

9.简述DNS的解析过程

```
a.用户输入网址，在本地Hosts文件中查找，是否存在，存在就直接返回结果，不存在，就继续下一步
b.计算机按照本地DNS的顺序，向合法的DNS服务器查询IP结果
c.合法的DNS服务器返回DNS结果给本地的DNS，本地DNS并缓存结果，直到TTL过期，才再次查询此结果
d.本地DNS返回IP给浏览器
e.浏览器根据IP信息，获取页面
```

10.文件如下，请获取主机名，并统计相应的访问次数
http://a.domain.com/1.html
http://b.domain.com/1.html
http://c.domain.com/1.html
http://a.domain.com/2.html
http://b.domain.com/2.html
http://a.domain.com/3.html

```
awk -F '/' '{S[$3]++}END{for (i in S) print i, S[i]}' test2.txt | sort -r
```

11.将主机192.168.1.9这台主机的server文件夹挂载到Linux本地/mnt/server,主机名为administrator 密码为123456

```
mount -t cifs -o username=administrator, password=123456 //192.168.1.9/server /mnt/server
```

12.tomcat发生内存溢出 如何处理

打印出堆栈日志，杀死进程，重启服务

13.linux系统入侵分析

```
分析可疑进程
再断网
使用rpm -Va 查看存在修改系统配置文件
分析/etc/password 查看是否有可疑用户
在查看/etc/secure.log 看下安全验证
查看下开机启动服务和crontab
分析日志
由大到小，多上stack overflow 解决问题
```


14.用Iptables添加一个规则允许192.168.0.123 访问本机3306端口

```
iptales -I INPUT -p tcp -m tcp --dport 3306 -s 192.168.0.123 -j ACCEPT
```


15.个人对该工作的未来规划，需要加强哪些能力

```
首先，有一个真诚的心，遇事冷静沉着，不急躁
其次，我有相应的专业知识和工作经验，2年多的业务运维经验锻炼了我在这个行业的业务能力，并对行业前景和发展动态有相应的了解
最后，我会用踏实的作用在今后的工作中证明自己的能力
```




16.系统管理员的职责包括哪些，管理的对象是什么

```
系统管理员的职责是进行系统资源管理，设备管理，系统性能管理，安全管理和系统性能监测。
```


shell 脚本编程部分：
1．从a.log 文件中提取包含―WARNING‖或‖FATAL‖,同时不包含―IGNOR‖的行，然后，
提取以―：‖分割的第五个字段？


2．添加一个新组为class01,然后，添加属于这个组的30 个用户，用户名的形式为stdXX,
其中，XX 从01 到30？

```
#!/bin/bash
#

groupadd class01
for($i=1; $i<=30; $i++); do

	useradd -G class01 std$i
done
```
3．在每个月的第一天备份并压缩/etc 目录下的所有内容，存放在/root/backup 目录里，
且文件名为如下形式yymmdd_etc,yy 为年，mm为月，dd 为日。shell 程序fileback
存放在/usr/bin 目录下？



4．用shell 编程，判断一文件是不是字符设备文件，如果是将其拷贝到/dev 目录下？

```
参考答案：
#!/bin/bash
directory=/dev
for file in anaconda-ks.cfg install.log install.log.syslog
do
if [ -f $file ]
then
cp $file $directory/$file.bak
echo " HI, $LOGNAME $file is backed up already in $directory !!"
fi
done 
```



简述题
1.linux如何修改IP,主机名，DNS




2.linux如何添加路由

```
route add default gw 192.168.1.0 # 添加默认路由
route add -host 192.168.1.10 dev eth0  # 设置一个主机路由对于某个特定的主机指定路由信息
route add -host 192.168.1.11 gw 192.168.1.1 # 添加主机可以通过指定网关来实现
route add -net 192.168.1.0 netmask 255.255.255.0 eth0 # 添加网络路由信息
route del ... # 删除路由
```


3.简述linux下编译内核的意义与步骤

```
linux内核是不断更新的，通常，更新内核会支持更多的硬件，具备更好的进程管理能力，运行速度块，并且更稳定，会修复老版本中发现的许多漏洞等
```

4.全部磁盘块由4个部分组成，分别是引导块，专用块，I节点表块和数据存储块


5.网络管理的重要任务是监控和控制


6.系统管理的任务之一是能够在分布式的环境中实现对程序和数据的安全保护，备份和恢复和更新

7.进程与程序的区别在于其动态性，动态的产生和终止，从而终止进程可以具有的基本状态为 运行态，就绪态和等待态(阻塞态)

8.局域网络地址为192.168.1.0/24，它的网关地址为192.168.1.1，主机192。168.1.20访问172.16.1.0/24网络时，路由设置

```
route add -net 172.16.1.0 gw 192.168.1.1 netmask 255.255.255.255 metric
```


9.简述Linux文件系统通过i节点把文件的逻辑结构和物理结构转换的工作过程

```
linux通过I节点将文件的逻辑结构和物理结构进行转换
i节点是一个64字节长的表，表中包含了文件的相关信息，其中有文件的大小，文件所有者，文件的存取许可方式以及文件的类型等重要信息
在i节点表中最重要的内容是磁盘地址表。在磁盘地址表中有13个块号，文件将以块号在磁盘地址表中的顺序依次读取相应的块。Linux文件系统通过把i节点和文件名进行连接，当需要读取该文件时，文件系统在当前目录表中查找该文件名对应的项，由此得到该文件相对应的i节点号，通过该I及诶单的磁盘地址表把分散存放的文件物理块连接成文件的逻辑结构
```

10.简述进程的启动，终止的方式以及如何进行进程的查看

```
有手工启动和调度启动2种方式
1.手工启动
用户输入端发出命令，直接启动一个进程的启动方式
a.前台启动：直接在shell中输入命令进行启动
b.后台启动：启动一个目前并不紧急的进程

2.调度启动
系统管理员根据系统资源和进程占用的情况，事先进行调度安排，指定任务运行的时间和场合。到时系统会自动完成任务
经常使用的进程调度命令有 at crontab
```



11.解释i节点在文件系统中的作用

```
在Linux文件系统中，是以块为单位存储信息的。为了找到某一个文件再存储空间中存放的位置，用i节点对一个文件系统进行索引。I节点包含了描述一个文件所必须的全部信息。所以i节点是文件系统管理的一个数据结构
```
