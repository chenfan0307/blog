# Information of monitoring and analysis

## Top

```
VIRT: 虚拟内存中含有共享库，共享内存，棧，堆，所有已申请的总内存空间
RES：是进程正在使用的内存空间(堆,栈)，申请内存后该内存已被重新赋值
SHR：共享内存正在使用的空间
SWAP: 交换的是已经申请，但没有使用的空间，包括(堆,栈内存共享)
DATA：是进程棧，堆申请的总空间
CODE：可执行代码占用的物理内存，单位为K
PR: 优先级
NI：nice值。负值表示高优先级，正直表示低优先级
```
`shift+p` 按照cpu排序

`shift+m` 按照内存排序

`k`输入pid，kill一个进程

f 显示top dashbord参数的意义

## pmag 查看进程空间

`pmag -x pid`

```
address：start address of map 映像起始地址
kbytes: size of map in kilobytes 映像大小
RSS: resident set size in kilobytes 驻留集大小
dirty: dirty pages(both shared and private) in kilobytes 脏页大小
mode: permissions on map 映像权限: r=read,w=write,x=excute,s=shared,p=private
mapping: 映像支持文件
offset: offset into the file 文件偏移
device 设备名
```


