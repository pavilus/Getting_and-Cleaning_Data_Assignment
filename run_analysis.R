# Assignment - Getting and Cleaning Data 

#Downloading the zip file
url <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
newfile <- "UCI_HAR_dataset.zip"
if (!file.exists(newfile)){
  download.file(url,"UCI_HAR_dataset.zip")
}
#unzip the file
unzip(newfile)

# Read in the test data
features     <- read.table('UCI HAR Dataset/features.txt',header=FALSE)
subjectTest <- read.table('UCI HAR Dataset/test/subject_test.txt',header=FALSE)
xTest       <- read.table('UCI HAR Dataset/test/x_test.txt',header=FALSE)
yTest       <- read.table('UCI HAR Dataset/test/y_test.txt',header=FALSE)

# Assign column names to the test data imported above
colnames(subjectTest) <- "subjectId"
colnames(xTest)       <- features[,2] 
colnames(yTest)       <- "activityId"

# Assemble  test dataset by putting together the xTest, yTest and subjectTest data
testData = cbind(yTest,subjectTest,xTest)


# Same process for training dataset
activityType <- read.table('UCI HAR Dataset/activity_labels.txt',header=FALSE)
subjectTrain <- read.table('UCI HAR Dataset/train/subject_train.txt',header=FALSE)
xTrain       <- read.table('UCI HAR Dataset/train/x_train.txt',header=FALSE)
yTrain       <- read.table('UCI HAR Dataset/train/y_train.txt',header=FALSE)

colnames(activityType)  <- c('activityId','activityType')
colnames(subjectTrain)  <- "subjectId"
colnames(xTrain)        <- features[,2] 
colnames(yTrain)        <- "activityId"

# 1. Merging the training and the test sets to create one dataset.
trainingData <- cbind(yTrain,subjectTrain,xTrain)
allData <- rbind(trainingData,testData)
colNames  <- colnames(allData)

# 2. Extracting only the measurements on the mean and standard deviation for each measurement. 
testVector <- (grepl("activity..",colNames) | grepl("subject..",colNames) | grepl("-mean..",colNames) & !grepl("-meanFreq..",colNames) & !grepl("mean..-",colNames) | grepl("-std..",colNames) & !grepl("-std()..-",colNames))
allData <- allData[testVector==TRUE]

# 3. Naming the activities in the data set

# Including descriptive activity names
allData <- merge(allData,activityType,by='activityId',all.x=TRUE);
colNames  <- colnames(allData);
len <- length(colNames)
# Cleaning up the variable names
for (i in 1:len) 
{
  colNames[i] = gsub("-std$","StdDev",colNames[i])
  colNames[i] = gsub("-mean","Mean",colNames[i])
  colNames[i] = gsub("^(t)","Time",colNames[i])
  colNames[i] = gsub("^(f)","Freq",colNames[i])
  colNames[i] = gsub("([Gg]ravity)","Gravity",colNames[i])
  colNames[i] = gsub("([Bb]ody[Bb]ody|[Bb]ody)","Body",colNames[i])
  colNames[i] = gsub("[Gg]yro","Gyro",colNames[i])
  colNames[i] = gsub("AccMag","AccMagnitude",colNames[i])
  colNames[i] = gsub("([Bb]odyaccjerkmag)","BodyAccJerkMagnitude",colNames[i])
  colNames[i] = gsub("JerkMag","JerkMagnitude",colNames[i])
  colNames[i] = gsub("GyroMag","GyroMagnitude",colNames[i])
}

# 4. Labeling the data set with descriptive activity names.
colnames(allData) <- colNames

# 5. Creating a second, independent tidy data set with the average of each variable for each activity and each subject. 
cleanData  <-allData[,names(allData) != 'activityType']
myData <- aggregate(cleanData[,names(cleanData) != c('activityId','subjectId')],by=list(activityId=cleanData$activityId,subjectId = cleanData$subjectId),mean)
myData <- merge(myData,activityType,by='activityId',all.x=TRUE)
#write.csv(myData, "UCIDatabase.csv", row.names=TRUE)
write.table(myData, "UCIDatabase.txt", row.names=FALSE)