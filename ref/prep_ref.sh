#!/bin/bash

genome=$1

./list_frag_pairs.pl $genome.HindIII.frag.bed 2000000 | ./remove_outlier.py $genome.blacklist.frag >$genome.within_2Mb.frag_pair
./count_trans_pairs_by_length.pl $genome.HindIII.frag.bed $genome.group.frag_length.range $genome.frag.length.map >trans.group.count.by.length
./count_trans_pairs_by_length.pl $genome.HindIII.frag.bed $genome.group.frag_GC.range $genome.frag.gc.map >trans.group.count.by.GC
./get_map_5kb_window.pl $genome.HindIII.frag.bed >frag.2.all.5kb.anchor
