# HiCorr
HiCorr is a pipeline designed to normalize and visualize Hi-C/eHi-C data. It needs to be run in an unix/linux environment. Currently it includes reference files of genome build hg19 and mm10.

### How to setup
1. Download everything into your local machine.
2. Go to the directory "ref", uncompress all the gz files, then run the script: <br/>
   ./prep_ref.sh <reference_genome>
3. Go back to the main directory, edit "HiCorr":
   - Line 3: Replace "PATH_TO_REF" with the path to your directory "ref"
   - Line 4: Replace "PATH_TO_BIN" with the path to your directory "bin"

### To run the pipeline
1. You will need two input files: one file contains intra-chromosome looping fragment pairs(cis pairs), and another contains inter-chromosome looping fragment pairs(trans pairs).
    - Intra-chromosome looping pairs need to have 4 tab-delimited columns, in the following format:<br/>
       <table><tr><td>frag_id_1</td> <td>frag_id_2</td> <td>observed_reads_count</td> <td>distance_between_two_fragments</td></tr>  </table>
       See sample file here: http://hiview.case.edu/test/sample/frag_loop.IMR90.cis.sample
    - Inter-chromosome looping piars need to have 3 tab-delimited columns, in the following format:<br/>
      <table><tr><td>frag_id_1</td> <td>frag_id_2</td> <td>observed_reads_count</td> </tr>  </table>
        See sample file here: http://hiview.case.edu/test/sample/frag_loop.IMR90.trans.sample
    - These two files needs to be sorted before you run the pipeline (sort -k1 -k2).
    - **If you have a bam file and need help generate the fragment-pair files, we have a pipeline included.** Go to the "bin" folder, find the script named "bam_to_frag_loop.sh". Before you run, replace "PATH_TO_REF" and "PATH_TO_BIN" with the pathes to "ref" and "bin" correspondingly. Then run the pipeline: <br/>./bam_to_frag_loop.sh <bam_file> <name_of_your_data> <mapped_read_length_in_your_bam_file> 

2. Finally, run the pipeline:<br/>
 ```./HiCorr.sh <cis_loop_file> <trans_loop_file> <name_of_your_data> <reference_genome> [options]``` <br/>
 #### Options
 * _--no-GC-map_ <br/> 
      If _--no-GC-map_ is specified, HiCorr will not correct mappability and GC content. Note that based on our experience, GC content and mappability have limited effect on final normalization result. 

### Output
The final result will be an anchor-to-anchor looping pairs file, which has 5 columns:<br/>
     <table><tr><td>anchor_id_1</td><td>anchor_id_2</td> <td>obserced_reads_count</td> <td>expected_reads_count</td> <td>p_value_ </td></tr></table>
See sample file here: http://hiview.case.edu/test/sample/anchor_2_anchor.loop.IMR90.p_val.sample
