#!/bin/bash

name=$4

bin=$1
bowtie_index=$2
genome=$3

cat $name.R1.fastq.gz | gunzip | $bin/reformat_fastq.py 6 36 | bowtie -v 3 -m 1 --best --strata --time -p 1 --sam $bowtie_index - $name.R1.sam &
cat $name.R2.fastq.gz | gunzip | $bin/reformat_fastq.py 6 36 | bowtie -v 3 -m 1 --best --strata --time -p 1 --sam $bowtie_index - $name.R2.sam &

wait
$bin/pair_two_SAM.pl $name.R1.sam $name.R2.sam $name

echo Total Reads count for $name is `grep -v "^@" $name.R1.sam | wc -l` >>summary.total.read_count &
cat $name.mapped.pair | samtools view -bS -t $genome -o - - > $name.bam
let x=`samtools view $name.bam | wc -l`
let x=x/2
echo Uniquely mapped read pairs for $name is $x >> summary.total.read_count &
samtools sort $name.bam | samtools view - | $bin/remove_dup_PE_ELPU.pl | samtools view -bS -t $genome -o - - > $name.sorted.nodup.bam
let x=`samtools view $name.sorted.nodup.bam | wc -l`
let x=x/2
echo Non-redundant mapped read pairs for $name is $x>> summary.total.read_count &

samtools view $name.sorted.nodup.bam | cut -f2-13 | $bin/bam_to_temp_HiC.pl| awk '{OFS="\t"; print $1,$2,$3,$4,$5,$6,42,42}'> $name.temp
$bin/reads_to_frag_loop_ELPU.py $ref/eHiC/$genome.HindIII.frag.bed $name.temp $name 0 >>summary.frag_loop.read_count
rm $name.temp $name.bam $name.mapped.pair $name.loop.nofrag $name.loop.samefrag $name.loop.trans.nofrag
