# This script has been written as Week4 - Getting and Cleaning Data - Course Project
# and has been named run_analysis.R; 
# it merges the training and test sets to create one data set
# extracts only measurements on the mean and st dev for each measurement
# and at the end there is a new data set with the average of each variable for each activity and each subject

# Following section read the tables
# trainings tables:
xtrain <- read.table("./train/X_train.txt")
ytrain <- read.table("./train/y_train.txt")
subjectTrain <- read.table("./train/subject_train.txt")

# testing tables:
xtest <- read.table("./test/X_test.txt")
ytest <- read.table("./test/y_test.txt")
subjectTest <- read.table("./test/subject_test.txt")

# feature vector:
features <- read.table('./features.txt')

# activity labels:
activityLabels = read.table('./activity_labels.txt')

# Following section to name columns
colnames(activityLabels) <- c('activityId','activityName')
colnames(features) <- c('featuresId', 'featuresName')
colnames(subjectTest) <- "subjectId"
colnames (subjectTrain) <- "subjectId"
colnames (xtest) <- features[,2]
colnames (xtrain) <- features[,2]
colnames (ytest) <- "activityId"
colnames (ytrain) <- "activityId"

# Following section merges all data
myDataTest <- cbind (subjectTest, xtest, ytest)
myDataTrain <- cbind (subjectTrain, xtrain, ytrain)
myData <- rbind(myDataTest,myDataTrain)
rm(myDataTest)
rm(myDataTrain)

# Following section extracts mean and st dev
columns <- colnames(myData)
results <- (grepl("activityId" , columns)|grepl("subjectId" , columns)|grepl("mean.." , columns)|grepl("std.." , columns))
meanStDev <- myData[,results == TRUE]
rm(columns)
rm(results)

# Activities will be listed showing related names
result <- merge(meanStDev,activityLabels, by='activityId')

# Making a new indipendent data set with the average of each variable for each activity and each subject
result<-result[order(result$subjectId),]
tidyData <- aggregate(result[, 3:81], list(result$activityName, result$subjectId), mean)
colnames(tidyData)[1] <- "activityName"
colnames(tidyData)[2] <- "subjectId"
names(tidyData) <- gsub("-std()", "-mean()- ", names(tidyData))
write.table(tidyData, "tidyFile.txt", row.names = FALSE, quote = FALSE)