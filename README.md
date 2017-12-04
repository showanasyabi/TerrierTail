TerrierTail includes two main parts: A Netback driver which resides in DOM0(Linux Kernel) and a CPU scheduler which resides 
in the Xen hypervisor. 
So to build TerrierTail, you need to build a new Linux kernel and a new Xen hypervisor: 
(1)In the DoM0(Linux ) kernel, you need to replace several files in the DOM0’s Kernel with our modified files which are 
located in  hypercall/dom0 folder
(2)In the Xen hypervisor you need to replace the Xen’s Default scheduler and hypercall related files with 
the terrierTail scheduler (located in terrierTail-scheduler folder) and our hypercall related files 
(located in hypercall/xen folder) and build a new Xen hypervisor. 


Note that we used Ubuntu 16.04 (Kernel Version: 4.4.36) as DOM0 and Xen 4.7.1(staging 4.7) as the hypervisor


To build TerrierTail, please take the following steps in order:
1)	You need to have a physical machine which runs Linux as OS 
2)	Install the Xen hypervisor from source using xen_install.sh 
3)	Build and Install new Dom0 Kernel. To do so:
    a.	Download Linux source code from Kernel.org 
    b.	Go to folder hypercall/dom0 and run replace.sh to replace Linux default files with TerrierTail files. 
    You should pass the path of your Linux source code to the script
    c.	After replacing files, you need to build and install the new Kernel.
    d.	To do so, go to the kernel folder and run the following command
    i.	make -j4 && make modules install && make install && reboot
    e.	 Boot with the modified kernel in the GRUB
4)	Build and Install the  new hypervisor. To do so:
    a.	Go to folder hypercall/xen and run replace.sh to replace Xen’s defaults files with TerrierTail files 
    (you should pass the path of your Xen’s source code to the shell script)
    b.	Go to the folder terrierTail_scheduler and run replace.sh to replace the Xen’s default scheduler with the
    TerrierTail scheduler (you should pass the path of your Xen’s source code to the shell script)

    c.	Go to Xen source code folder to build and install the Xen hypervisor using the following command
    i.	make dist && make install && update-grub && reboot
    d.	boot with the new Linux with the Xen hypervisor  
