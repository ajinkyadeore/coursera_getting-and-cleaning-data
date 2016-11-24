library(reshape2)

# reading datasets from the zip file into r
#------------------------------------------------------------------------------------
x_train <- read.table("Project/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("Project/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("Project/UCI HAR Dataset/train/subject_train.txt")

x_test <- read.table("Project/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("Project/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("Project/UCI HAR Dataset/test/subject_test.txt")
#------------------------------------------------------------------------------------

# Merging the training and the test sets to create one data set.
#------------------------------------------------------------------------------------
x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
subject_data <- rbind(subject_train, subject_test)
#------------------------------------------------------------------------------------

# Extracting features corresponding to mean and standard deviation
features <- read.table("Project/UCI HAR Dataset/features.txt")
mean_and_std_features<-grep(".(mean|std|Mean|Std).",features[,2])

#Keeping data only for the features corrsponding to mean and std dev
x_data <- x_data[, mean_and_std_features]
names(x_data) <- features[mean_and_std_features, 2]

#binding data, activities and subject from train and test into one data frame
activities <- read.table("activity_labels.txt")
y_data[, 1] <- activities[y_data[, 1], 2]
names(y_data) <- "activity"
names(subject_data) <- "subject"
all_data <- cbind(x_data, y_data, subject_data)

#convert wide format data to long format with ids subject and activity
all_data.melted <- melt(all_data, id = c("subject", "activity"))

#convert the melted data to wide  format with ids subject and activity and value = mean
all_data.mean <- dcast(all_data.melted, subject + activity ~ variable, mean)

#converts data frame into a csv which is written into tidy.txt
write.csv(all_data.mean, "tidy.txt", row.names = TRUE)