#!/usr/bin/python

import sys

def reform(id):
	id=int(id.split('_')[1])
        if id%2==0:
                id="frag_"+str(id/2)+"-"
	else:
		id="frag_"+str((id+1)/2)+"+"
	return id

#file=open(sys.argv[1])
#while True:
#	line=file.readline()
#	if not line:
#		break
for line in sys.stdin:
	cols=line.rstrip().split('\t')
	end1,end2=cols[0],cols[1]
	end1=reform(end1)
	end2=reform(end2)
	print end1+"\t"+end2+"\t"+"\t".join(cols[2:])
#file.close()
        
