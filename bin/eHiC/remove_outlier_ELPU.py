#!/usr/bin/python

import sys

dic={}
outlier=open(sys.argv[1])
for line in outlier.readlines():
	frag=line.rstrip().split('\t')[3]
	dic[frag]=""
outlier.close()

file=open(sys.argv[2])
while True:
	line=file.readline()
	if not line:
		break
	frag1,frag2=line.split('\t')[0:2]
	#frag1=frag1[:-1]
	#frag2=frag2[:-1]
	if frag1 not in dic and frag2 not in dic:
		print line.rstrip()
file.close()	
