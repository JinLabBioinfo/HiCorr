#!/bin/bash

./list_frag_pairs.pl hg19.HindIII.frag.bed 2000000 | ./remove_outlier.py hg19.blacklist.frag >hg19.within_2Mb.frag_pair
./count_trans_pairs_by_length.pl hg19.HindIII.frag.bed group.frag_length.range hg19.frag.length.map >trans.group.count.by.length
./count_trans_pairs_by_length.pl hg19.HindIII.frag.bed group.frag_GC.range hg19.frag.gc.map >trans.group.count.by.GC
./get_map_5kb_window.pl hg19.HindIII.frag.bed >frag.2.all.5kb.anchor
