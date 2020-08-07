# HiCorr
HiCorr is a pipeline designed to do bias-correction and visualization of Hi-C/eHi-C data. HiCorr focuses on the mapping of chromatin interactions at high-resolution, especially the sub-TAD enhancer-promoter interactions, which requires more rigorous bias-correction, especially the correction of distance biases. It needs to be run in an unix/linux environment. Currently it includes reference files of genome build hg19 and mm10.

If you use HiCorr, please site:<br/>
_Lu,L. et al._ Robust Hi-C Maps of Enhancer-Promoter Interactions Reveal the Function of Non-coding Genome in Neural Development and Diseases. Molecular Cell; doi: https://doi.org/10.1016/j.molcel.2020.06.007

For any question about HiCorr, please contact xxl244@case.edu

## How to setup
<b>To use HiCorr on HindIII or eHiC data:</b> 
1. Download everything into your local machine.
2. Since several reference files are too large to fit github, please download them here: http://hiview.case.edu/test/HiCorr_ref/, and put reference files into corresponding directories.
2. Go to the directory "ref", uncompress all the gz files, then run the script: <br/>
   ./prep_ref.sh <reference_genome>
3. Go back to the main directory, edit "HiCorr":
   - Line 3: Replace "PATH_TO_REF" with the path to your directory "ref"
   - Line 4: Replace "PATH_TO_BIN" with the path to your directory "bin" <br/>
<br/>
<b>To use HiCorr on DPNII/Mbol data:</b> <br/>
See the [DPNII/Mbol - Preparation files](https://github.com/JinLabBioinfo/HiCorr/blob/master/README.md#preparation-files) section for detail.

## Run HiCorr
Usage:<br/>
   ```./HiCorr <mode> <parameters>```
<br/>
<br/>
**_HiCorr has 4 different modes: Bam-process, HindIII, DPNII, eHiC and Heatmap_**

### Bam-process
Bam-process mode takes a sorted bam file as input, processes and generates two files as outputs. The two output files are the required input files when using the HiCorr HindIII mode. The two output files are intra-chromosome looping fragment-pair file and inter-chromosome looping fragment-pair file. <br/>
This mode currently is only able to process bam file of HindIII Hi-C data. <br/>
To run the Bam-process mode, you need 4 arguments:<br/>
   ```./HiCorr Bam-process <bam_file> <name_of_your_data> <mapped_read_length_in_your_bam_file> ```
<br/>

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
   
### DpnII/Mbol(beta version)

DpnII/Mbol corrects bias of DpnII/Mbol digested Hi-C data. This pipelines is able to process data form the very beginning, eg. .fastq files to the ultimately bias-corrected files. <br/>

The parameters for user to input are listed below. <br/>

- The dictionary where the script folder locates. <br/>
- The path where Bowtie locates. <br/>
   We did test a few different mapping tools, BWA and bowtie, and compared the mapping efficiency and accurracy. It turns out that Bowtie is more strict than BWA. <br/>
- The genome of your Hi-C data, eg. hg19 or mm10. (Currently, we only provide mm10 and hg19) <br/>
- The path where the folder named fastq locates. We restrict that the data (.fastq file) must within a folder named fastq. The user is required to provide the where the fastq folder is, in other word, the data's parent folder. <br/>

To run the DpnII/Mbol mode: <br/>
```./HiCorr DpnII <Parent_Path_of_Script> <Bowtie_Path> <Genome Type> <Parent_Path_of_Fastq_file>```

#### Preparation Files

```BED files```: The link below provide users to download the BED files and then keep them in ```references```.
                 ```http://hiview.case.edu/ssz20/xww/HiCorr/```

```references``` : includes most of the pre-requested files which are required for bias-correction. Users are required to link and generate a few files before running the code. <br/>

- Bowtie Index: these index files should included in a folder which locate within the ```references```. <br/>
   * _hg19_BowtieIndex_ <br/>
   * _mm10_BowtieIndex_ <br/>
- samtools Index: these index files should included within ```references```. <br/>
   * _hg19.fa.fai_ <br/>
   * _mm10.fa.fai_ <br/>
- All possible Anchor Pairs: This file can be generated by user. <br/>

         ./src/list_full_matrix.pl ./references/hg19_DpnII_anchors_avg.bed 2000000 | ./src/remove.blacklist.py ./references/hg19_5kb_anchors_blacklist > ./references/hg19.full.matrix
         ./src/list_full_matrix.pl ./references/mm10_DpnII_anchors_avg.bed 2000000 | ./src/remove.blacklist.py ./references/mm10_5kb_anchors_blacklist > ./references/mm10.full.matrix


#### Options
 * _--no-GC-map_ <br/> 
      If _--no-GC-map_ is specified, HiCorr will not correct mappability and GC content. Note that based on our experience, GC content and mappability have limited effect on final bias-correction result. 

### eHiC
eHiC mode corrects bias of eHi-C data. It takes two fragment-end-pair files as input and outputs an anchor_pair file. <br/>
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
   ```./HiCorr Heatmap <chr> <start> <end> <anchor_loop_file> [option]```
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
