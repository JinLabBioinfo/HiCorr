# *HiCorr*
HiCorr is a pipeline designed to do bias-correction and visualization for multi-platform Hi-C(in-situ Hi-C, Arima, micro-C). HiCorr focuses on the mapping of chromatin interactions at high-resolution, especially the sub-TAD ~5kb resolution enhancer-promoter interactions, which requires more rigorous bias-correction. It needs to be run in an unix/linux environment. Currently it includes reference files of genome build hg19 and mm10, the reference files for other genome build will be provided upon request, please contact Shanshan Zhang(ssz20@case.edu) or Fulai Jin(fxj45@case.edu). For a noise-free and enhanced signal, please check [DeepLoop](https://github.com/JinLabBioinfo/DeepLoop) we recently developed.<br/>
## Setup
```
git clone https://github.com/shanshan950/HiCorr.git
cd HiCorr/
chmod 755 HiCorr
chmod -R 755 bin/*
```
## Gateway for different Hi-C data type:
Each section descibes reference file downloading, preprocessing (mapping and fragment filteration), and how to run HiCorr.
 ## :point_right:  [*HiCorr on micro-C*](https://github.com/JinLabBioinfo/HiCorr/blob/master/documents/HiCorr_micro-C.md)
 ## :point_right:  [*HiCorr on Arima*](https://github.com/JinLabBioinfo/HiCorr/blob/master/documents/HiCorr_Arima.md)
 ## :point_right:  [*HiCorr on HindIII enzyme Hi-C*](https://github.com/JinLabBioinfo/HiCorr/blob/master/documents/HiCorr_HindIII.md)
 ## :point_right:  [*HiCorr on eHi-C*](https://github.com/JinLabBioinfo/HiCorr/blob/master/documents/HiCorr_eHi-C.md)
 ## :point_right:  [*HiCorr on in-situ Hi-C or DPNII/Mbol enzyme Hi-C*](https://github.com/JinLabBioinfo/HiCorr/blob/master/documents/HiCorr_insituHi-C.md)
 ## :point_right:  [*Visualize HiCorr contact heatmaps*](https://github.com/JinLabBioinfo/HiCorr/blob/master/documents/HiCorr_heatmap.md)
 ## :point_right:  [*Compatible with HiCPro valid pairs*](https://github.com/JinLabBioinfo/HiCorr/blob/master/documents/HiCpro%20validPairs%20input.md)
 ## :point_right:  [*Generate reference files for HiCorr*](https://github.com/JinLabBioinfo/HiCorr/blob/master/documents/generate_reference_files.md)
 
### Next step analysis
   We developed DeepLoop to remove noise and enhance signals from low-depth Hi-C data, See more details in https://github.com/JinLabBioinfo/DeepLoop <br/>
## 40 Processed Hi-C datasets by *HiCorr* and *DeepLoop* can be visualized in [website](https://hiview.case.edu/public/DeepLoop/) <br/>

## Citation: <br/>
_Lu,L. et al._ Robust Hi-C Maps of Enhancer-Promoter Interactions Reveal the Function of Non-coding Genome in Neural Development and Diseases. Molecular Cell; doi: https://doi.org/10.1016/j.molcel.2020.06.007


