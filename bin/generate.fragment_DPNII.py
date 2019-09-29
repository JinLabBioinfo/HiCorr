#!/usr/bin/python


import sys
import os


def print_info(id, val):

		if type(val) is str:
			array = []
			array.append(val)
		else:
			array = val

		for frag in array:

			print frag + '\t' + id





curr_chr = 'chr1'

index = 1
resolution = int(sys.argv[2])

curr_beg, curr_end, curr_len = 0,0,0

anchor = open('anchor.bed','w')

frag_to_anchor = open('frag_to_anchor','w')

prev_len = 0

frag_list = []

with open(sys.argv[1],'r') as f:

	for line in f:
		chr, beg, end, frag, length = line.rstrip().split('\t')
		
		length = int(length)
		#frag_list.append(frag)
		if curr_chr != chr :
		
			if len(frag_list)!=0:
			
				anchor.write(curr_chr+'\t'+curr_beg+'\t'+curr_end+'\t'+'A_'+str(index)+'\t'+str(curr_len)+'\n')

				print_info('A_'+str(index), frag_list)

				frag_to_anchor.write('A_'+str(index) + '\t' + ','.join(frag_list) + '\n')

				curr_chr, curr_beg, curr_end = chr, beg, end
				frag_list = []
	
				index += 1

				curr_len = 0
			else:
				curr_chr, curr_beg, curr_end = chr, beg, end
				frag_list = []
				
				
		"""if the first one is > resolution"""
		if curr_len == 0  and length >= resolution:

			
			anchor.write(curr_chr+'\t'+beg+'\t'+end+'\t'+'A_'+str(index)+'\t'+ str(length) +'\n')
			#print_info(index, frag)
	 		frag_to_anchor.write('A_'+str(index) + '\t' + frag + '\n')	

			print_info('A_'+str(index), frag)
			
			index += 1
	
			curr_beg = str(int(end)+1)
			frag_list = []

			continue
		""" document the previous value"""

		prev_len = curr_len
		curr_len += length
		curr_end = end
		frag_list.append(frag)		
		"""if the previous is close to resolution, just stop"""
		if prev_len <= resolution and curr_len > resolution:

			anchor.write(curr_chr+'\t'+curr_beg+'\t'+str(int(beg)-1)+'\t'+'A_'+str(index) +'\t'+str(prev_len)+'\n')
			print_info('A_'+str(index),frag_list[0:(len(frag_list)-1)])
			frag_to_anchor.write('A_'+str(index) + '\t' + ','.join(frag_list[0:(len(frag_list)-1)]) + '\n')
			#print_info(index,frag_list[0:(len(frag_list)-1)])
			index += 1
		
			#curr_beg = beg
			
			#curr_len = length 
			frag_list = []
			"""length over resolution directly output"""	
			if length >= resolution:

				anchor.write(curr_chr+'\t'+beg+'\t'+end+'\t'+'A_'+str(index)+'\t' +str(length) +'\n')
				#print_info(index, tem_frag_list)
				frag_to_anchor.write('A_'+str(index) + '\t' + frag + '\n')
				print_info('A_'+str(index),frag)
				index += 1
				curr_len = 0
				#tem_frag_list = []
				curr_beg = str(int(end)+1)
			else:

				#frag_list = []
				frag_list.append(frag)
				curr_len = length
				curr_beg = beg
f.close()

anchor.close()	
				
frag_to_anchor.close()









			
			
