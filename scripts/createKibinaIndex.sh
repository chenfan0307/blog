#!/bin/bash

DATA=`date +%Y-%m-%d`
DATA2=`date -d"yesterday" +%Y-%m-%d`

/usr/bin/curl -H "Content-Type: application/json" -u elastic:ijiami2022 -XGET "http://prd-efk:9200/_cat/indices?v&s=index:desc" |awk -F ' ' '{print $3}' | sort -n | grep ${DATA}  > index.log

for line in $(cat index.log); do
    # now to delete $line for kibina
    # curl -u elastic:i****2022  -XDELETE "http://prd-efk:5601/api/saved_objects/index-pattern/${line}" -H 'kbn-xsrf: true'
    # now to create $line for kibina
    /usr/bin/curl -u elastic:i****2022 -f -XPOST -H 'Content-Type: application/json' -H 'kbn-xsrf: anything' "http://prd-efk:5601/api/saved_objects/index-pattern/${line}" -d"{\"attributes\":{\"title\":\"${line}\",\"timeFieldName\":\"@timestamp\"}}"
done
