#!/bin/bash
Pwd=*****
Port=22
rm -rf /root/.ssh/id_dsa*
ssh-keygen -t dsa -f "/root/.ssh/id_dsa" -N "" -q
for ip in 63 64 65
do
    echo "========== host 172.10.4.$ip info=========="
    sshpass -p $Pwd ssh-copy-id -i /root/.ssh/id_dsa.pub -p$Port -o StrictHostKeyChecking=no 172.10.4.$ip
    echo ""
done
Com=uptime
for ip in 63 64 65
do
    echo "================= host 172.10.4.$ip check_info ================="
    ssh -p$Port root@172.10.4.$ip $Com
    echo ""
done
