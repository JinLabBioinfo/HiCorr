#!/bin/bash

chr=$1
start=$2
end=$3
region=$1"_"$start"_"$end
anchor_loop=$4
bin=$5
ref=$6
option=$7

$bin/select_anchor.sh $chr $start $end $ref
$bin/select_loop.py anchors_$region.bed $anchor_loop >anchor_loop.$region

$bin/generate_data_matrix.pl anchors_$region.bed  anchor_loop.$region grid.$region

name=$region.r
sed "s/REGION/$region/g" $bin/template.r >$name
sed -i "s/START/$start/g" $name
sed -i "s/END/$end/g" $name
if [ $7 = "-raw" ];then
	R --vanilla < $name matrix.obs
elif [ $7 = "-expected" ];then
	R --vanilla < $name matrix.expected
elif [ $7 = "-ratio" ];then
	R --vanilla < $name matrix.ratio
else
	R --vanilla < $name matrix.obs
	R --vanilla < $name matrix.expected
	R --vanilla < $name matrix.ratio
fi
rm anchor_loop.$region grid.$region $region.r matrix.obs matrix.expected matrix.ratio
