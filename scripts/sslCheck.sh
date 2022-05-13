#!/bin/bash
# 检测https证书有效期

source /etc/profile

function SendMessageToDingding(){
        url="https://oapi.dingtalk.com/robot/send?access_token=a8dbad2972437db090cc1e62ef6d4ae2c97544739913362a12cf09c08eb8f22e"

        #推送到钉钉
        curl -XPOST -s -L $url -H "Content-Type:application/json" -H "charset:utf-8"  -d "
        {
        \"msgtype\": \"text\", 
        \"text\": {
                 \"content\": \"url地址：$1\n 剩余时间：$2\"           
                 },
         'at': {
                  'isAtAll': true
       }
    }"
}


while read line; do
    echo "====================================================================================="
    
    echo "当前检测的域名：" $line
    end_time=$(echo | timeout 1 openssl s_client -servername $line -connect $line:443 2>/dev/null | openssl x509 -noout -enddate 2>/dev/null | awk -F '=' '{print $2}' )
    ([ $? -ne 0 ] || [[ $end_time == '' ]]) &&  exit 10
    
    end_times=`date -d "$end_time" +%s `
    current_times=`date -d "$(date -u '+%b %d %T %Y GMT') " +%s `
    
    let left_time=$end_times-$current_times
    days=`expr $left_time / 86400`
    echo "剩余天数: " $days
    
    # [ $days -lt 30 ] && echo "https 证书有效期少于30天，存在风险"  
    [ $days -lt 30 ] && SendMessageToDingding $line "https 证书有效期少于$days"  
done < https_list
