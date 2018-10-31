# SHELL字符串


```
echo ${var%% *} # 从右边开始计算，删除最左边的空格右边的所有字符
echo ${var% *}  # 从右边开始计算，删除第一个空格右边的所有字符

echo ${var##* } # 从左边开始计算，删除右边的空格左边的所有字符
echo ${var#* }  # 从左边开始计算，删除第一个空格左边的所有字符 

echo ${var/ /_} # 把第一个空格替换成下划线
echo ${var// /_}# 把所有空格都替换成下划线

echo ${var// /} # 把所有的空格都删除

echo ${var:0:5} # 提取最左边的5个字节
echo ${var:5:5} # 提取第5个字节右边的连续5个字节

${file-my.file.txt} ：假如 $file 沒有設定，則使用 my.file.txt 作傳回值。(空值及非空值時不作處理) 
${file:-my.file.txt} ：假如 $file 沒有設定或為空值，則使用 my.file.txt 作傳回值。 (非空值時不作處理)
${file+my.file.txt} ：假如 $file 設為空值或非空值，均使用 my.file.txt 作傳回值。(沒設定時不作處理)
${file:+my.file.txt} ：若 $file 為非空值，則使用 my.file.txt 作傳回值。 (沒設定及空值時不作處理)
${file=my.file.txt} ：若 $file 沒設定，則使用 my.file.txt 作傳回值，同時將 $file 賦值為 my.file.txt 。 (空值及非空值時不作處理)
${file:=my.file.txt} ：若 $file 沒設定或為空值，則使用 my.file.txt 作傳回值，同時將 $file 賦值為 my.file.txt 。 (非空值時不作處理)
${file?my.file.txt} ：若 $file 沒設定，則將 my.file.txt 輸出至 STDERR。 (空值及非空值時不作處理)
${file:?my.file.txt} ：若 $file 沒設定或為空值，則將 my.file.txt 輸出至 STDERR。 (非空值時不作處理)
```



