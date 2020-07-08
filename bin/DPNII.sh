#!/usr/bin/bash

# Copyright 2019 Jin Lab

# The script is used to perform the 4-base cutter Hi-C data, processing from the raw data (.fastq).

# [topDir]/fastq - Should contain the fastq files. This code assumes that there is "_R.fastq "
#		  inside the folder. i.e. *_R*.fastq

# [topDir]/process - Where to write the restore the output file from the bowtie and samtools

# [topDir]/loops - where to write the frag pairs which mapped from the reads.

# bin - Where the scripts and references files located
bin=$1
# top level directory, can also be set in option
topDir=$(pwd)
# restriction enzyme, can also be set in options
site="DpnII"
# genome ID, default to human, can also be set in options
genomeID="hg19"

process=${topDir}/process
loops=${topDir}/loops

# create the process folder 
if [ ! -d $process ]; then

	mkdir "$process"
fi

# create the loops folder

if [ ! -d $loops ]; then

        mkdir "$loops"
fi
# select for user
while getopts "d:g:hs:p:y:z:m:D:b:" opt; do
    case $opt in
        g) genomeID=$OPTARG ;;
        h) printHelpAndExit 0;;
        d) topDir=$OPTARG ;;
        s) site=$OPTARG ;;
        p) genomePath=$OPTARG ;;
        y) site_file=$OPTARG ;;
        z) refSeq=$OPTARG ;;
        m) bowtie=$OPTARG ;;
        D) bin=$OPTARG ;;
        b) ligation=$OPTARG ;;
        [?]) printHelpAndExit 1;;
    esac
done

## Set reference sequence based on genome ID
case $genomeID in
        
        mm10) refSeq="${bin}/references/mm10_BowtieIndex/mm10";;
        hg19) refSeq="${bin}/references/hg19_BowtieIndex/genome";;

        *)  echo "$usageHelp"
            echo "$genomeHelp"
            exit 1
esac


cat ${topDir}/fastq/*_R1.fastq > ${process}/merged_R1.fastq & 
cat ${topDir}/fastq/*_R2.fastq > ${process}/merged_R2.fastq &

wait

# Map fastq files to reference genomes

length=`head ${process}/merged_R1.fastq | tail -1 | wc -m`
let length=$length-1

if [[ $length -gt 36 ]];then
# trim length. $2 need to be the length of sequence reads
# bowtie mapping, ONE CPU each process
	let trlen=$length-36
        rdlen=36
        
	$bowtie -v 3 -m 1 --trim3 $trlen --best --strata --time -p 1 --sam $refSeq ${process}/merged_R1.fastq ${process}/merged_R1.sam &
        $bowtie -v 3 -m 1 --trim3 $trlen --best --strata --time -p 1 --sam $refSeq ${process}/merged_R2.fastq ${process}/merged_R2.sam &
else
        rdlen=$length
        $bowtie -v 3 -m 1 --best --strata --time -p 1 --sam $refSeq ${process}/merged_R1.fastq ${process}/merged_R1.sam &
        $bowtie -v 3 -m 1 --best --strata --time -p 1 --sam $refSeq ${process}/merged_R2.fastq ${process}/merged_R2.sam &
fi

wait

# Document the reads number after mapping

echo Total reads count for merged is `samtools view -c ${process}/merged_R1.sam` >> ${process}/summary.total.read_count &

# Pair two sam file into one bam file
# Users are required to add your local .fa.fai files into the reference folder.

case $genomeID in

        mm10) refSeq="${bin}/ref/mm10.fa.fai";;
        hg19) refSeq="${bin}/ref/hg19.fa.fai";;

        *)  echo "$usageHelp"
            echo "$genomeHelp"
            exit 1
esac


${bin}/bin/pairing_two_SAM_reads_DPNII.pl ${process}/merged_R1.sam ${process}/merged_R2.sam | samtools view -bS -t $refSeq -o - - > ${process}/merged.bam &

wait

echo Uniquely mapped read pairs for merged is `samtools view -c ${process}/merged.bam` >> ${process}/summary.total.read_count &

# remove duplications from the paired bam files
samtools sort ${process}/merged.bam | samtools view - | ${bin}/bin/remove_dup_PE_SAM_sorted_DPNII.pl | samtools view -bS -t $refSeq -o - - > ${process}/merged.sorted.nodup.bam &

wait

echo Total non-duplicated read pairs is `samtools view -c ${process}/merged.sorted.nodup.bam` >> ${process}/summary.total.read_count

echo -ne read_summary_file\\ttotal_inter\\ttotal_intra\\ttotal_samestrand\\tloop_samestrand\\tloop_inward\\tloop_outward\\n >> ${loops}/summary.frag_loop.read_count

samtools view ${process}/merged.sorted.nodup.bam | cut -f2-8 | ${bin}/bin/bam_to_temp_HiC_DPNII.pl > ${process}/merged.temp

wait 

# select the frag bed reference file

case $genomeID in

        mm10) fragbed="${bin}/ref/mm10.DPNII.frag.bed";;
        hg19) fragbed="${bin}/ref/hg19.DPNII.frag.bed";;

        *)  echo "$usageHelp"
            echo "$genomeHelp"
            exit 1
esac

# Map reads to fragment pairs
${bin}/bin/reads_2_cis_frag_loop_DPNII.pl $fragbed $rdlen ${loops}/merged.loop.inward ${loops}/merged.loop.outward ${loops}/merged.loop.samestrand ${loops}/summary.frag_loop.read_count merged ${process}/merged.temp &

${bin}/bin/reads_2_trans_frag_loop_DPNII.pl $fragbed $rdlen ${loops}/temp.merged.trans.loop ${process}/merged.temp &

${bin}/bin/reads_2_trans_frag_loop_DPNII.pl $fragbed $rdlen ${loops}/merged.trans.loop ${process}/merged.temp &
wait

# Step2 : summary the inward and outward fragments

for file in `ls ${loops}/*.loop.* | grep -v trans`;do       #inward,outward,samestrand

        ${bin}/bin/summary_sorted_frag_loop_DPNII.pl $fragbed $file > ${file}.temp
done &
wait

cat ${loops}/*.samestrand.temp > ${loops}/frag_loop.merged.samestrand &
cat ${loops}/*.inward.temp | awk '{if($4>1000)print $0}' > ${loops}/frag_loop.merged.inward  &
cat ${loops}/*.outward.temp | awk '{if($4>5000)print $0}' > ${loops}/frag_loop.merged.outward &


${bin}/bin/summary_sorted_trans_frag_loop_DPNII.pl ${loops}/temp.merged.trans.loop > ${loops}/merged.trans.loop &
wait
# Merge all the cis pairs together
${bin}/bin/merge_sorted_frag_loop_DPNII.pl ${loops}/frag_loop.merged.samestrand ${loops}/frag_loop.merged.inward ${loops}/frag_loop.merged.outward >${loops}/frag_loop.merged &

# assign the frag pairs to anchor pairs
wait
${bin}/bin/fragdata_to_anchordata_DPNII.pl ${loops}/frag_loop.merged ${bin}/ref/${genomeID}_DpnII_frag_2_anchor > ${loops}/end_loop.cis &

${bin}/bin/fragdata_to_anchordata_DPNII.pl ${loops}/merged.trans.loop ${bin}/ref/${genomeID}_DpnII_frag_2_anchor > ${loops}/end_loop.trans &

wait

norm=${topDir}/norm

if [ ! -d $norm ];then

	mkdir $norm

fi

# Step3 : start to do the normalization

# Extract the cis loops within 2M and remove the blacklist

anchorbed=${bin}/ref/${genomeID}_DpnII_anchors_avg.bed

cat ${loops}/end_loop.cis |${bin}/bin/remove.blacklist_DPNII.py ${bin}/ref/${genomeID}_5kb_anchors_blacklist |${bin}/bin/get_dist_DPNII.py $anchorbed | awk '{if($4<=2000000) print $0}' > ${norm}/end_loop.2M.rmbl
cat ${loops}/end_loop.cis |${bin}/bin/remove.blacklist_DPNII.py ${bin}/ref/${genomeID}_5kb_anchors_blacklist |${bin}/bin/get_dist_DPNII.py $anchorbed | awk '{if($4>2000000) print $0}' > ${norm}/end_loop.gt.2M

cat ${loops}/end_loop.trans |${bin}/bin/remove.blacklist_DPNII.py ${bin}/ref/${genomeID}_5kb_anchors_blacklist > ${norm}/end_loop.rmbl.trans 

wait

# merged trans and reads over 2M

cat ${norm}/end_loop.gt.2M ${norm}/end_loop.rmbl.trans | cut -f1-3 > ${norm}/end_loop.merged.trans

wait

# Form the full matrix

${bin}/bin/merge_sorted_anchor_loop_DPNII.pl ${bin}/ref/${genomeID}.full.matrix ${norm}/end_loop.2M.rmbl > ${norm}/end_loop.full &

${bin}/bin/get_trans.avg_by_len_DPNII.pl ${norm}/end_loop.merged.trans ${bin}/ref/${genomeID}_anchor_length.groups $anchorbed ${bin}/ref/${genomeID}.trans.possible.pairs > ${norm}/trans.stat &

wait

${bin}/bin/get_corr_factor_by_len_DPNII.py ${norm}/trans.stat > ${norm}/len.factor &

${bin}/bin/correct.trans.reads.by.corr_DPNII.pl ${norm}/end_loop.merged.trans $anchorbed ${bin}/ref/${genomeID}_anchor_length.groups ${norm}/len.factor > ${norm}/trans.corr.by.all &

wait

${bin}/bin/sum_anchor_reads_DPNII.py ${norm}/trans.corr.by.all > ${norm}/anchors.sum &
wait

avg=`cat ${norm}/anchors.sum | awk '{s+=$2;n++}END{print s/n}'`

#

cat ${norm}/anchors.sum | awk -v avg=$avg '{print $1,$2/avg}' OFS='\t'  > ${norm}/anchor.vis.list


wait

${bin}/bin/get_group_statistics_DPNII.pl ${norm}/end_loop.full $anchorbed ${bin}/references/${genomeID}_anchor_length.groups ${bin}/ref/${genomeID}.dist.401.group > ${norm}/dist.len.stat 

wait

${bin}/bin/get_loop_lambda_DPNII.pl ${norm}/end_loop.full $anchorbed ${bin}/ref/${genomeID}_anchor_length.groups ${bin}/ref/${genomeID}.dist.401.group ${norm}/dist.len.stat > ${norm}/end_loop.after.dist.len

wait

${bin}/bin/add.vis.to.cis.2M_DPNII.pl ${norm}/end_loop.after.dist.len ${norm}/anchor.vis.list > ${norm}/end_loop.after.vis

wait












































