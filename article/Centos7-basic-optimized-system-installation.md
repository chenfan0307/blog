# Centos7系统安装后的基本优化和安全设置

## 1.关闭SELINUX功能
selinux是美国国家安全局(NSA)对于强制访问控制的实现，用于安全控制
```shell
[root@elk selinux]# sed -i '7s#enforcing#disabled#' /etc/selinux/config
[root@elk selinux]# grep -n disabled config
6:#     disabled - No SELinux policy is loaded.
7:SELINUX=disabled
```
查看selinux状态与临时设置为disabled
```
[root@elk selinux]# setenforce  # setenforce 0 临时设置为disabled 
usage:  setenforce [ Enforcing | Permissive | 1 | 0 ]
[root@elk selinux]# getenforce 
Disabled
```

## 2.修改SSH服务端远程登录的配置
sshd的配置文件在/etc/ssh目录下
ssh_config -> client
sshd_config -> server
一般是修改远程登录的端口和禁止root登录
```shell
vi /etc/sshd_confg
17 #Port 22  # 更改ssh远程端口，需修改
38 #PermitRootLogin yes # 禁止root登录，需禁止
[root@elk selinux]# systemctl restart sshd.service
```

## 3.通过sudo提权
```
[root@elk selinux]# visudo
 91 ## Allow root to run any commands anywhere
 92 root    ALL=(ALL)       ALL  # 复制一条，将root替换为需要提权的用户
```
## 4.修改文件描述符
```shell
[root@elk selinux]# echo '* - nofile 65535 ' > /etc/security/limits.conf
[root@elk selinux]# ulimit -n
655350
[root@elk selinux]# tail -n 5 /etc/security/limits.conf # 个人比较喜欢的一个配置
# End of file
* soft nofile 655350
* hard nofile 655350
* soft memlock ulimited
* hard memlock ulimited
```

## 5.关闭firewalld防火墙
systemctl stop firewalld.service
systemctl status firewalld.service
## 6.配置ntpdate时间同步

安装ntp

```
[root@elk selinux]# yum install bash-completion ntp
[root@elk selinux]# crontab -e
* */5 * * * /usr/sbin/ntpdate cn.ntp.org.cn> /dev/nul 2&>1
```

## 7.配置国内yum源

配置阿里云的yum源

```
[root@elk selinux]# mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
[root@elk selinux]# wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
[root@elk selinux]# yum clean all
[root@elk selinux]# yum makecache
```

## 8.linux最小化原则

- 安装精简版本的linux系统，yum安装软件最小化
- 开机自启动服务最小化，不开无用的服务
- 操作命令最小化原则
- 禁止root远程终端登录，使用普通用户和私钥来操作
- 文件和目录的权限设置最小化
- 网络服务和配置文件的参数需要合理化

## 9.隐藏系统版本信息显示
清空/etc/issue 的内容

```
[root@elk selinux]# > /etc/issue
[root@elk selinux]# 
[root@elk selinux]# 
[root@elk selinux]# vi /etc/issue
```

## 10.精简开机启动项

可以用脚本，也可以手动来做，第一次做表示手动，重复3次以上，最好是脚本化

```
[root@elk selinux]# chkconfig --list | grep 3:on

jenkins        	0:off	1:off	2:off	3:on	4:off	5:on	6:off
network        	0:off	1:off	2:on	3:on	4:on	5:on	6:off
openresty      	0:off	1:off	2:off	3:on	4:on	5:on	6:off

[root@elk selinux]# systemctl disable command
```

## 11.清楚多余的系统帐号
/etc/passwd  注释即可
