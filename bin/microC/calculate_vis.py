#!/usr/bin/python

import sys

dic={}
sums=0
count=0
for line in sys.stdin:
	if not line:
		break
	frag1,frag2,reads=line.rstrip().split('\t')[0:3]
	if frag1 not in dic:
		dic[frag1]=0
		count+=1
	dic[frag1] += float(reads)
	sums+=float(reads)


avg=float(sums)/count

for frag in dic:
#	print frag+"\t"+str(dic[frag])
	print(frag + '\t' + str(dic[frag]/avg))
