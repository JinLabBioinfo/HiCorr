#!/bin/bash

ref=$1
bin=$2
cis_loop=$3
trans_loop=$4
name=$5
genome=$6

#-----------------------------------------------distance & length---------------------------------------------------------------------------------#
$bin/merge_and_resort_end_loop.py $ref/$genome.HindIII.frag.ends.bed $cis $genome.end_pairs.within_2Mb.filtered >end_loop.$name.within_2Mb.full
$bin/get_group_statistics.pl end_loop.$name.within_2Mb.full $ref/$genome.HindIII.frag.ends.bed $ref/group.frag_length.range $ref/group.frag_dist.range $ref/$genome.frag.end.GC.map >loop_statistics.by_group.$name
$bin/get_loop_lambda.pl end_loop.$name.within_2Mb.full $ref/$genome.HindIII.frag.ends.bed $ref/$genome.frag.end.GC.map $ref/group.frag_length.range $ref/group.frag_dist.range loop_statistics.by_group.$name >$name.loop.between.end.after_length_dist
rm end_loop.$name.within_2Mb.full loop_statistics.by_group.$name

#---------------------------------------------GC content------------------------------------------------------------------------------------------#
cat $trans_loop | $ref/remove_outlier.py $ref/$genome.blacklist.end >$name.trans_loop.without.blacklist
$bin/get_trans_avg_by_GC.pl $name.trans_loop.without.blacklist $ref/group.frag_GC.range $ref/$genome.frag.end.GC.map $ref/trans.group.count.by.GC 0.2 >avg_trans_count.by.GC_group
$bin/get_corr_factor_by_GC.pl avg_trans_count.by.GC_group > lambda_correction.by.GC_group
$bin/get_loop_lambda_GC_correct.pl $name.loop.between.end.after_length_dist $ref/group.frag_GC.range $ref/$genome.frag.end.GC.map lambda_correction.by.GC_group >$name.loop.between.end.after_GC
rm $name.loop.between.end.after_length_dist avg_trans_count.by.GC_group



