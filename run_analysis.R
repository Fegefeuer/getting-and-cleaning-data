# Lines 2-17: Reading in all of the necessary data
setwd("~/HAR/UCI HAR Dataset")

activity_names <- read.table("activity_labels.txt", header = F, stringsAsFactors = F)
activities <- read.table("features.txt", header = F, sep = '')

setwd("~/HAR/UCI HAR Dataset/test")

x_test <- read.table("X_test.txt", sep = "", header = F, col.names = activities$V2)
y_test <- read.table("y_test.txt", sep = "", header = F, col.names = "activity")
subject_test <- read.table("subject_test.txt", sep = '', header = F, col.names = "id")

setwd("~/HAR/UCI HAR Dataset/train")

x_train <- read.table("X_train.txt", sep = "", header = F, col.names = activities$V2)
y_train <- read.table("y_train.txt", sep = "", header = F, col.names = "activity")
subject_train <- read.table("subject_train.txt", sep = '', header = F,col.names = "id")


# These four lines are to extract only the mean and standard deviation variables
x_train_avgs <- x_train[, grep("(mean\\.|std\\.)", colnames(x_train))]
x_test_avgs <- x_test[, grep("(mean\\.|std\\.)", colnames(x_test))]


# Adding descriptive activity names
y_test <- activity_names$V2[unlist(y_test)]
y_train <- activity_names$V2[unlist(y_train)]

# Merging all of the data frames into one large data frame
full_xtest <- cbind(subject_test, activity = y_test, x_test_avgs)
full_xtrain <- cbind(subject_train, activity = y_train, x_train_avgs)
full_df <- rbind(full_xtest, full_xtrain)

# Cleaning up the variable names
names(full_df) <- gsub("\\.\\.\\.", ".", names(full_df))
names(full_df) <- gsub("\\.\\.", "", names(full_df))
names(full_df) <- gsub("^t", "time.", names(full_df))
names(full_df) <- gsub("^f", "freq.", names(full_df))
names(full_df) <- tolower(names(full_df))

# Creating a tidy dataset with the average of each variable 
# for each activity and each subject
library(dplyr)
tidy_avg <- full_df %>% group_by(id, activity) %>% summarise_each(funs(mean))
