#!/usr/bin/python

import sys

file=open(sys.argv[1])
line=file.readline()
#prev_frag=line.split('\t')[0]
#sum=int(line.split('\t')[2])
dic={}
while True:
	line=file.readline()
	if not line:
		break
	frag1,frag2,reads=line.rstrip().split('\t')[0:3]
	if frag1 not in dic:
		dic[frag1]=0
	dic[frag1] += float(reads)
file.close()

for frag in dic:
	print frag+"\t"+str(dic[frag])
