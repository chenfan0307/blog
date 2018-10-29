# Redis 入门指北

## 概念

redis是一个使用ANSI C编写的开源，支持网络，基于内存，可选持久性的键值对(key-value)存储数据库。

### redis的特性
	- 高速读写，数据类型丰富
	- 支持持久化，多种内存分配及回策略
	- 支持弱事项，消息队列，消息订阅
	- 支持高可用，支持分布式分片集群

### 启动实例

- 安装和启动参照官网

- 备份redis.conf文件  cp redis.conf{,bak,$(date +%F)}

  ```
  [root@elk redis-4.0.6]# ll redis.conf*
  -rw-rw-r-- 1 root root 57764 Dec  4 12:01 redis.conf
  -rw-r--r-- 1 root root 57764 Mar 16 03:02 redis.conf2018-03-16
  -rw-r--r-- 1 root root 57764 Mar 16 02:43 redis.conf.bak
  ```

- 精简配置文件

  ```
  [root@elk redis-4.0.6] egrep -v '#|^$' redis.conf.$(date +%F) >redis.conf
   [root@elk redis-4.0.6] cp redis.conf /etc
   ````
  ```
- 修改/etc/redis.conf配置文件 

   11 logfile "/var/log/redis_6379.log"  # 配置redis 日志

- [redis启动脚本]()请参考网上

- redis 多实例配置
  [reids多实例创建脚本](../scipts/redis_create.sh)
  [redis多实例启动脚本](../scipts/redis_start.sh)

###  reids数据持久化
redis提供了多种不同级别的持久化方式，一种是RDB，另一种是AOF

* AOF更安全，可以将数据及时同步到文件夹中，但需要较多的磁盘io，AOF的文件尺寸大，文件内容恢复较慢，也更完整

* RDB持久化，安全性较差，它是正常数据备份及 master-slave数据同步的最佳手段，文件尺寸较小，恢复速度较快

#### RDB持久化
	可以在指定的时间间隔内生成数据集的时间点快照
	- RDB是一个非常凑近的文件，它保存了redis在某个时间点上的数据集。这种文件非常适合备份。例如，在最近的24小时内每个小时进行一次备份，并在每月的每一天，也备份一个RDB文件。这样的话，就算遇到问题，也可以快速回滚
	- RDB可以最大化redis的性能。父进程在保存RDB文件时，惟一做的就是fork出一个子进程，子进程处理后面的所有操作，父进程不需要执行任何磁盘的I/O操作
	- RDB在恢复大数据集时的速度比AOF的恢复速度快
	- 缺陷：RDB对数据完整性要求不高，还有由于保存RDB文件，需要fork一个子进程，如果数据很大，对比AOF会比较耗资源


#### AOF持久化
	记录服务器执行的所有写操作命令，并在服务器时，通过重新执行这些命令来还原数据。AOF命令全以redis协议的格式来保存，新命令会追加到文件的末尾
	- AOF 可以让redis更耐久，可以使用不同的fsync策略：无fsync和每秒fsync，每次写的时候，会使用默认的每秒fsync策略。对数据的完整性
	
	- AOF 文件有序的保存了对数据库执行的所有写入操作，这些操作以redis协议格式保存。因此它的可读性比较好
redis还可以在后台对AOF文件进行重写(rewrite),使AOF的文件体积不会超过数据收集状态所需的实际大小。它可以使用RDB和AOF的持久化。在这种情况下，redis重启，它会优先使用AOF文件来还原数据集。因为AOF保存的数据集比RDB文件保存的数据集更完整。


### redis主从复制

```
[root@elk ~] redis-cli -p 6380/6381/6382
127.0.0.1:6380> SLAVEOF 127.0.0.1 6379
OK

```
	- 管理 
	- 主从复制状态监控 info replication
	- 主从切换	slaveof no one

### redis 集群	

redis集群是一个在多个redis节点之间进行数据共享的设施

#### 配置集群
```
去ruby官网 download 它的源码包 编译安装
直接 yum install ruby ruby-gem 安装的版本过低 导致创建集群失败
./redis-trib.rb create --replicas 1 192.168.8.157:6379 127.0.0.1:{6380..6385}
```

### redis HA实践

#### redis cluster

这个是官方推荐的，它集合了主从和 sentinel的优点，管理也更加方便，并且容易，上手

安装参考官方文档
主要是使用redis-trib.rb

### Redis的数据备份与恢复

```
127.0.0.1:6379> CONFIG GET dir
1) "dir"
2) "/root"
127.0.0.1:6379> save
OK
127.0.0.1:6379> BGSAVE
Background saving started
127.0.0.1:6379> CONFIG GET dir
1) "dir"
2) "/root"

推荐使用bgsave 它会在后台一直备份，然后恢复的话只要redis服务即可
```
