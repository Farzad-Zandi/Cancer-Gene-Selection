Prostate-Cancer-Gene-Selection
A new hybrid gene selection model for prostate cancer diagnosis.
% Crow Search Algorithm. 
% Orignal code: https://www.mathworks.com/matlabcentral/fileexchange/64609-binary-chaotic-crow-search-algorithm
% Feature selection via a novel chaotic crow search algorithm.
% https://link.springer.com/article/10.1007/s00521-017-2988-6https://link.springer.com/article/10.1007/s00521-017-2988-6
% Feature selection based on crow search and kNN classifier.
==========================================================================================================================
Files description:
Main_crow_search.m ==> Main file.
BinaryInitialization.m ==> Initialize population positions and got their fitness.
obj.m ==> Object function to calculate fitness by KNN classifier.
chaos.m ==> Generate Chaotic vectors.
BCCSA.m ==> Feature selection via chaotic crow search algorithm.
------------------------------------------------------------------------------------
Folders descripton:
Data ==> prostate dataset file.
Feature selection ==> feature selection methods for step 1.
GeneIndex_and_Accuracy_CSV_Outputs ==> Selected gene indexes with their accuracy that produced as CSV files.
--------------------------------------------------------------------------------------------------------------
Getting Started:
Running Main_crow_search.m file will done the all steps automatically.
-------------------------------------------------------------------------
Results:
For 10 iteration:
    For each feature selection method (1 to 6).
    For each chaotic vectors (1:10) in addition to const0.5 and random numbers.
    For max Iteration.
    For APfl method.
    Matlab outputs as .mat files generate.
As a results for each chaotic, 54 .mat file will be generate.

    
