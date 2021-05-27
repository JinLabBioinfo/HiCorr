#!/usr/bin/python

import sys

#if len(sys.argv)!=4:
#	print "Usage: ./test_frag_corr.py <read_sum> <frag_GC_mappability> <frag_loop>"
#	sys.exit()

reads_count={}
mappability={}
read_sum=open(sys.argv[1])
sum=0
NR=0
for line in read_sum.readlines():
	frag,read=line.rstrip().split('\t')
	reads_count[frag]=float(read)
read_sum.close()

GC={}
map_file=open(sys.argv[2])
for line in map_file.readlines():
	frag,gc,map=line.rstrip().split('\t')
	mappability[frag]=float(map)
	GC[frag]=float(gc)
	#NR+=1
map_file.close()

dic={}
for frag in mappability:
	if frag in reads_count and mappability[frag]!=0 and GC[frag]!=0:
		dic[frag]=reads_count[frag]/mappability[frag]
		sum+=dic[frag]
		NR+=1
	else:
		dic[frag]=0
	#sum+=dic[frag]
	#NR+=1
mean=sum/float(NR)

for frag in dic:
	dic[frag]=dic[frag]/mean

#loop=open(sys.argv[3])
#while True:
	#line=loop.readline()
	#if not line:
	#	break
for line in sys.stdin:
	frag1,frag2,obs,expt=line.rstrip().split('\t')
	if frag1 in dic:
		corr1=dic[frag1]
	else:
		corr1=0
	if frag2 in dic:
		corr2=dic[frag2]
	else:
		corr2=0
	corr=corr1*corr2
	expt=float(expt)*corr
	if expt==0:
		obs="0"
	print frag1+"\t"+frag2+"\t"+obs+"\t"+str(expt)
#loop.close()
