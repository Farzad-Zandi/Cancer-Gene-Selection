## Cancer-Gene-Selection.

### A new hybrid gene selection method for diagnosing cancer diseases.

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

    
