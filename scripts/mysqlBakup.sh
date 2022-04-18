#!/bin/bash
# -------------------------------------------------------------------------------
# FileName:    mysql_backup.sh 
# Describe:    Used for database backup
# Revision:    1.0
# Date:        2020/08/11

mysql_user="****"
mysql_password="*****"
mysql_host="*****"
mysql_port="5408"
backup_dir=/

dt=$(date +'%Y%m%d_%H%M')
echo "Backup Begin Date:" $(date +"%Y-%m-%d %H:%M:%S")

function SendMessageToDingding(){
        url="******"

        #推送到钉钉
        curl -XPOST -s -L $url -H "Content-Type:application/json" -H "charset:utf-8"  -d "
        {
        \"msgtype\": \"text\", 
        \"text\": {
                 \"content\": \"主机IP：$1\n 异常备份：$2\n 巡检时间：$3\"           
                 },
         'at': {
                  'isAtAll': true
       }
    }"
}

mysqldump -h$mysql_host -P$mysql_port -u$mysql_user -p$mysql_password -R -E --all-databases --single-transaction > $backup_dir/mysql_backup_$dt.sql

if [ $? -eq 0 ]; then
  find $backup_dir -mtime +14 -type f -name '*.sql' -exec rm -rf {} \;
  echo "Backup Succeed Date:" $(date +"%Y-%m-%d %H:%M:%S")
else
   SendMessageToDingding $(hostname -i) "mysql_backup_$dt.sql" $dt
fi
