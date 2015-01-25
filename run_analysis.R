#KB
#1. Merges the training and the test sets to create one data set.
#2. Extracts only the measurements on the mean and standard deviation for each measurement. 
#3. Uses descriptive activity names to name the activities in the data set
#4. Appropriately labels the data set with descriptive variable names. 
#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# Installs required packages
if (!require("data.table")) {
        install.packages("data.table")
}
require("data.table")
library(data.table) 

# Downloads the file
# method="curl" relevant to MAC OSX
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" 
download.file(fileUrl, destfile = "Dataset.zip", method="curl") 

# Unzips file
unzip("Dataset.zip")

#1. Merges the training and the test sets to create one data set.
x_train <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE)
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)

# Combines data table (train vs test) by rows
x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
subject_data <- rbind(subject_train, subject_test)

#2. Extracts only the measurements on the mean and standard deviation for each measurement. 
features <- read.table("./UCI HAR Dataset/features.txt")
names(features) <- c('feat_id', 'feat_name')
index_features <- grep("-mean\\(\\)|-std\\(\\)", features$feat_name) 
x_data <- x_data[, index_features] 
# Replaces all matches of a string features 
names(x_data) <- gsub("\\(|\\)", "", (features[index_features, 2]))

#3. Uses descriptive activity names to name the activities in the data set.
activities <- read.table("./UCI HAR Dataset/activity_labels.txt")
names(activities) <- c('act_id', 'act_name')
y_data[, 1] = activities[y_data[, 1], 2]
#4. Appropriately labels the data set with descriptive variable names. 
names(y_data) <- "Activity"
names(subject_data) <- "Subject"

# creates data table
tidy <- cbind(subject_data, y_data, x_data)

#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
write.table(tidy,file="tidy.csv",sep=",",row.names = FALSE) 
print("Finished processing. Tidy dataset has been written to tidy.csv")