do
	vm="172.16.1."$i
	ssh -f $vm "~/thrift-0.9.3/tutorial/cpp/TutorialServer"
done