#!/bin/bash
 
for i in `seq $1 $2`
do
	vm="172.16.1."$i
	ssh -f $vm "~/thrift-0.9.3/tutorial/cpp/TutorialServer"
done
