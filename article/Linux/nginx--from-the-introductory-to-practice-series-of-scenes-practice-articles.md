# Nginx深度学习篇

## http协议状态码

```
200 OK
3xx 重定向 301 302 304 永久重定向 临时重定向 缓存 
4xx 错误 用户访问路径有问题，目录权限问题
5xx 服务器内部错误，代码问题

Nginx :413 request Entity too Larage 用户上传文件限制：client_max_body_size
502 Bad Gateway  后端服务无响应，重启服务
504 Gateway Time-out 后端服务执行超时
403 访问被拒绝
404 文件没有找到
400 请求参数错误
```

## Nginx https配置

### nginx ssl

#### nginx生成证书

1.需要创建证书和私钥的目录
```
mkdir -pv /etc/nginx/cert; cd /etc/nginx/cert
```
2.创建服务器私钥
```
openssl genrsa -des3 -out test.key 1024
```
3.创建签名的请求证书
```
openssl req -new -key test.key -out test.csr
```
4.加载ssl支持Nginx并使用上述私钥时除去必须的口令
```
cp test.key test.key.org
openssl rsa -in test.key.org -out test.key
```

#### 配置Nginx
最后标记证书使用上述私钥和scr
```
openssl x509 -req -days 365 -in test.csr -signkey test.key -out test.csr
```
修改Nginx的conf.d的虚拟主机的配置文件，让其包含新标记的证书和私钥
```
server {
	listen 80;
	servername test.test.com;
	listen 443 ssl;

	ssl_cerrtificate /etc/nginx/cert/test.crt;
	ssl_cerrtificate_key /etc/nginx/cert/test.key;
	ssl_portocols TLSv1 TLSv1.1 TLSv1.2;
	ssl_ciphers         AES128-SHA:AES256-SHA:RC4-SHA:DES-CBC3-SHA:RC4-MD5;
    ssl_session_cache   shared:SSL:10m;
    ssl_session_timeout 10m;
    keepalive_timeout   70;
}
```

## Nginx负载均衡配置
nginx-sticky-module
这个模块是通过cookie黏贴的方式将来自同一个客户端的请求发送到同一个后端服务器上处理，这么做一定程度上可以解决多个backend servers的session同步的问题
另外内置的ip_hash也可以实现根据客户端ip来分发请求，但它很容易造成负载不均衡的情况
```
 upstream backend {
     server 192.168.1.243:888 weight 1;
     server 192.168.1.242:888 weight 2;
     sticky;
 }
 ```
 ```
 upstream backend {
     ip_hash;
     server 192.168.1.243:888 weight 2;
     server 192.168.1.242:888 weight 1 max_fails=2 fail_timeout=30s;
     server 192.168.1.24:888 backup;
 }

 server {
     proxy_pass http://backend;
     proxy_next_upstream error timeout invalid_header http_500 http_502 http_504;
 }
 ```
 weight: 轮询权值也是可以用在ip_hash中，默认为1
 max_fails: 允许请求失败的次数，默认为1.当超过最大次数时，返回proxy_nex_upstream 模块定义的错误
 fail_timeout: 在30s内最多2次失败，2次失败后，30s内不会分配到这个主机
 backup: 预留的备份机器，其他机器故障的时候，才会启用backup
 max_conns: 限制同时连接到某台服务器后端服务器的连接数，默认是0 无限制


## Nginx反向代理配置
将远程主机192.168.1.243:5566反向代理到kibana.test.com
```
 server {
        listen  80;
        server_name     kibana.test.com;
        error_log /var/log/nginx/kibana.error.log;
        auth_basic "Restricted Acess";
        location / {
           proxy_pass http://192.168.1.243:5666;
           access_log off;
        }
        proxy_pass_header       Server;
        proxy_set_header    Host        $http_host;
        proxy_redirect  off;
        proxy_set_header        X-Real-IP       $remote_addr;
        proxy_set_header    X-Scheme    $scheme;
        proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
        error_page 403 404 501 502 503  /404.html;
    }
```
## Nginx缓存场景演示
对于一个含有大量内容的网站来说，随着访问量的增多，对于经常被用户访问的内容，若每一次都要到后端服务器中获取，会给服务器造成很大的压力。利用反向代理服务器对访问频率较多的内容进行缓存，有利于节省后端服务器的资源。Nginx提供了2种Web缓存方式，一种是永久性缓存，另一种是临时性缓存

一般是准备一台缓存服务器，因为缓存分为临时缓存和永久性缓存
一般是配置在nginx.conf文件中的
proxy_store指令可以将内容源服务器响应的内容缓存到本地，不手动删除，它会一直存在，永久性缓存适合缓存网站中几乎不会更改的一些内容

临时缓存配置：
```
# 代理临时目录
proxy_temp_path /usr/local/nginx/proxy_temp_dir; # /usr/local/nginx/proxy_temp_dir 自定义缓存文件保存目录
# web缓存目录和参数设置
proxy_cache_path /usr/local/nginx/proxy_cache_dir levels=1:2 keys_zone=cache_one:50m inactive=1m max_size=500m; 
```
keys_zone=cache_one:50m
指定缓存区名称及大小,cache_one:50m表示缓存区名称为cache_one，在内存中的空间是50M
incative=1m
主动清空在指定时间内未被访问的缓存
max_size=500m
表示指定磁盘空间大小


## Nginx return redirect的配置

rewrite模块的简介
重写和重定向功能是现在大多数web服务器都支持的一项功能，相对于其他产品而言，Nginx中的rewrite模块提供的配置上更加的灵活自由，可定制都比较高

语法
```
rewrite regex replacement [flag];
```
regex 是正则表达式 参数replacement表示符合正则规则的替换算法
flag用于指定进一步的处理标识
 	  last	终止rewrite，继续匹配其他规则
 重写 break 终止rewrite，不再继续匹配
 		redirect 临时重定向 302
 重定向 permanent 永久重定向 301

#### rewrite 的重写
```
server {
    listen 80;
    server_naem test.test.com;
    index index.html index.htm;
    root html
    if (!-e $request_filename) {
        rewrite "^/.*" /html/default.html break;
    }
}
```
if 判断如果请求的文件或目录不存在就执行If内的语句
$request_filename 表示当前请求的文件路径
^/.* 正则匹配当前网站下的所有请求

if指令可以使用判断符号如下
```
判断符号    说明  
=           判断变量与内容相等
~           区分大小写正则匹配 ~ *   不区分大小写
!~          不区分大小写
-f          判断文件存在 !-f
-d
-e          判断文件或目录存在
-x          判断可执行文件
```
#### break和rewrite的区别
break 在rewrite指令匹配成功后就`不再进行匹配`

last 在rewrite规则重新发起一个新的请求继续进行匹配

```
server {
    listen 80;
    server_name test.test.com;
    root /etc/nginx/html;
    localtion /break/ {
        rewrite ^/break/(.*)/test/$1 break;
        echo "break page";
    }

    location /last/ {
        rewrite ^/last/(.*)/test/$1 last;
        echo "last page";
    }

    location /test/ {
        echo "test page";
    }

}
```

#### rewrite 实现重定向
rewrite 重定向就是将用户访问的URL修改为重定向的地址，只需要将flag修改为 redirect 或者 permanent
```
server {
    listen 80;
    server_name test.test.com;
    set $name $1;
    rewrite ^/img-([0-9]+).jpg$ /img/$name.jpg permanent;
    }
}
```
set 指令为变量$name赋值，$1表示符合正则表达式第一个子模式的值


虽然rewrite比较强大 但是个人还是比较偏向于return，因为return 的语法比较明确
```
# rewrite 301
	return 301 $scheme://www.test.com$request_uri;
	location = / {
		return 301 https://www.test.com
	}
```
$scheme 这个参数是http https
$request_uri 这个参数是请求的原始 URI，也就是包含 $args 的。而 rewrite 指令本身有自带 $args，于是 $args 就被重复加了一次。比如请求「http://localhost/?a=1」想被 301 到「https://localhost/?a=1?a=1

[可以参考](https://www.web-tinker.com/article/21194.html)

个人写的Nginx教程比较简单，还是需要看Nginx Plus的官方教程