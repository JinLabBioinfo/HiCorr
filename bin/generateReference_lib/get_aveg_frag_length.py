#!/usr/bin/python


from __future__ import division

import sys
import os


""" frag anchor bed """

dic={}

with open(sys.argv[1],'r') as f:

	for line in f:

		frag, anchor = line.rstrip().split('\t')

		if anchor not in dic:

			dic[anchor] = set()

		dic[anchor].add(frag)

f.close()


"""DpnII anchor bed file """

with open(sys.argv[2],'r') as f:

	for line in f:

		chr, beg, end, anchor, length = line.rstrip().split('\t')

		frag_count = len(dic[anchor])

		avg = float(length)/frag_count
	
		


		print '\t'.join([chr, beg, end, anchor, length, str(avg)])


f.close()









	
