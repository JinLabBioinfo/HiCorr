
# prepare reference file ##########################################################################################
- 1. Genome build version. e.g. hg38
  - download chrom.sizes: 
  - donwload fa directory: 
  - download blacklist region: https://github.com/Boyle-Lab/ 
- 2. We use 500bp windows for micro-C/Dnase-Hi-C "frag", and 5kb as "anchor", generated by bedtools makewindows
- 3. path to the scripts, <HiCorr_dir>/bin/generateReference_lib/
```
wget https://hgdownload.cse.ucsc.edu/goldenpath/hg38/bigZips/hg38.chrom.sizes
wget https://hgdownload.cse.ucsc.edu/goldenpath/hg38/bigZips/hg38.chromFa.tar.gz
wget http://mitra.stanford.edu/kundaje/akundaje/release/blacklists/hg38-human/hg38.blacklist.bed.gz
gunzip hg38.blacklist.bed.gz
tar -xvf hg38.chromFa.tar.gz
for file in `ls chroms/ | grep _`;do
        rm chroms/$file
done
# reformat hg38.chrom.sizes by the 1st column: chr1, chr2, ... chr22, chrX, chrY
cat <(cat hg38.chrom.sizes | grep -v "_\|M" | sed s/"chr"//g | sort -gk 1 | grep -v 'X\|Y') \
    <(cat hg38.chrom.sizes | grep -v "_\|M" | sed s/"chr"//g | sort -gk 1 | grep 'X\|Y') \
    | awk '{print "chr"$0}' > hg38.chrom.sizes.reformat

## start build references #################################################################################
bedtools makewindows -g hg38.chrom.sizes.reformat -w 500 | awk '{print $1 "\t" $2+1 "\t" $3 "\t" "frag_"NR}' > hg38.500bp.bed
bedtools makewindows -g hg38.chrom.sizes.reformat -w 5000 | awk '{print $1 "\t" $2+1 "\t" $3 "\t" "A_"NR}' > hg38.5kb.bed
bedtools intersect -wa -a hg38.5kb.bed -b hg38.blacklist.bed | cut -f1-4 | sort -u > hg38.5kb.bed.blacklist
bedtools intersect -wa -wb -a hg38.500bp.bed -b hg38.5kb.bed | awk '{print $4 "\t" $8}' > hg38.500bp_5kb
cp ${HiCorr_path}/bin/dist.401.group hg38.dist.5kb.group
${HiCorr_path}/bin/generateReference_lib/list_full_matrix.pl hg38.5kb.bed 2000000 | python $lib/remove.blacklist.py hg38.5kb.bed.blacklist > hg38.full.filter.matrix &
${HiCorr_path}/bin/microC/get_group_statistics.pl hg38.full.filter.matrix hg38.dist.5kb.group | awk '{print $0,0}' OFS='\t' > $genome.full.dist.stat.5kb

```
