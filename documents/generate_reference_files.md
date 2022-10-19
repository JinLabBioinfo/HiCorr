
## prepare files ##########################################################################################
# 1. genome build. e.g. hg19
  ## download chrom.sizes: wget https://hgdownload.cse.ucsc.edu/goldenpath/hg19/bigZips/hg19.chrom.sizes
  ## donwload fa directory: wget https://hgdownload.cse.ucsc.edu/goldenpath/hg19/bigZips/hg19.fa.gz
  ## download blacklist region: https://github.com/Boyle-Lab/Blacklist
# 2. cutting site of the specified restriction enzyme
# 3. path to the scripts, <HiCorr_dir>/bin/generateReference_lib/
```
genome_fa_dir=
genome_chrom_size=
cutsite=
enzymeName=
blackregion=
lib=<HiCorr_dir>/bin/generateReference_lib/
###########################################################################################################

## start build references #################################################################################
# 1. generate fragment bed file
$lib/find_RE_sites.pl $genome_fa_dir $genome_chrom_size $cutsite> $genome.$enzymeName.cutting.sites 
$lib/sites_to_frag.py $genome_chrom_size $genome.$enzymeName.cutting.sites | awk '{print $0,$3-$2+1}' OFS='\t' >  $genome.$enzymeName.frag.bed
# 2. generate ~5kb anchor
$lib/generate.fragment.py $genome.$enzymeName.frag.bed 5000 > frag.2.anchor 
$lib/get_aveg_frag_length.py frag.2.anchor anchor.bed > $genome.$enzymeName.anchor.5kb.bed
mkdir $genome.$enzymeName.anchor.5kb
cat $genome.$enzymeName.anchor.5kb.bed | awk '{print>"'$genome'""'.$enzymeName'".anchor.5kb/$1".bed"}'
# 3. divide all anchors by their length to 20 groups
$lib/get_group_range.pl $genome.$enzymeName.anchor.5kb.bed 6 20 > $genome_anchor_length.groups
# 4. generate possible trans contacts anchor pairs
$lib/count_trans_pairs_by_GC.pl $genome.$enzymeName.anchor.5kb.bed $genome.$enzymeName.anchor.5kb.bed ${genome}_anchor_length.groups > $genome.trans.possible.pairs
# 5. generate anchors overlapping black regions
bedtools intersect -wa -a $genome.$enzymeName.anchor.5kb.bed -b $blackregion | cut -f4 | sort -u > $genome.$enzymeName.anchor.5kb.bed.blacklist
# 6. generate all possible pairs within 2Mb
$lib/list_full_matrix.pl $genome.$enzymeName.anchor.5kb.bed 2000000 | python $lib/remove.blacklist.py $genome.$enzymeName.anchor.5kb.blacklist > $genome.full.filter.matrix 
# 7. generate distance group within 2Mb
### "$genome.dist.5kb.group" contains distance groups (401 groups for 200,0000)
# 1       -1      1000
# 2       1001    5000
# 3       5001    10000
# 4       10001   15000
# ...
# 400     1990001 1995000
#401     1995001 2e+06
# 8. generate distance stat 
cat $ref/$genome.full.filter.matrix | $lib/get_group_statistics.pl - $ref/$genome.dist.5kb.group | awk '{print $0,0}' OFS='\t' > $ref/$genome.full.dist.stat.5kb

## end  ####################################################################################################
```
