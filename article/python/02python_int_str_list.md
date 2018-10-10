# Python_learn_for_devops_by_oldboy-int_str_list

### 一.什么是数据
```
x=5,5
是存储的数据数字
作用:年级，等级，薪资，身份证号，qq号等数字相关信息
十进制转二进制 print(bin(number)) # 10 => 2
十进制转八进制 print(oct(number)) # 10 => 8
十进制转十六进制 print(hex(number))
```

### 二.字符串
* 字符串作用：名字，性别，国际，地址等描述信息

* 定义: 在单引号，双引号，三引号内，由一串字符组成

`name = 'chenfan' # name=str('chenfan')print(name[0])`

* 常用操作：
```
a.移除空白  # str.strip()   name=input('Username: ').strip()
b.切分 # str.split('分隔符'，次数)[参数]
c.长度 # str.__len__()  or len(str)
d.索引 # stre.切片 # str[0:5]

In [15]: name="***chenfan****"
In [16]: nameOut[16]: '***chenfan****'
In [17]: name.strip('*')
In [25]: cmd_info.split('|',1)
Out[25]: ['get', 'A.txt|333']
In [26]: cmd_info.split('|',1)[0]
Out[26]: 'get'
```
* 其他操作
```
a. startwith,endswithIn 

In [31]: name="C_m"
In [32]: print(name.endswith('m'))
True
In [33]: print(name.startswith('m'))
False
In [34]: print(name.startswith('C'))
True

b.replace

In [37]: name="chen say: i need money chen chen"
In [38]: print(name.replace('chen',"min",2))
min say: i need money min chen
In [39]: print(name.replace('chen',"min",1))
min say: i need money chen chen

c.format 参数传参
'{} {} {}'.format('chen',27,'male')
'{0} {2} {1}'.format('chen',27,'male')
'{name} {age} {sex}'.format(name='chen', age=27, sex='male')
'Name:{name} Age:{age} Sex:{sex}'.format(name='chen', age=27, sex='male')

d.isdigit

print(input('Pls input your age: ').isdigit())

e.find,rfind,index,rindex,count

f.join
join可迭代的对象必须是字符串
str.join(sequence) # sequence 要连接的元素序列
In [69]: '*'.join(a)
Out[69]: 'a*b*c'

g.center
In [72]: name="chenfan"
In [73]: name.center(30,'-')
Out[73]: '-----------chenfan------------'

h.expantabs 
设置tab键的空格
name="chen\thello"
print(name.expantabs(2))

i.lower,upper

j.captalize,swapcase,titlek.isalnum,isalpha
```

### 三.列表

作用：
