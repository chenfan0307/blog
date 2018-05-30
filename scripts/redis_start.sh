#!/bin/bash
cd /data/redis
for i in 638{0..5}; do
	cd $i
	pwd
	./redis-server ./redis.conf &
	cd ../
done
