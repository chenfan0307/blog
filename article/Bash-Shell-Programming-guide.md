# BASH技巧

1.重定向

```
echo "Chenfan@38" | passwd --stdin root >/dev/null # 无意义的信息丢到黑洞去
id  chenfan >> user 2>> error # 错误信息输出到error，有用的信息输出到user中
```

2.自定义变量
```
read -p "Pls input a number: " P_number
echo $P_number
```

3.正则表达式

```
.	匹配单个字符
*	匹配前一个字符出现零次或多次
.* 	匹配任意多个任意字符
[] 	匹配集合中的任意单个字符，括号中为一个集合
[x-y]	匹配连续的字符串范围
\{n,m\}	匹配前一个字符重复n到m次
\{n,\}	匹配前一个字符至少n次
\{n\}	匹配前一个字符n次
```


```
#!/bin/bash

for i in {1..80}: do
	cut -c$i $1 >> one.txt
	cut -c$i $2 >> two.txt
done

grep "[[:alnum:]]" one.txt > onebak.tmp
grep "[[:alnum:]]" two.txt > twobak.tmp

sort onebak.tmp | uniq -c | sort -k1, 1n -k2, 2n|tail -30 > oneresult
sort twobak.tmp | uniq -c | sort -k1, 1n -k2, 2n|tail -30 > tworesult
rm -rf one.txt two.txt onebak.tmp twobak.tmp
vimdiff oneresult tworesult
```

4.if语句


```
#!/bin/bash

if [ "$(id -u)"  -eq "0" ]; then
	tar -czf /root/etc.tar.gz /etc &>/dev/null
fi


#!/bin/bash

read -p "Enter a password: " Password

[ "$Password" == "Chenfan@38" ] && echo "OK" || echo "Not Ok"
```


 5.case语句

```
#!/bin/bash

Date=$(date -d yesterday)
Time=$(date +%Y%m%d)

case $Date in
	Wed|Fri)
		tar -czf /usr/src/${Time}_log.tar.gz /var/log &> /dev/null;;
		*)
		echo "Today neither Wed nor Fri";;
esac
```

 6. for语句

```
#!/bin/bash

Domain=szzjcs.com
for Mail_u in chenfan flanky tim; do
	mail -s "Log" $Mail_u@$Domain </var/log/messages
done

#!/bin/bash

for i in {1..9}; do
	for ((j=1; j<=i; j++)); do
		printf "%-10s" $j*$i=$((j*i))
	done
	echo
done
```

 7. while语句

```
#!/bin/bash

File=/var/log/messages

while read -r line; do
	echo $line
done < $File

#!/bin/bash

while True; do
	clear
	echo "-"*10
	echo "1.Display Cpu Info:"
	echo "2.Display System Load:"
	echo "3.Exit Program:"
	echo "-"*10
	read -p "Pls select an iterm(1-3): " U_select

	case $U_select in
		1)
			echo $(cat /proc/cpuinfo)
			read -p "Press Enter to continue: ";;
		2)
			echo $(uptime)
			read -p "press Enter to continue: ";;
		3)
			exit ;;
		*)
			read -p "Pls select 1-3, press Enter to continue: ";;
	esac

done
```

 8. select语句

```
#!/bin/bash

echo "Where are you from? "

select var in "BJ" "SH" "JJ" "SZ"; do
	break
done

echo "You are from $var"
```