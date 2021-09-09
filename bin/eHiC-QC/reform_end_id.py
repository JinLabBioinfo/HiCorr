#!/usr/bin/python

import sys

def reform(id):
	if id[-1]=="+":
		id=int(id[0:-1])*2-1
	elif id[-1]=="-":
		id=int(id[0:-1])*2
	else:
		return -1
	return str(id)

#file=open(sys.argv[1])
#while True:
	#line=file.readline()
	#if not line:
	#	break
for line in sys.stdin:
	end1,end2=line.rstrip().split('\t')
	end1=end1.split('_')[1]
	end2=end2.split('_')[1]
	end1="frag_"+reform(end1)
	end2="frag_"+reform(end2)
	print end1+"\t"+end2+"\t1"
#file.close()
