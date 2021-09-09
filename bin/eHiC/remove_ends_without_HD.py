#!/usr/bin/python

import sys

#if len(sys.argv)!=3:
#	print "Usage: ./remove_ends_without_HD.py <frag_GC_map> <frag_loop>"
#	sys.exit()
 
dic={}
mappability={}
GC_file=open(sys.argv[1])
for line in GC_file.readlines():
	end,GC,map=line.rstrip().split('\t')
	if float(GC)==0:
		dic[end]=""
	if int(map)==0:
		dic[end]=""
GC_file.close()

#loop_file=open(sys.argv[2])
#out=open(sys.argv[3],"w+")
#while True:
for line in sys.stdin:
	#line=loop_file.readline()
	#if not line:
	#	break
	cols=line.rstrip().split('\t')
	frag1=cols[0]
	frag2=cols[1]
	if frag1 not in dic and frag2 not in dic:
		print line.rstrip()
#loop_file.close()
