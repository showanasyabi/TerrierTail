#!/bin/bash
pkill mem.out
mkdir $6/$5
rm $6/$5/*
gcc findvalue.c -o mem.out -lmemcached -lm
for i in `seq $1 $2`
do
	file_name=$6/$5/log$i.log
	timeout -s SIGINT $4 ./mem.out $3 172.16.1.62 2> $file_name &
done
file_name=$6/$5/log_mix.log
#timeout -s SIGINT $4 ./mem.out $7 172.16.1.85 2> $file_name &

echo  "wating ..."
wait
#echo "mix"
#python $6/percentile_mix.py $6/$5 99.9
echo "pure"
python $6/percentile.py $6/$5 $2 99.9


