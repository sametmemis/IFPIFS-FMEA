# IFPIFS-FMEA

**Hesitation-Aware Failure Mode and Effects Analysis via Intuitionistic Fuzzy Parameterized Intuitionistic Fuzzy Soft Matrices**

MATLAB implementation of IFPIFS-FMEA and the data and scripts needed to reproduce the results of the paper below. IFPIFS-FMEA represents each occurrence (O), severity (S) and detection (D) rating by a membership and a non-membership degree, treats the experience of each expert as an intuitionistic fuzzy parameter weight, and ranks the failure modes with iPEM, a soft decision-making method based on the prevalence effects of alternatives and parameters in the ifpifs-matrices space.

## Citation

If you use this code or data, please cite:

S. Memiş, B. O. Ceylan. Hesitation-Aware Failure Mode and Effects Analysis via Intuitionistic Fuzzy Parameterized Intuitionistic Fuzzy Soft Matrices: Risk Prioritization of a Marine Main Engine Lubricating Oil System. *Ships and Offshore Structures* (submitted).

The expert ratings were originally collected and published in:

B. O. Ceylan, S. Memiş, 2025. Fuzzy parameterized fuzzy soft matrices-based failure mode and effects analysis (FPFS-FMEA) with ship lubricating oil system risk assessment. *Ocean Engineering*, 342, 123049.
DOI: https://doi.org/10.1016/j.oceaneng.2025.123049

## Repository contents

| File / folder | Description |
|---|---|
| `IFPIFSFMEA.m` | IFPIFS-FMEA (Algorithm 1 of the paper): builds the ifpifs-matrix from crisp O-S-D ratings and an experience vector and returns the risk scores, normalized risk scores and the riskiest failure mode |
| `iPEM.m` | Soft decision-making method iPEM in the ifpifs-matrices space (Arslan et al., 2021) |
| `score2rank.m` | Converts a score vector into ranking orders (1 = highest score; ties receive the average rank) |
| `Demo_LubricatingOilSystem.m` | Reproduces all results of the case study and writes them to `Results_LubricatingOilSystem.xlsx` |
| `VIKOR.m`, `TOPSIS.m`, `COPRAS.m` | Methods used for comparison, applied to the mean O-S-D ratings (VIKOR-, TOPSIS- and COPRAS-FMEA) |
| `WERANK.m` | WE-RANK, entropy weights and Borda count (Akdamar et al., 2026) |
| `CCE10.m` | Soft decision-making method used for FPFS-FMEA (Enginoğlu & Memiş, 2018) |
| `LO_data.mat` | `OSD` (18 x 15 crisp ratings) and `B` (experience vector of the five experts) |
| `OSD_ratings.csv` | The same ratings in plain text; columns `O_E1, S_E1, D_E1, ..., O_E5, S_E5, D_E5` |
| `expert_experience.csv` | Ship and academic experience of the experts and the experience vector B |
| `IF_linguistic_scale.csv` | Intuitionistic fuzzy linguistic scale IF1-IF10 (membership, non-membership and hesitation degrees) |

## Data

The dataset covers 18 failure modes (LO-01 to LO-18) of the main engine lubricating oil system of a 50,000 DWT product tanker (MAN B&W 6S50MC-C) rated by five marine engineers on a 1-10 scale for occurrence, severity and detection. The experience vector B = [9 10 12 8 14] is the sum of the ship and academic experience (in years) of each expert. The ratings contain no personal data.

## Usage

Requirements: MATLAB R2016b or later (no toolboxes are required). Keep all files in the same folder.

```matlab
% Reproduce all results of the case study
Demo_LubricatingOilSystem

% Apply IFPIFS-FMEA to your own data
% OSD: m x 3n matrix of integer ratings in {1,...,10}, columns [O1 S1 D1 ... On Sn Dn]
% B  : 1 x n experience vector of the n experts
[sv,dv,op] = IFPIFSFMEA(OSD,B);
rank = score2rank(dv);           % 1 = riskiest failure mode
```

A different intuitionistic fuzzy linguistic scale can be supplied as two 1 x 10 vectors:

```matlab
[sv,dv,op] = IFPIFSFMEA(OSD,B,scaleMu,scaleNu);
```

## Expected results

With the experience-based weights, the five highest-risk failure modes are LO-11 (1.0000), LO-14 (0.9893), LO-12 (0.8802), LO-13 (0.7937) and LO-07 (0.7842). The Spearman rank correlations between IFPIFS-FMEA and RPN-, VIKOR-, TOPSIS-, COPRAS-FMEA, WE-RANK and FPFS-FMEA are 0.957, 0.734, 0.963, 0.967, 0.953 and 0.983, respectively, and Kendall's W across the seven rankings is 0.941.

## References

- B. Arslan, T. Aydın, S. Memiş, S. Enginoğlu, 2021. Generalisations of SDM methods in fpfs-matrices space to render them operable in ifpifs-matrices space and their application to performance ranking of the noise-removal filters. *Journal of New Theory*, 36, 88-116.
- E. Akdamar, G. Elidolu, M. Gögebakan, B. O. Ceylan, 2026. Entropy-based Borda extended weighted expert FMEA approach: Comparison with classical and fuzzy FMEA on a ship system. *Applied Soft Computing*, 188, 114424.
- S. Enginoğlu, S. Memiş, 2018. A configuration of some soft decision-making algorithms via fpfs-matrices. *Cumhuriyet Science Journal*, 39(4), 871-881.
- H. S. Tooranloo, A. S. Ayatollah, 2016. A model for failure mode and effects analysis based on intuitionistic fuzzy approach. *Applied Soft Computing*, 49, 238-247.

## License

The code (`.m` files) is released under the MIT License (`LICENSE`). The data files (`LO_data.mat`, `OSD_ratings.csv`, `expert_experience.csv`, `IF_linguistic_scale.csv`) are released under the Creative Commons Attribution 4.0 International License (CC BY 4.0, https://creativecommons.org/licenses/by/4.0/). When using the data, please cite Ceylan and Memiş (2025), Ocean Engineering, 342, 123049, https://doi.org/10.1016/j.oceaneng.2025.123049.

## Contact

Samet Memiş, Department of Marine Engineering, Faculty of Maritime, Bandırma Onyedi Eylül University, Türkiye (smemis@bandirma.edu.tr)
