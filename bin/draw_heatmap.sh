#!/bin/bash

chr=$1
start=$2
end=$3
region=$chr"_"$start"_"$end
anchor_loop=$4
ref=$5
bin=$6
genome=$7
enzyme=$8
option=$9

$bin/generate.raw.expt.ratio.matrix.pl <(cat $ref/$enzyme/${genome}_${enzyme}_anchors_avg.bed | awk '{if($1=="'$chr'")print}') $anchor_loop $chr $start $end ${genome}.${enzyme}.${region}

#$bin/select_anchor.sh $chr $start $end $ref $genome $enzyme
#$bin/select_loop.py $genome.anchors_$region.bed $anchor_loop >anchor_loop.$region

#$bin/generate_data_matrix.pl anchors_$region.bed  anchor_loop.$region grid.$region

#name=$region.r
#sed "s/REGION/$region/g" $bin/template.r >$name
#sed -i "s/START/$start/g" $name
#sed -i "s/END/$end/g" $name
if [ $9 == "-raw" ];then
	$bin/plot.heatmap.r ${genome}.${enzyme}.${region}.raw.matrix
elif [ $9 == "-expected" ];then
	$bin/plot.heatmap.r ${genome}.${enzyme}.${region}.expt.matrix
elif [ $9 == "-ratio" ];then
	$bin/plot.heatmap.r ${genome}.${enzyme}.${region}.ratio.matrix
else
	$bin/plot.heatmap.r ${genome}.${enzyme}.${region}.raw.matrix
	$bin/plot.heatmap.r ${genome}.${enzyme}.${region}.expt.matrix
	$bin/plot.heatmap.r ${genome}.${enzyme}.${region}.ratio.matrix
fi
rm -f ${genome}.${enzyme}.${region}.raw.matrix ${genome}.${enzyme}.${region}.expt.matrix ${genome}.${enzyme}.${region}.ratio.matrix
