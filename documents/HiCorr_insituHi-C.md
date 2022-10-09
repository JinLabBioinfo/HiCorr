# :point_down:  *HiCorr on in-situ Hi-C or DPNII/Mbol enzyme Hi-C*
- Download the code from this repository, "bin/DPNII/" <br/>
- Download the reference files for DPNII (mm10/hg19 genome build)
```
wget http://hiview.case.edu/ssz20/tmp.HiCorr.ref/DPNII_HiCorr_ref.tar.gz
tar -xvf DPNII_HiCorr_ref.tar.gz
```
- Check the [preprocessing for DPNII data (mapping, fragments filter, outs are cis and trans 500bp fragment loops)](https://github.com/JinLabBioinfo/HiCorr/blob/master/documents/micro-C%20preprocessing.sh) <br/>
- Run HiCorr on DPNII Hi-C data:
```
bash HiCorr_DPNIII.sh DPNII_HiCorr_ref/ bin/DPNII/ <frag_loop.name.cis> <frag_loop.name.trans> <outputname> <hg19/mm10>
   # specify the path of downloaded unzipped reference file and scripts
   # input two fragment loop files genrated from preprocessing step
   # specifiy outputname prefix
   # specify genome build, the provided reference only include hg19 and mm10
```

### HiCorr test data (bam, DPNII)
This test dataset is subsampled bam file for H1 Bio1Tech1Ind2 in-situ Hi-C.(restriction enzyme: DPNII; genome build:hg19) from 4DNES2M5JIGV.
```
wget http://hiview.case.edu/ssz20/tmp.HiCorr.ref/HiCorr_test_data/4DNES2M5JIGV.Bio1Tech1Ind2.subsample.sorted.bam
./HiCorr Bam-process-DpNII 4DNES2M5JIGV.Bio1Tech1Ind2.subsample.sorted.bam  4DNES2M5JIGV.Bio1Tech1Ind2.subsample 50 hg19 DPNII
```
You will found "4DNES2M5JIGV.Bio1Tech1Ind2.subsample.cis.frag_loop" and "4DNES2M5JIGV.Bio1Tech1Ind2.subsample.trans.frag_loop", the other files are intermediate files. <br/>
Next run HiCorr bias correction using two *frag_loop files. <br/>
```
./HiCorr DPNII 4DNES2M5JIGV.Bio1Tech1Ind2.subsample.cis.frag_loop 4DNES2M5JIGV.Bio1Tech1Ind2.subsample.trans.frag_loop 4DNES2M5JIGV.Bio1Tech1Ind2.subsample hg19 # It take a few hours to run
```
