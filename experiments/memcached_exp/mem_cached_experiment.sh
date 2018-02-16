#!/bin/bash

pkill mem.out
gcc findvalue.c -o mem.out -lmemcached -lm


ssh -f 172.16.1.60 "/home/erfan/Desktop/xen_ex/backup/thrift_experimetns/thrift/killbusy.sh 62 85"

echo "start sleeping for 10 seconds"
sleep 10
echo "slept for 10 seconds"

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
	
	pkill mem.out
	sleep 5
	for((j=63;j<i+63;j++));
	do
		echo "kill lookbusy $j"
		ssh -f 172.16.1.$j "pkill lookbusy"
		file_name=$1/log$j.log
		timeout -s SIGINT 150 ./mem.out 500 172.16.1.$j 2> $file_name &
		echo "memcached started $j 4%"
	done
	echo "memcached 62 pinger started " $i
	file_name=$1/log62.log
	timeout -s SIGINT 120 ./mem.out 50 172.16.1.62 2> $file_name &
	echo "waiting"
	wait
	echo "reading logs"
	python $1/percentile_1.py $1 99.9
	echo "$i round finished ###########################"
done 
