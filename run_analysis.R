## Coursera
Sys.setlocale("LC_TIME", "English")
library(plyr)

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


## 2.Extracts only the measurements on the mean and standard deviation for each measurement. 
mean_standart <- dataset[,grepl("mean|std|Subject_id|Activity_id", names(dataset))]
## done with "2"


