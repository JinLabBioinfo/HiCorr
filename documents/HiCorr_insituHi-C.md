# :point_down:  *HiCorr on in-situ Hi-C or DPNII/Mbol enzyme Hi-C*
- Download the code from this repository, "bin/DPNII/" <br/>
- Download the reference files for DPNII (mm10/hg19/hg38 genome build)
```
wget --no-check-certificate https://hiview10.gene.cwru.edu/public/DeepLoop_ref/ref/DPNII_HiCorr_ref.tar.gz
# old path: http://hiview.case.edu/ssz20/tmp.HiCorr.ref/ref/DPNII_HiCorr_ref.tar.gz
tar -xvf DPNII_HiCorr_ref.tar.gz
```
- Check the [preprocessing for DPNII data (mapping, fragments filter, outs are cis and trans DPNII fragment contacts)](https://github.com/JinLabBioinfo/HiCorr/blob/master/documents/DPNII_preprocessing.sh) <br/>
- Run HiCorr on DPNII Hi-C data:
```
bash HiCorr_DPNIII.sh DPNII_HiCorr_ref/ bin/DPNII/ <frag_loop.name.cis> <frag_loop.name.trans> <outputname> <hg19/mm10/hg38>
   # specify the path of downloaded unzipped reference file and scripts
   # input two fragment loop files genrated from preprocessing step
   # specifiy outputname prefix
   # specify genome build, the provided reference only include hg19, hg38 and mm10
```


