# 🌉 Bayesian Reliability Updating of the Zijlweg Viaduct

**Author:** Neguse Solomon Mekonnen

**Programme:** NoRisk Erasmus Mundus Joint Master's Programme

**Supervisors:** Dr. Eva Lantsoght, Dr. Rolando Chacón

**Year:** June 22, 2026

**Status:** Final Dissertation Submission, 2026

## Overview

This repository contains the code, datasets, and results developed for the Master's dissertation:

**Bayesian Reliability Updating of Bridge Structural Reliability Using Monitoring Data and Stop Criteria: A Case Study of the Zijlweg Viaduct**

The research applies the Bayesian reliability updating framework proposed by De Vries et al. (2025) to monitoring data obtained during the 2015 proof load test of the Zijlweg viaduct, an alkali-silica reaction (ASR) affected reinforced concrete slab bridge located in Noord Brabant, the Netherlands.

## Research Objectives

The study investigates how field monitoring data (strains and crack widths) can be incorporated into a Bayesian framework to:

* Quantify the reliability gain provided by successful proof load increments.
* Bypass the inherent conservatism of analytical ASR-capacity models.
* Validate the consistency between quantitative reliability indices (β) and deterministic mechanical stop criteria (CSCT/CSDT).
* Determine if a test can be safely terminated once annual target reliability levels are achieved.

## Methodology

The analysis follows an integrated workflow:

1. Stage 1: Preprocessing of 2015 proof load test data using MATLAB and Python.
2. Stage 2: Corrected sectional analysis using Latin Hypercube Sampling (LHS) to establish prior resistance distributions.
3. Stage 3: Bayesian updating using Markov Chain Monte Carlo (MCMC) simulations (1 × 10^8 samples) to calculate posterior reliability.
4. Stage 4: Real-time safety verification using Critical Shear Crack Theory (CSCT) and Critical Shear Displacement Theory (CSDT) stop criteria.

## Key Results

The analysis re-evaluated the viaduct using Annual Reliability Targets for Consequence Class 3 (CC3) structures, as specified in Dutch assessment guidelines (NEN 8700).

### Final Reliability at Maximum Proof Load (Step 5)

| Failure Mode | Updated Reliability Index (β_after) | Annual Target (New Structure) |
| ------------ | ----------------------------------: | ----------------------------: |
| **Bending**  |                            **5.33** |                          4.70 |
| **Shear**    |                            **4.89** |                          4.70 |

### Main Findings

* **Safety Targets:** Both failure modes exceeded the Annual Target for New Structures (β = 4.7), demonstrating that the viaduct satisfies the required safety level for continued service despite ASR damage.
* **Testing Efficiency:** The annual target reliability level for disapproval or usage (β = 4.0) was achieved at Step 3 for bending and Step 4 for shear, indicating the potential for earlier termination of instrumented proof load tests when reliability-based stop criteria are satisfied.
* **ASR Restraint Effect:** The results suggest that reinforcement restraint of ASR-induced expansion may contribute to enhanced shear resistance beyond that predicted by conventional analytical reduction factors. This observation provides a possible explanation for the conservatism of standard ASR assessment approaches.
* **Methodological Consistency:** Deterministic stop criteria remained within the "Green Light" zone throughout the proof load test, consistent with the high reliability indices obtained through Bayesian updating.

## 📂 Repository Structure

```text
zijlweg-bayesian-reliability/
│
├── README.md
│
├── code/
│   ├── cpp/
│   │   ├── chapter_5_bending_ZIJLWEG.cpp
│   │   ├── chapter_5_shear_ZIJLWEG_FIXED.cpp
│   │   └── chapter_5_case_study_2_sectional_analysis_ZIJLWEG.cpp
│   │
│   ├── python/
│   │   ├── extract_bending_data.py
│   │   ├── extract_shear_data.py
│   │   ├── calculate_structural_inputs.py
│   │   ├── calculate_correct_mX.py
│   │   ├── generate_figure_5_1.py
│   │   ├── generate_figure_5_2.py
│   │   ├── generate_figure_5_3.py
│   │   ├── generate_figure_5_4.py
│   │   ├── generate_figure_5_5.py
│   │   └── generate_figure_5_6.py
│   │
│   └── matlab/
│       ├── bending04.m
│       └── shear01.m
│
├── results/
│   ├── Moment-strain curves ZIJLWEG corrected.csv
│   ├── bending_MCMC_output.txt
│   └── shear_MCMC_output.txt
│
└── figures/
    ├── Fig5.1_moment_strain_curves.png
    ├── Fig5.2_prior_distributions.png
    ├── Fig5.3_bending_reliability.png
    ├── Fig5.4_resistance_ratio_model.png
    ├── Fig5.5_shear_reliability.png
    └── Fig5.6_stop_criteria.png
```

## ⚙️ Software and Dependencies

### C++ Requirements

* Boost (Math/Distributions)
* Eigen 3.0+
* OpenMP (Parallel Processing)
* rdv structural reliability library (included)

### Python Requirements

* NumPy
* Matplotlib
* SciPy

### MATLAB Requirements

* MATLAB
* Statistics and Machine Learning Toolbox

## 🔄 Reproducibility

To reproduce the results presented in the dissertation:

1. Extract and preprocess monitoring data using the MATLAB scripts.
2. Calculate structural inputs and generate corrected sectional analysis results using the Python scripts.
3. Compile and execute the C++ programs for sectional analysis and Bayesian reliability updating.
4. Verify the outputs using the MCMC result files.
5. Regenerate all dissertation figures using the provided Python scripts.

The final reliability indices and figures reported in the dissertation can be reproduced using the data and scripts provided in this repository.

## 📖 Citation

Mekonnen, N. S. (2026). *Bayesian Reliability Updating of Bridge Structural Reliability Using Monitoring Data and Stop Criteria: A Case Study of the Zijlweg Viaduct*. Master's Dissertation, NoRisk Erasmus Mundus Joint Master's Programme.

## References

* De Vries, R., et al. (2025). *Structural reliability updating on the basis of proof load testing and monitoring data*. Engineering Structures, 330, 119863.
* Lantsoght, E. O. L., et al. (2017). *Towards standardisation of proof load testing: Pilot test on viaduct Zijlweg*. Structure and Infrastructure Engineering, 14(3), 365-380.

## 📜 License

This repository is intended for academic and research purposes. Please cite the associated dissertation when using or adapting the material.
