#!/bin/bash
### prepare: ######################################################################################
fq1=$1
fq2=$2
name=$3 # outputname as prefix
hg19=hg19btIndex/hg19 # hg19 bowtieIndex
hg19fai=hg19_bowtie2Index/hg19.fa.fai
lib=HiCorr/bin/preprocess/ 
bed=DPNII_HiCorr_ref/hg19.DPNII.frag.bed

# If you have two sorted bam files (R1 and R2, bam sort by read name), go to step3
# If you have one sorted bam file (R1 and R2 bam are paired already, and paired bam is sorted by coordinates), go to step4
###################################################################################################
### Note: you can use different mapper and read length for mapping ################################
# 1. mapping, take 50bp for mapping
cat $fq1 | $lib/reformat_fastq.py 1 50 | bowtie -v 3 -m 1 --best --strata --time -p 10 --sam $hg19 - > $name.R1.sam &
cat $fq2 | $lib/reformat_fastq.py 1 50 | bowtie -v 3 -m 1 --best --strata --time -p 10 --sam $hg19 - > $name.R2.sam &
wait
# 2. sam to sorted bam 
echo Total reads count for $name is `samtools view $name.R1.sam | grep -vE ^@ | wc -l | awk '{OFMT="%f"; print $1}'` >> summary.total.read_count &
samtools view -u $name.R1.sam | samtools sort -@ 12 -n -T $name.R1 -o $name.R1.sorted.bam  &
samtools view -u $name.R2.sam | samtools sort -@ 12 -n -T $name.R2 -o $name.R2.sorted.bam  &
wait
# 3. pair two sam & sort
$lib/pairing_two_SAM_reads.pl <(samtools view $name.R1.sorted.bam) <(samtools view $name.R2.sorted.bam) | samtools view -bS -t $hg19fai -o - - > $name.bam
echo Uniquely mapped read pairs for $name is `samtools view $name.bam | wc -l | awk '{OFMT="%f"; print $1/2}'` >> summary.total.read_count  &
samtools sort -@ 10 -m 4G -n -T $name -o $name.sorted.bam $name.bam 
# 4. remove dups
samtools view $name.sorted.bam | $lib/remove_dup_PE_SAM_sorted.pl | samtools view -bS -t $hg19fai -o - - > $name.sorted.nodup.bam
echo Total non-duplicated read pairs for $name is `samtools view $name.sorted.nodup.bam | wc -l | awk '{OFMT="%f"; print $1/2}'` >> summary.total.read_count
# 5. categorize reads pair and map them to Airma fragment pairs
samtools view $name.sorted.nodup.bam | cut -f2-8 | $lib/bam_to_temp_HiC.pl > $name.temp
$lib/reads_2_cis_frag_loop.pl $bed 50 $name.loop.inward $name.loop.outward $name.loop.samestrand $name $name.temp & # 50 is read length for mapping
$lib/reads_2_trans_frag_loop.pl $bed 50 $name.loop.trans $name.temp & # 50 is read length for mapping
wait
for file in $name.loop.inward $name.loop.outward $name.loop.samestrand;do
        cat $file | $lib/summary_sorted_frag_loop.pl $bed  > temp.$file &
done
cat $name.loop.trans | $lib/summary_sorted_trans_frag_loop.pl - > temp.$name.loop.trans &
wait
for file in $name.loop.inward $name.loop.outward $name.loop.samestrand;do
        $lib/resort_by_frag_id.pl $bed temp.$file $lib &
done
wait
# 6. filter the fragment pairs:
cat temp.$name.loop.inward | awk '{if($4>1000)print $0}' > temp.$name.loop.inward.filter &
cat temp.$name.loop.outward | awk '{if($4>5000)print $0}' > temp.$name.loop.outward.filter &
wait 
# 7. merge fragment pairs (Note if you have multiple biological reps, run the first 6 steps for each rep, and merge in step 7)
$lib/merge_sorted_frag_loop.pl temp.$name.loop.samestrand temp.$name.loop.inward.filter temp.$name.loop.outward.filter > frag_loop.$name.cis &
$lib/merge_sorted_frag_loop.pl temp.$name.loop.trans > frag_loop.$name.trans &
wait 
echo $name "trans:" `cat frag_loop.$name.trans | awk '{sum+=$3}END{print sum/2}'` "cis:" `cat frag_loop.$name.cis | awk '{sum+=$3}END{print sum/2}'` "cis2M:" `cat frag_loop.$name.cis | awk '{if($4<=2000000)print}' | awk '{sum+=$3}END{print sum/2}'` >> summary.total.read_count 
# 8. clean UP, frag_loop.$expt.cis and frag_loop.$name.trans are the input files for HiCorr 
rm -f temp.$name.loop.inward.filter temp.$name.loop.outward.filter temp.$name.loop.inward temp.$name.loop.outward


