#!/usr/bin/python

import sys

dic={}
for line in sys.stdin:
	frag1,frag2,reads=line.rstrip().split('\t')[0:3]
	if frag1 not in dic:
		dic[frag1]=0
	dic[frag1] += float(reads)

for frag in dic:
	print frag+"\t"+str(dic[frag])
