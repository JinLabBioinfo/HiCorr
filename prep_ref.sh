#!/bin/bash

./get_group_range.pl hg19.HindIII.frag.bed 5 20 >group.frag_length.range
./list_frag_pairs.pl hg19.HindIII.frag.bed 2000000 | ./remove_outlier.py hg19.blacklist.frag >hg19.within_2Mb.frag_loop
cut -f4- hg19.HindIII.frag.bed >hg19.frag_length.temp
./count_trans_pairs_by_length.pl hg19.HindIII.frag.bed group.frag_length.range hg19.frag_length.temp >trans.group.count.by.length
rm hg19.frag_length.temp
