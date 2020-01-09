#!/bin/bash

trap "postfix stop" SIGTERM
rsyslogd
crond
newaliases
postfix check
/usr/lib/MailScanner/init/ms-init start
/usr/lib/MailScanner/init/msmilter-init start
/usr/libexec/postfix/master -d &
wait
