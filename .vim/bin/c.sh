#!/bin/bash
rm -f  /tmp/c_pre.tmp /tmp/c.tmp
fd -i -t d "$@" > /tmp/c_pre.tmp || exit 1
if [ ! -s /tmp/c_pre.tmp ] ; then exit 0 ; fi
cat /tmp/c_pre.tmp | sk --reverse > /tmp/c.tmp || rm -f /tmp/c.tmp
if [ ! -s /tmp/c.tmp ] ; then rm -f /tmp/c.tmp ; fi
exit 0
