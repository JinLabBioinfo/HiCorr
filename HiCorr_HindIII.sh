#!/bin/bash

ref=$1
bin=$2
cis_loop=$3
trans_loop=$4
name=$5
genome=$6

cat $cis_loop | $bin/remove_outlier.py $ref/$genome.blacklist.frag | awk '{if($4<=2000000)print $0}' > $name.loop.between.frag.within_2Mb
$bin/merge_sorted_frag_loop.pl $name.loop.between.frag.within_2Mb $ref/$genome.frag_pairs.within_2Mb.without.blacklist >$name.loop.between.frag.within_2Mb.full
cat $trans_loop | $bin/remove_outlier.py $ref/$genome.blacklist.frag >frag_loop.$name.trans.without_blacklist
$bin/get_group_statistics.pl $name.loop.between.frag.within_2Mb.full $ref/$genome.HindIII.frag.bed $ref/$genome.group.frag_length.range $ref/group.frag_dist.range $ref/$genome.HindIII_frag.stat >group.statistics
$bin/get_cis_avg_by_GC.pl frag_loop.$name.trans.without_blacklist $ref/$genome.group.frag_GC.range $ref/$genome.HindIII_frag.stat $ref/$genome.count.trans.frag_loop.by.GC_group.list 0.2 >avg_count.by.trans.GC
$bin/get_cis_avg_by_GC.pl frag_loop.$name.trans.without_blacklist $ref/$genome.group.frag_length.range $ref/$genome.frag.length.map $ref/$genome.count.trans.frag_loop.by_length.group 0.2 >avg_count.by.length

$bin/get_corr_factor_by_GC.pl avg_count.by.length >lambda.by.length
$bin/get_corr_factor_by_GC.pl avg_count.by.trans.GC >lambda.by.trans.GC

$bin/correct_tran_reads.py $ref/$genome.HindIII_frag.stat $ref/$genome.frag.length.map lambda.by.trans.GC lambda.by.length $ref/$genome.group.frag_GC.range $ref/$genome.group.frag_length.range frag_loop.$name.trans.without_blacklist | $bin/sum_frag_reads_2.py >frag.reads.sum
$bin/get_loop_lambda.pl $name.loop.between.frag.within_2Mb.full $ref/$genome.HindIII.frag.bed $ref/$genome.HindIII_frag.stat $ref/$genome.group.frag_length.range $ref/group.frag_dist.range group.statistics | $bin/get_loop_lambda_GC_correct.pl - $ref/$genome.group.frag_GC.range $ref/$genome.HindIII_frag.stat lambda.by.trans.GC | $bin/test_frag_corr.py frag.reads.sum $ref/$genome.HindIII_frag.stat >$name.frag_loop.normalized

ln -s $ref/$genome.HindIII.frag.bed
ln -s $ref/$genome.frag.2.all.5kb.anchor
cp $bin/fragdata_to_anchordata.pl $bin/batch_anchor_by_chrom.pl $bin/get_anchor_pval.r ./
./batch_anchor_by_chrom.pl $genome.HindIII.frag.bed $name.frag_loop.normalized $genome.frag.2.all.5kb.anchor
#for i in {1..22} X Y;do
#        cat temp.by.chrom/anchor_2_anchor.loop.chr$i.p_val >> anchor_2_anchor.loop.p_val.$name
#done
mkdir HiCorr_output
mv temp.by.chrom/anchor_2_anchor.loop* HiCorr_output/
rm -rf temp.by.chrom
rm -f $genome.HindIII.frag.bed $genome.frag.2.all.5kb.anchor fragdata_to_anchordata.pl batch_anchor_by_chrom.pl get_anchor_pval.r $name.loop.between.frag.within_2Mb $name.loop.between.frag.within_2Mb.full frag_loop.$name.trans.without_blacklist frag.reads.sum $name.frag_loop.normalized 
