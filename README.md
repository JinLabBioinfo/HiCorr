# HiCorr
This is a pipeline designed to normalize HiC data. It needs to be run in a unix/linux environment. Currently it includes reference files of genome build hg19, mm10 to be added.

How to setup
1. Download everything into your local machine.
2. Go to the directory "ref_hg19", run the script "prep_ref.sh"
3. Go back to the main directory, edit "run.sh":
   - Line 3: Replace "PATH_TO_REF" with the path to your directory "ref_hg19"
   - Line 4: Replace "PATH_TO_BIN" with the path to your directory "bin"

To run the pipeline
1. You will need two input files: one file contains intra-chromosome looping fragment pairs(cis pairs), and another contains inter-chromosome looping fragment pairs(trans pairs).
2. Intra-chromosome looping pairs need to have 4 tab-delimited columns, in the following format:
    frag_id_1    frag_id_2    observed_reads_count    distance_between_two_fragments
    See sample files here: http://hiview.case.edu/test/sample/frag_loop.IMR90.cis.sample
3. Inter-chromosome looping piars need to have 3 tab-delimited columns, in the following format:
    frag_id_1    frag_id_2    observed_reads_count
    See sample files here: http://hiview.case.edu/test/sample/frag_loop.IMR90.trans.sample
4. These two files needs to be sorted before you run the pipeline (sort -k1 -k2).
5. Finally, run the pipeline:
./HiCorr.sh <cis_loop_file> <trans_loop_file> <name_of_your_data>
