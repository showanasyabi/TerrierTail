#!/bin/bash
cd /home/erfan/Desktop/xen_ex/backup/thrift_experimetns/thrift

cd non_smp
echo "start vm"
#./startvms.sh
echo 30
sleep 30 #
ssh 172.16.1.62 "nohup "
busy_wait.sh
sleep 10
#start_pinging #non_smp io
echo "pinging non_smp io"

ssh 172.16.1.62 "lookbusy -c 30" & 
sleep 20

#start_pinging #non_smp mix
echo "pinging non_smp mix"

cd ../
#xl shutdown --all
./kill_busy
echo 20
sleep 20 #

cd smp
#./startvms
echo "start vm"
echo 30
sleep 30
busy_wait.sh
sleep 10

#start_pinging #smp io
echo "pinging smp io" 

ssh 172.16.1.62 "lookbusy -c 30" & 
sleep 20

#start pinging #smp mix
echo "pinging smp mix"




