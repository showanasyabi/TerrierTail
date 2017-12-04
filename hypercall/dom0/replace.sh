
#!/bin/bash


LINUX_ROOT=$1

cat ./netback.c > $LINUX_ROOT/drivers/net/xen-netback/netback.c
cat ./events_base.c > $LINUX_ROOT/drivers/xen/events/events_base.c
cat ./events.h > $LINUX_ROOT/include/xen/events.h
cat ./event_channel.h > $LINUX_ROOT/include/xen/interface/event_channel.h
