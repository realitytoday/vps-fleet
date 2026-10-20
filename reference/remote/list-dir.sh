#!/bin/sh
# One directory level, tab-separated:
# type, target type, size, mode string, modified time, name, link target, owner, group, octal mode
find . -mindepth 1 -maxdepth 1 -printf '%y\t%Y\t%s\t%M\t%TY-%Tm-%Td %TH:%TM\t%f\t%l\t%u\t%g\t%m\n'
