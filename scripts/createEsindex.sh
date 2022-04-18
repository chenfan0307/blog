#/bin/bash

DATA=`date -d "1 week ago" +%Y-%m-%d`

time=`date`

# /usr/bin/curl -u elastic:i****2022  -H'Content-Type:application/json' -d'{"query":{"range":{"@timestamp":{"lt":"now-7d","format":"epoch_millis"}}}}' -XPOST "http://prd-efk:9200/*-*${DATA}/_delete_by_query?pretty"
curl -H 'Content-Type: application/json' -u elastic:i****2022 -XDELETE "http://prd-efk:9200/*-*${DATA}"

if [ $? -eq 0 ];then
echo $time"-->del $DATA log success.." >> /zywa/commands/es-index-clear.log
else
echo $time"-->del $DATA log fail.." >> /zywa/commands/es-index-clear.log
fi
