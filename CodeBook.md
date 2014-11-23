---
title: "Codebook for the Getting and cleaning data project"
---

Feature Selection 
=================

The features selected for this database come from the accelerometer and gyroscope 3-axial raw signals tAcc-XYZ and tGyro-XYZ. These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals). 

These signals were used to estimate variables of the feature vector for each pattern:  

'-XYZ' is used to denote 3-axial signals in the X, Y and Z directions.

* "timeBodyAccelerometer"
* "timeGravityAccelerometer"
* "timeBodyAccelerometerJerk"
* "timeBodyGyroscope-mean"
* "timeBodyGyroscopeJerk"
* "timeBodyAccelerometerMagnitude"
* "timeBodyGyroscopeMagnitude"
* "timeBodyGyroscopeJerkMagnitude"
* "frequencyBodyAccelerometer"
* "frequencyBodyAccelerometerJerk"
* "frequencyBodyGyroscope"
* "frequencyBodyAccelerometerMagnitude"
* "frequencyBodyAccelerometerJerkMagnitude"
* "frequencyBodyGyroscopeMagnitude"
* "frequencyBodyGyroscopeJerkMagnitude"


####The set of variables that were estimated from these signals are: 

* mean(): Mean value
* std(): Standard deviation

# The raw data sets are processed with run_analisys.R script to create a tidy data
# set

### 1.Merges the training and the test sets to create one data set.

Test and training data, subject ids and activity ids are merged to obtain a single data set. Variables are labelled with the names assigned by original collectors.


#### Read in column names (features) and activity labels
```{r}
features <- read.table(file.path(data_dir, "/features.txt"),sep="", header=FALSE)
```
```{r}
act_labels <- read.table(file.path(data_dir, "/activity_labels.txt"),sep="", header=FALSE)  
```

#### rename activity data columns
```{r}
colnames(act_labels) <- c('Activity_id','Activity_type')
```

#### Read in "test" data and rename columns
```{r}
x_test <- read.table(file.path(data_dir, "/test/X_test.txt"),sep="", header=FALSE)
```

#### rename x columns names from "features" data
```{r}
colnames(x_test) <- features[,2]
```

#### read and rename other "test" data
```{r}
y_test <- read.table(file.path(data_dir, "/test/y_test.txt"),sep="", header=FALSE)
```
```{r}
colnames(y_test) <- "Activity_id"
```
```{r}
subject_test <- read.table(file.path(data_dir, "/test/subject_test.txt"),sep="", header=FALSE)
```
```{r}
colnames(subject_test) <- "Subject_id"
```

#### bind "test" data by columns
```{r}
test_data <- cbind(cbind(x_test,subject_test),y_test)
```

#### Read in "train" data
```{r}
x_train <- read.table(file.path(data_dir, "/train/X_train.txt"),sep="", header=FALSE)
```

#### rename x columns names from "features" data
```{r}
colnames(x_train) <- features[,2]
```

#### read and rename other "train" data
```{r}
y_train <- read.table(file.path(data_dir, "/train/y_train.txt"),sep="", header=FALSE)
```
```{r}
colnames(y_train) <- "Activity_id"
```
```{r}
subject_train <- read.table(file.path(data_dir, "/train/subject_train.txt"),sep="", header=FALSE)
```
```{r}
colnames(subject_train) <- "Subject_id"
```

#### bind "train" data by columns
```{r}
train_data <- cbind(cbind(x_train,subject_train),y_train)
```

#### Bind all of the above in to one dataset
```{r}
dataset <- rbind(train_data,test_data)
```


## 2.Extracts only the measurements on the mean and standard deviation for each measurement.

```{r}
meanstd <- dataset[grepl("mean|std|Subject_id|Activity_id", names(dataset))]
```

## 3.Uses descriptive activity names to name the activities in the data set
```{r}
meanstd <- left_join(meanstd, act_labels, by="Activity_id",copy = FALSE)[,-1]
```

## 4.Appropriately labels the data set with descriptive variable names. 
```{r}
names(meanstd)<-gsub("\\(|\\)","",names(meanstd))
```
```{r}
names(meanstd)<-gsub("^t", "time", names(meanstd))
```
```{r}
names(meanstd)<-gsub("^f", "frequency", names(meanstd))
```
```{r}
names(meanstd)<-gsub("Acc", "Accelerometer", names(meanstd))
```
```{r}
names(meanstd)<-gsub("Gyro", "Gyroscope", names(meanstd))
```
```{r}
names(meanstd)<-gsub("Mag", "Magnitude", names(meanstd))
```
```{r}
names(meanstd)<-gsub("BodyBody", "Body", names(meanstd))
```

## 5.From the data set in step 4, creates a second, independent tidy data set 
## with the average of each variable for each activity and each subject.
```{r}
tidy_data <- ddply(meanstd, c("Subject_id","Activity_type"), numcolwise(mean))
```
```{r}
write.table(tidy_data, file = "tidy_data.txt",row.name=FALSE)
```


