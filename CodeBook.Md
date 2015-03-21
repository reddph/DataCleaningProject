---
title: "Code book for Getting and Cleaning Data Course Project"
author: "Phanindra Reddigari"
date: "Monday, March 16, 2015"
output: html_document
---

##### The UCI HAR zip file is downloaded from URL: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 
#####and extracted to UCI HAR Dataset folder in the working directory using the R-function unzip

#### Data files used for analysis from UCI HAR folder:
1. README.txt
2. features_info.txt
3. features.txt
4. activity_labels.txt
5. train/X_train.txt
6. train/y_train.txt
7. train/subject_train.txt
8. test/X_test.txt
9. test/y_test.txt
10.subject_test.txt

#### Brief description of variables:

**_subject_train_** - Data frame to stage the stage the training subject identifiers  
**_X_train_** - Data frame to stage the training observations  
**_y_train_** - Data frame to stage the training activity identifiers  
**_subject_test_** - Data frame to stage the test subject identfiers  
**_X_test_** - Data frame to stage the test observations  
**y_test** - Data frame to stage the test activity identifiers  
**_activity_labels_** - Data frame to stage the activity names (the identifiers here are cross referenced in y test and train data sets)  
**_features_** - Data frame to stage the variable names  
**_X_unified_** - Data frame to merge (consolidate) the test and training observations  
**_meanStdFeatureNames_** - Character vector to stage variables associated with mean and std in the features    
**_X_unified_mean_Std_** - Data frame to unify the test and training mean and std observation set of interest    
**_Subjects_unified_** - Data frame to unify the test and training subject identifier data sets  
**_ActivityId_unified_** - Data frame to unify the test and training activity identifier data sets  
**_SetType_** - Data frame to identify the test and training label to the unified mean std set  
**_ID_** - a vector of row idenfiers over the entire unified set, used to sort the   data set to the original order since merging the activity label changes the data order  
**_X_unified_index_slice_** - Data frame comprising SubjectId, SetType, and ActivityName vectors  
**_by_SubjAct_** - tidy data to summarize the average of all measurements grouped by subject and activity name across 79 variables pertaining to mean and std  
**_ActSubjAvgStats.txt_** - Output file name. The *by_SubjAct* data frame to the output file in the working directory

#### R Script name:

**run_analysis.R**  

#### Description of algorithm:  

Please see README for detailed description of the algorithm used to derive the independent tidy data set with the average of each variable for each subject and activity  

#### Summary of the methodology used to derive the wide tidy data set:  

* Extract a subset of the features by searching for "-Mean" or "-Std" text string to isolate the useful feature subset for further processing. The criterion for subsetting is to search for case insensitive string patterns: "-mean" or "-std". This criterion may exclude feature names which may have "mean" or "std" in them but for this analysis, it is assumed that they are angle measurements. Here is a code chunk used to extract the tidy data set:  
    
```
grep("-Mean|-Std", features$V2, ignore.case=TRUE, value=TRUE)  
```

This methodology results in 46 variables for mean and 33 variables for std in addition to Subject and activity variables. Following is a sorted list of the variables in the final data set, with the sort done in decreasing order. This places all the time domain signals in the subset before the frequency domain signals 

```
 [1] "tGravityAccMag-std()"            "tGravityAccMag-mean()"          
 [3] "tGravityAcc-std()-Z"             "tGravityAcc-std()-Y"            
 [5] "tGravityAcc-std()-X"             "tGravityAcc-mean()-Z"           
 [7] "tGravityAcc-mean()-Y"            "tGravityAcc-mean()-X"           
 [9] "tBodyGyroMag-std()"              "tBodyGyroMag-mean()"            
[11] "tBodyGyroJerkMag-std()"          "tBodyGyroJerkMag-mean()"        
[13] "tBodyGyroJerk-std()-Z"           "tBodyGyroJerk-std()-Y"          
[15] "tBodyGyroJerk-std()-X"           "tBodyGyroJerk-mean()-Z"         
[17] "tBodyGyroJerk-mean()-Y"          "tBodyGyroJerk-mean()-X"         
[19] "tBodyGyro-std()-Z"               "tBodyGyro-std()-Y"              
[21] "tBodyGyro-std()-X"               "tBodyGyro-mean()-Z"             
[23] "tBodyGyro-mean()-Y"              "tBodyGyro-mean()-X"             
[25] "tBodyAccMag-std()"               "tBodyAccMag-mean()"             
[27] "tBodyAccJerkMag-std()"           "tBodyAccJerkMag-mean()"         
[29] "tBodyAccJerk-std()-Z"            "tBodyAccJerk-std()-Y"           
[31] "tBodyAccJerk-std()-X"            "tBodyAccJerk-mean()-Z"          
[33] "tBodyAccJerk-mean()-Y"           "tBodyAccJerk-mean()-X"          
[35] "tBodyAcc-std()-Z"                "tBodyAcc-std()-Y"               
[37] "tBodyAcc-std()-X"                "tBodyAcc-mean()-Z"              
[39] "tBodyAcc-mean()-Y"               "tBodyAcc-mean()-X"              
[41] "fBodyGyro-std()-Z"               "fBodyGyro-std()-Y"              
[43] "fBodyGyro-std()-X"               "fBodyGyro-meanFreq()-Z"         
[45] "fBodyGyro-meanFreq()-Y"          "fBodyGyro-meanFreq()-X"         
[47] "fBodyGyro-mean()-Z"              "fBodyGyro-mean()-Y"             
[49] "fBodyGyro-mean()-X"              "fBodyBodyGyroMag-std()"         
[51] "fBodyBodyGyroMag-meanFreq()"     "fBodyBodyGyroMag-mean()"        
[53] "fBodyBodyGyroJerkMag-std()"      "fBodyBodyGyroJerkMag-meanFreq()"
[55] "fBodyBodyGyroJerkMag-mean()"     "fBodyBodyAccJerkMag-std()"      
[57] "fBodyBodyAccJerkMag-meanFreq()"  "fBodyBodyAccJerkMag-mean()"     
[59] "fBodyAccMag-std()"               "fBodyAccMag-meanFreq()"         
[61] "fBodyAccMag-mean()"              "fBodyAccJerk-std()-Z"           
[63] "fBodyAccJerk-std()-Y"            "fBodyAccJerk-std()-X"           
[65] "fBodyAccJerk-meanFreq()-Z"       "fBodyAccJerk-meanFreq()-Y"      
[67] "fBodyAccJerk-meanFreq()-X"       "fBodyAccJerk-mean()-Z"          
[69] "fBodyAccJerk-mean()-Y"           "fBodyAccJerk-mean()-X"          
[71] "fBodyAcc-std()-Z"                "fBodyAcc-std()-Y"               
[73] "fBodyAcc-std()-X"                "fBodyAcc-meanFreq()-Z"          
[75] "fBodyAcc-meanFreq()-Y"           "fBodyAcc-meanFreq()-X"          
[77] "fBodyAcc-mean()-Z"               "fBodyAcc-mean()-Y"              
[79] "fBodyAcc-mean()-X"              

```

#### Methodology to derive the summarization of the average of each variable for each activity and subject:  

* Apply the summarise\_each function to compute the average of the mean and std variables in the unified data set grouping by Subject and Activity name. Here is a code chunk for the summarise\_each  
```
by_SubjAct <- group_by(X_unified_mean_Std,SubjectId,ActivityName) %>% summarise_each(funs(mean),-c(SubjectId:ActivityName))  
```

* The final result is a wide data based on tidy principles with 180 observations and 81 variables:  
    + SubjectId  
    + ActivityName  
    + 79 variables  

#### Caveats for tidy data set:  

* The variables in this data set are raw signals pertaining to:     
    + _x, y, and z axes_    
    + _time and frequency domains, which makes this a wide data set_  
  
_One could attempt to make this long or tall data set by separation of the axial dimensions (x, y, and Z) or separation of the time and frequency domains, but one needs to have a deeper understanding of the signal properties and dependencies between them. Therefore, no attempt has been made here to convert this wide data set to long data set._  
 
####
  
  