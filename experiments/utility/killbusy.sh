for i in `seq $1 $2`
do
	ip="172.16.1."$i
	ssh -f $ip "pkill lookbusy"
done
