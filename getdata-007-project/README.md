---
title: "Getting and cleaning Data, Course Proj"
author: "Dieter Jundt"
date: "Sunday, September 10, 2014"
output: html_document
---

###Data source 
Source data downloaded form  <https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip> on September 07, 2014.  
Reference: Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz. Human Activity Recognition on Smartphones using a Multiclass Hardware-Friendly Support Vector Machine. International Workshop of Ambient Assisted Living (IWAAL 2012). Vitoria-Gasteiz, Spain. Dec 2012.

Unzipped files and copied into working directory (using windows system). Processing in R.

Necessary packages loaded:

```{r}
library(plyr)
```

The data is all provided in text format. The train folder contains 7352 observations, the folder test 2947 observations. We combine the two sets and merge all control variables and observables into one dataframe.

###Reading data to build data frame
Reading in the data and combining it is done using rbind. The remove() function frees up memory after a dataframe is no longer used.

`subject_train<-read.csv("./UCI HAR Dataset/train/subject_train.txt",col.names="subjectno",header=FALSE)`
`subject_test<-read.csv("./UCI HAR Dataset/test/subject_test.txt",col.names="subjectno",header=FALSE)`
`subject<-rbind(subject_train,subject_test)`
`remove(subject_train); remove(subject_test)`

This is also done for X_train.txt and X_test.txt which give the data we use (10299 obs. of 561 variables)

The files y_train.txt and y_test.txt are listing the activites for the observations using an integer code. The lookup is provided in activity_labels.txt. The two tables were merged to provide a descriptive column of activities:  
`activities<-merge(y,activity_labels,by.x="V1",by.y="V1")`  

###picking columns of interest and naming them
`features<-read.csv("./UCI HAR Dataset/features.txt",header=FALSE,sep=" ",as.is=TRUE)`
reads in the lookup table for measurement feature integer to description string (561 different measurement types)
The integer corresponds to the column number for the data. We only are interested in measurements that have labels containing "mean" or "std". we look through the features to find those using grep:
`goodcols<-grep(".*std.*|.*mean.",features$V2,ignore.case=FALSE)`
We then keep only those columns (79 of them) and name them appropriately (after cleaning strings).

###building a data frame
cbind is used to add the subject number and activity to each observation. The resulting data frame has 81 columns.

###creating tidy data set with average of e ach variable
ddply is used to get the mean of all measurements for each of the (subjectno,activity) combination.
This tidy dataset is ordered using arrange by subject number and activity.
The result is written to file.


