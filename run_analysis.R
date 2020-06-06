download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",destfile="./ds.zip")
unzip("./ds.zip")
#Reads and Merges the training and the test sets to create one data set.
xtest <- read.table("./UCI HAR Dataset/test/X_test.txt")
ytest <- read.table("./UCI HAR Dataset/test/y_test.txt")
test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
ytrain <- read.table("./UCI HAR Dataset/train/y_train.txt")
train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
x <- rbind(xtest,xtrain)         ##bind
y <- rbind(ytest,ytrain)           ##bind
combtt <- rbind(test,train)           ##bind
feature <- read.table("./UCI HAR Dataset/features.txt")
activity <- read.table("./UCI HAR Dataset/activity_labels.txt")

#Extracts only the measurements on the mean and standard deviation for each measurement.
ind <- grep("mean\\(\\)|std\\(\\)",feature[ ,2]) 
length(ind)
x<-x[,ind]
dim(x)

#Uses descriptive activity names to name the activities in the data set
y[,1]<-activity[y[,1],2]
head(y) 

#Appropriately labels the data set with descriptive variable names.
names<-feature[ind,2]
names(x)<-names
names(combtt)<-"SubjectID"
names(y)<-"Activity"
CleanedData<-cbind(combtt,y,x)
head(CleanedData[,c(1:4)]) 

#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
library(data.table)
CleanedData<-data.table(CleanedData)
TidyData <- CleanedData[, lapply(.SD, mean), by = 'SubjectID,Activity']
dim(TidyData)
write.table(TidyData, file = "Tidy.txt", row.names = FALSE)
head(TidyData[order(SubjectID)][,c(1:4), with = FALSE],12) 
