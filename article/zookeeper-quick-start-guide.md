# Zookeeper

## 简介:
ZooKeeper是一个典型的分布式数据一致性的解决方案，分布式应用程序可以基于它实现诸如数据发布、数据订阅、负载均衡、命名服务、分布式协调、分布式通知、集群管理、master选举、分布式锁和分布式队列等功能。ZooKeeper可以保证如下分布式一致性特性。


## 安装
- 1.jdk部署
- 2.下载zookeeper稳定版本
- 3.解压/opt/zookeeper,软链接到/usr/local/zookeeper
```
sudo tar zxf /tmp/zookeeper-3.4.11.tar.gz -C /opt
mv /opt/zookeeper-3.4.11/conf/zoo_sample.cfg /opt/zookeeper-3.4.11/conf/zoo.cfg
ln -sv /opt/zookeeper-3.4.11 /usr/local/zk
chown user.group /opt/zookeeper-3.4.11
cat >>/etc/profile.d/env.sh <<EOF
ZOOKEEPER_HOME=/usr/local/zk/
PATH=$PATH:$ZOOKEEPER_HOME/bin
export ZOOKEEPER PATH
EOF
zkServer.sh start
```

```
zkCli.sh # 连接zookeeper
```

- 4.安装ncat来校验zookeeper集群的情况
  wget https://nmap.org/dist/ncat-7.60-1.x86_64.rpm
  sudo rpm -ivh ncat-7.60-1.x86_64.rpm
  sudo ln -s /usr/bin/ncat /usr/bin/nc
  nc --version

echo stat | nc 127.0.0.1 2181 # 校验
## 集群搭建

配置jdk环境和zookeeper环境

- 基本环境
  主机名 IP地址 监听端口 leader交互端口 选举端口 myid

  zk01 10.25.82.38 2182 2888 3888 1

  zk01 10.25.82.39 2183 2888 3888 2

  zk01 10.25.82.40 2184 2888 3888 3



2888端口用来集群成员的信息交换，是服务器与集群中的leader服务器交换信息的端口



3888端口是leader挂掉的时候用来进行选举leader所用的



sudo useradd zookeeper

sudo mkdir /data/zk0{1..3}/logs -p # 一台机器集群



do chown zookeeper.chenfan /usr/local/zk0{1..3} # 一台机器集群



dataDir=/data/zk0{1..3}  # 依次/data/zk01 ...



for i in {1..3};do cp -a /opt/zookeper/* /data/zookeeper/zk0$i;done



dataDir=/data/zookeeper/zk01/data1



server.1=127.0.0.1:2888:3888

server.2=127.0.0.1:2889:3889

server.3=127.0.0.1:2900:3890



`myid  需要放在zoo.cfg配置文件的dataDir中`



echo 1 >/data/zookeeper/zk01/data1/myid

echo 2 >/data/zookeeper/zk02/data1/myid

echo 3 >/data/zookeeper/zk03/data1/myid



telnet ip



 zkServer.sh status  查看zookeeper节点的状态

iptables -A INPUT -p tcp -m tcp --dport 2181 -j ACCEPT

### Zookeeper为什么使用奇数集群

防止脑裂的产生
Zookeeper有这么一个特性[集群中只有超过过半的机器是正常工作的，那么整个集群对外就是可用的]
也就是说如果有2个zookeeper，那么1个死了zookeeper就不可用了，因为1没有过半，所以2个zookeeper的死亡容忍度为0，同理，3个zookeeper，一个死了，还有2个，过半了，所以3个zookeeper的容忍度为1。2n 和2n-1的容忍度是一样的，都是n-1，所以为了更加高效，没必要增加一个不必要的zookeeper

`zookeeper集群一大特性是只要集群中半数以上的节点存活，集群就可以正常提供服务，
而2n+1台和2n+2台机器的容灾能力相同，都是允许n台机器宕机。本着节约的宗旨，一般选择部署2n+1台机器`


[参考](http://zookeeper.apache.org/doc/r3.5.3-beta/zookeeperStarted.html)
[参考](http://huzongzhe.cn/categories/zookeeper/)