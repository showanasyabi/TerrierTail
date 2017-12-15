#!/bin/bash

path=$3

for i in `seq $1 $2`
do
	vm=$path'/vm'$i'.cfg'
	echo $vm
	xl create $vm > /dev/null 2>&1
	result=$?
	if [ "$result" -gt "0" ]; then
		echo "recreating " $result " " " $vm " 
		xl create $vm > /dev/null 2>&1
	fi
done
