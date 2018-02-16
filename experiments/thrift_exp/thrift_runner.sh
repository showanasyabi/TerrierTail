#!/bin/bash

pkill lt-TutorialClie
#gcc findvalue.c -o mem.out -lmemcached -lm

echo "killing all lookbusy processes ..."
ssh -f 172.16.1.60 "/home/erfan/Desktop/xen_ex/backup/thrift_experimetns/thrift/killbusy.sh 62 85"

sleep 10
echo "killing all thrift server processes ..."
./kill_thrift_servers.sh 62 85

echo "start sleeping for 10 seconds"
sleep 10
echo "slept for 10 seconds, now starting the thrift servers"

./run_thrift_servers.sh 62 85

sleep 10

ssh -f 172.16.1.62 "lookbusy -c 3"
echo "VM 62 lookbusy started 3%"
for i in `seq 63 85`;
do
	ssh -f 172.16.1.$i "lookbusy -c 4"
	echo "VM" $i " lookbusy started 4%"
done


END=24

for((i=0;i<END;i++));
do
	
	pkill lt-TutorialClie
	sleep 5
	for((j=63;j<i+63;j++));
	do
		echo "kill lookbusy $j"
		ssh -f 172.16.1.$j "pkill lookbusy"
		file_name=$1/log$j.log
		timeout -s SIGINT 150 ./TutorialClient 400 172.16.1.$j > $file_name &
		echo "thrift started $j 4%"
	done
	echo "thrift 62 pinger started " $i
	file_name=$1/log62.log
	timeout -s SIGINT 120 ./TutorialClient 80 172.16.1.62 > $file_name &
	echo "waiting"
	wait
	new_file_name=$file_name\_$i
	cat $file_name > $new_file_name
	echo "reading logs"
	python $1/percentile_1.py $1 99.9
	echo "$i round finished ###########################"
done 
