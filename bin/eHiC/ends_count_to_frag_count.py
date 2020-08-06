#!/usr/bin/python

import sys

dic={}
file=open(sys.argv[1])
while True:
	line=file.readline()
	if not line:
		break
	frag1,frag2,obs,expt=line.rstrip().split('\t')
	frag1=frag1[0:-1]
	frag2=int(frag2[0:-1].split('_')[1])
	if frag1 not in dic:
		for x in dic:
			for y in sorted(dic[x]):
				print x+"\tfrag_"+str(y)+"\t"+str(dic[x][y][0])+"\t"+str(dic[x][y][1])
		dic={}
		dic[frag1]={}
		dic[frag1][frag2]=[int(obs),float(expt)]
	else:
		if frag2 in dic[frag1]:
			dic[frag1][frag2][0] += int(obs)
			dic[frag1][frag2][1] += float(expt)	
		else:
			dic[frag1][frag2]=[int(obs),float(expt)]
file.close()
