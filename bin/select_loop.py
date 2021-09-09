#!/usr/bin/python

import sys

dic={}
anchor_bed=open(sys.argv[1])
for line in anchor_bed.readlines():
	chr,start,end,id=line.rstrip().split('\t')
	dic[id]=""
anchor_bed.close()

loop=open(sys.argv[2])
while True:
	line=loop.readline()
	if not line:
		break
	anchor1,anchor2,obs,expt=line.rstrip().split('\t')
	if anchor1 in dic and anchor2 in dic:
		print(line.rstrip())
loop.close()
