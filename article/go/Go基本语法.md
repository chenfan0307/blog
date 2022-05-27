[TOC]

# Go Learn

## 基础学习

### 构建与运行

```go
package main

import "fmt"

func main() {
	fmt.Println("Hello world!")
}
```

go build  编译指定得源文件或代码包以及依赖包

go build -o test .\main.go

go install 安装自身包和依赖包

go run 编译并运行go程序

### 变量

var 关键字去定义的

```go
package main

import "fmt"

func varInitValue() {
	var a, b int = 3, 5
	fmt.Println(a, b)
}

func main() {
	var a int
	var b string
	fmt.Printf("%d %q\n", a, b)
	varInitValue()
}

```

### 变量类型

* bool
* string
* (u)int (u)int8 (u)int16 (u)int32 uintptr
* byte(uint8) rune(int32 unicode)
* float32 float64 complex64 complex128

> go语言不支持隐式类型转换,只能强制转换

>go语言不支持指针运算

```go
package main

import (
	"fmt"
	"runtime"
	"strconv"
)

func main() {
	var a int = 1
	var b int32 = 2

	fmt.Printf("%T, %T\n", a, b)

	cpuArch := runtime.GOARCH
	intSize := strconv.IntSize

	fmt.Println(cpuArch, intSize)

	var f1 float32
	var f2 float64
	fmt.Printf("%f %f\n", f1, f2)

	var bt byte = 2
	var ru rune = '中'
	fmt.Printf("%T %T\n", bt, ru)

	// var a1, a2 = 3, 4
	// var c int
	// temp := a1*a1 + a2*a2
	// c = int(math.Sqrt(float64(temp)))
	// c = int()
	// fmt.Printf("%T %d\n", c, c)
	p := 1
	ptr := &p

	fmt.Println(*ptr)
}

```

### 常量 枚举 变量定义与别名

#### 常量 const

常量的值不可以改变

```go
package main

import (
	"fmt"
	"math"
)

func constDemo() {
	const a string = "hello"
	const k, v = 3, 4
	fmt.Println(a, k, v)
	var c int
	c = int(math.Sqrt(k*k + v*v))
	fmt.Println(c)

	const (
		s1  = "golang"
		max = 10
	)
	fmt.Println(s1, max)
}

func main() {
	constDemo()

}

```

#### 枚举

> 枚举式一种特殊的常量,可以通过iota快速设置连续的值

```go
func enumDemo() {
	const (
		Sunday = iota
		Monday
		Tuesday
		Wednesday
		Thursday
		Friday
	)
	fmt.Println(Sunday, Monday, Tuesday, Wednesday, Thursday, Friday)
}
```

#### 类型定义与别名

```go
func typeDefAndAlias() {
	type MyInt1 int   // 基于int定义的一个新的类型
	type MyInt2 = int // 和int完全一致
	var i int = 1
	var i1 MyInt1 = MyInt1(i)
	var i2 MyInt2 = i
	fmt.Println(i1, i2)

}
```

### 运算符

* go 语言没有前置的++和--, ++a和--a是错误的

#### 算术运算符

| 运算符 | 描述 | 实例  |
| :----- | ---- | ----- |
| +      | 相加 | a +b  |
| -      | 相减 | a - b |
| *      | 相乘 | a * b |
| /      | 相除 | a / b |
| %      | 求余 | a % b |
| ++     | 自增 | a++   |
| --     | 自减 | a--   |

#### 关系运算符

| 运算符 | 描述                                                         | 实例   |
| ------ | ------------------------------------------------------------ | ------ |
| ==     | 检查2个值是否相等,如果相等则返回True否则返回False            | a == b |
| !=     | 检查2个值是否不相等,如果不相等返回true,相等返回false         | a != b |
| >      | 检查左边的值是否大于右边的值,如果是返回true，否则返回false   | a > b  |
| <      | 检查左边的值是否小于右边的值,如果是返回true，否则返回false   | a < b  |
| >=     | 检查左边的值是否大于等于有便的值，如果是返回true，否则返回false | a >= b |
| <=     | 检查右边的值是否小于等于左边的值,如果是返回true，否则返回false | a <= b |

#### 逻辑运算符

| 运算符 | 描述                                                         | 实例      |
| ------ | ------------------------------------------------------------ | --------- |
| &&     | 逻辑and运算符,如果两边的操作都是true,条件true,否则false      | a && b    |
| \|\|   | 逻辑or运算符,如果两边的操作只要有一个为true,则为true,否则false | a \|\| b  |
| !      | 逻辑not运算符. 如果条件为true,则逻辑not条件为false,否则true  | !(a && b) |

#### 位运算符

| 运算符 | 描述                                                         | 实例   |
| ------ | ------------------------------------------------------------ | ------ |
| &      | 按位与运算符"&"是双目运算符,其功能是参与运算的两数各对应的2进位相与 | a & b  |
| ^      | 按位异或                                                     | a ^ b  |
| \|     | 按位或                                                       | a \| b |
| <<     | 左移运算符                                                   | a << b |
| >>     | 右移运算符                                                   | a >> b |

### 条件语句

```
if 语句：
if 布尔表达式 {
	/* 布尔表达式位true执行 */
} else if 另一个布尔表达式 {
	
} else {
	/* 布尔表达式为false执行 */
}


```

```go
package main

import "fmt"

func demoTest() {
	sum := 0
	for i := 1; i <= 100; i++ {
		sum += i
	}
	fmt.Println(sum)
}

func whileDemoTest() {
	n := 0
	for n < 10 {
		n++
		fmt.Printf("%d\n", n)
	}
}

func siDemoTest() {
	for {
		fmt.Println("dead loop")
	}

}
func main() {
	demoTest()
	whileDemoTest()
	siDemoTest()
}

```

#### 循环控制语句

* break语句 中断当前for循环
* continue语句 跳过当前循环的剩余语句,然后继续进行下一轮循环
* goto语句 将控制转移到标记的语句

```go
package main

import "fmt"

func demoTest() {
	sum := 0
	for i := 1; i <= 100; i++ {
		sum += i
	}
	fmt.Println(sum)
}

func whileDemoTest() {
	n := 0
	for n < 10 {
		n++
		fmt.Printf("%d\n", n)
	}
}

func siDemoTest() {
	for {
		fmt.Println("dead loop")
	}

}

func whileDemoTest2() {
	a := 15

	for a < 20 {
		a++
		if a == 17 {
			continue
		}
		fmt.Printf("============> a = %d \n", a)
	}

LOOP:
	for a < 30 {
		a++
		if a == 20 {
			goto LOOP
		}
		fmt.Printf("-----------> a = %d \n", a)
	}

	for a < 20 {
		fmt.Printf("a = %d\n", a)
		a++
		if a > 18 {
			break // 跳出整个循环
		}
	}

}

func main() {
	demoTest()
	whileDemoTest()
	// siDemoTest()
	whileDemoTest2()
}

```

### 函数

*func operate(a, b int, op string) int*   **函数返回值类型写在最后面**

*func swap(a,b int) (x, y int)* **函数可以返回多个值,也可以返回值命名,一般和error组合使用**

*func compute(op func(int int) int, a, b int)int* **函数式编程,函数可以作为参数传递给其他函数**

*func sum(nums ...int) int* **go语言中没有默认参数,可选参数,但是可以使用可变参数列表**



```go
package main

import (
	"errors"
	"fmt"
	"math"
	"os"
)

func operate(a, b int, op string) int {
	switch op {
	case "+":
		return a + b
	case "-":
		return a - b
	case "*":
		return a * b
	case "/":
		return a / b
	default:
		panic(fmt.Sprintf("Not support operate: %s", op))
	}
}

func operate2(a, b int, op string) (int, error) {
	switch op {
	case "+":
		return a + b, nil
	case "-":
		return a - b, nil
	case "*":
		return a * b, nil
	case "/":
		return a / b, nil
	default:
		return 0, errors.New(fmt.Sprintf("Not support operate: %s", op))
		// panic(fmt.Sprintf("Not support operate: %s", op))
	}
}

func swap(a, b int) (int, int) {

	filename, err := os.Open("ABC.txt")
	if err != nil {
		fmt.Println("Open file error")
	} else {
		fmt.Println(filename)
	}

	return b, a
}

func compute(op func(int, int) int, a, b int) int {
	return op(a, b)
}

func powInt(a, b int) int {
	return int(math.Pow(float64(a), float64(b)))
}

type greeting func(name string) string

func say(g greeting, world string) {
	fmt.Println(g(world))
}

func sayEnglish(name string) string {
	return "hello " + name
}

func sayFranch(name string) string {
	return "bgj " + name
}

func sum(nums ...int) int {
	s := 0
	for i := 0; i < len(nums); i++ {
		s += nums[i]
	}
	return s
}

func main() {
	a, b := 10, 5
	fmt.Println(operate(a, b, "+"))
	fmt.Println(swap(a, b))
	if result, err := operate2(a, b, "x"); err != nil {
		fmt.Println(err.Error())
	} else {
		fmt.Println(result)
	}

	fmt.Println(compute(powInt, 3, 5))
	say(sayEnglish, "world")
	say(sayFranch, "bjanack")
	fmt.Println(sum(1, 2, 3, 4, 5, 6))
}

```

### 作用域和指针

* 局部变量 函数内定义的变量(作用域只在函数体内,参数和返回值变量也是局部变量)
* 全局变量 函数外定义的变量(全部变量可以在整个包甚至到外部包中使用)
* 形式参数 函数中定义的变量(作为函数的局部变量来使用)

```go
package main

import "fmt"

// 全局变量
var g = 100

func sum(a, b int) int {
	var c = 10
	s := a + b + c + g
	return s

}

func main() {
	// 局部变量
	var a, b, c int
	a = 10
	b = 20
	c = a + b + g

	fmt.Println(a, b, c)
	fmt.Println(sum(5, 10))
}

```



#### 指针

```go
var p int = 20 // 声明实际变量
var ip *int // 声明指针变量
ip = &ip // 指针变量的存储地址
*ip = 30 // 指针变量赋值
fmt.Println(p)
```

*指针变量指向一个值的内存地址, \**号用于指定变量是作为一个指针

& 符号是用于取后面的变量的内存地址

将指针ip指向的内容更改,则变量p也会更改,因为是同一块内存地址


```go
package main

import "fmt"

// 全局变量
var g = 100

func sum(a, b int) int {
	var c = 10
	s := a + b + c + g
	return s

}

func funcValRef(a int) {
	a = 1000
	fmt.Printf("In fuc inner: %d\n", a)
}

func funcValRefPtr(a *int) {
	*a = 1000
	fmt.Printf("in func inner: %d\n", a)
}

func main() {
	// 局部变量
	var a, b, c int
	a = 10
	b = 20
	c = a + b + g

	fmt.Println(a, b, c)
	fmt.Println(sum(5, 10))

	var p int = 20
	var ip *int
	ip = &p
	*ip = 30
	fmt.Println(p)

	var j = 100
	funcValRef(j)
	fmt.Println(j)

	funcValRefPtr(&j)
	fmt.Println(j)

}

```

