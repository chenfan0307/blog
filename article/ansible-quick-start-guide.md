# Ansible入门指北

## 自动化批量管理方式说明

### SSH-KEY
免密码登录验证是单向的，方向是私钥 -> 公钥
ssh免密码登录是基于用户的，最好不要跨不同用户
ssh连接慢，需要修改sshd_config配置文件参数
批量分发1000台初始都需要输入密码

### Ansible
不需要安装客户端，它是基于sshd服务，系统自带的，所以sshd就相当于是Ansible的客户端
不需要服务端
需要依靠大量的模块实现批量管理
配置文件/etc/ansible/ansible.cfg

### Ansiblle查看模块相关的信息方法
```
ansible-doc -l 
ansible-doc -s cron 
```

## 部署Ansible软件

### 先部署ssh-key免密码登录
ssh-copy -i ~/.ssh/id_rsa.pub "test@192.168.1.242 2222"
### 被管理端安装Ansible相关管理软件
yum install libselinux-python 
### 管理端安装Ansible ，需要配置hosts文件
```
yum install ansible
cat <<EOF>>/etc/ansible/hosts
[server] 
192.168.1.242
192.168.1.202
192.168.1.211
EOF
```

ansible 定义的组/单个ip/域名/all -m command -a "uptime"
-m 指定的模块
-a 指定使用模块中的相应的命令参数
command 模块名称

#### hosts文件配置指定的端口和帐号密码

vim /etc/ansible/hosts

[server]
192.168.1.242:2222 ansible_ssh_user=user ansible_ssh_password=password
192.168.1.202
192.168.1.211

### 常用模块

#### ping模块，测试连通性

ansible all -m ping

#### command 命令常用参数说明

chdir	在执行命令之前，切换指定目录 ansible server -m command -a "chdir=/tmp pwd"
creates  定义一个文件是否存在，如果不存在运行相应命令；存在跳过此步骤
removes  ansible server -m command -a "removes=/data/logs date"

#### shell模块，万能

`需要远程主机也有相应脚本`
ansible server -m shell -a "/bin/sh /data/command/scripts/ssh.sh"

#### script模块 脚本内容远程执行
ansible all -m script -a "/data/command/scripts/ssh.sh"

执行的脚本需要给执行权限即可

#### copy模块 把本地文件发送到远端
copy模块常用参数
```
backup[重要参数] 在覆盖远端服务器文件之前，将远端服务器文件备份，备份文件包含时间信息。2个选项 yes|no
content 用于代替"src"，可以直接指定文件的值
dest 必选项。将源文件复制到远程主机的绝对路径，如果源文件是一个目录，那么改路径也必须是目录
directoy_mode 递归设定目录的权限，个人喜欢是默认
forces 如果目标文件包含该文件，但内容不一样，如果设置为yes，就强制覆盖，们默默人为yes
src 被复制到远程主机的本地文件，可以是绝对路径也可以是相对路径。如果路径是一个目录，递归复制。如果路径使用/结尾，则只复制目录中的内容，没有使用/，就复制包含目录在内的所有内容，类似rsync
mode 定义文件或目录的权限
owner 属主
group 属组
```

ansible server -m copy -a "src=/etc/ansible/hosts dest=/data/hosts mode=0600 owner=root group=root"

#### file模块 设置文件属性

```
owner 复制传输后的数据属主信息
group 复制传输后的数据属组信息
mode  设置文件数据权限
dest  要创建的文件或目录命令，以及路径信息
src   指定要创建软链接的文件信息
		directory	创建目录
		file		创建文件
state	link 		创建软链接
		hard 		创建硬链接
		touch 		创建文件，如果路径不存在就创建一个新的文件
```	

#### fetch 拉取文件

ansible server -m fetch -a "dest=/tmp/backup src=/etc/hosts flat=yes"
dest 将远程主机拉取过来保存的文件的本地路径信息
src 远程主机将要拉取的文件信息 
flat 就是直接拉取文件到dest，不会包含远程文件的目录信息，默认为No

#### yum 安装模块

ansible server -m yum -a "name=ntp state=installed"

#### service 模块

ansible server -m server -a "name=mysqld state=restarted"

#### mount 模块

ansible server -m mount -a "fstype=nfs opts=rw path=/data/ src=192.168.1.9:/data/ state=mounted"

## Anisble-Playbook 剧本

### 语法规则

`规则1` 缩进，不要忘记tab
`规则2` 冒号 每个冒号后面需要一个空格
`规则3` 短横线 想要表示列表项，使用短横线 加一个空格

`核心规则`是：有效的利用空格进行剧本的编写，剧本编写是不支持tab的

```
### 剧本的开头 可以不写
- hosts all
tasks: <- 剧本所要干的事情
- command:
ansible all -m command -a "Faild"
```

```
cat >>EOF<</data/command/ansible/rsync_server.yml
- hosts: server
  tasks:
    - name: install rsync
      yum: name=rsync state=installed 
```

#### `剧本编写后的检查方法`
ansible-playbook --syntax-check /data/command/ansible/rsync_server.yml
   -- 进行剧本配置的语法检测

ansible-playbook -C /data/command/ansible/rsync_server.yml
   -- 模拟剧本执行(彩排)

playbook示例，它是ansibled的核心

```
- hsots: all
  tasks:
    - name: restart network
      service: name=network state=restarted
    - name: restarted network
      cron: name="restart network" minute=00 hour=00 job="/usr/bin/ntpdate time.paic.gov &> /dev/null"
    - name: sync time
      cron: name="sync time" minute=*/5 job="/usr/bin/ntpdate time.paic.gov &> /dev/null"

    - name: show ip addr to file
      shell: echo $(hostname -i) >>/tmp/ip.txt
```

[参考](http://www.ansible.com.cn/)

