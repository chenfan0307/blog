# tomcat 安装配置和优化

## 安装
参考官方文档
iptables -I INNPUT -p tcp -m tcp --dport 13855 -j ACCEPT

线上常用配置：
多实例端口修改 
多实例日志路径修改
jvm优化
性能优化

一般是直接使用tomcat默认的配置
sed -i '22s#8005#8511#;69s#8080#13855#' conf/server.xml

sed -i "26s#${catalina.base}/logs#/logs/web-student/#g; 30s#${catalina.base}/logs#/logs/web-student/#g" conf/logging.properties

bin/setenv.sh

```
#!/bin/bash

UMASK=0033
LOG_PATH="/logs/web-student"       #修改这一行
#CATALINA_OPTS="$CATALINA_OPTS -Djava.library.path=/usr/local/apr/lib"
CATALINA_OUT=$LOG_PATH/catalina.out
CATALINA_PID=$LOG_PATH/tomcat.pid

#java opt used by start run debug
CATALINA_OPTS="-server -Xms1024m -Xmx1024m -Xmn300m -Xss800k -XX:PermSize=300m -XX:MaxPermSize=300m -XX:+ExplicitGCInvokesConcurrent -XX:+UseParNewGC -XX:+UseConcMarkSweepGC -XX:CMSInitiatingOccupancyFraction=85 -XX:+PrintGCDetails -XX:+PrintGCTimeStamps -XX:SurvivorRatio=8 -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=$LOG_PATH -Xloggc:$LOG_PATH/jvm.`date +%Y-%m-%d`.log"
```

之前公司配置 记得一般是修改这3个地方

可以参考[老男孩博客](http://blog.oldboyedu.com/

## 性能优化

屏蔽DNS查询
            connectionTimeout="6000" enableLookups="false" acceptCount="800"
            redirectPort="8443" />

Jvm调优
tomcat比较吃内存，只要内存够，tomcat就跑的很快
之前是默认配置 512m，觉得官翻推荐的配置一般默认是最优的，所以也就没有动它
catalina.sh

JAVA_OPTS="-Djava.awt.headless=true -Dfile.encoding=UTF-8 -server -Xms1024m -Xmx1024m -XX:NewSize=512m -XX:MaxNewSize=512m -XX:PermSize=512m -XX:MaxPermSize=512m"


``` 线上配置
CATALINA_OPTS="-server -Xms1024m -Xmx1024m -Xmn300m -Xss800k -XX:PermSize=300m -XX:M    axPermSize=300m -XX:+ExplicitGCInvokesConcurrent -XX:+UseParNewGC -XX:+UseConcMarkSw    eepGC -XX:CMSInitiatingOccupancyFraction=85 -XX:+PrintGCDetails -XX:+PrintGCTimeStam    ps -XX:SurvivorRatio=8 -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=$LOG_PATH -X    loggc:$LOG_PATH/jvm.`date +%Y-%m-%d`.log"
```

nginx跳转参考 nginx文档

需要删掉webapps里面的内容，然后进行软链接
```
cd /www/runedu/backend/web-student/webapps
ln -s  /releases/runedu/backend/web-student/$TAG  act
```
