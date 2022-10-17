# :point_down:  *HiCorr on micro-C*
- Download the code from this repository, "bin/microC/" <br/>
- Download the reference files for micro-C (mm10/hg19 genome build)
```
wget http://hiview.case.edu/ssz20/tmp.HiCorr.ref/microC_HiCorr.tar.gz
tar -xvf microC_HiCorr.tar.gz
chmod 775 HiCorr/bin/microC/*
```
- Check the [preprocessing for micor-C data (mapping, fragments filter, outs are cis and trans 500bp fragment loops)](https://github.com/JinLabBioinfo/HiCorr/blob/master/documents/micro-C%20preprocessing.sh) <br/>
- Run HiCorr on micor-C data:
```
bash HiCorr_micro-C.sh microC_ref/ bin/microC/ <frag_loop.name.cis> <frag_loop.name.trans> <outputname> <hg19/mm10>
   # specify the path of downloaded unzipped reference file and scripts
   # input two fragment loop files genrated from preprocessing step
   # specifiy outputname prefix
   # specify genome build, the provided reference only include hg19 and mm10
```
