#!/usr/bin/python

import sys

chromosize={}

with open(sys.argv[1],'r') as f:
	for line in f:
		chr,size=line.rstrip().split('\t')
		chromosize[chr]=size
f.close()

prev=""
i=1
with open(sys.argv[2],'r') as f:
	for line in f:
		chr,beg,end=line.rstrip().split('\t')
		if prev=="":
			print(chr+'\t'+'1'+'\t'+str(int(beg)+1)+'\t'+'frag_'+str(i))
			i+=1
		if prev==chr:
			print(chr+'\t'+str(prev_end-1)+'\t'+str(int(beg)+1)+'\t'+'frag_'+str(i))
			i+=1
		if prev!=chr and prev!="":
			print(prev+'\t'+str(prev_end-1)+'\t'+str(chromosize[prev])+'\t'+'frag_'+str(i))
			i+=1
			print(chr+'\t'+'1'+'\t'+str(int(beg)+1)+'\t'+'frag_'+str(i))
			i+=1
		prev=chr
		prev_end=int(end)
		
print(prev+'\t'+str(prev_end-1)+'\t'+str(chromosize[prev])+'\t'+'frag_'+str(i))

f.close()
