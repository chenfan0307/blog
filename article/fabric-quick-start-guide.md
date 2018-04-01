# fabric入门指北

作用: 可以讲自动化部署或者多机操作的命令固话到一个脚本里，简单易用

环境配置： pip3 install fabric | easy_install fabric


## hello world

新建一个fabfile.py

```fabric
def hello():
print("Hello World!")

[chenfan@~/tmp/fab]$ fab -f fabfile.py hello
Hello World!

Done
```

修改它

```
def hello(name, value):
print("%s = %s!" % (name, value))

[chenfan@~/tmp/fab]$ fab -f fabfile.py hello:name=age, value=20
age = 20!

Done
```

## 执行本机操作

```
from fabric.api import local, lcd

def lsfab():
with lcd('~/tmp/fab'):
local('ls')
[chenfan@~/tmp/fab]$ fab -f fabfile.py lsfab
[localhost] local: cd ~/tmp/fab
[localhost] local: ls
fabfile.py

Done

```

```python
from fabric.api import local, lcd

def setting_ci():
with lcd('/home/project/test/conf')
local("git add settings.py")
local("git commit -m 'daily update setting.py'")
local("git push origin master")
```

## 混搭整合远端操作

```
#!/bin/env python3
# -*- encoding:utf-8 -*-

from fabric.api import local, cd, run, env
env.host=['user@ip:port',]
env.passwd='pwd'

def setting_ci():
local("echo 'add and commit settings in local'")

def update_setting_remote():
print "remote update"
with cd('~/tmp'):
run('ls -l | wc -l')

def update():
setting_ci()
update_setting_remote()

[chenfan@~/tmp/fab]$ fab -f fabfile.py update
[user@ip:port] Executing task 'update'
[localhost] local: echo "add and commit settings in local"
add and commit setting in local
remote update
[user@ip:port] run: ls -l | wc -l
[user@ip:port] out: 12
[user@ip:port] out:

Done.
```

## 多服务器混搭

```
#!/bin/env python3
# -*- encoding:utf-8 -*-

from fabric.api import *

env.roledefs = {
'testserver':['user1@host1:port1',],
'realserver':['user2@host2:port2',]
}

@roles('testserver')
def task1():
run('ls -l | wc -l')

@roles('realserver')
def task2():
run('ls ~/tmp|wc -l')

def dotask():
execute(task1)
execute(task2)

[user@ip:port] fab -f fablifle dotask
[user1@host1:port1] Executing task 'task1'
[user1@host1:port1] run: ls -l | wc -l
[user1@host1:port1] out: 9
[user1@host1:port1] out:

....

Done.
```

此文入门教程[转自](http://wklken.me/posts/2013/03/25/python-tool-fabric.html)，也可看官翻。个人推荐是看管翻

## 线上实例