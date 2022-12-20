```
git clone https://github.com/JinLabBioinfo/HiCorr.git
chmod +x HiCorr/bin/preprocess/*
chmod +x HiCorr/bin/*

lib=HiCorr/bin/preprocess/ # the path to lib of the Hi-C-data-preprocess 
validPair= .allValidPairs.gz # from HiCPro
fragbed=../LiJia/hg38_DPNII/hg38.DPNII.frag.bed # enzyme fragment bed "frag_1"..., provided in HiCorr reference files, HindIII, DPNII for mm10 and hg19 are provided, other type of reference files could be generated upon request
outputname=test # your outpuname or sample name

# convert all valid pairs to fragment pairs, and catogorize
cat $validPair | gunzip | cut -f2-7 | HiCorr/bin/Arima/reads_2_cis_frag_loop.pl $fragbed 50 $outputname.loop.inward $outputname.loop.outward $outputname.loop.samestrand summary.frag_loop.read_count $outputname - &
cat $validPair | gunzip | cut -f2-7 | HiCorr/bin/Arima/reads_2_trans_frag_loop.pl $fragbed 50 $outputname.loop.trans - &
wait 
# sort and merge
for file in $outputname.loop.inward $outputname.loop.outward $outputname.loop.samestrand;do
        cat $file | $lib/summary_sorted_frag_loop.pl $fragbed > temp.$file &
done
cat $outputname.loop.trans | $lib/summary_sorted_trans_frag_loop.pl - > temp.$outputname.loop.trans &
wait
for file in $outputname.loop.inward $outputname.loop.outward $outputname.loop.samestrand;do
        $lib/resort_by_frag_id.pl $fragbed temp.$file &
done
wait
$lib/merge_sorted_frag_loop.pl temp.$outputname.loop.samestrand <(cat temp.$outputname.loop.inward | awk '{if($4>1000)print $0}') <(cat temp.$outputname.loop.outward | awk '{if($4>5000)print $0}') > frag_loop.$outputname.cis &
$lib/merge_sorted_frag_loop.pl temp.$outputname.loop.trans > frag_loop.$outputname.trans &
wait
cat frag_loop.$outputname.cis <(cat frag_loop.$outputname.cis | awk '{print $2 "\t" $1 "\t" $3 "\t" $4}') | sed s/"frag_"//g | sort -k1,2n -k2,2n | awk '{print "frag_"$1 "\t" "frag_"$2 "\t" $3 "\t" $4}' > frag_loop.$outputname.cis.tmp &
cat frag_loop.$outputname.trans <(cat frag_loop.$outputname.trans | awk '{print $2 "\t" $1 "\t" $3 "\t" $4}') | sed s/"frag_"//g | sort -k1,2n -k2,2n | awk '{print "frag_"$1 "\t" "frag_"$2 "\t" $3 "\t" $4}' > frag_loop.$outputname.trans.tmp &
wait
mv frag_loop.$outputname.cis.tmp frag_loop.$outputname.cis
mv frag_loop.$outputname.trans.tmp frag_loop.$outputname.trans
```
