#!/bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin
DESC="ABRA FlexiBee Server"
NAME="flexibee"
DAEMON="/usr/sbin/flexibee-server"
SCRIPTNAME=/etc/init.d/$NAME
FLEXIBEE_PID=/var/run/flexibee.pid
FLEXIBEE_USER="winstrom"
FLEXIBEE_VIRTUALS="default"

touch /var/log/flexibee.log
id $FLEXIBEE_USER 2>/dev/null >/dev/null && chown $FLEXIBEE_USER /var/log/flexibee.log


exec $DAEMON || rc_failed