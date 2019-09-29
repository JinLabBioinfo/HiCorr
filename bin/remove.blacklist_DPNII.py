#!/usr/bin/python

"""
my usage= "remove.blacklist.py <blacklist.bed> <end_loop>" 
"""

import sys

bed=set()

with open(sys.argv[1],'r') as f:

	for line in f:
		
		chr, beg, end, id, size = line.rstrip().split('\t')

		bed.add(id)
f.close()




for line in sys.stdin:

	a1, a2 = line.rstrip().split('\t')[0:2]

	if a1 not in bed and a2 not in bed and a1 != a2:

		print line.rstrip()


f.close()
