## Instructions:

You should create one R script called run_analysis.R that does the following. 
1 Merges the training and the test sets to create one data set.
2 Extracts only the measurements on the mean and standard deviation for each measurement. 
3 Uses descriptive activity names to name the activities in the data set
4 Appropriately labels the data set with descriptive variable names. 
5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.


# 1 Merges the training and the test sets to create one data set.

```{r}
Newpath <- file.path("./data" , "UCI HAR Dataset")
```



Read labels (Y_* files)

```{r}
dataLabelsTest  <- read.table(file.path(Newpath,"test","Y_test.txt" ),header = FALSE)
dataLabelsTrain <- read.table(file.path(Newpath,"train","Y_train.txt"),header = FALSE)
```

Read sets (X_* files)

```{r}
dataSetsTest  <- read.table(file.path(Newpath,"test","X_test.txt" ),header = FALSE)
dataSetsTrain <- read.table(file.path(Newpath,"train","X_train.txt"),header = FALSE)
```


Read subject files

```{r}
dataSubjectTest  <- read.table(file.path(Newpath,"test","subject_test.txt"),header = FALSE)
dataSubjectTrain <- read.table(file.path(Newpath,"train","subject_train.txt"),header = FALSE)
```



See structure of tables:

```{r}
str(dataLabelsTest)
```

```{r}
str(dataLabelsTrain)
```

```{r}
str(dataSetsTest)
```

```{r}
str(dataSetsTrain)
```

```{r}
str(dataSubjectTrain)
```

```{r}
str(dataSubjectTest)
```

rbind Data (x+y)

```{r}
dataLabels<- rbind(dataLabelsTrain, dataLabelsTest)
dataSets<- rbind(dataSetsTrain, dataSetsTest)
dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
```

Column names. For dataSets, we use features.txt file

```{r}
names(dataLabels)<-c("Labels")

namesdataSets <- read.table(file.path(Newpath,"features.txt"),head=FALSE)
names(dataSets)<- namesdataSets$V2

names(dataSubject)<-c("Subject")
```

We merge all data in a single data frame


```{r}
datasubjectpluslabels <- cbind(dataLabels,dataSubject)
mergeddata <- cbind(dataSets,datasubjectpluslabels)
```

# 2 Extracts only the measurements on the mean and standard deviation for each measurement. 

We extract data based on labels. Mean as grep(mean), standard deviation as grep(std)

```{r}
meanandstdcolumns<-namesdataSets$V2[grep("mean\\(\\)|std\\(\\)", namesdataSets$V2)]

meanandstdcolumns <- as.vector(meanandstdcolumns)
meanandstd <- subset(mergeddata,select=meanandstdcolumns)
```


check only correct columns are extracted:
str(meanandstd)

# 3 Uses descriptive activity names to name the activities in the data set

We read activity_labels.txt file in the data

```{r}
activity_columns <- read.table(file.path(Newpath,"activity_labels.txt"),header = FALSE)

names(activity_columns)<-c("Labels","Activity_Type")

mergeddataplusactiviy <- merge(mergeddata,activity_columns,by='Labels',all.x=TRUE)

head(mergeddataplusactiviy$Activity_Type)
```


# 4 Appropriately labels the data set with descriptive variable names. 

Done in previous streps, assigning descriptions in .txt files included


```{r}
str(mergeddataplusactiviy)
```

# 5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

```{r}
library(plyr);
Newtidydata<-aggregate(. ~Subject + Activity_Type, mergeddataplusactiviy, mean)
Newtidydata<-Newtidydata[order(Newtidydata$Subject,Newtidydata$Activity_Type),]
      write.table(Newtidydata, file = "Step5tidydata.txt",row.name=FALSE)
```

# eoproject
