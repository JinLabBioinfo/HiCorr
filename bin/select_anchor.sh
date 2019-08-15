#!/bin/bash

chr=$1
beg=$2
end=$3
ref=$4

let range=$end-$beg
if [ $range -gt 2000000 ];then
	echo "Please enter an region <=2,000,000bp"
else
	awk -v chr=$chr -v beg=$beg -v end=$end '{OFS="\t";if($1==chr && $2>=beg && $3<=end)print $1,$2,$3,$4}' $ref/anchors_5kb.bed >anchors_$chr\_$beg\_$end.bed
fi
