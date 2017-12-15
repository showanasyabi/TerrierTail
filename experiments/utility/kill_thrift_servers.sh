for i in `seq $1 $2`
do
	vm="172.16.1."$i
	ssh -f $vm "pkill lt-TutorialServ"
done