# HiCorr
HiCorr is a pipeline designed to normalize and visualize Hi-C/eHi-C data. It needs to be run in an unix/linux environment. Currently it includes reference files of genome build hg19 and mm10.

## How to setup
1. Download everything into your local machine.
2. Go to the directory "ref", uncompress all the gz files, then run the script: <br/>
   ./prep_ref.sh <reference_genome>
3. Go back to the main directory, edit "HiCorr":
   - Line 3: Replace "PATH_TO_REF" with the path to your directory "ref"
   - Line 4: Replace "PATH_TO_BIN" with the path to your directory "bin"

## Run HiCorr
Usage:<br/>
   ```./HiCorr <mode> <parameters>```
<br/>
<br/>
**_HiCorr has 4 different modes: Bam-process, HindIII, eHiC and Heatmap_**

### Bam-process
Bam-process mode takes a sorted bam file as input, processes and generates two files as outputs. The two output files are the required input files when using the HiCorr HindIII mode. The two output files are intra-chromosome looping fragment-pair file and inter-chromosome looping fragment-pair file. <br/>
This mode currently is only able to process bam file of HindIII Hi-C data. <br/>
To run the Bam-process mode, you need 4 arguments:<br/>
   ```./HiCorr Bam-process <bam_file> <name_of_your_data> <mapped_read_length_in_your_bam_file> ```
<br/>

### HindIII
HindIII mode run the normalization of HindIII Hi-C data. It takes two fragment-pair files as input and outputs an anchor_pair file. <br/>
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
#### Options
 * _--no-GC-map_ <br/> 
      If _--no-GC-map_ is specified, HiCorr will not correct mappability and GC content. Note that based on our experience, GC content and mappability have limited effect on final normalization result. 

### eHiC

### Heatmap
Heatmap mode generates Hi-C heatmaps of a certain region you choosed(up to 2,000,000bp). This mode need to be run after either HindIII mode or eHiC mode, since it takes an anchor-to-anchor looping-pair file as input.
<br/>
To run the Heatmap mode: <br/>
   ```./HiCorr Heatmap <chr> <start> <end> <anchor_loop_file> [option]```
#### Options
*  _Default_ <br/>
   By defult, heatmap mode will generates 3 heatmaps for the region you entered: a raw heatmap of observed reads, a heatmap of expected reads, and a heatmap of normalized reads(as a ratio of observeds reads over expected reads). If you want all 3 of these heatmaps, leave the option as blank.
* _-raw_ <br/>
   Only generates a raw heatmap of observed reads
* _-expected_ <br/>
   Only generates a heatmap of expected reads
* _-ratio_ <br/>
   Only generates a normalized heatmap

Sample Heatmaps
![sample heatmaps](http://hiview.case.edu/test/sample/sample_heatmap.PNG)
