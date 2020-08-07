#!/usr/bin/python

import sys

start=int(sys.argv[1])-1
length=int(sys.argv[2])

i=1
for line in sys.stdin:
	if i==1:
			id,barcode=line.rstrip().split(' ')
			barcode=barcode.rstrip().split(':')
			print id+':'+barcode[-1][0:6]
	if i==2:
			line='AAGCTT'+line[start:(start+length)]
			print line.rstrip()
	if i==3:
                print line.rstrip()
        if i==4:
			line='JJJJJJ'+line[start:(start+length)]
			print line.rstrip()
	i=i+1
	if i>4:
		i=1

