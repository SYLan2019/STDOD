# STDOD
 A visual object tracking method where we take into account the difference between occlusion and self-deformation in a spatial-temporal regularised DCF filter. (Robust Visual Object Tracking with Spatiotemporal Regularisation and Discriminative Occlusion Deformation, International Conference on Image Processing (ICIP). IEEE, 2021, pp. 1879-1883.)

 In this demo video, a comparison of our approach (red) with STRCF (green), HCFstar (blue), ASRCF (yellow),  and GFSDCF (cyan) on the first 240 frames of Girl2 sequence  from OTB100. 

In this work, we We have referenced and borrowed codes from the GFSDCF tracker (https://github.com/XU-TIANYANG/GFS-DCF). Please reference the usage to download the model (imagenet-resnet-50-dag.mat) from GFSDCF, and copy it to the directory ./STDOD/tracker_featu/offline_models/

Along with our tidying process, Codes for STDOD Will be released gradually.

Configuring matconvent for new version of cuda. 


## []. Citing STDOD

If you use this repository or would like to refer the paper, please use the following BibTeX entry
```
 @inproceedings{lan2021robust,
  title={Robust Visual Object Tracking with Spatiotemporal Regularisation and Discriminative Occlusion Deformation},
  author={Lan, Shiyong and Li, Jin and Sun, Shipeng and Lai, Xin and Wang, Wenwu},
  booktitle={2021 IEEE International Conference on Image Processing (ICIP)},
  pages={1879--1883},
  year={2021},
  organization={IEEE}
}
```
