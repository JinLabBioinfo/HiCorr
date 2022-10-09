
### Download reference files
After you run the following commands, you will see "ref/" in the current directory. There are 4 subdirectories under "ref/": "DPNII/  eHiC/  eHiC-QC/  HindIII".
In each subdirectory, there are reference files for genome build hg19 and mm10. </br>
[More descriptions for the reference files](https://github.com/JinLabBioinfo/HiCorr/blob/master/documents/reference_file_description.md).</br>

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

**_HiCorr has different modes: Bam-process-HindIII, Bam-process-DPNII, HindIII, DPNII, eHiC-QC, eHiC and Heatmap_**

### Bam-process
Bam-process mode takes a sorted bam file as input, processes and generates two files as outputs. The two output files are the required input files when using the HiCorr HindIII mode. The two output files are intra-chromosome looping fragment-pair file and inter-chromosome looping fragment-pair file. <br/>
This mode currently is only able to process bam file of HindIII Hi-C data. <br/>
To run the Bam-process mode, you need 6 arguments:
   
   ```./HiCorr Bam-process-HindIII <bam_file> <name_of_your_data> <mapped_read_length_in_your_bam_file> <genome> HindIII```
   
   ```./HiCorr Bam-process-DPNII <bam_file> <name_of_your_data> <mapped_read_length_in_your_bam_file> <genome> DPNII```

More details about the preprocessing (fastq to bam files to fragment loops) are [here](https://github.com/shanshan950/Hi-C-data-preprocess)
