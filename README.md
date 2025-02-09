# A new hybrid gene selection method for diagnosing cancer diseases
![Graphical Abstract](https://github.com/Farzad-Zandi/ancer-Gene-Selection/blob/main/Graphical%20Abstract.png)
## Abstract
Cancer remains a significant global health challenge, contributing to nearly 10 million deaths each year and imposing substantial burdens on individuals and healthcare systems worldwide. Thanks to the availability of analytical techniques, we can now generate thousands of data points using various OMICs techniques, such as proteomics, metabolomics, and genomics, for any given samples. However, dealing with such complex and multidimensional data introduces higher complexity, requiring the use of proper techniques to extract biologically relevant information. In this study, we employed three microarray datasets for Prostate, SRBCT, and Leukemia cancers, introducing a novel swarm intelligent technique to identify a precise and effective set of genetic markers. This approach aims to enhance diagnostic and prognostic accuracy while simplifying computational processes. Utilizing six common dimensionality reduction techniques and applying a Chaotic Crow Search feature selection with specific APfl parameters, we refined the top 10 genes using parallel computing. The combination of Fisher Score and Chaotic Crow Search yielded accuracy ranging from 92.63 to 96.23. Ultimately, this study successfully pinpointed a small set of genes, fewer than 10, with accuracy values spanning 90.83 to 96.23, potentially valuable for 3 very diverse cancers. The selected genes exhibit functional enrichment in biological processes (BP) related to lymphocyte differentiation, mononuclear cell differentiation, and B cell differentiation. In terms of cellular components (CC), the genes are associated with tertiary granule, secretory granule lumen, cytoplasmic vesicle lumen, and vesicle lumen. Additionally, the molecular functions (MF) of these genes include endopeptidase inhibitor activity, peptidase inhibitor activity, and endopeptidase regulator activity. This enriched gene profile suggests potential implications for cancer diagnosis, particularly in understanding the regulatory mechanisms and differentiation processes that may play crucial roles in cancer pathogenesis and progression.
## Keyword
Cancer, OMICs techniques, Swarm intelligent, Genetic markers, Feature selection, Parallel computing.
## Authors
Farzad Zandi, Parvaneh Mansouri, Mohammad Goodarzi.
## DOI and Links
## Description
Prostate dataset files are available in `.csv` and `.mat` format in Data folder.
Feature selection methods for step 1 are available in Feature selection folder.
Selected gene indexes with their accuracy that produced as `.csv` files are available in GeneIndex_and_Accuracy_CSV_Outputs folder.
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

    
