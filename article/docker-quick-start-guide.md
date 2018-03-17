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
yum install docker-ce # docker-ce 社区版本
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

## 原理解读

## 高级应用技巧


## Kubernetes