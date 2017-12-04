
#!/bin/bash

XEN_ROOT=$1

cat xlat.lst > $XEN_ROOT/xen/include/xlat.lst
cat xlat.c > $XEN_ROOT/xen/common/compat/xlat.c
cat sched.h > $XEN_ROOT/xen/include/sched.h
cat event_channel.h > $XEN_ROOT/xen/include/public/event_channel.h
cat event_channel.c > $XEN_ROOT/xen/common/event_channel.c
cat event.h > $XEN_ROOT/xen/include/xen/event.h

