# 三剑客和find的使用



## 三剑客

### awk



### sed

> sed格式如下

sed ［-nefr］ ［n1,n2］ action

- -n  安静模式，只有经过sed处理的行才显示出来，其他不显示

- -e  表示直接在命令行模式进行sed操作

- -r 支持扩展表正则达式

- n1,n2 是需要处理的行 这个是可选项

- action:

  a append

  c change

  d delete

  i insert

  p print

  s search 和replace 

  ```shell
  sed 1,20s/old/new/g file_name
  ```

example:

```shell
[root@elk tmp]# cat -n id | sed '3,4d'
     1	root:x:0:0:root:/root:/bin/bash
     2	bin:x:1:1:bin:/bin:/sbin/nologin
     5	lp:x:4:7:lp:/var/spool/lpd:/sbin/nologin
     6	sync:x:5:0:sync:/sbin:/bin/sync
     7	shutdown:x:6:0:shutdown:/sbin:/sbin/shutdown
     8	halt:x:7:0:halt:/sbin:/sbin/halt

[root@elk tmp]# cat -n id | sed '3a hello fan'
     1	root:x:0:0:root:/root:/bin/bash
     2	bin:x:1:1:bin:/bin:/sbin/nologin
     3	daemon:x:2:2:daemon:/sbin:/sbin/nologin
hello fan
     4	adm:x:3:4:adm:/var/adm:/sbin/nologin

[root@elk tmp]# cat -n id | sed '3,9c life is sort, you should learn python'
     1	root:x:0:0:root:/root:/bin/bash
     2	bin:x:1:1:bin:/bin:/sbin/nologin
life is sort, you should learn python
    10	operator:x:11:0:operator:/root:/sbin/nologin
    
[root@elk tmp]# ifconfig ens33 |grep inet | awk -F[' ']+ '{print $3}'
192.168.8.157	
```

sed 分析 日志 在以下的secure日志文件中，我想用Sed抓取12∶48∶48至12∶48∶55的日志

```
sed  -n '/12:48:48/,/12:48:55/' /var/log/secure
```

### grep

grep - [acinv] '搜索的内容' file_name

- -a  表示以文本文件方式搜索
- -c 表示计算找到符合行的次数
-  -n 表示输出行号

```
grep -n '^[adi]*' file_name # 寻找以a,d,i开头的行
grep -n '[^g]*' file_name # 寻找不带有g的字符串行
grep -n 'o \{2\}' file_name # 搜索包含2个o的字符串的行
grep -n 'o \{2,5\}gc' file_name # 搜索至少2到5个o，再以gc结尾的字符串的行
grep -n 'o \{2,\}' file_name # 搜索至少包含2个o的字符串的行
```

个人最喜欢的还是egrep

```
egrep -v '^#|^$' file_name # 过滤出不包含空行和以#开头的内容
```

## find

find pathname -options [-print, -exec, -ok, xargs...]

- pathname: 文件路径

- -print 表示find命令将匹配的文件输出到标准输出中

- -exec 表示find命令对匹配的文件执行改参数锁给出的shell指令。相应的命令的形式为'command' {} \;

- -ok 表示和-exec效果是一样的，只是他会给用户一个选择判断的机会

- xargs 个人是最喜欢这个参数，因为它是查找到文件后就执行，而-exec是在找到所有相关后再执行

- options:

  ​	-name : 以文件名

  ​	-perm : 权限

  ​	-user : 所属用户

  ​	-group : 所属组

  ​	-mtime -n/+n/n :  -n是几天内，+n是几天前，n是第几天

```
find ~ -name "*.log" -print
find . -perm 007 -print

find /data -name "/data/chenfan" -prune -o -print  # ignore /data/chenfan

find / -mtime -5 -print 
find /data/chenfan -mtime +3 -print

find /etc -type d -print 

find /data/chenfan -size +100M -print 
find /data/chenfan -size +100M -size -5G -print 

find . -type f -exec ls -l {} \;
find /var/logs -type f -mtime +5 -exec rm {} \;

find / -type f -print | xargs file
find /data/chenfan -type f -print | xargs rm -f

find . \(-name "*.txt" -o -name "*.pdf"\) -print
# 使用正则查找txt和pdf
find . -regex ".*\(\.txt|\.pdf)$"
find . ! -name "*.txt" -print
find . -maxdepth 1 -type f
find . -type f -name "*.swap" -delete
find . -type f -user root -exec chow chenfan {} \
find . -type f -mtime + 10 -name "*.txt" -exec cp {} OLD \
```
