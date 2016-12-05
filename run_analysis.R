# Run Analysis

## Merges the training and the test sets to create one data set.

### Set up working directory

setwd("C:/Users/Stefan/Desktop/Data/3.Getting_Cleaning_Data/Lesson4/GCD_Course_Project")

### Set up url, filename and dir vectors

url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
filename <- "data.zip"
dir <- "UCI HAR Dataset"

### Checking whether the file already exists. If not, the file is downloaded

if (!file.exists(filename)) {
        download.file(url,filename)
}

### Checking whether the file has been unzipped. Otherwise, the zip file is unzipped.

if (!dir.exists(dir)){
        unzip(filename)
}


### Load data into R

feat <- read.table("UCI HAR Dataset/features.txt")

activity <- read.table("UCI HAR Dataset/activity_labels.txt")

x_test <- read.table("UCI HAR Dataset/test/x_test.txt")
labels_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subj_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

x_train <- read.table("UCI HAR Dataset/train/x_train.txt")
labels_train <-read.table("UCI HAR Dataset/train/y_train.txt")
subj_train <- read.table("UCI HAR Dataset/train/subject_train.txt")


## Appropriately labels the data set with descriptive variable names 
cnames <- feat$V2
colnames(x_test) <- cnames
colnames(x_train) <- cnames

## Uses descriptive activity names to name the activities in the data set

newlabelstest <- left_join(labels_test,activity)
newlabelstrain <- left_join(labels_train,activity)

colnames(newlabelstest) <- c("activitylabel","activity")
colnames(newlabelstrain) <- c("activitylabel","activity")

colnames(subj_test) <- "subject"
colnames(subj_train) <- "subject"

test <- cbind(subj_test,newlabelstest,x_test)
train <- cbind(subj_train,newlabelstrain,x_train)


### Join the test and train data into one dataframe

data <- rbind(train,test)

## Extracts only the measurements on the mean and standard deviation for each measurement

### Create a TRUE/FALSE vector for the mean and std

meanstd_vector <- c(rep(TRUE,3),rep(FALSE,561)) | grepl("mean",names(data)) | grepl("std",names(data))

### Filter out only mean and standard deviation columns

final_data <- data[,meanstd_vector]

final <- select(final_data,-activitylabel)

### Summarise means by subject and activity to create a tidy dataset

tidy <- final %>% group_by(subject,activity) %>% summarise_all(mean)

### export final result

write.table(tidy, file ="tidy.txt", row.names = FALSE, quote = FALSE)

