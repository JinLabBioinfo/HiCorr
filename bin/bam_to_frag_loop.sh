#/bin/bash

bam_file=$1
name=$2
rdlen=$3	#read length

ref=$4
bin=$5

samtools view $bam_file | cut -f2-8 | $bin/bam_to_temp_HiC.pl | $bin/reads_2_cis_frag_loop.pl $ref/hg19.HindIII.frag.bed $rdlen $name.loop.inward $name.loop.outward $name.loop.samestrand $name &
samtools view $bam_file | cut -f2-8 | $bin/bam_to_temp_HiC.pl | $bin/reads_2_trans_frag_loop.pl $ref/hg19.HindIII.frag.bed $rdlen $name.loop.trans &
wait

sed -i 's/BIN/$bin/g' $bin/resort_by_frag_id.pl
$bin/summary_sorted_frag_loop.pl $ref/hg19.HindIII.frag.bed $name.loop.inward >temp.$name.loop.inward &
$bin/summary_sorted_frag_loop.pl $ref/hg19.HindIII.frag.bed $name.loop.outward >temp.$name.loop.outward &
$bin/summary_sorted_frag_loop.pl $ref/hg19.HindIII.frag.bed $name.loop.samestrand >temp.$name.loop.samestrand &
$bin/summary_sorted_trans_frag_loop.pl $name.loop.trans >temp.$name.loop.trans &
wait
mv temp.$name.loop.inward $name.loop.inward
mv temp.$name.loop.outward $name.loop.outward
mv temp.$name.loop.samestrand $name.loop.samestrand
mv temp.$name.loop.trans $name.trans.frag_loop

$bin/resort_by_frag_id.pl $ref/hg19.HindIII.frag.bed $name.loop.inward  &
$bin/resort_by_frag_id.pl $ref/hg19.HindIII.frag.bed $name.loop.outward  &
$bin/resort_by_frag_id.pl $ref/hg19.HindIII.frag.bed $name.loop.samestrand  &
$bin/resort_by_frag_id.pl $ref/hg19.HindIII.frag.bed $name.loop.trans  &
wait

awk '{if($4>1000)print $0}' $name.loop.inward >temp.$name.loop.inward &
awk '{if($4>25000)print $0}' $name.loop.outward >temp.$name.loop.outward &
wait
mv temp.$name.loop.inward $name.loop.inward
mv temp.$name.loop.outward $name.loop.outward

$bin/merge_sorted_frag_loop.pl $name.loop.inward $name.loop.outward $name.loop.samestrand >$name.cis.frag_loop
rm $name.loop.inward $name.loop.outward $name.loop.samestrand
