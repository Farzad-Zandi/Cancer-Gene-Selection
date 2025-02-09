# A new hybrid gene selection method for diagnosing cancer diseases
![Graphical Abstract](https://github.com/Farzad-Zandi/ancer-Gene-Selection/blob/main/Graphical%20Abstract.jpg)
## Abstract
Understanding many biological processes relies heavily on accurately predicting protein-protein interactions (PPIs). In this study, we propose a novel method for predicting PPIs that is based on LogitBoost with a binary bat feature selection algorithm. Our approach involves the extraction of an initial feature vector by combining pseudo amino acid composition (PseAAC), pseudo-position-specific scoring matrix (PsePSSM), reduced sequence and index-vectors (RSIV), and autocorrelation descriptor (AD). Subsequently, a binary bat algorithm is applied to eliminate redundant features, and the resulting optimal features are fed into the LogitBoost classifier for the identification of PPIs. To evaluate the proposed method, we test it on two databases, Saccharomyces cerevisiae and Helicobacter pylori, using 10-fold cross-validation, and achieve accuracies of 94.39% and 97.89%, respectively. Our results showcase the significant potential of our pipeline in accurately predicting protein-protein interactions (PPIs), thereby offering a valuable resource to the scientific research community.
## Keyword
Predicting protein-protein interactions, Features extraction, Features selection, Machine learning, Swarm intelligence, Ensemble learning.
## Authors
Farzad Zandi, Parvaneh Mansouri, Mohammad Goodarzi.
## DOI and Links
## Description
Datasets are available in the `Datasets` folder in `.mat` and `.csv` format.  
Feature extraction methods are available in the `feature extraction` folder implemented by MATLAB programming language.  
Feature selection method (Binary Bat Algorithm) is available in the `feature selection` folder implemented by MATLAB programming language.  
## Usage
To run the model, follow the steps below:

1. Extract features with 4 feature extraction methods: AD, RSIV, PsePSSM, PseAAC as follows:
   - Run `Auto_yeast.m` for extracting autocorrelation descriptor features.
     ```sh
     Auto_yeast.m
     ```
   - Run `selectfeature_Y.m` for extracting reduced sequence and index-vectors features.
     ```sh
     selectfeature_Y.m
     ```
   - Run `PAAC_Y.m` for extracting pseudo amino acid composition features.
     ```sh
     PAAC_Y.m
     ```
   - Create pseudo-position-specific scoring matrix with Blast and run `PsePSSM_y.m` for extracting pseudo-position-specific scoring matrix features.
     ```sh
     PsePSSM_y.m
     ```
2. Fuse the 4 extracted data sets to construct a 1318-dimension vector.
3. Run BBA code for extracting the best features and save the obtained data.
     ```sh
     BBA.m
     ```
4. Predict using any machine learning method you prefer.

## Citiation
## Contact
For further inquiries, please contact us:
- Name: Farzad Zandi.
- Email: [zandi8farzad@gmail.com](zandi8farzad@gmail.com)
- Email: [zandi_farzad@yahoo.com](zandi_farzad@yahoo.com)
- Email: [info@zandigroup.ir](info@zandigroup.ir)
- LinkedIn: [Farzad Zandi](https://www.linkedin.com/in/farzad-zandi-86a37326a/)


## Files description:

Main_crow_search.m ==> Main file.

BinaryInitialization.m ==> Initialize population positions and calculate their fitness.

obj.m ==> Object function to calculate fitness by KNN classifier.

chaos.m ==> Generate Chaotic vectors.

BCCSA.m ==> Feature selection via chaotic crow search algorithm.

## Folders descripton:

Data ==> prostate dataset files in .csv and .mat.

Feature selection ==> feature selection methods for step 1.

GeneIndex_and_Accuracy_CSV_Outputs ==> Selected gene indexes with their accuracy that produced as CSV files.

## Getting Started:

Running Main_crow_search.m file will done all steps automatically.

## Results:

For 10 iteration:

    For each feature selection method (1 to 6).
    
    For each chaotic vectors (1 to 10) in addition to const0.5 and random numbers.
    
    For 1 to max Iteration.
    
    For APfl methods.
    
        Generate matlab outputs as .mat files.
    
As a results for each chaotic, 54 .mat file will be generate.

    
