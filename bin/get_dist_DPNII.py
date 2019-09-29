#!/usr/bin/python

import sys


""" 
This code is going to get the distance between anchor pairs

"""

bed={}

with open(sys.argv[1], 'r') as f:
	
	for line in f:

		chr, beg, end , anchor = line.rstrip().split('\t')[0:4]

		bed[anchor]=map(int, [beg,end])

f.close()

for line in sys.stdin:

	a1, a2 = line.rstrip().split('\t')[0:2]

	id1, id2 = map(lambda x:int(x.split('_')[1]),[a1, a2])

	if id1 > id2:

		dist = bed[a1][0] - bed[a2][1] - 1

	else:

		dist = bed[a2][0] - bed[a1][1] - 1

	print line.rstrip() + '\t' + str(dist)




	

