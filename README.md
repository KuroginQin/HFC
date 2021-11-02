# Towards a Profiling View for Unsupervised Traffic Classification by Exploring the Statistic Features and Link Patterns

This repository provides a reference matlab implementation of *HFC* introduced in the paper "Towards a Profiling View for Unsupervised Traffic Classification by Exploring the Statistic Features and Link Patterns".

### Abstract
In this paper, we study the network traffic classification task. Different from existing supervised methods that rely heavily on the labeled statistic features in a long period (e.g., several hours or days), we adopt a novel view of unsupervised profiling to explore the flow features and link patterns in a short time window (e.g., several seconds), dealing with the zero-day traffic problem. Concretely, we formulate the traffic identification task as a graph co-clustering problem with topology and edge attributes, and proposed a novel Hybrid Flow Clustering (HFC) model. The model can potentially achieve high classification performance, since it comprehensively leverages the available information of both features and linkage. Moreover, the two information sources integrated in HFC can also be utilized to generate the profiling for each flow category, helping to reveal the deep knowledge and semantics of network traffic. The effectiveness of the model is verified in the extensive experiments on several real datasets of various scenarios, where HFC achieves impressive results and presents powerful application ability.

### Usage
To check the (clustering) performance of HFC with different parameter settings on different datasets, open the following matlab script:
```
HFC_demo.m
````
Select the test dataset (by setting variables 'file' and 'data_name') and then run the script. The evaluation results w.r.t. different parameter settings will be saved in 'res/'. Some example results (by running HFC_demo.m) have been saved in 'res/examples'.

To check an example case study regarding the flow profiling on the ISP(2) dataset, run the following matlab script:
```
HFC_case_study.m
``` 
The derived (1) link membership matrix **Z***, (2) feature description matrix **Y***, (3) transition matrix **U***, (4) node membership matrix **R***, and (5) final cluster semantic descriptions will be saved in 'res/'.

All the datasets can be found in 'data/' with the .m format. To include your own dataset, you need to provide (1) an N-by-M flow feature matrix **F** (e.g.,, named as 'feats') with N and M as the number of flows and discrete features, (2) a TAG edge list (e.g., named as 'TAG_list'), and (3) a ground-truth label sequence w.r.t. each edge/flow (e.g., named as 'gnd'). In particular, the TAG edge list is an M-by-2 matrix, with the i-th row indicating the source and destination nodes of the i-th flow.

### Citing
Please cite the following paper if you use *HFC* in your research:
>@inproceedings{qin2019towards,
>  title={Towards a Profiling View for Unsupervised Traffic Classification by Exploring the Statistic Features and Link Patterns},
>  author={Qin, Meng and Lei, Kai and Bai, Bo and Zhang, Gong},
>  booktitle={Proceedings of the ACM SIGCOMM 2019 Workshop on Network Meets AI \& ML},
>  pages={50--56},
>  year={2019}
>}

If you have any questions regarding this project, please contact the authors via [mengqin_az@foxmail.com].