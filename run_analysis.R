## Coursera

# installs dependencies
if (!require("plyr")){
  install.packages("plyr", dependencies=TRUE)
}

if (!require("dplyr")){
  install.packages("dplyr", dependencies=TRUE)
}

# Get the data
# don't forget getwd()/setwd()
setwd("./")

if(!file.exists("./UCI_HAR_Dataset.zip")) {
  download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
                destfile="UCI_HAR_Dataset.zip")
}
unzip("UCI_HAR_Dataset.zip")

# Folders and file reading
data_dir <- "./UCI\ HAR\ Dataset"

                     
## 1.Merges the training and the test sets to create one data set.

# Read in column names (features) and activity labels
features <- read.table(file.path(data_dir, "/features.txt"),sep="", header=FALSE)

act_labels <- read.table(file.path(data_dir, "/activity_labels.txt"),sep="", header=FALSE)
# rename columns
colnames(act_labels) <- c('Activity_id','Activity_type')

#----
# Read in "test" data
x_test <- read.table(file.path(data_dir, "/test/X_test.txt"),sep="", header=FALSE)
# rename columns from features data
colnames(x_test) <- features[,2]

y_test <- read.table(file.path(data_dir, "/test/y_test.txt"),sep="", header=FALSE)
# rename columns
colnames(y_test) <- "Activity_id"

subject_test <- read.table(file.path(data_dir, "/test/subject_test.txt"),sep="", header=FALSE)
#rename columns
colnames(subject_test) <- "Subject_id"

# bind test data by columns
test_data <- cbind(cbind(x_test,subject_test),y_test)
#----

#----
# Read in "train" data
x_train <- read.table(file.path(data_dir, "/train/X_train.txt"),sep="", header=FALSE)
# rename columns from features data
colnames(x_train) <- features[,2]

y_train <- read.table(file.path(data_dir, "/train/y_train.txt"),sep="", header=FALSE)
# rename columns
colnames(y_train) <- "Activity_id"

subject_train <- read.table(file.path(data_dir, "/train/subject_train.txt"),sep="", header=FALSE)
#rename columns
colnames(subject_train) <- "Subject_id"

# bind test data by columns
train_data <- cbind(cbind(x_train,subject_train),y_train)
#----

# Bind all of the above in to one dataset
dataset <- rbind(train_data,test_data)
## done with "1"


## 2.Extracts only the measurements on the mean and standard deviation for each measurement. ??
meanstd <- dataset[grepl("mean|std|Subject_id|Activity_id", names(dataset))]
## done with "2"

## 3.Uses descriptive activity names to name the activities in the data set
meanstd <- left_join(meanstd, act_labels, by="Activity_id",copy = FALSE)[,-1]
## done with "3"

## 4.Appropriately labels the data set with descriptive variable names. 
names(meanstd)<-gsub("\\(|\\)","",names(meanstd))
names(meanstd)<-gsub("^t", "time", names(meanstd))
names(meanstd)<-gsub("^f", "frequency", names(meanstd))
names(meanstd)<-gsub("Acc", "Accelerometer", names(meanstd))
names(meanstd)<-gsub("Gyro", "Gyroscope", names(meanstd))
names(meanstd)<-gsub("Mag", "Magnitude", names(meanstd))
names(meanstd)<-gsub("BodyBody", "Body", names(meanstd))
## done with "4"

## 5.From the data set in step 4, creates a second, independent tidy data set 
## with the average of each variable for each activity and each subject.
tidy_data <- ddply(meanstd, c("Subject_id","Activity_type"), numcolwise(mean))

write.table(tidy_data, file = "tidy_data.txt",sep="\t")
## done with "5"

