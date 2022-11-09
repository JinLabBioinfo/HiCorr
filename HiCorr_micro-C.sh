#!/bin/bash

ref=$1
bin=$2
cis=$3
trans=$4
name=$5
genome=$6
anchorbed=${ref}/$genome.5kb.bed
blacklist=${ref}/$genome.5kb.bed.blacklist
lib=$bin
#
# fragment pairs to anchorpairs 
$lib/fragdata_to_anchordata.pl $cis $ref/$genome.500bp_5kb | $lib/remove.blacklist.py $blacklist | $lib/get_dist.py $anchorbed > end_loop.$name.cis &
$lib/fragdata_to_anchordata.pl $trans $ref/$genome.500bp_5kb | $lib/remove.blacklist.py $blacklist > end_loop.$name.trans &
wait 

cat end_loop.$name.cis | awk '{if($4<=2000000) print $1,$2,$3,$4}' OFS='\t' | $lib/split_chromo.py $anchorbed & 
cat end_loop.$name.cis | awk '{if($4<=2000000) print $1,$2,$3,$4}' OFS='\t' | $lib/get_group_statistics.pl - $ref/$genome.dist.5kb.group > dist.stat & 
cat end_loop.$name.cis | awk '{if($4>2000000) print $0}' | cat - end_loop.$name.trans | cut -f1-3 | $lib/calculate_vis.py > anchor.vis.list &
wait

Rscript $lib/integrated.r $ref/$genome.full.dist.stat.5kb

for file in `ls split/`;do
        chr=${file#anchor_2_anchor.loop.}
        cat $anchorbed | awk '{if($1=="'$chr'")print}' | $lib/list_full_matrix.pl - 2000000 | perl $lib/merge_sorted_anchor_loop.pl - split/$file | $lib/get_loop_lambda.pl $ref/$genome.dist.5kb.group integrated.dist.len.stat | $lib/add.vis.to.cis.2M.pl - anchor.vis.list > temp
        mv temp split/anchor_2_anchor.loop.$chr
done
mv split HiCorr
wait
exit
