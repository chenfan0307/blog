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

sudo useradd zookeeper

sudo mkdir /data/zk0{1..3}/logs -p # 一台机器集群

sudo cp -a /usr/lcoal/zk /usr/local/zk0{1..3} # 一台机器集群

sudo chown zookeeper.chenfan /usr/local/zk0{1..3} # 一台机器集群

将主配置文件zoo.conf

dataDir=/data/zk0{1..3}  # 依次/data/zk01 ...

server.1=127.0.0.1:2888:3888

server.2=127.0.0.1:2889:3889

server.3=127.0.0.1:2900:3890

echo 1 >/data/zk01/myid

echo 2 >/data/zk02/myid

echo 3 >/data/zk03/myid

telnet ip

stat 查看zookeeper节点的状态


iptables -A INPUT -p tcp -m tcp --dport 2181 -j ACCEPT

[参考](http://zookeeper.apache.org/doc/r3.5.3-beta/zookeeperStarted.html)
[参考](http://huzongzhe.cn/categories/zookeeper/)