#!/bin/sh
# Usage: processes.sh cpu|mem
# Primary: procps top, second frame only (the first frame's %CPU is averaged since process start).
# Fallback: ps, where %CPU is a lifetime average and therefore less accurate.
if [ "$1" = mem ]; then TOPKEY='%MEM'; PSKEY=pmem; else TOPKEY='%CPU'; PSKEY=pcpu; fi
out=$(top -b -n 2 -d 0.5 -c -w 512 -o "$TOPKEY" 2>/dev/null | awk '/^top -/{n++} n==2')
if [ -n "$out" ]; then echo "$out"; else
  ps -eo pid=,user=,pcpu=,pmem=,rss=,time=,args= --sort=-"$PSKEY" 2>/dev/null | head -n 200
fi
