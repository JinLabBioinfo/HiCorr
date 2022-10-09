### HindIII
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

To run the HindIII mode:<br/>
   ```./HiCorr HindIII <cis_loop_file> <trans_loop_file> <name_of_your_data> <reference_genome> [options]```
  
     
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
