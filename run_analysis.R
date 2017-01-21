# run_analysis.R that does the following...
# 
#       Merges the training and the test sets.
#       Extracts mean and standard deviation for each measurement.
#       Attach activity names
#       Write out above as "movement_mean_std.txt"
#       Creates a second, independent tidy data set with the average 
#       of each variable for each activity and each subject.

#   Download data zip file from: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
#   Read in data from unzipped UCI directory
test <- read.table("test/X_test.txt", header = FALSE, na.strings = TRUE)
train <- read.table("train/X_train.txt", header = FALSE, na.strings = TRUE)
features <- read.table("features.txt")
column_names <- as.character(features$V2)   # to serve as colnames and data.frame columns to be selected
rm(features)

#   Select columns of data associated with mean and standard deviation (std)...
x <- grep("[Mm][Ee][Aa][Nn]", column_names)
y <- grep("[Ss][Tt][Dd]", column_names) 
z <- c(x, y)
#   but remove data associated with meanFreq and gravityMean
f <- grep("meanFreq", column_names)
g <- grep("gravity", column_names)
fg <- c(f, g)
z <- z[!z %in% fg]  
z <- sort(z)
test <- test[, z]
train <- train[, z]

#   Reformat variable names for readability 
data_labels <- column_names[z]
data_labels <- gsub("_", "", data_labels)
data_labels <- gsub("-s", "S", data_labels)
data_labels <- gsub("-m", "M", data_labels)
data_labels <- gsub("-", "", data_labels)
data_labels <- gsub("\\)", "", data_labels)
data_labels <- gsub("\\(", "", data_labels)

names(test) <- data_labels
names(train) <- data_labels
rm(x, y, z, f, g, fg, column_names, data_labels)

# prepare and attached activity ids
activity_test <- read.table("test/y_test.txt")
names(activity_test) <- "activity"
activity_test$activity[activity_test$activity == 1] <- "WALKING"
activity_test$activity[activity_test$activity == 2] <- "WALKING_UPSTAIRS"
activity_test$activity[activity_test$activity == 3] <- "WALKING_DOWNSTAIRS"
activity_test$activity[activity_test$activity == 4] <- "SITTING"
activity_test$activity[activity_test$activity == 5] <- "STANDING"
activity_test$activity[activity_test$activity == 6] <- "LAYING"
test <- cbind(activity_test, test)
rm(activity_test)

activity_train <- read.table("train/y_train.txt")
names(activity_train) <- "activity"
activity_train$activity[activity_train$activity == 1] <- "WALKING"
activity_train$activity[activity_train$activity == 2] <- "WALKING_UPSTAIRS"
activity_train$activity[activity_train$activity == 3] <- "WALKING_DOWNSTAIRS"
activity_train$activity[activity_train$activity == 4] <- "SITTING"
activity_train$activity[activity_train$activity == 5] <- "STANDING"
activity_train$activity[activity_train$activity == 6] <- "LAYING"
train <- cbind(activity_train, train)
rm(activity_train)

#   prepare and attach subject ids
subject_test <- read.table("test/subject_test.txt")
names(subject_test) <- "subject"
subject_train <- read.table("train/subject_train.txt")
names(subject_train) <- "subject"

test <- cbind(subject_test, test)
train <- cbind(subject_train, train)
rm(subject_test, subject_train)

# bind test and train data sets
all_data <- rbind(test, train)      

#   Arrange labels to have mean next to sum. Selection based on visual inspection.
mean_next_to_std <- c(1, 2, 3, 6, 4, 7, 5, 8, 9, 12, 10, 13, 11, 14, 15, 18, 16, 19, 
                      17, 20, 21, 24, 22, 25, 23, 26, 27, 30, 28, 31, 29, 32, 33, 34, 
                      35, 36, 37, 38, 39, 40, 41, 42, 43, 46, 44, 47, 45, 48, 49, 52, 
                      50, 53, 51, 54, 55, 58, 56, 59, 57, 60, 61, 62, 63, 64, 65, 66, 
                      67, 68)
all_data <- all_data[, mean_next_to_std]
rm(mean_next_to_std)

write.table(all_data, "movement_mean_std.csv", sep = ",", row.names = FALSE, col.names = TRUE)

#   If needed, data can be read in with the following command. 
# data <- read.table("movement_mean_std.txt", sep = " ", header = TRUE)
##############################################################################
#   
#       From all_data, create a second data set reporting average 
#       of each variable for each activity and each subject.

##################   WALKING  #######################
#   Average for activity.. subject = "total"
activity_data <- all_data[all_data$activity == "WALKING", ]
total_sub_data <- activity_data[, 3:68]
sub_mean_rows <- as.data.frame(colMeans(total_sub_data))
sub_mean <- sub_mean_rows
name_list <- list("total")

#   Now to deal with each subject 
for (i in 1:30) {                               
    subject <- activity_data[activity_data$subject == i, ]
    sub_data <- subject[, 3:68]
    means <- colMeans(sub_data)
    sub_mean <- cbind(sub_mean, means)
    sub <- paste("Subject", i, sep = ".")
    name_list <- c(name_list, sub)
}
names(sub_mean) <- name_list
sub_mean <- gather(sub_mean, subject, walking_mean)

# gather function does not handle rownames
# Get column with the original rownames with length of total_walking_means
rows <- rownames(sub_mean_rows)
repeat_rows <- as.list(replicate(31, rows))
repeat_row <- as.data.frame(repeat_rows)
measurement <- t(repeat_row)

# bind rownames lost due to gather function
final_report <- cbind(measurement, sub_mean)
rm(rows, repeat_rows, repeat_row, measurement)

############ WALKING UP #####################
#   Average for activity.. subject = "total"
activity_data <- all_data[all_data$activity == "WALKING_UPSTAIRS", ]
total_sub_data <- activity_data[, 3:68]
sub_mean_rows <- as.data.frame(colMeans(total_sub_data))
sub_mean <- sub_mean_rows
name_list <- list("total")

#   Now to deal with each subject 
for (i in 1:30) {                               
    subject <- activity_data[activity_data$subject == i, ]
    sub_data <- subject[, 3:68]
    means <- colMeans(sub_data)
    sub_mean <- cbind(sub_mean, means)
    sub <- paste("Subject", i, sep = ".")
    name_list <- c(name_list, sub)
}

#   Gathering data and binding to report
names(sub_mean) <- name_list
sub_mean <- gather(sub_mean, subject, walking_upstairs_mean)
walking_up_mean <- sub_mean$walking_upstairs_mean
final_report <- cbind(final_report, walking_up_mean)

############ WALKING DN #####################
#   Average for activity.. subject = "total"
activity_data <- all_data[all_data$activity == "WALKING_DOWNSTAIRS", ]
total_sub_data <- activity_data[, 3:68]
sub_mean_rows <- as.data.frame(colMeans(total_sub_data))
sub_mean <- sub_mean_rows
name_list <- list("total")

#   Now to deal with each subject 
for (i in 1:30) {                               
    subject <- activity_data[activity_data$subject == i, ]
    sub_data <- subject[, 3:68]
    means <- colMeans(sub_data)
    sub_mean <- cbind(sub_mean, means)
    sub <- paste("Subject", i, sep = ".")
    name_list <- c(name_list, sub)
}
names(sub_mean) <- name_list
sub_mean <- gather(sub_mean, subject, walking_down_mean)
walking_dn_mean <- sub_mean$walking_down_mean
final_report <- cbind(final_report, walking_dn_mean)

############ SITTING #####################
#   Average for activity.. subject = "total"
activity_data <- all_data[all_data$activity == "SITTING", ]
total_sub_data <- activity_data[, 3:68]
sub_mean_rows <- as.data.frame(colMeans(total_sub_data))
sub_mean <- sub_mean_rows
name_list <- list("total")

#   Now to deal with each subject 
for (i in 1:30) {                               
    subject <- activity_data[activity_data$subject == i, ]
    sub_data <- subject[, 3:68]
    means <- colMeans(sub_data)
    sub_mean <- cbind(sub_mean, means)
    sub <- paste("Subject", i, sep = ".")
    name_list <- c(name_list, sub)
}
names(sub_mean) <- name_list
sub_mean <- gather(sub_mean, subject, sitting_mean)
sitting_mean <- sub_mean$sitting_mean
final_report <- cbind(final_report, sitting_mean)

############ STANDING #####################
#   Average for activity.. subject = "total"
activity_data <- all_data[all_data$activity == "STANDING", ]
total_sub_data <- activity_data[, 3:68]
sub_mean_rows <- as.data.frame(colMeans(total_sub_data))
sub_mean <- sub_mean_rows
name_list <- list("total")

#   Now to deal with each subject 
for (i in 1:30) {                               
    subject <- activity_data[activity_data$subject == i, ]
    sub_data <- subject[, 3:68]
    means <- colMeans(sub_data)
    sub_mean <- cbind(sub_mean, means)
    sub <- paste("Subject", i, sep = ".")
    name_list <- c(name_list, sub)
}
names(sub_mean) <- name_list
sub_mean <- gather(sub_mean, subject, standing_mean)
standing_mean <- sub_mean$standing_mean
final_report <- cbind(final_report, standing_mean)

############ LAYING #####################
#   Average for activity.. subject = "total"
activity_data <- all_data[all_data$activity == "LAYING", ]
total_sub_data <- activity_data[, 3:68]
sub_mean_rows <- as.data.frame(colMeans(total_sub_data))
sub_mean <- sub_mean_rows
name_list <- list("total")

#   Now to deal with each subject 
for (i in 1:30) {                               
    subject <- activity_data[activity_data$subject == i, ]
    sub_data <- subject[, 3:68]
    means <- colMeans(sub_data)
    sub_mean <- cbind(sub_mean, means)
    sub <- paste("Subject", i, sep = ".")
    name_list <- c(name_list, sub)
}
names(sub_mean) <- name_list
sub_mean <- gather(sub_mean, subject, laying_mean)
laying_mean <- sub_mean$laying_mean
final_report <- cbind(final_report, laying_mean)

write.table(final_report, "movement_mean_by_activity_subject.txt", sep = ",", row.names = FALSE, col.names = TRUE)
