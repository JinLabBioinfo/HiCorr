#!/usr/bin/python

import sys

dic={}
outlier=open(sys.argv[1])
for line in outlier.readlines():
	frag=line.rstrip().split('\t')[3]
	dic[frag]=""
outlier.close()

for line in sys.stdin:
	frag1,frag2=line.split('\t')[0:2]
	if frag1 not in dic and frag2 not in dic:
            print(line.rstrip())
