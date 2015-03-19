library(dplyr)

## Import the data sets from UCI HAR Dataset folder into corresponding data frames
## Note the subject_train and subject_test.txt files identify the subjects in training and test respectively
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", quote="\"")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", quote="\"")

# Import the data set activity_labels. This data frame identifies the activity name associated with each activity id
activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt", quote="\"")

# Import the features data set into a features data frame. This identifies all the variables used in the capture
features <- read.table("./UCI HAR Dataset/features.txt", quote="\"")

# Import the training activity identifiers to y_train data frame
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", quote="\"")

# Import the training observations into X_train data frame
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt", quote="\"")

# Import the test activity identifiers to y_test data frame
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", quote="\"")

# Import the test observations into X_test data frame
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt", quote="\"")

# Merge the rows of X_test and X_train data frames to a unified data frame
X_unified <- rbind(X_test, X_train)

# Convert the column names of X_unified to the names from the features set
names(X_unified) <- features$V2

# Extract a subset of the features by searching for "-Mean" or "-Std" text string 
# to isolate the useful feature subset for further processing
# It is useful to note that the criterion of subsetting used here is to search
# for case insensitive patterns: "-mean" or "-std". This criterion may exclude
# feature names which may have "mean" or "std" in them but for this analysis, it
# is assumed that they are angle measurements.
meanStdFeatureNames <- grep("-Mean|-Std", features$V2, ignore.case=TRUE, value=TRUE)

# Build a subset data frame for the unified mean and std variables (columns) using the
# meanStdFeatureNames vector from the above
X_unified_mean_Std <- X_unified[,meanStdFeatureNames]

# Unify the subject identfiers from test and training subjects into one data frame
Subjects_unified <- rbind(subject_test, subject_train)

# Change the sole column name to SubjectId from the default name V1 for meaningful notation
names(Subjects_unified) <- c("SubjectId")

# Unify the test and training activity identifiers into one data frame
ActivityId_unified <- rbind(y_test, y_train)

# Change the sole column name to ActivityId from default name V1 for meaningful notation
names(ActivityId_unified) <- c("ActivityId")

# Change the columns of activity_labels data frame from V1, V2 to ActivityId and ActivityName
# for meaningful notation
names(activity_labels) <- c("ActivityId","ActivityName")

# Build a setType vector to identify the test or training label 
SetType <- c(rep("Test", nrow(y_test)), rep("Training", nrow(y_train)))

# Add additional columns (ActivityId, SubjectId, and ) to the X_unified_mean_std data frame to the right
X_unified_mean_Std <- mutate(X_unified_mean_Std, ActivityId = ActivityId_unified$ActivityId, SubjectId = Subjects_unified$SubjectId)

# Add SetType column to the X_unified_mean_std data frame
X_unified_mean_Std <- mutate(X_unified_mean_Std, SetType)

### Build a vector for row idenfiers over the entire unified set
id <- 1:nrow(X_unified_mean_Std)

### Add a record identifier to the unified data set to keep track of the 
### original records from test and training data sets

X_unified_mean_Std <- mutate(X_unified_mean_Std, ID = id)

# merge the X_unified_mean_std data frame with activity labels data frame joining by the ActivityId column
# in both data frames. But the merged data frame will join both ActivityId and
# ActivityName to the data frame. And also the order of the observations is changed.
# It should be of no concern since the integrity of the observations relative to
# the relationship between subject and activity is still in tact. It is just that 
# the observations get sorted by merge in a different way. We can always sort the
# merged set back to the original order by using the ID column in the set.
X_unified_mean_Std <- merge(X_unified_mean_Std, activity_labels, by.x="ActivityId", by.y="ActivityId") 

#colNames_X_unified_mean_Std <- names(X_unified_mean_Std)
#names(X_unified_mean_Std) <- replace(colNames_X_unified_mean_Std, colNames_X_unified_mean_Std=="V2", "ActivityName")

# Use ID to sort the merged unified result data set to get back the data to the same
# order as the original unified data set
X_unified_mean_Std <- arrange(X_unified_mean_Std,ID)

# Since we already have added the activity names to the unified mean std data frame,
# and sorted the unified mean std data frame by ID to restore the order to the order
# in the original unified data set, we can safely remove the ActivityId and ID from 
# the variable set
X_unified_mean_Std <- select(X_unified_mean_Std, -ActivityId, -ID)

# Extract SubjectId, SetType, and ActivityName columns from the unified mean std data frame
# so we can move it to the front of the column set
X_unified_index_slice <- select(X_unified_mean_Std,SubjectId,SetType,ActivityName)

## Shuffle the ActivityName, SubjectId, and SetType to the front columns for easier visual inspection
## using the next two steps
X_unified_mean_Std <- select(X_unified_mean_Std,-c(SubjectId:ActivityName))
X_unified_mean_Std <- data.frame(X_unified_index_slice,X_unified_mean_Std)

# validate that the final version of the unified mean std data frame has 
# all the data included from the original test and training data sets 
# by comparing the summary counts of test and training with the raw data sets

## Compare the raw test data set counts by activityId with the
## counts in unified mean std data set applying the test filter

ytestStats <- summarize(group_by(y_test,V1),n())
names(ytestStats) <- c("ActivityId","Count")
ytestStats <- merge(ytestStats, activity_labels, by.x="ActivityId", by.y="ActivityId")

comp1 <- select(ytestStats,ActivityName,Count) %>% arrange(ActivityName)

#                   V2   Count
# 1             LAYING   537
# 2            SITTING   491
# 3           STANDING   532
# 4            WALKING   496
# 5 WALKING_DOWNSTAIRS   420
# 6   WALKING_UPSTAIRS   471

compStats <- summarize(group_by(X_unified_mean_Std,ActivityName,SetType),n())
names(compStats) <- c("ActivityName","SetType","Count")

# Filter the set by using SetType == Test
# Note the counts summarized by activityId are identical
comp2 <- select(compStats, SetType, ActivityName, Count) %>% filter(SetType=="Test") %>% select(ActivityName, Count)

#         ActivityName   Count
# 1             LAYING   537
# 2            SITTING   491
# 3           STANDING   532
# 4            WALKING   496
# 5 WALKING_DOWNSTAIRS   420
# 6   WALKING_UPSTAIRS   471

## Compare the raw training data set counts by activityId with the
## counts in unified mean std data set applying the training filter

ytrainStats <- summarize(group_by(y_train,V1),n())
names(ytrainStats) <- c("ActivityId","Count")
ytrainStats <- merge(ytrainStats, activity_labels, by.x="ActivityId", by.y="ActivityId")

comp3 <- select(ytrainStats, ActivityName, Count) %>% arrange(ActivityName)

#         ActivityName Count
# 1             LAYING  1407
# 2            SITTING  1286
# 3           STANDING  1374
# 4            WALKING  1226
# 5 WALKING_DOWNSTAIRS   986
# 6   WALKING_UPSTAIRS  1073

# Filter the set by using SetType == Training
# Note the counts summarized by activityId are identical
comp4 <- select(compStats, SetType, ActivityName, Count) %>% filter(SetType=="Training") %>% select(ActivityName, Count)

#         ActivityName Count
# 1             LAYING  1407
# 2            SITTING  1286
# 3           STANDING  1374
# 4            WALKING  1226
# 5 WALKING_DOWNSTAIRS   986
# 6   WALKING_UPSTAIRS  1073

stopifnot(nrow(setdiff(comp1,comp2)) == 0, nrow(setdiff(comp3, comp4)) == 0)

## Remove the SetType column for further analysis since it has no use for this project
X_unified_mean_Std <- select(X_unified_mean_Std, -SetType)

# Finally apply the summarise_each function to compute the average
# of the mean and std variables in the unified data set.
# Use the %.% operator to pipe the group_by results to summarise_each
by_SubjAct <- group_by(X_unified_mean_Std,SubjectId,ActivityName) %>% summarise_each(funs(mean),-c(SubjectId:ActivityName))

## Update the variable names with the actual descriptive variable names from features table
names(by_SubjAct) <- c("SubjectId","ActivityName",meanStdFeatureNames)

## The result is a tidy data (180x81)
## SubjectId,
## ActivityName, and
## 79 variables for a total of 81 variables
## 30 subjects x 6 activities = 180 observations

## The variables in this data set are raw signals pertaining to:
##      - x, y, and z axes
##      - time and frequency domains
## which makes this a wide data set
## One could attempt to make this long or tall data set by separation of the axial 
## dimensions (x, y, and Z) or separation by time and frequency domains, but one needs 
## to have a deeper understanding of the signal properties and dependencies between them.
## Therefore, no attempt has been made here to convert this wide data set to long data set.
## This data set still conforms to the basic tidy data principles:
##
## Each variable forms a column
## Each observation forms a row

write.table(by_SubjAct, file="./ActSubjAvgStats.txt", row.name=FALSE)

