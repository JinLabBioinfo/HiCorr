#!/usr/bin/python

import sys

if len(sys.argv)!= 11 :
	print "Usgae: ./correct_trans_reads.py <end_HD_length> <end_GC> <frag_length> <HD_lambda> <GC_lambda> <length_lambda> <HD_group_range> <GC_group_range> <length_group_range> <trans_loop>"
	sys.exit()

def find_HD_group(end):
	global HD_length
	global HD_group
	length=HD_length[end]
        for group in HD_group:
                if length>HD_group[group][0] and length<=HD_group[group][1]:
                        return group

def find_GC_group(end):
	global GC
	global GC_group
	gc=GC[end]
	for group in GC_group:
		if gc>GC_group[group][0] and gc<=GC_group[group][1]:
			return group
def find_length_group(end):
        global frag_length
        global frag_group
        length=frag_length[end]
        for group in frag_group:
                if length>frag_group[group][0] and length<=frag_group[group][1]:
                        return group


HD_length={}
HD_file=open(sys.argv[1])
for line in HD_file.readlines():
	end,length=line.rstrip().split('\t')[0:2]
	HD_length[end]=int(length)
HD_file.close()

GC={}		
GC_file=open(sys.argv[2])
for line in GC_file.readlines():
	end,gc=line.rstrip().split('\t')[0:2]
	GC[end]=float(gc)
GC_file.close()

frag_length={}
frag_file=open(sys.argv[3])
for line in frag_file.readlines():
	frag,length,map=line.rstrip().split('\t')
	frag_length[frag]=int(length)
frag_file.close()

HD_lambda={}
HD_lambda_file=open(sys.argv[4])
for line in HD_lambda_file.readlines():
	group1,group2,corr=line.rstrip().split('\t')
	HD_lambda[(group1,group2)]=float(corr)
HD_lambda_file.close()

GC_lambda={}
GC_lambda_file=open(sys.argv[5])
for line in GC_lambda_file.readlines():
        group1,group2,corr=line.rstrip().split('\t')
        GC_lambda[(group1,group2)]=float(corr)
GC_lambda_file.close()

frag_lambda={}
frag_lambda_file=open(sys.argv[6])
for line in frag_lambda_file.readlines():
        group1,group2,corr=line.rstrip().split('\t')
        frag_lambda[(group1,group2)]=float(corr)
frag_lambda_file.close()


HD_group={}
HD_group_file=open(sys.argv[7])
for line in HD_group_file.readlines():
	group,high,low=line.rstrip().split('\t')
	HD_group[group]=[int(high),int(low)]
HD_group_file.close()

GC_group={}
GC_group_file=open(sys.argv[8])
for line in GC_group_file.readlines():
        group,high,low=line.rstrip().split('\t')
        GC_group[group]=[float(high),float(low)]
GC_group_file.close()

frag_group={}
frag_group_file=open(sys.argv[9])
for line in frag_group_file.readlines():
        group,high,low=line.rstrip().split('\t')
        frag_group[group]=[float(high),float(low)]
frag_group_file.close()


loop=open(sys.argv[10])
while True:
	line=loop.readline()
	if not line:
		break
	end1,end2,obs=line.rstrip().split('\t')
	group_HD=(find_HD_group(end1),find_HD_group(end2))
	corr_HD=HD_lambda[group_HD]
	group_GC=(find_GC_group(end1),find_GC_group(end2))
	corr_GC=GC_lambda[group_GC]
	group_length=(find_length_group(end1),find_length_group(end2))
	corr_length=frag_lambda[group_length]
	obs=int(obs)/corr_GC/corr_length/corr_HD
	print end1+"\t"+end2+"\t"+str(obs)
loop.close()

