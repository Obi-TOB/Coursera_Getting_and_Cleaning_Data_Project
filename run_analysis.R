# prepare tidy data set

# Script does the following:
# 1. Merges the training and the test sets to create one data set
# 2. Extracts only the measurements on the mean and standard deviation for each measurement
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names
# 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# Author: Thomas Obkircher
# latest update: 20140725

# load test_data
setwd("C:\\Coursera\\data\\class3\\UCI HAR Dataset\\test")
test_data_raw = read.table("X_test.txt");
test_persons_raw = read.table("subject_test.txt");
test_labels_raw = read.table("y_test.txt");

# merge test_data
test_raw <- cbind(test_data_raw,test_persons_raw,test_labels_raw);

# load training_data
setwd("C:\\Coursera\\data\\class3\\UCI HAR Dataset\\train")
train_data_raw = read.table("X_train.txt");
train_persons_raw = read.table("subject_train.txt");
train_labels_raw = read.table("y_train.txt");

#merge training_data
train_raw <- cbind(train_data_raw, train_persons_raw,train_labels_raw);

#merge test & training_data
all_raw <- rbind(test_raw, train_raw)

# quick line number verification
nrow(test_data_raw) + nrow(train_data_raw) == nrow(all_raw)

# load feature names
setwd("C:\\Coursera\\data\\class3\\UCI HAR Dataset")
feature_names <- read.table('features.txt', colClasses = "character")[,2]

# replace column names with feature names
colnames(all_raw) <- (c(feature_names, "Subject", "Activity"))

# cut relevant columns (562, 562 are Subject and Activity)
relevant_cols_std <- grep('std()', feature_names, fixed = TRUE)
relevant_cols_mean <- grep('mean()', feature_names, fixed = TRUE)
all_relevant_cols <- c(relevant_cols_std,relevant_cols_mean,562,563)
cut_raw <- all_raw[all_relevant_cols[order(all_relevant_cols)]]

# replace activity names
cut_raw$Activity <- gsub(1, "WALKING", all_raw$Activity);
cut_raw$Activity <- gsub(2, "WALKING_UPSTAIRS", all_raw$Activity);
cut_raw$Activity <- gsub(3, "WALKING_DOWNSTAIRS", all_raw$Activity);
cut_raw$Activity <- gsub(4, "SITTING", all_raw$Activity);
cut_raw$Activity <- gsub(5, "STANDING", all_raw$Activity);
cut_raw$Activity <- gsub(6, "LAYING", all_raw$Activity);

# aggregate by Subject & Activity
cut_agg <-aggregate(. ~ Subject + Activity, cut_raw,FUN=mean)

# correct names of new clean dataset
colnames(cut_agg) <- c("Subject", "Activity",paste0("Mean_",colnames(cut_agg)[3:length(colnames(cut_agg))]))

# output tidy dataset
write.table(cut_agg, "Tidy_dataset.txt", row.names = FALSE)
