# *HiCorr*
HiCorr is a pipeline designed to do bias-correction and visualization of Hi-C/eHi-C data. HiCorr focuses on the mapping of chromatin interactions at high-resolution, especially the sub-TAD enhancer-promoter interactions, which requires more rigorous bias-correction, especially the correction of distance biases. It needs to be run in an unix/linux environment. Currently it includes reference files of genome build hg19 and mm10.

If you use HiCorr, please site:<br/>
_Lu,L. et al._ Robust Hi-C Maps of Enhancer-Promoter Interactions Reveal the Function of Non-coding Genome in Neural Development and Diseases. Molecular Cell; doi: https://doi.org/10.1016/j.molcel.2020.06.007

For any question about HiCorr, please contact xxl244@case.edu

## How to setup
### Download the code
```
git clone https://github.com/shanshan950/HiCorr.git
cd HiCorr/
chmod 755 HiCorr
chmod -R 755 bin/*
```
### Download reference files
After you run the following commands, you will see "ref/" in the current directory. There are 4 subdirectories under "ref/": "DPNII/  eHiC/  eHiC-QC/  HindIII".
In each subdirectory, there are reference files for genome build hg19 and mm10. </br>
[More descriptions for the reference files](https://github.com/JinLabBioinfo/HiCorr/blob/master/documents/reference_file_description.md).</br>
[How to generate reference files](https://github.com/JinLabBioinfo/HiCorr/blob/master/documents/Generate.reference.md)</br>
```
wget http://hiview.case.edu/ssz20/tmp.HiCorr.ref/HiCorr.tar.gz # download reference files 
# It needs ~103G space after decompress
tar -xvf HiCorr.tar.gz 
ls
ls ref/
```
### Change variables ref and bin in HiCorr file
> In HiCorr file, you can manually replace the "PATH_TO_REF" with the path to your directory "ref", Replace "PATH_TO_BIN" with the path to your directory "bin" 
> Or use the command below: 
```
new_bin=`pwd`"/bin" 
new_ref=`pwd`"/ref" 
sed -i "s|PATH_TO_REF|${new_ref}|" HiCorr
sed -i "s|PATH_TO_BIN|${new_bin}|" HiCorr
```

## Run HiCorr
Usage:<br/>
   ```./HiCorr <mode> <parameters>```
<br/>

### HiCorr test data
This test dataset is H9 H-C fragment loop(restriction enzyme: HindIII) from GSE130711.  <br/>
The preprocessing is done with genome build hg19. <br/>
```
wget wget http://hiview.case.edu/ssz20/tmp.HiCorr.ref/HiCorr_test_data/frag_loop.H9.cis.gz # cis frag_loop
wget wget http://hiview.case.edu/ssz20/tmp.HiCorr.ref/HiCorr_test_data/frag_loop.H9.trans.gz # trans frag_loop
gunzip frag_loop.H9.cis.gz
gunzip frag_loop.H9.trans.gz
./HiCorr HindIII frag_loop.H9.cis frag_loop.H9.trans H9 hg19 # It take a few hours to run
```

Some example including preprocessing steps logs are be found [here](https://github.com/shanshan950/Hi-C-data-preprocess)

**_HiCorr has 5 different modes: Bam-process-HindIII, Bam-process-DPNII, HindIII, DPNII, eHiC-QC, eHiC and Heatmap_**


### Bam-process
Bam-process mode takes a sorted bam file as input, processes and generates two files as outputs. The two output files are the required input files when using the HiCorr HindIII mode. The two output files are intra-chromosome looping fragment-pair file and inter-chromosome looping fragment-pair file. <br/>
This mode currently is only able to process bam file of HindIII Hi-C data. <br/>
To run the Bam-process mode, you need 6 arguments:
   
   ```./HiCorr Bam-process-HindIII <bam_file> <name_of_your_data> <mapped_read_length_in_your_bam_file> <genome> HindIII```
   
   ```./HiCorr Bam-process-DPNII <bam_file> <name_of_your_data> <mapped_read_length_in_your_bam_file> <genome> DPNII```


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
   
### DpnII/Mbol
- The format of the two input files are the same as HindIII
To run the DpNII/Mbol mode:<br/>
   ```./HiCorr DPNII <cis_loop_file> <trans_loop_file> <name_of_your_data> <reference_genome> [options]```

### eHiC-QC
eHiC-QC mode takes a pair of fastq.gz files as input, aligns and processes eHiC reads, outputs fragment-end-pair files for further analysis. This mode also outputs summarize numbers which works as quality check fo eHiC experiments.
Make sure to name your fastq.gz files as <name>.R1.fastq.gz and <name>.R1.fastq.gz.
You need to have Bowtie(http://bowtie-bio.sourceforge.net/index.shtml) and samtools(http://www.htslib.org/) installed since HiCorr calls Bowtie to do alignments.
You also need Bowtie index and fa.fai file.
To run the eHiC-QC mode, you need 4 arguments: <br/>
   ```./HiCorr eHiC-QC <bowtie_index> <fa.fai> <name>```
 
### eHiC
eHiC mode corrects bias of eHi-C data. It takes two fragment-end-pair files as input (use HiCorr's eHiC-QC mode if you need to generate these files) and outputs an anchor_pair file. <br/>
- The two input files: one file contains intra-chromosome looping fragment-end pairs(cis pairs), and another contains inter-chromosome looping fragment-end pairs(trans pairs).
   - Intra-chromosome looping pairs need to have 4 tab-delimited columns, in the following format:<br/>
       <table><tr><td>frag_end_id_1</td> <td>frag_end_id_2</td> <td>observed_reads_count</td> <td>distance_between_two_fragments</td></tr>  </table>
       See sample file here: 
   - Inter-chromosome looping piars need to have 3 tab-delimited columns, in the following format:<br/>
      <table><tr><td>frag_end_id_1</td> <td>frag_end_id_2</td> <td>observed_reads_count</td> </tr>  </table>
        See sample file here: 
   - These two files needs to be sorted before you run the pipeline (sort -k1 -k2).
- The final result of HindIII mode is an anchor-to-anchor looping pairs file, which has 5 columns:<br/>
     <table><tr><td>anchor_id_1</td><td>anchor_id_2</td> <td>obserced_reads_count</td> <td>expected_reads_count</td> <td>p_value_ </td></tr></table>
   See sample file here: http://hiview.case.edu/test/sample/anchor_2_anchor.loop.IMR90.p_val.sample <br/>
To run the eHiC mode:<br/>
   ```./HiCorr eHiC <cis_loop_file> <trans_loop_file> <name_of_your_data> <reference_genome>```
   
### Heatmap
Heatmap mode generates Hi-C heatmaps of a certain region you choosed(up to 2,000,000bp). This mode need to be run after either HindIII mode or eHiC mode, since it takes an anchor-to-anchor looping-pair file as input.
<br/>
To run the Heatmap mode: <br/>
   ```./HiCorr Heatmap <chr> <start> <end> <anchor_loop_file> <reference_genome> <enzyme> [option]```
#### Options
*  _Default_ <br/>
   By defult, heatmap mode will generates 3 heatmaps for the region you entered: a raw heatmap of observed reads, a heatmap of expected reads, and a heatmap of bias-corrected reads(as a ratio of observeds reads over expected reads). If you want all 3 of these heatmaps, leave the option as blank.
* _-raw_ <br/>
   Only generates a raw heatmap of observed reads
* _-expected_ <br/>
   Only generates a heatmap of expected reads
* _-ratio_ <br/>
   Only generates a bias-corrected heatmap

Sample Heatmaps
![sample heatmaps](http://hiview.case.edu/test/sample/sample_heatmap.PNG)
