# Nginx深度学习

nginx的相关命令
```
./nginx -t 用于检测配置文件是否正确
./nginx -s stop 关闭 强制关闭
./nginx -s quit 优雅的关闭 # 就是直到没人访问才会关闭
./nginx -s reload 重新加载配置文件
./nginx -V 查看nginx的配置文件信息
```
nginx header版本号的隐藏
```
curl -I localhost
 # curl -I localhost
 HTTP/1.1 200 OK
 Server: nginx/1.12.0
 Date: Thu, 20 Jul 2017 20:32:29 GMT
 Content-Type: text/html
 Content-Length: 612
 Last-Modified: Thu, 20 Jul 2017 19:20:33 GMT
 Connection: keep-alive
 ETag: "59710281-264"
 Accept-Ranges: bytes
```
编辑nginx.conf文件 在http{}代码段添加 server_tokens off 参数即可 隐藏掉nginx的版本号

配置nginx worker进程个数
 最好时根据服务器的CPU逻辑核心数来配置
```
 # grep "processor" /proc/cpuinfo | wc -l
 #vi /usr/local/nginx/conf/nginx.conf
  worker_processes 8; #个人喜欢auto
  worker_cpu_affinity 00000001 00000010 00000100 00001000 00010000 00100000 01000000 10000000 #数字代表1，2，3...的掩码，平均分摊进程的压力
```
 防止进程在一个核心上运行也可以使用 taskset 命令
```
 #tasket -c 1,2,3,4 /usr/local/nginx/sbin/nginx start 
```
nginx日志相关的优化和安全
1.nginx日志切割，备份
 ```
 #!/bin/bash
 cd /usr/local/nginx/logs
 mv access.log access_$(date +%F -d -1day).log
 mv error.log error_$(date +%F -d -1day).log 
 /usr/local/nginx/sbin/nginx -s reload
 ```
加入到定时任务
 ```
 cat >>/etc/crontab<<EOF
 00 00 * * * /bin/sh /data/scripts/cut_nginx_log.sh > /dev/null 2>&1
 EOF
 ```
2.不记录不需要的访问日志
 对于健康检查或者某些图片，js,css日志，一般不需要记录日志，因为统计pv时按照页面计算的，而且写入频繁会消耗IO，降低服务器性能
 ```
 location ~ .\*\.(js|jpg|JPG|JPEG|css|bmp|gif|GIF)$ {
      access_log off;
  }
 ```
3.访问日志的权限设置
```
 chown -R root. /usr/local/nginx/logs
 chmod -R 700 /usr/local/nginx/logs
```
nginx站点目录及文件url访问控制
 1.根据扩展名限制程序或者文件被访问
   用户上传头像，防止恶意上传 造成解析执行
   ```
   server{
   location ~ ^/images/.*\.(php|php5|sh|p1|py)$ {
        deny all;
      }
      localtion ~ ^/static/.*\.(php|php5|sh|p1|py)$ {
        deny all;
      }
      localtion ~ ^/data/.*\.(php|php5|sh|p1|py)$ {
        deny all;
      }
      localtion ~ .*\.(php|ph5)?$ {
         root html/www
         fastcgi_pass 127.0.0.1:9000;
         fastcgi_index index.php;
         include fastcgi.conf
      }
   }
   ```
 2.禁止访问目录并返回制定的HTTP代码
 ```
  server {
       location /admin/ {return 404}
  }
 ```
 3.限制网站来源IP地址
 ```  
   server  {
       location ~ ^/admin/ {
          allow 192.168.1.249;
          deny all;
       }
   }
 ```