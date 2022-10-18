#!/bin/bash
# This is to show process allValidPairs(HiCPro output) to fragment pairs that HiCorr can take as input
lib=preprocess/lib
allValidPairsFile=$1 # gz format, if not, remove gunzip in the following command
name=$2 
bed=Arima_HiCorr_ref/hg19.Arima.frag.bed

# 1. map allValidPairs read pairs to fragment pairs, and split to categories
cat $allValidPairsFile | gunzip | cut -f2-7 | $lib/reads_2_trans_frag_loop.pl $bed 50 $name.loop.trans - & # 50 is read length for mapping
cat $allValidPairsFile | gunzip | cut -f2-7 | $lib/reads_2_cis_frag_loop.pl $bed 50 $name.loop.inward $name.loop.outward $name.loop.samestrand summary.frag_loop.read_count $name - & # 50 is read length for mapping
wait
# 2. sort and filter fragment pairs
for file in `ls *loop* | grep -v trans`;do
        cat $file | $lib/summary_sorted_frag_loop.pl $bed  > temp.$file &
done
cat $name.loop.trans | $lib/summary_sorted_trans_frag_loop.pl - > temp.$file &
wait
for file in `ls temp*loop* | grep -v trans`;do
        $lib/resort_by_frag_id.pl $bed $file &
done
wait
cat temp.$name.loop.inward | awk '{if($4>1000)print $0}' > temp.$name.loop.inward & 
cat temp.$name.loop.outward | awk '{if($4>5000)print $0}' > temp.$name.loop.outward & 
wait 
# 3. merge fragment pairs
$lib/merge_sorted_frag_loop.pl temp.$name.loop.samestrand temp.$name.loop.inward temp.$name.loop.outward > frag_loop.$name.cis &
$lib/merge_sorted_frag_loop.pl temp.$name.loop.trans > frag_loop.$name.trans &
wait
# 4. this step is to make sure both upper and lower triangle pairs are included, which can be used as HiCorr_Arima.sh input
for file in frag_loop.$name.cis frag_loop.$name.trans;do
        cat $file <(cat $file | awk '{print $2 "\t" $1 "\t" $3 "\t" $4}') | sed s/"frag_"//g | sort -k1,2n -k2,2n | awk '{print "frag_"$1 "\t" "frag_"$2 "\t" $3 "\t" $4}' > $file.tmp & 
done
wait 
for file in frag_loop.$name.cis frag_loop.$name.trans;do
  mv $file.tmp $file 
done 


