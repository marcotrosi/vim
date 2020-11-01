#!/bin/bash
sed -E -n -e '3,$s/^[^"]+"//p' /tmp/r_pre.tmp | sk --reverse > /tmp/r.tmp || rm -f /tmp/r.tmp
if [ ! -s /tmp/r.tmp ] ; then rm -f /tmp/r.tmp ; fi
exit 0
