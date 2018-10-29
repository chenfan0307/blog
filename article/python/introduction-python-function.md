# function

> 程序分解方法

```
a. 函数(function)
b. 对象(object)
c. 模块(module)
```

### 函数格式

```
def <name>(arg1,arg2,...,<*args>, <**kwargs>)
	<statements>
	return <value>
```

### 向函数传递参数

```
def hello(name):
	print(f'hello, {name}!')

hello('chenfan')
```

* 形参

> 是指函数定义中在内部使用的参数，这是函数完成其工作所需的一项信息，在没实际调用的时候，函数用形参来代替 <hello(name)>

* 实参

> 是指调用函数时由调用者传入的参数，这个是后形参指代的内容就是实参了<hello('chenfan')>

### 参数类型

* 位置参数

```
def hello(name, sex):
	print(f'hello,{name}! {sex}')

hello('chenfan', 'male')
```

* 关键字参数

```
def hello(name='chenyifa'): print(f'hello, {name}!')

hello() => hello, chenyifa
hello('chenfan') => hello, chenfan
```

* ** 变长关键字参数

```
def run(a, b = 1, ** kwargs):
	print(kwargs)
```

* 混合使用参数

```
def hello(name, default='World'):
	print(f'Hello,{name or default}!') # 这么使用有点错误

def func(a, b = 0, *args, **kwargs):
	print('a =', a, 'b=', b, 'args=', args, 'kwargs=', 'kwargs')
```

* 返回值

```
def add(a + b): return a + b
```