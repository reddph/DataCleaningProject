---
title: "README"
author: "Phanindra Reddigari"
date: "Tuesday, March 17, 2015"
output: html_document
---

### Objectives  

run_analysis.R script is designed to meet the following project requirements:  

* Import the test and training data files from UCI HAR Dataset folder
* Merge the training and the test sets to create one unified data set  
* Extract only the measurements on the mean and standard deviation for each measurement  
* Assign descriptive activity names to name the activities in the data set  
* Labels the data set with descriptive variable names  
* Output a tidy data set with the average of each variable for each activity and each subject  

### High level algorithm:  

* Download the UCI HAR data zip file from the URL in the course project description to the working directory  

* Extract the UCI HAR Dataset folder using unzip to the working directory at the same level where the run_analysis.R script resides  

* Import Note the subject\_train.txt and subject\_test.txt files which identify the subjects in training and test respectively into subject\_train and subject\_test data frames

* Import the data set for activity\_labels. This data frame identifies the activity name associated with each activity id  

* Import the features data set into a features data frame. This identifies all the variables used in the capture   

* Import the training activity identifiers to y_train data frame  

* Import the training observations into X_train data frame  

* Import the test activity identifiers to y\_test data frame  

* Import the test observations into X_test data frame  

* Merge the rows of X\_test and X\_train data frames to a unified data frame (X_unified)  

* Convert the column names of X_unified to the names from the features set  

* Extract a subset of the features by searching for "-Mean" or "-Std" text string to isolate the useful feature subset for further processing.  
    + The criterion for subsetting is to search for case insensitive patterns: "-mean" or "-std". This criterion may exclude feature names which may have "mean" or "std" in them but for this analysis, it is assumed that they are angle measurements. Here is a code chunk used for subsetting:  
    
```
grep("-Mean|-Std", features$V2, ignore.case=TRUE, value=TRUE)
```
* Extract a subset for the unified mean and std variables (columns) to X\_unified\_mean\_Std  

* Unify the subject identfiers from test and training subjects into Subjects\_unified data frame     

* Unify the test and training activity identifiers into one data frame ActivityId\_unified  

* Add additional columns (ActivityId, SubjectId, and ) to the X\_unified\_mean\_std data frame 

* Add SetType column to the X\_unified\_mean\_std data frame  

* Add a record identifier to the unified data set to keep track of the original records from test and training data sets   

* merge the X\_unified\_mean\_std data frame with activity labels data frame joining by the ActivityId column  

* sort the merged set back to the original order by using the ID column in the set. Here is a code chunk as an example for sorting 

```
X_unified_mean_Std <- arrange(X_unified_mean_Std,ID)  
```

* Remove the ActivityId and ID from the variable set  

* Validate that the final version of the unified mean std data frame has all the data included from the original test and training data sets by comparing the summary counts of test and training with the raw data sets. 

```
# Test data set summarization:

#         ActivityName   Count
# 1             LAYING   537
# 2            SITTING   491
# 3           STANDING   532
# 4            WALKING   496
# 5 WALKING_DOWNSTAIRS   420
# 6   WALKING_UPSTAIRS   471

# Training data set summarization:

#         ActivityName Count
# 1             LAYING  1407
# 2            SITTING  1286
# 3           STANDING  1374
# 4            WALKING  1226
# 5 WALKING_DOWNSTAIRS   986
# 6   WALKING_UPSTAIRS  1073
```

* Strip out the SetType column for further analysis since it has no further use  

* Apply the summarise\_each function to compute the average of the mean and std variables in the unified data set grouping by Subject and Activity name. Here is a code chunk for the summarise\_each
```
by_SubjAct <- group_by(X_unified_mean_Std,SubjectId,ActivityName) %>% summarise_each(funs(mean),-c(SubjectId:ActivityName))  
```

* The final result is a wide data based on tidy principles with 81 variables:  
+ SubjectId  
+ ActivityName  
+ 79 variables  

* _Note: The variables in this data set are raw signals pertaining to:_   
+ _x, y, and z axes_    
+ _time and frequency domains which makes this a wide data set_  
  _One could attempt to make this long or tall data set by separation of the axial dimensions (x, y, and Z) or separation by time and frequency domains, but one needs to have a deeper understanding of the signal properties and dependencies between them. Therefore, no attempt has been made here to convert this wide data set to long data set._    

* This data set still conforms to the basic tidy data principles:  
1. Each variable forms a column  
2. Each observation forms a row  

* Output the by_SubjAct data frame to _*ActSubjAvgStats.txt*_ in the working directory  
