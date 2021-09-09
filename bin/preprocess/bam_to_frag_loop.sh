#/bin/bash

bam_file=$1
name=$2
rdlen=$3	#read length
ref=$4
bin=$5
genome=$6
enzyme=$7

fragbed=$ref/$enzyme/$genome.$enzyme.frag.bed

samtools view $bam_file | cut -f2-8 | perl $bin/bam_to_temp_HiC.pl | perl $bin/reads_2_cis_frag_loop.pl $fragbed $rdlen $name.loop.inward $name.loop.outward $name.loop.samestrand $name &
samtools view $bam_file | cut -f2-8 | perl $bin/bam_to_temp_HiC.pl | perl $bin/reads_2_trans_frag_loop.pl $fragbed $rdlen $name.loop.trans &
wait

sed -i 's/BIN/$bin/g' $bin/resort_by_frag_id.pl
perl $bin/summary_sorted_frag_loop.pl $fragbed $name.loop.inward >temp.$name.loop.inward &
perl $bin/summary_sorted_frag_loop.pl $fragbed $name.loop.outward >temp.$name.loop.outward &
perl $bin/summary_sorted_frag_loop.pl $fragbed $name.loop.samestrand >temp.$name.loop.samestrand &
perl $bin/summary_sorted_trans_frag_loop.pl $name.loop.trans >temp.$name.loop.trans &
wait
mv temp.$name.loop.inward $name.loop.inward
mv temp.$name.loop.outward $name.loop.outward
mv temp.$name.loop.samestrand $name.loop.samestrand
mv temp.$name.loop.trans $name.trans.frag_loop

perl $bin/resort_by_frag_id.pl $fragbed $name.loop.inward $bin &
perl $bin/resort_by_frag_id.pl $fragbed $name.loop.outward $bin &
perl $bin/resort_by_frag_id.pl $fragbed $name.loop.samestrand $bin &
perl $bin/resort_by_frag_id.pl $fragbed $name.loop.trans $bin &
wait

awk '{if($4>1000)print $0}' $name.loop.inward >temp.$name.loop.inward &

if [[ $enzyme -gt HindIII ]]
then
	awk '{if($4>25000)print $0}' $name.loop.outward >temp.$name.loop.outward &
elif [[ $enzyme -gt DPNII ]]
then
	awk '{if($4>5000)print $0}' $name.loop.outward >temp.$name.loop.outward &
fi
wait

mv temp.$name.loop.inward $name.loop.inward
mv temp.$name.loop.outward $name.loop.outward

perl $bin/merge_sorted_frag_loop.pl $name.loop.inward $name.loop.outward $name.loop.samestrand >$name.cis.frag_loop
rm $name.loop.inward $name.loop.outward $name.loop.samestrand
