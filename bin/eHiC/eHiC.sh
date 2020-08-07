#!/bin/bash

if [ "$#" -ne 6 ]; then
        echo "Usage: ./eHiC.sh <ref> <bin> <cis_loop> <trans_loop> <name> <genome>"
        exit 2;
fi

ref=$1
bin=$2
cis_loop=$3
trans_loop=$4
name=$5
genome=$6

#-----------------------------------------------distance & length---------------------------------------------------------------------------------#
$bin/remove_outlier_ELPU.py $ref/$genome.blacklist.ends $cis_loop | $bin/remove_ends_without_HD.py $ref/$genome.frag.end.GC.map | awk '{if($4<=2000000)print $0}' >$name.loop.within_2Mb.filtered
$bin/merge_and_resort_end_loop.py $ref/$genome.HindIII.frag.ends.bed $name $name.loop.within_2Mb.filtered $ref/$genome.end_pairs.within_2Mb.filtered >end_loop.$name.within_2Mb.full
$bin/get_group_statistics.pl end_loop.$name.within_2Mb.full $ref/$genome.HindIII.frag.ends.bed $ref/$genome.group.frag_length.range $ref/group.frag_dist.range $ref/$genome.frag.end.GC.map >loop_statistics.by_group.$name
rm $name.loop.within_2Mb.filtered
rm -r temp.$name

#---------------------------------------------GC content------------------------------------------------------------------------------------------#
cat $trans_loop | $ref/remove_outlier.py $ref/$genome.blacklist.ends | $bin/remove_ends_without_HD.py $ref/$genome.frag.end.GC.map >$name.trans_loop.without.blacklist
$bin/get_trans_avg_by_GC.pl $name.trans_loop.without.blacklist $ref/$genome.group.frag_GC.range $ref/$genome.frag.end.GC.map $ref/$genome.count.trans.end_pair.by.GC 0 >$name.avg_trans_count.by.GC_group
$bin/get_corr_factor_by_GC.pl $name.avg_trans_count.by.GC_group > $name.lambda_correction.by.GC_group

#--------------------------------------------HD correction----------------------------------------------------------------------------------------#
$bin/get_trans_avg_by_GC.pl $name.trans_loop.without.blacklist $ref/$genome.HD.20.group $ref/$genome.frag.end.HD.map $ref/$genome.count.trans.end_pair.by.HD 0 >$name.avg_trans_count.by.HD_group
$bin/get_corr_factor_by_GC.pl $name.avg_trans_count.by.HD_group > $name.lambda_correction.by.HD_group

#-------------------------------------------visibility-------------------------------------------------------------------------------------------#
$bin/get_trans_avg_by_GC.pl $name.trans_loop.without.blacklist $ref/$genome.group.frag_length.range $ref/$genome.frag.end.HH.map $ref/$genome.count.trans.end_pair.by.HH 0 >$name.avg_trans_count.by.HH_group
$bin/get_corr_factor_by_GC.pl $name.avg_trans_count.by.HH_group > $name.lambda_correction.by.HH_group
$bin/correct_trans_reads_eHiC.py $ref/$genome.frag.end.HD.map $ref/$genome.frag.end.GC.map $ref/$genome.frag.end.HH.map $name.lambda_correction.by.HD_group $name.lambda_correction.by.GC_group $name.lambda_correction.by.HH_group $ref/$genome.HD.20.group $ref/$genome.group.frag_GC.range $ref/$genome.group.frag_length.range $name.trans_loop.without.blacklist | $bin/sum_frag_reads_2.py >$name.end.trans_reads.sum

$bin/get_loop_lambda.pl end_loop.$name.within_2Mb.full $ref/$genome.HindIII.frag.ends.bed $ref/$genome.frag.end.GC.map $ref/$genome.group.frag_length.range $ref/group.frag_dist.range loop_statistics.by_group.$name | $bin/get_loop_lambda_GC_correct.pl - $ref/$genome.group.frag_GC.range $ref/$genome.frag.end.GC.map $name.lambda_correction.by.GC_group | $bin/get_loop_lambda_GC_correct.pl - $ref/$genome.HD.20.group $ref/$genome.frag.end.HD.map $name.lambda_correction.by.HD_group | $bin/test_frag_corr_eHiC.py $name.end.trans_reads.sum $ref/$genome.frag.end.GC.map - >$name.end_loop.normalized
$bin/ends_count_to_frag_count.py $name.end_loop.normalized >$name.frag_loop

ln -s $ref/$genome.HindIII.frag.bed
ln -s $ref/$genome.frag.2.all.5kb.anchor
cp $bin/fragdata_to_anchordata.pl $bin/batch_anchor_by_chrom.pl $bin/get_anchor_pval.r ./
./batch_anchor_by_chrom.pl $genome.HindIII.frag.bed $name.frag_loop $genome.frag.2.all.5kb.anchor
for i in {1..22} X Y;do
        cat temp.by.chrom/anchor_2_anchor.loop.chr$i.p_val >> anchor_2_anchor.loop.p_val.$name
done
rm end_loop.$name.within_2Mb.full $name.trans_loop.without.blacklist $name.frag_loop *lambda* $genome.HindIII.frag.bed loop_statistics.by_group.$name frag.2.all.5kb.anchor fragdata_to_anchordata.pl batch_anchor_by_chrom.pl get_anchor_pval.r

