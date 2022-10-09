
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
