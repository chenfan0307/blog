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



## 原理解读


## 高级应用技巧


## Kubernetes