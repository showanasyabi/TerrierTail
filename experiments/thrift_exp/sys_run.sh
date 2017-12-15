#!/bin/bash

pkill lt-TutorialClie
path=$6
mkdir $path/$4
rm $path/$4/*

for i in `seq 1 $1`;
do
	#if [ $i == "62" ] || [ $i == "70" ] || [ $i == "71" ] || [ $i == "72" ] || [ $i == "73" ] ; then
	#	timeout -s SIGINT 300 ./TutorialClient 250 172.16.1.$i > /root/twelve_thrift_1/$2/$i.txt &
	#	echo "True" $i
	#else
	#	timeout -s SIGINT 300 ./TutorialClient 250 172.16.1.$i > /dev/null &
	#	echo "False" $i
	#fi
	#./TutorialClient 250 172.16.1.$i > /dev/null &
	timeout -s SIGINT $2 ./TutorialClient $3 172.16.1.62 > $path/$4/log$i.log &

done
	#timeout -s SIGINT $2 ./TutorialClient $5 172.16.1.85 > results/$4/log_mix.log &


wait

python $path/percentile.py $path/$4 $1 99.9
python $path/percentile.py $path/$4 $1 99.99
#python results/percentile_mix.py results/$4 99.9
