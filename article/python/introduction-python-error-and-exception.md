# Error And Exceptions

> 错误和异常

* 一个异常的例子

```
In [24]: def div(a, b): 
    ...:     return a /b                                                                                                                                                    

In [25]: div(2, 0)                                                                                                                                                          
---------------------------------------------------------------------------
ZeroDivisionError                         Traceback (most recent call last)
<ipython-input-25-d4f2e18433d9> in <module>
----> 1 div(2, 0)

<ipython-input-24-555e3174c584> in div(a, b)
      1 def div(a, b):
----> 2     return a /b

ZeroDivisionError: division by zero
```

### try-except

```
try:
	div(1, 0)
except ZeroDivisionError:
	print('Oops!')
```

```
a.首先执行try子句
b.如果没有发现异常则跳过except子句并try完成语句的执行
c.如果在执行try子句期间发生异常，则跳过该子句的其余部分。然后，如果其类型匹配在except关键字后面命名的异常，则执行except子句，然后在try语句之后继续执行
d.如果发生的异常与except子句中指定的异常不匹配，则将其传递给外部的try语句；如果没有找到处理程序，则它是一个未处理的异常，执行将停止并显示如上所示的消息
```

### except多个异常

```
l = []

try:
	l[1]
except (IndexError, ValueError):
	print('Oops!')


try:
	l[1]
excpet IndexError:
	print('index error')
except ValueError:
	print('value error')
```

### try-except-else

```
try:
	div(1, 0)
except ZeroDivisitionError:
	pass
else:
	print('Done!')
```

### try-finally

```
try:
	div(1, 0)
finally:
	print('finally')
```

### 组合try语法

```
def div(a, b):
	try:
		result = a / b
	except ZeroDivisionError as e:
		print(e)
	else:
		print('reslut is', result)
	finally:
		print('executing finally clause') 
```

### 异常

```
try/except
	捕捉由python或你引起的异常并恢复

try/finally
	无论异常是否发生，执行清理行为

raise
	手动在代码中触发异常

assert
	有条件地在程序代码中触发异常

with/as
```
### 异常角色

* 错误异常

```
在运行时检测到程序错误时，python就会引发异常。可以在程序代码中捕捉和响应错误，或者忽略已发生的异常
```

* 事件通知

```
异常也可用于发出有效状态的信号，而不需在程序间传递结果标志位。或者刻意对其进行测试
```

* 特殊情况处理

```
发生了某种罕见的情况，很难调整代码去处理。通常会在异常处理器中处理这些罕见的情况，从而省去编写应对特殊情况的代码
```

* 终止行为

```
try/finally
```
* 非常规控制流程

```

```