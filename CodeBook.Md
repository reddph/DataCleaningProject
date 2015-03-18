---
title: "Code book for Getting and Cleaning Data Course Project"
author: "Phanindra Reddigari"
date: "Monday, March 16, 2015"
output: html_document
---

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
**_X_unified_index_slice_** - Data frame comprising SubjectId, SetType, and ActivityName vectors  
**_by_SubjAct_** - tidy data to summarize the average of all measurements grouped by subject and activity name across 79 variables pertaining to mean and std  
**_ActSubjAvgStats.txt_** - Output file name for exporting *by_SubjAct* data frame  

#### R Script name:

**run_analysis.R**
