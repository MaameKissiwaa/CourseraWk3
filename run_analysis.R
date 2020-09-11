###PriscillaKissi Project 3###
library(dplyr)
filename <- "Coursera_DS3_Final.zip"

# Confirming file and folder path existence perworking directory####
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename, method="curl")
}  

if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}
###Naming all dataframes before merging to avoid errors###
features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subjectest <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
xtest <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
ytest <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subjecttrain <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
xtrain <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
ytrain <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")

##REQUIREMENT1-Merging the training and the test sets to create one dataset##
X <- rbind(xtrain, xtest)
Y <- rbind(ytrain, ytest)
Subject <- rbind(subjecttrain, subjectest)
Merged_Data <- cbind(Subject, Y, X)

 ###REQUIREMENT 2:Extracting only mean and standard deviation for each measurement####

NeatData <- Merged_Data %>% select(subject, code, contains("mean"), contains("std"))

##REQUIREMENT3:NAMING DATASETS DESCRIPTIVELY###
NeatData$code <- activities[NeatData$code, 2]

##REQUIREMENT 4:APPROPRIATE LABELLING OF DATAFRAMES PER DESCRIPTIVE VARIABLE NAMES WITH GSUB##
names(NeatData)[2] = "activity"
names(NeatData)<-gsub("Acc", "Accelerometer", names(NeatData))
names(NeatData)<-gsub("Gyro", "Gyroscope", names(NeatData))
names(NeatData)<-gsub("BodyBody", "Body", names(NeatData))
names(NeatData)<-gsub("Mag", "Magnitude", names(NeatData))
names(NeatData)<-gsub("^t", "Time", names(NeatData))
names(NeatData)<-gsub("^f", "Frequency", names(NeatData))
names(NeatData)<-gsub("tBody", "TimeBody", names(NeatData))
names(NeatData)<-gsub("-mean()", "Mean", names(NeatData), ignore.case = TRUE)
names(NeatData)<-gsub("-std()", "STD", names(NeatData), ignore.case = TRUE)
names(NeatData)<-gsub("-freq()", "Frequency", names(NeatData), ignore.case = TRUE)
names(NeatData)<-gsub("angle", "Angle", names(NeatData))
names(NeatData)<-gsub("gravity", "Gravity", names(NeatData))
##REQUIREMENT5:INDEPENDENT TIDY DATA###
FinalWork <- NeatData %>%
  group_by(subject, activity) %>%
  summarise_all(list(mean))
write.table(NeatData, "FinalWork.txt", row.name=FALSE)
###Check out contents of Final work##
str(FinalWork)
##Looks okay and may pass for Tidy-Helloworld###