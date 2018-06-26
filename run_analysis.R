library(dplyr)
# reading data
x_train <-  read.table(".\\UCI HAR Dataset\\train\\X_train.txt")
y_train <-  read.table(".\\UCI HAR Dataset\\train\\y_train.txt")
x_test <-  read.table(".\\UCI HAR Dataset\\test\\x_test.txt")
y_test <-  read.table(".\\UCI HAR Dataset\\test\\y_test.txt")
sub_train <-  read.table(".\\UCI HAR Dataset\\train\\subject_train.txt")
sub_test <-  read.table(".\\UCI HAR Dataset\\test\\subject_test.txt")
# merging data to form a dataset
xtotal <- rbind(x_train,x_test)
ytotal <- rbind(y_train,y_test)
subtotal <- rbind(sub_train,sub_test)
# reading features
features <- read.table(".\\UCI HAR Dataset\\features.txt")
#filtering out only mean() and std()
filterfeatures <- features[grep("mean\\(\\)|std\\(\\)",features[,2]),]
# selecting only rows in Xtotal which match filterfeatures
xtotal <- xtotal[,filterfeatures[,1]]
# Use descriptive activity names to name the activities in the data set
colnames(ytotal) <- "activity"
ytotal$activitylabel <- factor(ytotal$activity, labels = as.character(activity_labels[,2]))
activitylabel <- ytotal[,-1]
#Appropriately labels the data set with descriptive variable names
colnames(xtotal) <- features[filterfeatures[,1],2]
#independent tidy data set with the average of each variable for each activity and each subject
colnames(subtotal) <- "subject"
total <- cbind(xtotal, activitylabel, subtotal)
total_mean <- total %>% group_by(activitylabel, subject) %>% summarize_each(funs(mean))
write.table(total_mean, file = "./UCI HAR Dataset/tidydata.txt", row.names = FALSE, col.names = TRUE)
