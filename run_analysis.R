#get correct library ready
library(dplyr) 
library(tidyr)

#set working directory
setwd("UCI HAR Dataset")

#read in training data 
x_train   <- read.table("./train/X_train.txt")
y_train   <- read.table("./train/Y_train.txt") 
sub_train <- read.table("./train/subject_train.txt")

#read in testing data 
x_test   <- read.table("./test/X_test.txt")
y_test   <- read.table("./test/Y_test.txt") 
sub_test <- read.table("./test/subject_test.txt")

#get feature 
features <- read.table("./features.txt") 

#get activity labels 
activity_labels <- read.table("./activity_labels.txt") 

#merge the two data sets
x_total   <- rbind(x_train, x_test)
y_total   <- rbind(y_train, y_test) 
sub_total <- rbind(sub_train, sub_test) 

#get just the mean and standard deviation 
sel_features <- variable_names[grep(".*mean\\(\\)|std\\(\\)", features[,2], ignore.case = FALSE),]
x_total      <- x_total[,sel_features[,1]]

#assign column names
colnames(x_total)   <- sel_features[,2]
colnames(y_total)   <- "activity"
colnames(sub_total) <- "subject"

#merge dataset
total <- cbind(sub_total, y_total, x_total)

#make factor variables 
total$activity <- factor(total$activity, levels = activity_labels[,1], labels = activity_labels[,2]) 
total$subject  <- as.factor(total$subject) 

#create a summary data set 
total_mean <- total %>% group_by(activity, subject) %>% summarize_all(funs(mean)) 

#write the summary file
write.table(total_mean, "tidy_data.txt", row.names = FALSE, col.names = TRUE) 