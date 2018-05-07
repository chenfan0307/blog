# jenkins入门指北

## 定义:
jenkins是一个独立的开源的自动化服务器，可用于自动化各种任务，如构建，测试，部署软件。


### 持续集成的特点
* 自动化周期性的集成测试过程，从代码检出，编译构建，运行测试，结果记录，测试统计都是自动完成的，无需人工干预。
* 需要有专门的集成服务器来执行集成构建
* 需要代码托管工具支持

### 持续集成的作用
* 保证团队开发人员提交代码的质量，减轻软件发布时的压力
* 持续集成中的任何一个环节都是自动完成的，无需太多的人工干预，有利于减少重复以节省时间，费用和工作量。

## 安装
[参考](https://wiki.jenkins.io/display/JENKINS/Installing+Jenkins+on+Red+Hat+distributions)


个人环境是centos7
不同的环境，请[参考](https://wiki.jenkins.io/display/JENKINS/Installing+Jenkins)

## 配置

### 邮件配置

### 权限配置

### 构建配置
觉得自己把jenkins用的比较简单，jenkins可以用的很重，也可以用的很轻。个人用jenkins是用的比较轻，思路是利用jenkins提供的插件，将参数作为选项传入脚本，以$1,$2..的形式，后期执行脚本推送源码包到指定服务器，再重启服务。

## 结合sonarqube 做代码分析
[sonar官方文档](http://docs.sonarqube.org/display/SONAR/Analyzing+with+SonarQube+Scanner)

[安装参考](https://www.ibm.com/developerworks/cn/opensource/os-sonarqube/index.html)

[结合jenkins参考](https://docs.sonarqube.org/display/SCAN/Analyzing+with+SonarQube+Scanner+for+Jenkins)

