## Convert HiCPro output validPairs to fragment loops for HiCorr and DeepLoop analysis
### Before start, prepare essential files and infomation:
- validPairs_file
- genome build
- restriction enzyme, and its fragment bed file, use DPNII for both in-situ and Arima Hi-C 
- The read length for mapping, e.g. 36, 50, or 100
### Define variables:
```
lib=bin/preprocess/ # the path to lib of the bin/preprocess/
validPair= # from HiCPro
genome= # hg19/mm10
fragbed= # enzyme fragment bed "frag_1"..., provided in HiCorr reference files, mm10 and hg19 are provided
outputname= # your outpuname or sample name
readlength= #The read length for mapping, e.g. 36, 50, or 100
```
### Start
```
cat $validPair | gunzip | cut -f2-7 | $lib/reads_2_cis_frag_loop.pl $fragbed $readlength $outputname.loop.inward $outputname.loop.outward $outputname.loop.samestrand summary.frag_loop.read_count $outputname -
cat $validPair | gunzip | cut -f2-7 | $lib/reads_2_trans_frag_loop.pl $fragbed $readlength $outputname.loop.trans - &
for file in $outputname.loop.inward $outputname.loop.outward $outputname.loop.samestrand;do
        cat $file | $lib/summary_sorted_frag_loop.pl $bed  > temp.$file &
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
### Now you got the fragment loops for cis and trans, go to run HiCorr
 ## :point_right:  [*HiCorr on micro-C*](https://github.com/JinLabBioinfo/HiCorr/blob/master/documents/HiCorr_micro-C.md)
 ## :point_right:  [*HiCorr on Arima*](https://github.com/JinLabBioinfo/HiCorr/blob/master/documents/HiCorr_Arima.md)
 ## :point_right:  [*HiCorr on HindIII enzyme Hi-C*](https://github.com/JinLabBioinfo/HiCorr/blob/master/documents/HiCorr_HindIII.md)
 ## :point_right:  [*HiCorr on eHi-C*](https://github.com/JinLabBioinfo/HiCorr/blob/master/documents/HiCorr_eHi-C.md)
 ## :point_right:  [*HiCorr on in-situ Hi-C or DPNII/Mbol enzyme Hi-C*](https://github.com/JinLabBioinfo/HiCorr/blob/master/documents/HiCorr_insituHi-C.md)

