#!/bin/sh
# One SSH session per poll. One prefixed line per metric; parse by prefix, not by position.
# CPU: two /proc/stat samples 0.5s apart. Disk and network I/O are sampled around the same
# sleep, with /proc/uptime as the clock. Whole disks only (no partitions, loop, dm-*).
echo "U:$(uptime -p)"
free -b | awk '/Mem:/ {print "M:" $3 "," $2}'
df -Pk / | tail -1 | awk '{printf "D:%.0f,%.0f\n", $(NF-3)*1024, $(NF-4)*1024}'
dio() { awk '$3 ~ /^(sd[a-z]+|vd[a-z]+|xvd[a-z]+|hd[a-z]+|nvme[0-9]+n[0-9]+|mmcblk[0-9]+)$/ {r+=$6; w+=$10} END {printf "%.0f,%.0f", r*512, w*512}' /proc/diskstats 2>/dev/null; }
nio() { awk 'NR>2 {sub(/^ +/, ""); split($0, f, /[: ]+/); if (f[1] !~ /^(lo|veth|docker|br-|virbr)/) {r+=f[2]; t+=f[10]}} END {printf "%.0f,%.0f", r, t}' /proc/net/dev 2>/dev/null; }
echo "S1:$(head -1 /proc/stat)"; echo "IO1:$(dio)"; echo "NET1:$(nio)"; echo "T1:$(cut -d' ' -f1 /proc/uptime)"
sleep 0.5
echo "S2:$(head -1 /proc/stat)"; echo "IO2:$(dio)"; echo "NET2:$(nio)"; echo "T2:$(cut -d' ' -f1 /proc/uptime)"
echo "L:$(cut -d' ' -f1-3 /proc/loadavg)"
echo "N:$(nproc 2>/dev/null || grep -c ^processor /proc/cpuinfo)"
echo "F:$(systemctl --failed --no-legend --plain 2>/dev/null | grep -c .)"
[ -f /var/run/reboot-required ] && echo "R:1"
echo "O:$( (. /etc/os-release 2>/dev/null && echo "$PRETTY_NAME") || echo Unknown)"
