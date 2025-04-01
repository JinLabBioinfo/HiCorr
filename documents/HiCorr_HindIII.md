# :point_down:  *HiCorr on HindIII enzyme Hi-C*
- Download the code from this repository, "bin/HindIII/" <br/>
- Download the reference files for HindIII (mm10/hg19 genome build)
```
wget --no-check-certificate https://hiview10.gene.cwru.edu/public/DeepLoop_ref/ref/HindIII_HiCorr_ref.tar.gz
# old path: http://hiview.case.edu/ssz20/tmp.HiCorr.ref/HindIII_HiCorr_ref.tar.gz
tar -xvf HindIII_HiCorr_ref.tar.gz
```
- Check the [preprocessing for micor-C data (mapping, fragments filter, outs are cis and trans 500bp fragment loops)]([https://github.com/JinLabBioinfo/HiCorr/blob/master/documents/micro-C%20preprocessing.sh](https://github.com/shanshan950/Hi-C-data-preprocess/blob/master/documents/Fastq-to-FragmentContact.Tissue_example.md)) <br/>
- Run HiCorr on HindIII Hi-C data:
```
bash HiCorr_HindIII.sh HindIII_HiCorr_ref/ bin/HindIII/ <frag_loop.name.cis> <frag_loop.name.trans> <outputname> <hg19/mm10>
   # specify the path of downloaded unzipped reference file and scripts
   # input two fragment loop files genrated from preprocessing step
   # specifiy outputname prefix
   # specify genome build, the provided reference only include hg19 and mm10
```

### details:
HindIII corrects bias of HindIII Hi-C data. It takes two fragment-pair files as input and outputs an anchor_pair file. <br/>
- The two input files: one file contains intra-chromosome looping fragment pairs(cis pairs), and another contains inter-chromosome looping fragment pairs(trans pairs).
   - Intra-chromosome looping pairs need to have 4 tab-delimited columns, in the following format:<br/>
       <table><tr><td>frag_id_1</td> <td>frag_id_2</td> <td>observed_reads_count</td> <td>distance_between_two_fragments</td></tr>  </table>
       See sample file here: http://hiview.case.edu/test/sample/frag_loop.IMR90.cis.sample
   - Inter-chromosome looping piars need to have 3 tab-delimited columns, in the following format:<br/>
      <table><tr><td>frag_id_1</td> <td>frag_id_2</td> <td>observed_reads_count</td> </tr>  </table>
        See sample file here: http://hiview.case.edu/test/sample/frag_loop.IMR90.trans.sample
   - These two files needs to be sorted before you run the pipeline (sort -k1 -k2).
   - If you do not know how to generate these two files, please take a look at our bam-process mode.
- The final result of HindIII mode is an anchor-to-anchor looping pairs file, which has 5 columns:<br/>
     <table><tr><td>anchor_id_1</td><td>anchor_id_2</td> <td>obserced_reads_count</td> <td>expected_reads_count</td> <td>p_value_ </td></tr></table>
   See sample file here: http://hiview.case.edu/test/sample/anchor_2_anchor.loop.IMR90.p_val.sample <br/>

     
### HiCorr test data (fragment loop, HindIII)
This test dataset is Adrenal Hi-C.(restriction enzyme: HindIII; genome build:hg19) from GSE87112.
```
wget http://hiview.case.edu/ssz20/tmp.HiCorr.ref/HiCorr_test_data/frag_loop.Adrenal.cis.gz # cis fragment loop
wget http://hiview.case.edu/ssz20/tmp.HiCorr.ref/HiCorr_test_data/frag_loop.Adrenal.trans.gz # trans fragment loop
gunzip frag_loop.Adrenal.cis.gz
gunzip frag_loop.Adrenal.trans.gz
./HiCorr HindIII frag_loop.Adrenal.cis frag_loop.Adrenal.trans Adrenal hg19
../HiCorr Heatmap chr1 119457772 120457772 HiCorr_output/anchor_2_anchor.loop.chr1 hg19 HindIII # plot Adrenal heatmap
```
### HiCorr test data (bam, HindIII)
This test dataset is subsampled bam file for H9 rep1 Hi-C.(restriction enzyme: HindIII; genome build:hg19) from GSE130711.
```
wget http://hiview.case.edu/ssz20/tmp.HiCorr.ref/HiCorr_test_data/H9_rep1.subsample.sorted.bam
./HiCorr Bam-process-HindIII H9_rep1.subsample.sorted.bam H9_rep1.subsample 36 hg19 HindIII
```
You will found "H9_rep1.subsample.cis.frag_loop" and "H9_rep1.subsample.trans.frag_loop", the other files are intermediate files. <br/>
Next run HiCorr bias correction using two *frag_loop files. <br/>
```
./HiCorr HindIII H9_rep1.subsample.cis.frag_loop H9_rep1.subsample.trans.frag_loop H9_rep1.subsample hg19 # It take a few hours to run
```
