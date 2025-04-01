l
### Heatmap
Heatmap mode generates Hi-C heatmaps of a certain region you choosed(up to 2,000,000bp). This mode need to be run after either HindIII mode or eHiC mode, since it takes an anchor-to-anchor looping-pair file as input.
<br/>
To run the Heatmap mode: <br/>
   ```./HiCorr Heatmap <chr> <start> <end> <anchor_loop_file> <reference_genome> <enzyme> [option]``` <br/>
Example run: <br/>
   #### Download test dataset for H9 chr11 (restriction enzyme: HindIII; genome build:hg19) from GSE130711
   ```
   wget --no-check-certificate https://hiview10.gene.cwru.edu/public/DeepLoop_ref/HiCorr_test_data/HiCorr_output.tar.gz
   # old path: http://hiview.case.edu/ssz20/tmp.HiCorr.ref/HiCorr_test_data/HiCorr_output.tar.gz 
   tar -xvf HiCorr_output.tar.gz
   ls
   ls HiCorr_output
   ```
   #### Plot heatmaps
   ```./HiCorr Heatmap chr11 130000000 130800000 HiCorr_output/anchor_2_anchor.loop.chr11 hg19 HindIII``` <br/>
   You will see three png files named as "hg19.HindIII.chr11_130000000_130800000.raw.matrix.png", "hg19.HindIII.chr11_130000000_130800000.expt.matrix.png" and "hg19.HindIII.chr11_130000000_130800000.ratio.matrix.png" <br/>
   <p float="center">
      <img src="https://github.com/JinLabBioinfo/HiCorr/blob/master/png/hg19.HindIII.chr11_130000000_130800000.raw.matrix.png" width="200" />
      <img src="https://github.com/JinLabBioinfo/HiCorr/blob/master/png/hg19.HindIII.chr11_130000000_130800000.expt.matrix.png" width="200" /> 
      <img src="https://github.com/JinLabBioinfo/HiCorr/blob/master/png/hg19.HindIII.chr11_130000000_130800000.ratio.matrix.png" width="200" />
   </p>
   
#### Options
*  _Default_ <br/>
   By defult, heatmap mode will generates 3 heatmaps for the region you entered: a raw heatmap of observed reads, a heatmap of expected reads, and a heatmap of bias-corrected reads(as a ratio of observeds reads over expected reads). If you want all 3 of these heatmaps, leave the option as blank.
* _-raw_ <br/>
   Only generates a raw heatmap of observed reads
* _-expected_ <br/>
   Only generates a heatmap of expected reads
* _-ratio_ <br/>
   Only generates a bias-corrected heatmap
