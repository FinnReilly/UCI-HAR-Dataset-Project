# UCI-HAR-Dataset-Project

Uploaded content for Coursera "Getting and Cleaning Data" Course Project

Includes run_analysis.R script for cleaning and summarizing raw Samsung data.

The Source Data provided for this project must be in your working directory for this to work.

##The script does the following with the raw data - 

 1.Uses the variables provided in the "features.txt" file to extract mean and standard deviations for all measurements across all observations, and adds column names for these variables.
 
 2.Retrieves the information on subjects and activities from their respective files and adds it to the main dataset, replacing activity numbers with human readable names corresponding to those in "activity_labels.txt".
 
 3.Summarises the data to produce a table with the variables of Subject, Activity, Measurement, and Mean across all observations of that Measurement (as many of these are already means for a short time period covering that observation, this is in many cases a mean of means).

A more technical description of how the above is achieved is included in the comments within the script itself.
