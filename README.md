# faceHands
Repository for Rosenke et al. (201X) - Modeling neural tuning in human ventral temporal cortex predicts the perception of visual ambiguity.

_______
The repository contains two folders:
(1) code
(2) data

Code:
Code was developed and tested in MATLAB version 2015b.
We provide all code necessary to generate the figures of the main article as well as the supplementary materials.

Each script assumes that the current working directory is faceHands/code/ and that code and data folders are not modified.

helperFunctions: This folder contains plotting functions used for some of the scripts.

Fig1b_calibratedFaceHandLikeness.m: This script used the mTurk ratings for face- and hand-likeness ratings and plots Figure 1b.

Fig1c_calibratedDissimilarity.m: This script uses the mTurk ratings for (1) silhouettes with 100% variability among individual examples of each morph level, and (2) silhouettes with 75% variability and plots the dissimilarity ratings for the final stimulus set used. The final stimuli had 75% variability for morph level 1 (face silhouettes) and 100% variability for all other morph levels. This script plots Figure 1c.

Fig2_SuppFig1_plotROIbetas.m: This script plots the average beta responses for each ROI across subjects. The left hemisphere corresponds to Supplementary Figure 1, the right hemisphere to Figure 2.

Fig3_plotBehavior.m: This script plots the behavioral ratings of the 14 participants that took part in the main experiment. The plot corresponds to Figure 3.

linearRegressionAndFigures.m: This script runs the linear regression models for all main analyses done in the manuscript and plots the corresponding results. Line 17 can be modified to change which model will be run and plotted.



Data:
This folder contains the data relevant for all scripts in the form of MAT files.

behavior.mat: The categorization variable contains the average behavioral ratings that each subject submitted during the behavioral experiment. Each row corresponds to a subject and each column to one of the 5 morph level. Entries are averaged for ratings of 12 exemplars for the respective morph level. A rating of 1 corresponds to "face" while a rating of zero corresponds to "hand".

dissimilarityRatings.mat: Both variables contain the dissimilarity ratings of mTurk workers for 100% variability among morph level exemplars and 75% variability. Rows correspond to individual ratings. Column 1 corresponds to the morph level of the stimulus pair, column 2 specifies the exemplar pair used and column 3 shows the worker's rating for that stimulus pair. Ratings were on a scale from 1-7 with 7 being most dissimilar.

facehandLikenessRatings.mat: The "facelike" and "handlike" ratings from mTurk workers on the final round of calibrated morph stimuli. Each row corresponds to individual ratings. Column 1 specifies the morph level, column 2 the exemplar used and column 3 the rating. The ratings were on a scale from 1-5 with 5 being most "handlike" or "facelike", respectively.

roiBetas.mat: A structure matrix with ROI betas for each subject, hemisphere, ROI. Each structure contains information of the GLM results of a subject's ROI. Rows correspond to subjects, columns correspond to ROIs.

subjectColors.mat: A color matrix that is used for the color-matched plots for individual subject dots and lines throughout the manuscript. 
