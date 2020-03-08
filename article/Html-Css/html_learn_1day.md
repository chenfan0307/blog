## HTML

> learn html for ops

> html是用来描述网页的一种语言，使用标记标签来描述网页

### Html基础

> web框架是web应用中的一个简化的过程

* html是什么？

> html 是一个超文本的标记语言通过标签来构成文件

* html不是什么？

> html不是一种编程语言，而是一种标记语言 (markup language)，它使用标记标签来描述网页

```
标签分类：

a. block (块级标签) 自己独占一行
b. inline (内联标签) 按内容划分
```

```
<div>
	<h1>山的那边是海呀</h1>	
	<p>小时候，妈妈告诉我说山的那边是海呀，</p>
	<p>直到长大了，我才发现</p>
	<p>只有当我翻越了一座座高山，最终看到的才是大海</p>
</div>	
```

* html结构

```
</!DOCTYPE html> # 渲染，告诉浏览器使用什么样的html来解析html文档
<html lang="en"> # 文档的开始标记和结束标记
<head> 			 # 元素出现在文档的开头部分。内容不会再浏览器的文档窗口显示，但是其间的元素有特殊的重要意义
	<meta charset="utf-8">
	<title>chenfan.org</title> # 定义网页的标题，在浏览器标题栏显示
</head>
<body>			 # 文本可见的网页主体内容
	文件体（网页显示内容）
</body>
</html>
```

* 标签嵌套

`块级 标签 可以嵌套所有的内联和块级`
`内联 只能嵌套内联`


### Html常用标签

```
<html>
	<body>
		<h1>这是一个标题</h1>
		<p>这是一个段落</p>
	</body>
</html>
```

* html的属性

> html标签可以拥有属性，属性提供了有关html元素的更多的信息。属性总是以名称/值对的形式出现

```
<a href="https://www.runjiaoyun.com.cn">This is a link</a>

<section id="content" class="animate">
	<h2>Content</h2>
</section>
```

* html5

```
html5是最新的html标准，有非常多的新的语义和新元素，它有更大的技术集，它允许更多样化和强大的网站和应用程序
```

* 文档元数据

> 网页渲染

```
</!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>rjy</title>
	<link rel="stylesheet" type="text/css" href="main.css">
	<style type="text/css">
		h1 {color:red;}
	</style>
</head>
<body>
	<a href="https://www.runjiaoyu.com.cn">This is a link</a>

	<section id="content" class="animate">
		<h2>Content</h2>
	</section>
</body>
</html>
```

* 内容分区

> 一个页面的框架，类似架子

* 文本内容

```
<div style="color:#0000FF">
	<h3>
		这是一个在div元素中的标题
	</h3>
	<p>这是一个段落</p>
	<div>
		<p>这是一个嵌套在div的段落</p>
	</div>
	<ol> # 多个有序的列表，带有编号的
		<li>Coffe</li>
		<li>Tea</li>
		<li>Milk</li>
	</ol>

	<ul> # 无序的列表
		<li>Coffe</li>
		<li>Tea</li>
		<li>Milk</li>
	</ul>
</div>
```

* 内联文本语义

```
<div>
	<a href="https://www.runjiaoyu.com.cn">rjy</a>	

	<p>我看过<span style="color:blue">1000</span> 部电影了</p>

	<p><em>强调文本</em></p>

	<p><strong>加粗文本</strong></p>
</div>
```
