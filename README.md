[![INFORMS Journal on Computing Logo](https://INFORMSJoC.github.io/logos/INFORMS_Journal_on_Computing_Header.jpg)](https://pubsonline.informs.org/journal/ijoc)

# A Decision Rule Approach for Two-Stage Data-Driven Distributionally Robust Optimization Problems with Random Recourse

This archive is distributed in association with the [INFORMS Journal on
Computing](https://pubsonline.informs.org/journal/ijoc) under the [MIT License](LICENSE).

This repository contains supporting material for the paper [A Decision Rule Approach for Two-Stage Data-Driven Distributionally Robust Optimization Problems with Random Recourse](https://doi.org/10.1287/ijoc.2021.0306) by Xiangyi Fan and Grani A. Hanasusanto. 

The software and data in this repository are a snapshot of the software and data that were used in the research reported on in the paper.

## Cite

To cite the contents of this repository, please cite both the paper and this repo, using their respective DOIs.

https://doi.org/10.1287/ijoc.2021.0306

https://doi.org/10.1287/ijoc.2021.0306.cd

Below is the BibTex for citing this snapshot of the respoitory.

```
@article{FanHanasusanto2023,
  author =        {Xiangyi Fan and Grani A. Hanasusanto},
  publisher =     {INFORMS Journal on Computing},
  title =         {A Decision Rule Approach for Two-Stage Data-Driven Distributionally Robust Optimization Problems with Random Recourse},
  year =          {2023},
  doi =           {10.1287/ijoc.2021.0306.cd},
  url =           {https://github.com/INFORMSJoC/2021.0306},
}  
```

## Description

The goal of this repository is to demonstrate a decision rule approach for two-stage data-driven distributionally robust optimization probelms with random recourse.  

## Repository Structure

### Scripts
- The folder [Inventory_Allocation](scripts/Inventory_Allocation) contains Matlab implementation (except for Benders decomposition) of the experiment "Network Inventory Allocation" discussed in the paper. 

- The folder [Newsvendor](scripts/Newsvendor) contains Matlab implementation (except for Benders decomposition) of the experiment "Multi-item Newsvendor" discussed in the paper. 

- The folder [Medical_scheduling](scripts/Medical_Scheduling) contains Matlab implementation (except for Benders decomposition) of the experiment "Medical Scheduling" discussed in the paper. 

- The folder [Benders_Inventory_Allocation](scripts/Benders_Inventory_Allocation) contains Matlab implementation of Benders decomposition in the experiment "Network Inventory Allocation".

- The folder [Benders_Newsvendor](scripts/Benders_Newsvendor) contains Matlab implementation of Benders decomposition in the experiment "Multi-item Newsvendor".

- The folder [Benders_Medical_Scheduling](scripts/Benders_Medical_Scheduling) contains Matlab implementation of Benders decomposition in the experiment "Medical Scheduling".

- The folder [Benders_Facility_Location](scripts/Benders_Facility_Location) contains Matlab implementation of Benders decomposition in the experiment "Facility Location Problem".

### Data

All the necessary [data](data) for replicating the experiments is included within the scripts.

### Results

The [results](results) folder contains the model outputs.

## Replicating

### Main Text

- To replicate the results in Table 1 & 2 in the paper, run the files [LS_Npoints_plot_general.m](scripts/Inventory_Allocation/LS_Npoints_plot_general.m), [LS_Npoints_plot_general_cons_uniform.m](scripts/Inventory_Allocation/LS_Npoints_plot_general_cons_uniform.m), and [Npoints_plot.m](scripts/Benders_Inventory_Allocation/Npoints_plot.m).

- To replicate the results in [Figure 1](results/Newsvendor_Npoints_Plot.jpg) and Table 3, run the file [Npoints_plot.m](scripts/Newsvendor/Npoints_plot.m) 

- To replicate the results in [Figure 2 (Left)](results/Newsvendor_K_plot.jpg), [Figure 2 (middle)](results/Newsvendor_epsilon_plot.jpg), and [Figure 2 (right)](results/Newsvendor_gamma_plot.jpg), run the files [K_plot_fix.m](scripts/Newsvendor/K_plot_fix.m), [epsilon_plot.m](scripts/Newsvendor/epsilon_plot.m), and [epsilon_p_plot.m](scripts/Newsvendor/epsilon_p_plot.m), respectively. 

- To replicate the results in Table 4 in the paper, run the file [Npoints_plot.m](scripts/Benders_Newsvendor/Npoints_plot.m).

### Online Appendix

- To replicate the results in [Figure C.1](results/Medical_Scheduling/MS_Npoints_Plot.jpg) and Table C.1, run the file [MS_Npoints_plot.m](scripts/Medical_Scheduling/MS_Npoints_plot.m).

- To replicate the results in Table C.2 in the paper, run the file [Npoints_plot.m](scripts/Benders_Medical_Scheduling/Npoints_plot.m).  

- To replicate the results in [Figure C.2](results/FLP_Npoints_Plot.jpg), Table C.3, and Table C.4 in the paper, run the file [Npoints_plot.m](scripts/Benders_Facility_Location/Npoints_plot.m). 


## Requirements

All optimization problems are solved using MOSEK 9.2.28 via the YALMIP interface, i.e., a toolbox in MATLAB. 

## Support

For support in using the codes, please contact the corresponding author.  
