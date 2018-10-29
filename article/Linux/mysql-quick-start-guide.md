# Mysql 入坑指南

## install
参考官方文档
个人比较喜欢使用rpm包，比编译会更省时间，官方的推荐符合大众需求


## Mysql用户管理

select user,host,authentication_string from mysql.user;

### 用户的作用
* 登录数据库及使用数据
### 连接数据库
mysql -u username -p password -P port -h hostname
grant authority on 权限范围 to user identified by 'password'

authority: insert , update, select, delete, drop, create等
role: all privileges, replication slave等

权限范围:
```
全库: *.*
单库: mysql.*
单表: mysql.db
```

user:
```
'chen'@'localhost'
'chen'@'192.168.1.%'
```

 - Tips1 创建一个用户只能192.168.1.0/24访问，用户名为zjcs,密码为docker，这个用户只能对test库进行insert,create，update,select权限

 grant insert,create,update,select on test.* to zjcs@'192.168.1.%' identified by 'dcoker';

 查看用户权限：show grants for zjcs@'192.168.1.%'\G

 创建用户: create user 'zjcs'@'localhost' identified by 'docker';

 删除用户： drop user 'user'@'主机域'

 回收权限: revoke create,drop,insert,update on test.* from 'zjcs'@'192.168.1.%';
 
 设置数据库编码： create database test charset utf-8;

 对存在的数据库修改编码： alter database test charset utf-8;

 ### Mysqladmin mysqldump

 #### source命令的使用
 这个命令可以恢复数据
 source /data/mysql/test.sql
 非交互式命令，会产生大量的无用日志
 mysql -u user -p test < /data/mysql/test.sql

 mysqldump -u user -p test > /data/mysql/test.sql

 ## Mysql高可用

 ### master-slave

1.  `在master开启日志功能`

在/etc/my.cnf添加如下代码
server-id=1 # 给数据库服务的唯一标识
log-bin=mysql_backup-bin

2. `在master 创建使用从库访问masster，并获取用户读取二进制文件，实现数据同步`

mysql>create user backup;
mysql>grant peplication slave on *.* to 'backup'@'192.168.8.%' identified by 'Docker@38'; 

3. 备份mysql master的数据到从库
```
mysql>flush table with read lock; # 锁定写入操作
mysqldump -uroot -p --events -B -A --master-data=2 | gzip>/tmp/bak_sql.gz
msyql>unlock tables; # 解锁表

mysql -uroot -p < /tmp/bak_sql.sql # 从库 gzip -d 解压后，导入恢复
```

4. `从库/etc/my.cnf配置文件修改`

server-id=3
log-bin=mysql_backup-bin # 启用二进制文件

5. `重启slave`

mysql> change master to master_host='192.168.8.157',master_user='backup',master_password='Docker@38',master_port=3306;
#设置服服务器的用户信息
mysql> change master to master_log_file='mysql_backup-bin.000002',master_log_pos=333;
#设置binlog信息

7. `查看信息`

 ## Mysql优化

 ### 优化的哲学

 `优化可能带来的问题`
 优化不总是对一个单纯的环境进行，还有可能是一个复杂的已投产的系统
 优化的手段本来就有很大的风险，只不过你没能力意识和预见到
 任何技术可以解决一个问题，但必然存在带来一个问题的风险
 对于优化来说解决问题而带来的问题，控制在可接受的范围内才是有成果
 保持现状和出现更差的情况都是失败

 `优化的需求`
 稳定系和业务可持续性，通常比性能更重要
 优化不可避免涉及到变更，变更就有风险
 优化使性能变好，维持和变差是等概率事件
 切记优化，应该是各部门协同，共同参与的工作，任何单一部门都不能对数据库优化
 优化工作是由业务驱使的

在数据库优化上有2个主要的方面；安全和性能

 ### 优化的范围
 	安全 -> 数据可持续性
 	性能 -> 数据的高性能访问

 ### 优化的范围有哪些

 `存储，主机和操作系统方面`
 主机架构稳定性
 I/O规划及配置
 Swap交换分区
 Os 内核参数和网络访问

 `应用程序方面`
 应用程序稳定性
 SQL语句性能
 串行访问资源
 性能欠佳会话管理
 这个应用适不适合Mysql

 `数据库优化方面`
 内存
 数据库结构(逻辑和物理)
 实例配置

 以上3个就是数据库的优化和设计系统及定位问题的顺序


 ### 优化维度
 数据库优化维度有4个：
 	硬件，系统配置，数据表结构，sql及索引

 	![Mysql_optimization](/images/mysql_optimization.png)

 优化选择
 ```
 优化成本：硬件->系统配置->数据库表结构->sql及索引
 优化成本: 硬件->系统配置->数据库表结构->sql及索引
 ```

 ## 数据库层面的优化

 ```
 mysql
 mysqladmin 	mysql客户端，可进行管理操作
 mysqlshow 		功能强大的查看shell命令
 show [SESSION | GLOBAL] variables	查看数据库参数信息
 show [SESSION | GLOBAL] STATUS	查看数据库的状态信息
 information_schema	获取元数据的方法
 SHOW ENGINE INNODB STATUS innodb引擎的所有状态
 show processlist 查看当前所有连接processlist状态
 explain 获取查询语句的执行计划
 show index 查看表的索引信息
 slow-log 记录慢查询语句
 mysqldumpslow 分析slowlog文件 
 ```
 不常用但好用的工具
 zabbix 监控主机，系统，数据库
 pt-query-digest 分析慢日志
 mysqlslap 分析慢日志
 sysbench 压力测试工具
 performance schema mysql性能装填统计的数据
 workbench 管理，备份，监控，分析，优化工具(费资源，不建议)

 ### 数据库层问题解决思路

 `应急调优思路`

 `常规调优思路`
 针对业务周期性的卡顿，每天早上9点到10点业务特别慢，但是还能用，过了这段时间ok
 ```
 1.查看slowlog，分析slowlog，分析出慢查询的语句
 2.按照一定的优先级，进行一个一个的排查所有慢查询
 3.分析top sql，进行explain调试，查看语句执行时间
 4.调整索引或语句本身
 ```

 ### 系统层面

 vmstat 
 ```
 Procs : r表示有多少进程正在等待cpu时间。b显示处于不可中断的休眠的进程数量。在等待i/o
 Memory ：swpd显示被交换到磁盘的数据块的数量。未被使用的数据块，用户缓冲数据块，用于操作系统的数据块的数量
 Swap ： 操作系统每秒从磁盘上交换到内存和内存交换到磁盘的数据块的数量,sl和so最好是0
 Io : 每秒从设备中读入b1的写入到设备b0的数据块的数量。反映了磁盘I/O
 Cpu : 显示用于运行用户代码，系统代码，空闲，等待I/O的CPU时间

 ```
 个人不怎么会用vmstat

 iostat
 ```
 iostat -dk 1 5
 tps: 该设备每秒的传输次数。一次传输 意思是 一次IO请求。多个逻辑请求可能会被合并为 一次I/O请求
 iops：硬件出场的时候，厂家定一个一个每秒最大的IO次数
 kB_read/s： 每秒从设备读取的数据量
 kB_wrtn/s： 每秒向设备写入的数据量
 kB_read： 读取的总数据量
 kB_wrtn： 写入的总数量数据量
 ```

 不要使用swap分区

 mysql的优化没有做过，需要看下相关的文档