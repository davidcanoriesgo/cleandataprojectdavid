## Download file and store it in ./data directory

## library("RCurl")

## if(!file.exists("./data")){dir.create("./data")}
## fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
## download.file(fileUrl,destfile="./data/Dataset.zip")
## if MAC
## download.file(fileUrl,destfile="./data/Dataset.zip",method="curl")

## Unzip file

unzip(zipfile="./data/Dataset.zip",exdir="./data")

## Folder "UCI HAR Dataset" is created with data

## Instructions:
##You should create one R script called run_analysis.R that does the following. 
## 1 Merges the training and the test sets to create one data set.
## 2 Extracts only the measurements on the mean and standard deviation for each measurement. 
## 3 Uses descriptive activity names to name the activities in the data set
## 4 Appropriately labels the data set with descriptive variable names. 
## 5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

################################
## 1 Merges the training and the test sets to create one data set.
################################

## Read files

## Readme.txt
## - 'README.txt'
## - 'features_info.txt': Shows information about the variables used on the feature vector.
## - 'features.txt': List of all features.
## - 'activity_labels.txt': Links the class labels with their activity name.
## - 'train/X_train.txt': Training set.
## - 'train/y_train.txt': Training labels.
## - 'test/X_test.txt': Test set.
## - 'test/y_test.txt': Test labels.

Newpath <- file.path("./data" , "UCI HAR Dataset")

## Read labels (Y_* files)

dataLabelsTest  <- read.table(file.path(Newpath,"test","Y_test.txt" ),header = FALSE)
dataLabelsTrain <- read.table(file.path(Newpath,"train","Y_train.txt"),header = FALSE)

## Read sets (X_* files)

dataSetsTest  <- read.table(file.path(Newpath,"test","X_test.txt" ),header = FALSE)
dataSetsTrain <- read.table(file.path(Newpath,"train","X_train.txt"),header = FALSE)

## Read subject files

dataSubjectTest  <- read.table(file.path(Newpath,"test","subject_test.txt"),header = FALSE)
dataSubjectTrain <- read.table(file.path(Newpath,"train","subject_train.txt"),header = FALSE)


## See structure of tables:
str(dataLabelsTest)
str(dataLabelsTrain)

str(dataSetsTest)
str(dataSetsTrain)

str(dataSubjectTrain)
str(dataSubjectTest)

## rbind Data (x+y)

dataLabels<- rbind(dataLabelsTrain, dataLabelsTest)
dataSets<- rbind(dataSetsTrain, dataSetsTest)
dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)

## Column names. For dataSets, we use features.txt file

names(dataLabels)<-c("Labels")

namesdataSets <- read.table(file.path(Newpath,"features.txt"),head=FALSE)
names(dataSets)<- namesdataSets$V2

names(dataSubject)<-c("Subject")

## We merge all data in a single data frame

datasubjectpluslabels <- cbind(dataLabels,dataSubject)
mergeddata <- cbind(dataSets,datasubjectpluslabels)

################################
## 2 Extracts only the measurements on the mean and standard deviation for each measurement. 
################################

## We extract data based on labels. Mean as grep(mean), standard deviation as grep(std)

meanandstdcolumns<-namesdataSets$V2[grep("mean\\(\\)|std\\(\\)", namesdataSets$V2)]

meanandstdcolumns <- as.vector(meanandstdcolumns)
meanandstd <- subset(mergeddata,select=meanandstdcolumns)

## check only correct columns are extracted:
## str(meanandstd)

################################
## 3 Uses descriptive activity names to name the activities in the data set
################################

## We read activity_labels.txt file in the data

activity_columns <- read.table(file.path(Newpath,"activity_labels.txt"),header = FALSE)

names(activity_columns)<-c("Labels","Activity_Type")

mergeddataplusactiviy <- merge(mergeddata,activity_columns,by='Labels',all.x=TRUE)

head(mergeddataplusactiviy$Activity_Type)

################################
## 4 Appropriately labels the data set with descriptive variable names. 
################################

## done in previous streps, assigning descriptions in .txt files included

str(mergeddataplusactiviy)

################################
## 5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
################################

library(plyr);
Newtidydata<-aggregate(. ~Subject + Activity_Type, mergeddataplusactiviy, mean)
Newtidydata<-Newtidydata[order(Newtidydata$Subject,Newtidydata$Activity_Type),]
      write.table(Newtidydata, file = "Step5tidydata.txt",row.name=FALSE)

## eoproject
