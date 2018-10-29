# control flow

> 控制流

### for

```
l = [1, 3, 6] 

for i in l: print(i)

d = {'a':1, 'b':2}

for k in d:
	print(k, d[k])

for k, v in d.items(): print(k, v)
```

### if

```
if int(input('Pls enter an integer: ')) == 1: print('Yeah!')

if int(input('Pls enter an integer: ')) == 1: 
	print('Yeah!')
else:
	print('Oops!')
```

### while

```
a = 0

while a < 3:
	print(a)
	a += 1
```

### break

```
l = [1, 3, 6]

for i in l:
	if i > 6:
		break
	print(i)

i = 1

while 1:
	print(i)
	i += 1
	if i > 6
		break
```

### continue

```
l = [1, 3, 6]

for i in l:
	if i == 3:
		continue
	print(i)
```

### else

```
for i in l:
	continue
else:
	print('do else')

for i in l:
	if i == 3:
		break
else:
	print('do else')


i = 1

while 1:
	print(i)
	if i > 2:
		break
	i += 2
else:
	print('do else')
```

### range

```
range(5) = ranger(0, 5)

list(range(5)) => 1, 2, 3, 4, 5
```

### pass

```
class MyEmptyClass:
	pass

while False:
	pass
```