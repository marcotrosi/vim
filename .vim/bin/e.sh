#!/bin/bash
rm -f  /tmp/e_pre.tmp /tmp/e.tmp
fd -i -t f "$@" > /tmp/e_pre.tmp || exit 1
if [ ! -s /tmp/e_pre.tmp ] ; then exit 0 ; fi
cat /tmp/e_pre.tmp | sk -m --reverse > /tmp/e.tmp || rm -f /tmp/e.tmp
if [ ! -s /tmp/e.tmp ] ; then rm -f /tmp/e.tmp ; fi
exit 0
