# Nginx从入门到实践之基础篇

## nginx简介
Nginx是一款轻量级的Web 服务器/反向代理服务器及电子邮件(IMAP/POP3)代理服务器，并在一个BSD-like 协议下发行。由俄罗斯的程序设计师Igor Sysoev所开发，供俄国大型的入口网站及搜索引擎Rambler(俄文:Рамблер)使用。其特点是占有内存少，并发能力强，事实上nginx的并发能力确实在同类型的网页服务器中表现较好

## nginx应用场景
1、http服务器。Nginx是一个http服务可以独立提供http服务。可以做网页静态服务器。
2、虚拟主机。可以实现在一台服务器虚拟出多个网站，例如个人网站使用的虚拟机。
3、反向代理，负载均衡。当网站的访问量达到一定程度后，单台服务器不能满足用户的请求时，需要用多台服务器集群可以使用nginx做反向代理。并且堕胎服务器可以平均分担负载，不会应为某台服务器负载高宕机而某台服务器闲置的情况

## nginx的主要特点
1.高并发连接: 官方称单节点支持5万并发连接数，实际生产环境能够承受2-3万并发。
2.内存消耗少: 在3万并发连接下，开启10个nginx进程仅消耗150M内存 (15M*10=150M)
3.配置简单
4.成本低廉: 开源免费
5.支持rewrite重写规则: 6.能够根据域名、url的不同，将http请求分发到后端不同的应用服务器节点上
7.内置健康检查功能: 如果后端的某台应用节点挂了，请求不会再转发给这个节点，不影响线上功能
8.节省带宽: 支持gzip压缩
9.反向代理: 支持分布式部署环境，消除单点故障，支持7 * 24小时不停机发布

## nginx的安装
`nginx instll with yum`

复制如下到/etc/yum.repos.d/nginx.repo
```yum.repos.d
[nginx] 
name=nginx repo 
baseurl=http://nginx.org/packages/centos/$releasever/$basearch/ 
gpgcheck=0 
enabled=1
```
nginx依赖推荐
yum install zlib zlib-devel gcc-c++ libtool  openssl openssl-devel

yum install nginx

`nginx install with tar.gz`

添加第三方模块，依然需要重新编译，但不需要make install 只需copy可执行文件

```
nginx -V #查看原来的编译选项
./configure .... --add-module=....
make
cp ../nginx ../sbin/ngin
```

nginx 版本
```
[root@elk ~]# nginx -v
nginx version: nginx/1.12.2
```
个人比较喜欢yum安装，虽然源码包安装可以自定义，但官方推荐配置比个人自定义配置更好点

nginx常用命令
```
nginx -s reload	 # 修改配置文件，直接reload，人懒的重启服务
nginx -t		 # 测试nginx配置文件是否ok
nginx -s stop	 # 停止Nginx服务
nginx 			 # 启动服务	
```

## nginx的主配置文件
/etc/nginx/nginx.conf
```
user  nginx;
worker_processes  auto;

error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;


events {
    worker_connections  1024;
    use epoll;
}


http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

	log_format  access  '$remote_addr - [$time_local] "$request_time" '
    	'"$upstream_response_time" "$request" $status $body_bytes_sent "$http_referer" '
    	'"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile        on;
    tcp_nopush     	on;
	tcp_nodelay		on;
    keepalive_timeout  65;
	types_hash_max_size	2048;
    gzip  on;

    # for api _c header
    underscores_in_headers	on;

    # proxy
    proxy_set_header	Host	$host;
    proxy_set_header	X-Real-IP	$remote_addr;
    proxy_set_header	X-Scheme	$scheme;
    proxy_set_header	X-Forwarder-For	$proxy_add_x_forwarded_for;

	# buffer for direct proxy pass upstream large static file(like js/export)
	proxy_buffers 8 256k;
	proxy_temp_file_write_size	512k;
	
	# upload
	client_body_buffer_size 512k;

	# proxied respose code greater than 300 would be intercepted and redirected to nginx for processing with the error_page directive
	proxy_intercept_errors on

	# includ upstream conf
	include /etc/nginx/upstreams/*.conf

	# include conf
    include /etc/nginx/conf.d/*.conf;
}
```
默认访问日志的配置

```
配置			描述
$remote_addr	客户端地址
$remote_user	客户端请求认证的用户名
$time_local		Nginx服务器本地的时间
$request		请求行的信息
$status			返回的状态码
$body_bytes_sent	服务端响应给客户端的大小
$http_referer	当前URL的上一级URL
$http_user_agent	请求头中的浏览器
$http_x_forwarded_for	http携带的信息
```
