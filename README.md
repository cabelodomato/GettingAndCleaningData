# Getting and Cleaning Data

## Course Project

R script called run_analysis.R is doing the following:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive activity names.
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

## Steps to reproduce this course project

1. Set your workdir with ```setwd()```
2. Put ```run_analysis.R``` in to workdir
3. Run ```source("run_analysis.R")```, it will load all needed files and dependencies. 
Then it will generate a new file ```tiny_data.txt``` in your working directory.

## Dependencies

```run_analysis.R``` file will help you to install the dependencies automatically. It depends on ```plyr``` and ```dplyr```. 

## Codebook
Information about the datasets is provided in `CodeBook.md`.  