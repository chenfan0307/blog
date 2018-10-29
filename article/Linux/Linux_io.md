# Linux io监控与深入分析

![Linux_io](../images/linux_io.jpg)


各种io监视工具在Linux IO体系结构中的位置

[参考](http://www.cnblogs.com/quixotic/p/3258730.html)

## 1.系统级IO监控

`iostat`

```
[root@elk ~]# iostat -mdx 1
Linux 3.10.0-693.5.2.el7.x86_64 (elk) 	05/09/2018 	_x86_64_	(1 CPU)

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0.00     0.03    0.08    0.34     0.00     0.01    57.17     0.00    3.79    3.11    3.95   1.27   0.05
sdb               0.00     0.02    0.00    0.16     0.00     0.00    34.13     0.00    2.23    1.07    2.25   0.73   0.01
dm-0              0.00     0.00    0.08    0.55     0.00     0.01    46.85     0.00    3.78    3.17    3.86   0.99   0.06
dm-1              0.00     0.00    0.00    0.00     0.00     0.00    25.16     0.00    0.52    0.52    0.00   0.41   0.00

Device:         rrqm/s   wrqm/s     r/s     w/s    rMB/s    wMB/s avgrq-sz avgqu-sz   await r_await w_await  svctm  %util
sda               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00    0.00    0.00   0.00   0.00
sdb               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00    0.00    0.00   0.00   0.00
dm-0              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00    0.00    0.00   0.00   0.00
dm-1              0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00    0.00    0.00   0.00   0.00

```

%util 代表磁盘繁忙程度,100%表示磁盘繁忙，0%表示磁盘空闲。需要注意的是，磁盘繁忙不代表磁盘(带宽)利用率高
%iowait的值过高，表示磁盘存在I/O瓶颈


## 进程级IO监控

`iotop 和pidstat`

pidstat 统计进程pid的stat，进程的stat包括io的情况

iotop 简单粗暴，相当于io top
这2个命令可以按进程统计IO的状况，因此可以回答以下2个问题

1. 当前系统哪些进程在占用IO,百分比是多少？

2. 占用IO的进程是在读？还是在写？读写量是多少？

```
pidstat -u -r -d -t 1 # -d IO信息
					  # -r 缺页及内存信息
					  # -u cpu使用率
					  # -t 以线程为统计单位
					  # 1 1s统计一次
```

```
[root@elk ~]# pidstat -d 1
10:09:26 AM   UID       PID   kB_rd/s   kB_wr/s kB_ccwr/s  Command
10:09:27 AM     0    120365      0.00     12.50      0.00  java
10:09:27 AM     0    120578      0.00      8.33      0.00  java
```

### 磁盘碎片整理

只要磁盘容量不常年保持80%以上，基本上不用担心碎片问题

### 文件级IO监控

文件级IO分析，主要针对单个文件，回答当前哪些进程正在对某个文件进行读写操作

`lsof`

