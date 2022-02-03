#!/bin/bash
rm -f  /tmp/o.tmp
if [ ! -s /tmp/o_pre.tmp ] ; then exit 0 ; fi
cat /tmp/o_pre.tmp | sk -m --reverse > /tmp/o.tmp || rm -f /tmp/o.tmp
if [ ! -s /tmp/o.tmp ] ; then rm -f /tmp/o.tmp ; fi
rm -f  /tmp/o_pre.tmp
exit 0

