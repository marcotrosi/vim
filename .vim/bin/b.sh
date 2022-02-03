#!/bin/bash
# sed -E -n -e '3,$s/^[^"]+"//p' /tmp/b_pre.tmp | sk --reverse > /tmp/b.tmp || rm -f /tmp/b.tmp
cat /tmp/b_pre.tmp | sk --reverse > /tmp/b.tmp || rm -f /tmp/b.tmp
if [ ! -s /tmp/b.tmp ] ; then rm -f /tmp/b.tmp ; fi
exit 0
