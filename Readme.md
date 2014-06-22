# README

## Script Useage 
The script run_analysis.R contains a single function tidyDataOne that takes as
input the name of the directory containg a folder of the raw data. 
It assumes that the raw data folder is named "UCI HAR Dataset". 

Running the script switches the working directory to "directory", 
merges several data files, extracts the means of all data columns
that are themselves means or standard deviations and writes out these means 
to a new file called "tidiedData.csv" in "directory". The script returns 
the user to their original working directory. 


