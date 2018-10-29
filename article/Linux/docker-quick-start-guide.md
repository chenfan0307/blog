# Docker快速入门指北

## 概念
IaaS(基础设施服务)
	为基础设施运维人员，提供计算，存储，网络及其他基础资源，云平台使用者可以在上面部署和运行操作系统和应用程序在内的任意软件，无需再为基础设施的管理而分心
Paas(平台即服务)
	为应用层开发者，提供了支撑应用运行所需要的软件环境，相关工具与服务，如数据库服务，日志服务，监控服务等，让应用开发者专注于核心业务的开发
Saas(软件即服务)
	为一般用户服务，提供了一套完整可用的软件系统，让一般用户无需关注技术细节，只需要通过浏览器，应用客户端等方式就能使用部署在云上的服务

docker的概念：
	docker以容器为资源分割和调度的基本单位，封装整个软件的运行环境，用于构建，发布和运行分布式应用的平台。它是跨平台，可封装，可移植简单一用的，还有容器间是隔离的，它的快速部署是运维最喜欢的。

## 开启容器之旅

- 安装：

```
yum install docker-ce 
```

- 命令

```
continer
docker run [options] Image [command] [arg..]
registry
docker pull [options] NAME[:TAG]
docker push NAME[:TAG] # 推送本地image到docker hub或私有仓库
docker commit [options] CONTAINER [REPOSITORY[:TAG]] # 将容器打包为一个镜像
```
- 搭建私有docker registry

[配置使用docker服务使用的源](https://yq.aliyun.com/articles/29941)

注册一个自己的加速器地址，然后使用
```
ExecStart=/usr/bin/dockerd --bip 172.17.244.1/24 --registry-mirror=https://username.mirror.aliyuncs.com
```

1.采用官方的register:2镜像
```
docker run -d -p 5000:5000 --restart=always --name registry2 \
-v /data/docker-registry/data:/var/lib/registry \
docker.hub.com/registry:2
```
2.配置nginx以支持https(registry 默认是支持https)
可以在网上找到相应配置
[参考配置文件](https://www.hafang.top/scripts/docker-registry.conf)

docker私服帐号密码创建:
docker run –entrypoint htpasswd registry:2 -Bbn admin admin2017 > htpasswd

```
> mkdir dubbo && cd dubbo && vi Dockerfile #创建dockerfile用于创建镜像
> docker build -t docker.test.com/test/dubbo .  #创建镜像, 并放置在docker.zjcs.com/zjcs/域下
> docker push docker.test.com/test/dubbo  #上传镜像到私服
```

3.docker客户端的使用
1.由于docker.test.com的证书是自颁的, 在客户端需要设置接受这个证书或者忽略证书:
```
> cat {"insecure-registries":["docker.test.com"]} >> /etc/docker/daemon.json
> docker pull docker.test.com/centos
> docker pull docker.test.com/test/dubbo
```

### Dockerfile编写
[参考](https://blog.ansheng.me/article/docker-quick-start-guide)

```
指令	描述
FROM	指定基础镜像
MAINTAINER	维护者信息
RUN	执行的命令
ADD	把本地文件copy到镜像中
WORKDIR	指定工作目录
VOLUME	目录挂载
EXPOSE	启动的端口
CMD	最后执行的指令
```

jdk示例
```
FROM centos:latest

ENV TZ Asia/Shanghai
ENV LANG en_US.UTF-8

COPY software/jdk1.8 /opt/jdk1.8
ENV JAVA_HOME /opt/jdk1.8
ENV PATH $JAVA_HOME/bin:$PATH
```

tomcat示例:
```
FROM docker.test.com/test/jdk1.8:latest

COPY software/tomcat8 /opt/tomcat
ENV CATALINA_HOME /opt/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH

WORKDIR $CATALINA_HOME

EXPOSE 8080
CMD["catalina.sh", "run"]
```

### docker 网络模式

* none模式

这种模式下，Docker容器拥有自己的network namespace，但是并不会为 docker配置任何网络。也就是说docker容器除了network namespace自带的loopback网卡外没有任何其他的网卡,ip，路由信息。需要用户自己为docker容器配置网卡，Ip等。这种模式可以为用户最大自由度来定义容器的网络环境。

* host模式

使用--net=host指定，这种模式的docker server将不为docker容器创建网络协议栈，即不会创建独立的network namspace.docker容器中的进程处于宿主机的网络环境中，相当于docker容器和宿主机共同用一个network namespace，使用宿主机的网卡，ip和端口信息。但是容器的文件系统和进程等都是和宿主机隔离的。host模式可以很好的解决容器与外界通信的地址转换问题，可以直接使用宿主机的Ip进行通信。但是降低了隔离性，同时会引起网络资源的竞争与冲突

* bridge模式

使用--net=bridge指定，为docker的默认设置。这种模式就是将创建出来的docker容器连接到docker的网桥上。在Bridge模式下

1.创建一对虚拟网卡
2.赋予一块网卡类似veth的名字，将其留在宿主机root network namesapce中，并绑定到docker网桥上
3.将另一块网卡放入新创建的network namesapce（docker容器中），命名为eth0
4.从docker网络的子网中选择一个未使用的ip分配给eth0，并为docker容器设置默认路由，默认网关为docker网桥

它默认使用的是nat，在复杂的场景下使用会有诸多限制


* container 模式

就是新建一个容器使用之前一个容器的ip地址
```
docker run -d --network=container:container_name --restart=always -e UTF-8 --name busy_box nginx:latest
```

[参考](https://docs.docker.com/engine/tutorials/networkingcontainers/#create-your-own-bridge-network)

```
docker network ls # 显示当前网络
docker network disconnect bridge container-name # 拒绝掉容器名的网络
docker network create -d bridge my_bridge	 # 创建网桥
docker network inspect my_bridge # 显示my_bridge网桥的信息
docke run -d --net=my_bridge --name my_container_name centos:latest

docker inspect --format='{{json .NetworkSettings.Networks}}' db
docker run -d --name web nginx:latest python app.py
这么做2个容器是不互通的
docker network connect my_bridge web
```


### docker高级实践技巧


容器的本质是一个系统进程加上一套运行时库的封装，而针对容器，我们需要监控，资源控制，配置管理和安全等。

### docker 连接container ssh的替代方案

```
docker exec -it <container_name> bash 
```

### docker 的日志管理方案

```
docker对运行内部的日志管理较薄弱，每个运行在容器内的应用的日志输出同一保存到宿主机的/var/log目录下，文件夹以容器ID命名。
docker会把应用的stdout和stderr2个日志输出到/var/log下。docker以json消息记录每一行日志，将导致日志增长过快，从而超过磁盘限额
```

## 原理解读


## Kubernetes