## load packages
library(plyr)

##1. Merges the training and the test sets to create one data set

## read in subject id numbers and combine sets
subject_train<-read.csv("./UCI HAR Dataset/train/subject_train.txt",col.names="subjectno",header=FALSE)
subject_test<-read.csv("./UCI HAR Dataset/test/subject_test.txt",col.names="subjectno",header=FALSE)
subject<-rbind(subject_train,subject_test)
remove(subject_train); remove(subject_test)

## read in and merge observations X
data_train<-read.table("./UCI HAR Dataset/train/X_train.txt",header=FALSE)
data_test<-read.table("./UCI HAR Dataset/test/X_test.txt",header=FALSE)
data_X<-rbind(data_train,data_test);
remove(data_train); remove(data_test)

##2. Extracts measurements on the mean and standard deviation for each measurement

## read features (measurements so we can see which ones are mean or stddev)
features<-read.csv("./UCI HAR Dataset/features.txt",header=FALSE,sep=" ",as.is=TRUE)
## find the ones containing std or mean - decide not to include "Mean"
goodcols<-grep(".*std.*|.*mean.",features$V2,ignore.case=FALSE)
## only keep desired columns
data_X<-data_X[,goodcols]

## read in activity records, combine and convert to readable values
##3. Use descriptive activity names to name the activities in the data set
data_train<-read.csv("./UCI HAR Dataset/train/y_train.txt",header=FALSE)
data_test<-read.csv("./UCI HAR Dataset/test/y_test.txt",header=FALSE)
y<-rbind(data_train,data_test)
remove(data_train); remove(data_test)
activity_labels<-read.csv("./UCI HAR Dataset/activity_labels.txt",header=FALSE,sep=" ")
activities<-merge(y,activity_labels,by.x="V1",by.y="V1");
remove(activity_labels)

##4. Appropriately labels the data set with descriptive variable names
## get rid of parentheses, commas, make lower case, keep or insert dashes as separator
goodnames<-features[goodcols,2]
goodnames<-tolower(gsub("\\(\\)","",goodnames))
names(data_X)<-gsub("[\\(\\),]","-",goodnames)

## build dataframe and show subjects and activites as factors
dataset_mean_std<-cbind(subject, activities$V2, data_X)
dataset_mean_std$subjectno<-as.factor(dataset_mean_std$subjectno)
names(dataset_mean_std)[2]<-c("activities")
remove(data_X)

tidyset<-ddply(dataset_mean_std, .(subjectno,activities), colwise(mean)) ## maybe correct but needs reordering
tidyset<-arrange(tidyset,subjectno,activities)

##write to file so it can be submitted
write.table(tidyset,file="getdata-007-project-output.txt", row.name=FALSE)
