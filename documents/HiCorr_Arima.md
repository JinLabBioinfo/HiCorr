# :point_down:  *HiCorr on Arima*
- Download the code from this repository, "bin/Arima/" <br/>
- Download the reference files for Arima (mm10/hg19 genome build)
```
wget --no-check-certificate https://hiview10.gene.cwru.edu/public/DeepLoop_ref/ref/Arima_HiCorr_ref.tar.gz
# old path: http://hiview.case.edu/ssz20/tmp.HiCorr.ref/ref/Arima_HiCorr_ref.tar.gz
tar -xvf Arima_HiCorr_ref.tar.gz
```
- Check the [preprocessing for Arima data (mapping, fragments filter, outs are cis and trans fragment loops)](https://github.com/JinLabBioinfo/HiCorr/blob/master/documents/Arima.preprocessing.sh) <br/>
- One [example log](https://github.com/JinLabBioinfo/HiCorr/blob/master/documents/Arima.preprocessing.example.sh) for preprocessing two biological reps of Arima Hi-C
- Run HiCorr on Arima data:
```
bash HiCorr_Arima.sh Arima_HiCorr_ref/ bin/Arima/ <frag_loop.name.cis> <frag_loop.name.trans> <name> <hg19/mm10>
   # specify the path of downloaded unzipped reference file and scripts
   # input two fragment loop files genrated from preprocessing step
   # specifiy outputname prefix
   # specify genome build, the provided reference only include hg19 and mm10
```
