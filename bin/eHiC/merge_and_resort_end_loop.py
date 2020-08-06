#!/usr/bin/python

import sys
import os

if len(sys.argv)<4:
	print "Usage: ./merge_and_resort_end_loop.py <end_bed> <name> <end_loop> <full_end_pair>"
	sys.exit()

end_bed=open(sys.argv[1])
chrs={}
order={}
i=1
for line in end_bed.readlines():
	chr,start,end,id,length=line.rstrip().split('\t')
	chrs[id]=chr
	order[id]=i
	i+=1
end_bed.close()

dir_name="temp."+sys.argv[2]
os.system("mkdir "+dir_name)

chr_list=[]
prev_chr="chr1"
out=open(dir_name+"/end_loop.chr1",'a')
loop=open(sys.argv[3])
while True:
	line=loop.readline()
	if not line:
		break
	end1,end2,reads,dist=line.rstrip().split('\t')
	chr=chrs[end1]
	if chr!=prev_chr:
		out.close()
		chr_list.append(prev_chr)
		prev_chr=chr
		out=open(dir_name+"/end_loop."+chr,'a')
	out.write(line)
loop.close()
out.close()
chr_list.append(prev_chr)

full_pair=open(sys.argv[4])
prev_chr="chr1"
dic_loop={}
file=open(dir_name+"/end_loop."+prev_chr)
while True:
	line=file.readline()
	if not line:
		break
	end1,end2,reads,dist=line.rstrip().split('\t')
	dic_loop[(end1,end2)]=reads
file.close()

while True:
	line=full_pair.readline()
	if not line:
		break
	end1,end2,reads,dist=line.rstrip().split('\t')
	chr=chrs[end1]
	if chr!=prev_chr:
		dic_loop.clear()
		prev_chr=chr
		file=open(dir_name+"/end_loop."+prev_chr)
		while True:
        		line=file.readline()
        		if not line:
	                	break
        		end1,end2,reads,dist=line.rstrip().split('\t')
        		dic_loop[(end1,end2)]=reads
		file.close()
	if (end1,end2) in dic_loop:
		print end1+"\t"+end2+"\t"+dic_loop[(end1,end2)]+"\t"+dist
	else:
		print line.rstrip()
full_pair.close()
		
#os.system("rm -r "+dir_name)
