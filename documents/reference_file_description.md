# Reference files for HiCorr

## Download reference files
Run the commands below, you will directory "ref/".</br>
```
wget http://hiview.case.edu/ssz20/tmp.HiCorr.ref/HiCorr.tar.gz # download reference files
tar -xvf HiCorr.tar.gz 
ls 
ls ref/
```
There are 4 subdirectories under "ref/": "DPNII"  "eHiC"  "eHiC-QC"  "HindIII" </br>
The files in "eHiC" and "eHiC-QC" are for eHiC data generated in PMID: 32592681.  </br>
The files in "HindIII" and "DPNII" are for conventional Hi-C and in-situ HiC data. </br>

## Description for reference files
Each directory mainly includes the follwing files, for example, in "DPNII"
```
ls ref/DPNII/
```
hg19.DPNII.frag.bed: fragment bed file for DpNII enzyme cutting site.
<table><tr><td>chr</td><td>beg</td> <td>end</td> <td>fragment id</td> <td>fragment size</td></tr></table>

![sample heatmaps](https://github.com/JinLabBioinfo/HiCorr/blob/master/png/hg19.DPNII.frag.bed.PNG) </br>

hg19.DPNII.blacklist includes the fragment overlapping the blacklist regions.

![](https://github.com/JinLabBioinfo/HiCorr/blob/master/png/hg19.DPNII.blacklist.PNG) </br>

To run HiCorr with 5kb resolution, we need combine the neighbor fragments to achieve 5kb anchor size by using the hg19_DPNII_frag_2_anchor files
<table><tr><td>fragment</td><td>5kb_anchor</td></tr></table>

![](https://github.com/JinLabBioinfo/HiCorr/blob/master/png/hg19_DPNII_frag_2_anchor.PNG) </br>

After converting fragment to 5kb anchor, you will get anchor based files: </br>
hg19_DPNII_anchors_avg.bed:
<table><tr><td>chr</td><td>beg</td> <td>end</td> <td>anchor id</td> <td>anchor size</td><td>averaged fragment size</td></tr></table>

![](https://github.com/JinLabBioinfo/HiCorr/blob/master/png/hg19_DPNII_anchors_avg.bed.PNG) </br>

hg19_5kb_anchors_blacklist:

![](https://github.com/JinLabBioinfo/HiCorr/blob/master/png/hg19_5kb_anchors_blacklist.PNG) </br>

hg19.dist.401.group contains the 400 distance groups for 0-2Mb  
<table><tr><td>dist group id</td><td>group_start</td><td>group_end</td></tr></table>

![](https://github.com/JinLabBioinfo/HiCorr/blob/master/png/hg19.dist.401.group.PNG)</br>

hg19_anchor_length.groups contains anchor length group
<table><tr><td>length group id</td><td>group_start</td><td>group_end</td></tr></table>

![](https://github.com/JinLabBioinfo/HiCorr/blob/master/png/hg19_anchor_length.groups.PNG)</br>

hg19.full.matrix contains all possible anchor pairs within 2Mb.
<table><tr><td>anchor id 1</td><td>anchor id 2</td><td>zero</td><td>anchor loop size</td></tr></table>

![](https://github.com/JinLabBioinfo/HiCorr/blob/master/png/hg19.full.matrix.PNG)</br>

hg19.full.dist.len.stat
<table><tr><td>anchor1 length group id</td><td>anchor2 length group id</td><td>dist group id</td><td>number of anchor pairs within 2Mb</td></tr></table>

![](https://github.com/JinLabBioinfo/HiCorr/blob/master/png/hg19.full.dist.len.stat.PNG)</br>

hg19.trans.possible.pairs contains number possible pairs counts from trans-interactions
<table><tr><td>anchor1 length group id</td><td>anchor2 length group id</td><td>number of anchor pairs within 2Mb</td></tr></table>

![](https://github.com/JinLabBioinfo/HiCorr/blob/master/png/hg19.trans.possible.pairs.PNG)</br>


## Generate HiCorr reference files for given restriction enzyme cutting site and genome build

