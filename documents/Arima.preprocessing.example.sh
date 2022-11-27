# two biological replicates, run step1-7 for each rep, and merge loops in step8
fastq-dump --split-files SRR16827076 &
fastq-dump --split-files SRR16827077 &
wait

hg19=bowtie2_hg19_index/hg19
hg19fai=genome.fa.fai
lib=HiCorr/bin/preprocess/ 
chmod 777 HiCorr/bin/preprocess/*
bed=Arima_HiCorr_ref/hg19.Arima.frag.bed

# step 1. mapping, take 50bp for mapping
fq1=SRR16827076_1.fastq
fq2=SRR16827076_2.fastq
name=beta_rep1
cat $fq1 | ./reformat_fastq.py 1 50 | bowtie2 --very-sensitive -L 30 --score-min L,-0.6,-0.2 --end-to-end --reorder --rg-id BMG -p 5 -x $hg19 -U - | samtools view -bS - >  $name.R1.bam &
cat $fq2 | ./reformat_fastq.py 1 50 | bowtie2 --very-sensitive -L 30 --score-min L,-0.6,-0.2 --end-to-end --reorder --rg-id BMG -p 5 -x $hg19 -U - | samtools view -bS - >  $name.R2.bam &

fq1=SRR16827077_1.fastq
fq2=SRR16827077_2.fastq
name=beta_rep2
echo Total reads count for $name is `samtools view $name.R1.bam | grep -vE ^@ | wc -l | awk '{OFMT="%f"; print $1}'` >> summary.total.read_count &
samtools sort -@ 12 -n -T $name.R1 -o $name.R1.sorted.bam  $name.R1.bam &
samtools sort -@ 12 -n -T $name.R2 -o $name.R2.sorted.bam  $name.R2.bam &
wait 
echo Total reads count for beta_rep1 is `samtools view beta_rep1.R1.sorted.bam | grep -vE ^@ | wc -l | awk '{OFMT="%f"; print $1}'` >> summary.total.read_count &
echo Total reads count for beta_rep2 is `samtools view beta_rep2.R1.sorted.bam | grep -vE ^@ | wc -l | awk '{OFMT="%f"; print $1}'` >> summary.total.read_count &

for name in beta_rep1 beta_rep2;do
  # step 2. sam to sorted bam 
  samtools view -u $name.R1.sam | samtools sort -@ 12 -n -T $name.R1 -o $name.R1.sorted.bam  &
  samtools view -u $name.R2.sam | samtools sort -@ 12 -n -T $name.R2 -o $name.R2.sorted.bam  &
  wait
  # step 3. pair two sam & sort
  ~/zshanshan/lib/pairing_two_SAM_reads.pl <(samtools view $name.R1.sorted.bam) <(samtools view $name.R2.sorted.bam) | samtools view -bS -t $hg19fai -o - - > $name.bam 
  echo Uniquely mapped read pairs for $name is `samtools view $name.bam | wc -l | awk '{OFMT="%f"; print $1/2}'` >> summary.total.read_count &
  samtools sort -@ 10 -m 4G $name.bam -o $name.sorted.bam
  # step 4. remove dups
  samtools view $name.sorted.bam | $lib/remove_dup_PE_SAM_sorted.pl | samtools view -bS -t $hg19fai -o - - > $name.sorted.nodup.bam
  echo Total non-duplicated read pairs for $name is `samtools view $name.sorted.nodup.bam | wc -l | awk '{OFMT="%f"; print $1/2}'` >> summary.total.read_count &
  # step 5. categorize reads pair and map them to Arima fragment pairs
  samtools view $name.sorted.nodup.bam | cut -f2-8 | $lib/bam_to_temp_HiC.pl > $name.temp
  $lib/reads_2_cis_frag_loop.pl $bed 50 $name.loop.inward $name.loop.outward $name.loop.samestrand $name $name.temp & # 50 is read length for mapping
  for file in $name.loop.inward $name.loop.outward $name.loop.samestrand;do
        cat $file | $lib/summary_sorted_frag_loop.pl $bed  > temp.$file &
  done
  cat $name.loop.trans | $lib/summary_sorted_trans_frag_loop.pl - > temp.$name.loop.trans &
  wait
  for file in $name.loop.inward $name.loop.outward $name.loop.samestrand;do
        $lib/resort_by_frag_id.pl $bed temp.$file $lib &
  done
  wait
  # step 6. filter the fragment pairs:
  cat temp.$name.loop.inward | awk '{if($4>1000)print $0}' > temp.$name.loop.inward.filter &
  cat temp.$name.loop.outward | awk '{if($4>5000)print $0}' > temp.$name.loop.outward.filter &
  wait 
done

# step 7. merge fragment pairs (Note if you have multiple biological reps, run the first 6 steps for each rep, and merge in step 7)
$lib/merge_sorted_frag_loop.pl temp.beta_rep1.loop.samestrand temp.beta_rep1.loop.inward.filter temp.beta_rep1.loop.outward.filter temp.beta_rep2.loop.samestrand temp.beta_rep2.loop.inward.filter temp.beta_rep2.loop.outward.filter > frag_loop.beta.cis &
$lib/merge_sorted_frag_loop.pl temp.beta_rep1.loop.trans temp.beta_rep2.loop.trans > frag_loop.$name.trans &
wait 
echo beta "trans:" `cat frag_loop.beta.trans | awk '{sum+=$3}END{print sum/2}'` "cis:" `cat frag_loop.beta.cis | awk '{sum+=$3}END{print sum/2}'` "cis2M:" `cat frag_loop.beta.cis | awk '{if($4<=2000000)print}' | awk '{sum+=$3}END{print sum/2}'` >> summary.total.read_count 

