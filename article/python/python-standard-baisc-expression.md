# 表达式

- Tips1

任何优秀的代码，都是在频繁的修改和长期调整后才会出现

正式可分发的程序，由一到多个源码文件组成，各自对应一个运行期模块。模块内有很多语句，用于定义类型，创建实例，执行逻辑命令。其中包含表达式，可完成数据计算和函数调用。

	- 表达式(expression) 由标识符，字面量和操作符组成。其完成运算，属性访问，以及函数调用等。表达式像数学公式那样，总返回一个结果。

	- 语句(statement) 则由多行代码组成，其着重于逻辑过程，完成变量赋值，类型定义，以及控制执行流方向等。说起来，表达式算是语句的一种，但是语句不一定是表达式。

	-简单归纳 就是 表达式完成计算，语句执行逻辑

- Tips2 命令行

命令行参数分解释器和程序2种。分别以sys.flags, sys.argv读取

```
>>> import sys
>>> print(sys.flags.optimize) # 解释器参数
0
>>> print(sys.argv)           # 程序启动参数
['D:/back/007-learn/chenfan/python/bag/python/test.py']
```

- Tips3 退出

终止进程的正式做法是调用sys.exit函数，它确保退出前完成相关的清理操作

终止进程应返回状态码(exit status)，以便命令行管理工具据此作出判断。依惯例返回零表示正常结束，其他值为错误

- Tips4 代码

可读性和可测试性是代码的基本要求。前者保证代码自身的可持续性发展，后者维护其最终价值

## 推导式

>>> [x for x in range(5)]
[0, 1, 2, 3, 4]
>>> [x + 10 for x in range(10) if x % 2 == 0]
[10, 12, 14, 16, 18]

l = []

for x in range(10):
	if x % 2 == 0: l.append(x + 10)

>>> {k:v for k, v in zip("abc", range(10, 13))}
{'a':10, 'b':11, 'c':12}
>>> {k:0 for k in "abc"}
{'a':0, 'b':0, 'c':0}

>>> l = []
>>> for x in "abc":
	if x != "c":
		for y in range(3):
			if y != 0:
				l.append(f"{x}{y}")
>>> l
['a1', 'a2', 'b1', 'b2']

>>> [f"{x}{y}" for x in "abc" if x != "c"
				for y in range(3) if y != 0]
['a1', 'a2', 'b1', 'b2']

## 题目

1.使用while 循环 实现 1..100值范围 偶数和奇数的和
```
#!/bin/env python3
# -*- coding:utf-8 -*-

i = 1
sum = 0

while i <= 100:
	i += 1
	# if i % 2 == 0: # 偶数
	if i % 2 == 1 :  # 奇数
		sum += i
		print(i)
print(sum)
```

2.单身屌丝努力学习
```
#!/bin/env python3
# -*- coding:utf-8 -*-

chepiao = int(input("Pls enter 1.有女朋友, 2.单身汉 :")) # 1表示有票， 0表示没票
changdu = int(input("pls enter your jj cm :")) # 这是jj的长度 超过17cm就禁止进入

if chepiao == 1:
	print("WIFI,妹子在等你")
	
	if changdu >= 17:
		print("妹子不让进")
		print("刚颜射的妹子很漂亮...")
		print("老司机开车了...")
			# 还可以嵌套if
	elif 12 < changdu < 17:
		print("这个长度蛮好的...")
	else:
		print("拥有进入的权限，修炼赚钱!")
else:
	print("屌丝，还不去努力学习，你要打一辈子光棍吗")
```

3.找个白富美
```
#!/bin/env python3
# -*- coding:utf-8 -*-

# 1. 皮肤是否白
pp = int(input("how is her's (1.红润光泽， 2.一般):"))

# 2. 是否复用
bb = int(input("is she rich(1.yes, 2.no):"))
beautiful = int(input("is she beautiful(1.yes, 2.no)"))
# 3. 判断是否白富美

if pp == 1 and bb == 1 and beautiful == 1:
	print("I want fuck you")
else:
	print("Go out, i don't like you")
```

4. 9*9乘法表
```
#!/bin/env python3
# -*- coding:utf-8 -*-

i,j = 0, 0
# 控制行数
while i <= 5:
	# 控制一行中的个数
	while j <= i:
		print("*" * j )
		j += 1
	i += 1

#!/bin/env python3
for i in range(1, 10):
	for j in range(1, i+1):
		print('{} * {} = {}'.format(j, i, i * j), end = " ")
	print(" ")
```

