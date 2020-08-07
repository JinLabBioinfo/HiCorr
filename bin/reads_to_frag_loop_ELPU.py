#!/usr/bin/python

import sys

if len(sys.argv) != 5:
	print "./reads_to_frag_loop_ELPU.py <frag_pair> <reads_file> <experiment_name> <start_position>"
	print "<start_position>:if 'AGCTT' has been trimmed, then start_position=6; if 'AAGCTT' has been added to the sequence, then start_position=0" 
	sys.exit()

def find_frag(forward,reverse,strand,chr,start,len,start_bp):
	if chr not in forward:
		return 0
	if strand=="+":
		start=str(int(start)-start_bp)
		if start in forward[chr]:
			return forward[chr][start]
		else:
			return 0
	else:
		end=str(int(start)+int(len)-1+start_bp)
		if end in reverse[chr]:
			return reverse[chr][end]
		else:
			return 0

count=[0]*7	#list of count:[inward,outward,samestrand,samefrag,cis_nofrag,trans,trans_nofrag]
forward={}	#dictionary for searching strand=="+" fragment
reverse={}	#dictionary for searching strand=="-" fragment

name=sys.argv[3]
frag_pair=open(sys.argv[1])
for line in frag_pair.readlines():
	chr,start,end,id,length=line.rstrip().split('\t')
	if chr not in forward:
		forward[chr]={}
		reverse[chr]={}
	forward[chr][str(int(start)-3)]=id
	reverse[chr][str(int(end)+3)]=id
frag_pair.close()

reads_file=open(sys.argv[2])
start_bp=int(sys.argv[4])
inward=open(name+".loop.inward",'w')
outward=open(name+".loop.outward",'w')
samestrand=open(name+".loop.samestrand",'w')
samefrag=open(name+".loop.samefrag",'w')
cis_nofrag=open(name+".loop.nofrag",'w')
trans=open(name+".loop.trans",'w')
trans_nofrag=open(name+".loop.trans.nofrag",'w')
while True:
	line=reads_file.readline()
	if not line:
		break
	chr1,start1,strand1,chr2,start2,strand2,len1,len2=line.rstrip().split('\t')
	frag1=find_frag(forward,reverse,strand1,chr1,start1,len1,start_bp)
	frag2=find_frag(forward,reverse,strand2,chr2,start2,len2,start_bp)
	line_out=chr1+"\t"+start1+"\t"+strand1+"\t"+str(frag1)+"\t"+chr2+"\t"+start2+"\t"+strand2+"\t"+str(frag2)+"\n"
	if chr1==chr2:	#intra-chromosome pair
		if frag1==0 or frag2==0:	#either end cannot be mapped to HindIII fragment	
			cis_nofrag.write(line_out)
			count[4] += 1
		elif frag1==frag2:	#same-fragment pair
			samefrag.write(line_out)
			count[3] += 1
		else:
			if strand1==strand2:	#samestrand pair
				samestrand.write(line_out)
				count[2] += 1
			else:
				if int(start1)<int(start2):
					if strand1=='+':	#inward pair
						inward.write(line_out)
						count[0] += 1
					else:	#outward pair
						outward.write(line_out)
						count[1] += 1
				else:
					if strand1=='+':	#outward pair
						outward.write(line_out)
						count[1] += 1
					else:	#inward pair
						inward.write(line_out)
						count[0] += 1
	else:	#inter-chromosome pair
		if frag1==0 or frag2==0:	#either end cannot be mapped to HindIII fragment
			trans_nofrag.write(line_out)
			count[6] += 1
		else:
			trans.write(line_out)
			count[5] += 1
reads_file.close()
inward.close()
outward.close()
samestrand.close()
samefrag.close()
cis_nofrag.close()
trans.close()
trans_nofrag.close()

cis=sum(count[0:4])/2	#print counts
print "\ttotal_cis\tsamestrand\tinward\toutward\tself-circile\tcis_nofrag\ttotal_trans\ttrans_nofrag"
print name+"\t"+str(cis)+"\t"+str(count[2]/2)+"\t"+str(count[0]/2)+"\t"+str(count[1]/2)+"\t"+"\t".join([str(x/2) for x in count[3:]])
