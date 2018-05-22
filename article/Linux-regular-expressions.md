# 正则表达式

推荐书籍 精通正则表达式

Linux `Every Thing Is A File`
经常需要过滤一些文件，所以掌握正则表达式是很重要的


# bash中常用的参数扩展
```      
${var:-value} 如果变量设置为空，则将其扩展为value
${var#pattern} 从var值前面开始砍掉与pattern最短的匹配项
${var##pattern} 从var值前面开始砍掉与pattern最长的匹配项
${var%pattern} 从var值的末尾开始砍掉与pattern最短的匹配项
${var%%pattern} 从var值的末尾开始砍掉与pattern最长的匹配项
${var\\,\ } 将逗号替换为空
${var\root\chenfan} 将root替换为chenfan
```


```
[chars] Match any character from given set
[^chars] Match any character not in a given set
^	Match the beginning of a line
$ 	Match the end of a line
\w 	Match any "word" character (same as [A-Za-z0-9])
\d 	Match any digit (same as [0-9])
?	Allows zero or one match of the preceding element
* 	Allows zero,one,or many matches of the preceding element
+	Allows one or more matches of the preceding element
{n} Match exactly n instance of the preceding element
{min,} Match at least min instance (note the comma)
{min, max} Match any number of the instance from min to max 
|	Express or find multiple strings
()	Packet filtering matching
```

[参考](https://blog.ansheng.me/article/examples-of-linux-regular-expressions)