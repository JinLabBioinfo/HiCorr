### DpnII/Mbol
- The format of the two input files are the same as HindIII
To run the DpNII/Mbol mode:<br/>
   ```./HiCorr DPNII <cis_loop_file> <trans_loop_file> <name_of_your_data> <reference_genome> [options]```

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
