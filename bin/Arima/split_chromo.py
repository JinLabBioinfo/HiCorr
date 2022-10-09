#!/usr/bin/python

import sys
import os

dic={}

dir_name='HiCorr_output'

os.system('mkdir '+dir_name)



with open(sys.argv[1],'r') as f:

        for line in f:

                chr, beg, end, id = line.rstrip().split('\t')[0:4]
                dic[id] = chr

f.close()


out=open(os.path.join(dir_name, 'anchor_2_anchor.loop.chr1'),'w')

prev_chr='chr1'

for line in sys.stdin:

        a1, a2, obs, exp = line.rstrip().split('\t')[0:4]

        chr = dic[a1]

        if chr!=prev_chr:

                out.close()

                out=open(os.path.join(dir_name,'anchor_2_anchor.loop.'+chr),'w')

        out.write(line)
        prev_chr = chr


out.close()

f.close()

