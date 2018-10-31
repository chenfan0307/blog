## 迭代器

> 通过for循环遍历对象的每一个元素的过程

```
from collect import Iterable

isinstance('abc', Iterable) # abc是否是可迭代的实例对象
```

```
python迭代器表示的是一个元素流，可以被next()函数调用并不断返回下一个元素，直到没有元素出现StopIteration错误，可以把这个元素看做是一个有序序列，但却不能提前知道序列的长度，只能通过next()函数得到下一个元素，所以迭代器会更省内存
```

* Q1.迭代器与可迭代的区别

```
1. 凡是可用于for循环的都是可迭代类型
2. 凡是可作用于next()函数的对象都是迭代器类型
3. list,dict,str等是可迭代但不是迭代器，因为next()函数无法调动他们，可以通过Iter()函数转换为迭代器
4. python的for循环本质上就是通过不断调用Next()函数实现的
```

## 生成器 generator

> 生成器是一边生成一边获取的过程，用于高级语法

`g = (i*i for i in range(4))`
`yield`

> yield类似于函数的return<比return更高级> 【yield返回函数会生成协成，很高级】

* 斐波那契函数

``` 程序有问题
def fibonacci(n):
	a, b, count = 0, 1, 0

	while True:
		if count > n:
			return  
		yiled a # 有yield存在，函数 fibonacci会变为一个生成器

		a, b = b, a + b
		count += a
fib =fibonacci(20)
print(type(fib))

for i in fib:
	print(i, end=' ')
```

## 装饰器 decorator

> 在不改变原有代码的情况下，添加新的功能和调试 <开放封闭的原则>

* Q1 函数名 函数体 函数的返回值<可以是很多类型，包括函数本身>， 函数的内存地址

> 开放封闭，写出的代码是不可以修改的，需要直接在外部扩展功能

```
#!/bin/env python3
# -*- coding:utf-8 -*-

def outer(func):
	def inner():
		print("认证Ok")
		result= func()  # func = f1() 原来api的代码
		print("日志打印Ok")
		return result
	return inner

@outer
def f1(): # f1=inner()
	print("The team need python")

f1() # 这个是错误的，需要有2层函数
```

```
#1/bin/env python3
# -*- coding:utf-8 -*-
#

def outer(func):
    def inner(username, *args, **kwargs):
        print("认证Ok")
        result = func(username, *args, **kwargs)
        print("日志添加Ok")
        return result
    return inner
@outer
def f1(name, *args, **kwargs):
    # 加入认证
    print("业务部门1个接口{}".format(name))

@outer
def f2(name, *args, **kwargs):
    print("业务部门2个接口{}".format(name))

f1('chenfan')

f2('min')
```

> Q2.一个函数可以拥有多个装饰器吗, 代码必须符合业务逻辑

```
#1/bin/env python3
# -*- coding:utf-8 -*-
#

def outer(func):
    def inner(username,*args,**kwargs):
        print("认证Ok")
        result = func(username,*args,**kwargs)
        print("日志添加Ok")
        return result
    return inner

def outer2(func):
    def inner(username, *args, **kwargs):
        print("welcome to this home.")
        result = func(username, *args, **kwargs)
        print("Good Bye!")
        return result
    return inner

@outer
@outer2
def f1(name, *args, **kwargs):
    # 加入认证
    print("业务部门1个接口{}".format(name))


@outer2
@outer
def f2(name ,*args, **kwargs):
    print("业务部门2个接口{}".format(name))

@outer
def f3(name,*args, **kwargs):
    print("业务部门3个接口{}".format(name))


f1('chenfan')

f2('min')
```

