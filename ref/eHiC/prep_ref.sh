#!/bin/bash

genome=$1

perl ./list_frag_pairs.pl $genome.HindIII.frag.bed 2000000 | python ./remove_outlier.py $genome.blacklist.ends >$genome.end_pairs.within_2Mb.filtered
