#!/usr/bin/python

import sys

if len(sys.argv)!= 5 :
	print "Usgae: ./sum_frag_reads_no.py <frag_length> <length_lambda> <length_group_range> <trans_loop>"
	sys.exit()

def find_length_group(end):
        global frag_length
        global frag_group
        length=frag_length[end]
        for group in frag_group:
                if length>frag_group[group][0] and length<=frag_group[group][1]:
                        return group


frag_length={}
frag_file=open(sys.argv[1])
for line in frag_file.readlines():
	frag,length,map=line.rstrip().split('\t')
	frag_length[frag]=int(length)
frag_file.close()

frag_lambda={}
frag_lambda_file=open(sys.argv[2])
for line in frag_lambda_file.readlines():
        group1,group2,corr=line.rstrip().split('\t')
        frag_lambda[(group1,group2)]=float(corr)
frag_lambda_file.close()

frag_group={}
frag_group_file=open(sys.argv[3])
for line in frag_group_file.readlines():
        group,high,low=line.rstrip().split('\t')
        frag_group[group]=[float(high),float(low)]
frag_group_file.close()


loop=open(sys.argv[4])
prev_frag=0
sum=0
while True:
        line=loop.readline()
        if not line:
                break
        end1,end2,obs=line.rstrip().split('\t')[0:3]
        group_length=(find_length_group(end1),find_length_group(end2))
        corr_length=frag_lambda[group_length]
        obs=int(obs)/corr_length
        if end1!=prev_frag:
                if prev_frag!=0:
                        print prev_frag+"\t"+str(sum)
                prev_frag=end1
                sum=obs
        else:
                sum+=obs
loop.close()
print prev_frag+"\t"+str(sum)

