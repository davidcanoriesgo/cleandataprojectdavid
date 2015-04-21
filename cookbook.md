## Variables used with Project

# Reading files

Newpath --> Store data patch
dataLabelsTest  -> Y_ test file
dataLabelsTrain -> Y_ train file

dataSetsTest -> X_ test file
dataSetsTrain -> Y_ train file

dataSubjectTest  -> Subject Test file
dataSubjectTrain -> Subject Train file

mergeddata -> merged data in a single data set

# 2 Extracts only the measurements on the mean and standard deviation for each measurement. 

We extract data based on labels. Mean as grep(mean), standard deviation as grep(std)

meanandstdcolumns -> Columns names for mean and standard deviation variables
meanandstd -> New data set with only mean and standard deviation

# 3 Uses descriptive activity names to name the activities in the data set

mergeddataplusactiviy -> New set of data with activity type includes


# 5 From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

Newtidydata -> New set of data aggregated by activiy and subject
"Step5tidydata.txt" -> Aggregated data bulked into a project file