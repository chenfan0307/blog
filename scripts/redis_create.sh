#!/bin/bash

for i in {0..5}; do
	mkdir -p /data/redis/638$i
	\cp /usr/local/redis/src/redis-server /data/redis/638$i
	\cp /etc/redis.conf /data/redis/638$i
	sed -i "/dir/s#.*# dir /data/redis/638$i#g" /data/redis/638$i/redis.conf
	sed -i "s#6379#638$i#g" /data/redis/638$i/redis.conf
	sed -i "/protected-mode/s#yes#no#g" /data/redis/638$i/redis.conf
	echo "cluster-enabled yes" >>/data/redis/638$i/redis.conf
  	echo "cluster-config-file nodes-638${i}.conf" >>/data/redis/638$i/redis.conf
  	echo "cluster-node-timeout 15000" >> /data/redis/638$i/redis.conf
  	echo "appendonly yes" >> /data/redis/638$i/redis.conf
done
