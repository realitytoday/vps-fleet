#!/bin/sh
# Pending package updates without touching the network. Prints -1 if no supported package manager.
# Slow: run it every ten minutes, not on every poll.
if command -v apt-get >/dev/null 2>&1; then apt-get -s -o Debug::NoLocking=1 upgrade 2>/dev/null | grep -c '^Inst'
elif command -v dnf >/dev/null 2>&1; then dnf -C -q check-update 2>/dev/null | grep -c '^[[:alnum:]]'
elif command -v apk >/dev/null 2>&1; then apk -u list 2>/dev/null | grep -c .
else echo -1; fi
