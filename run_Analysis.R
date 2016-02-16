
library(dplyr)
library(tidyr)
download.file(url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
              destfile = "data/wearabledata.zip",
              method = "curl")

unzip("data/wearabledata.zip", exdir = "./data/")

# get the text files to read
file_list_test <- list.files("./data/UCI HAR Dataset/test/", pattern = "*.txt")
file_list_train <- list.files("./data/UCI HAR Dataset/train/", pattern = "*.txt")

# inverse the order of the files
file_list_test <- file_list_test[order(desc(file_list_test))]
file_list_train <- file_list_train[order(desc(file_list_train))]

# create test data frame
rm(test)
for (file in file_list_test){
    # if the merged dataset doesn't exist, create it
    if (!exists("test")){
        test <- read.table(paste0("./data/UCI HAR Dataset/test/",file))
    } else {
        temp_dataset <-read.table(paste0("./data/UCI HAR Dataset/test/",file))
        test<-cbind(test, temp_dataset)
        rm(temp_dataset)
    }
}

# create train data frame
rm(train)
for (file in file_list_train){
    # if the merged dataset doesn't exist, create it
    if (!exists("train")){
        train <- read.table(paste0("./data/UCI HAR Dataset/train/",file))
    } else {
        temp_dataset <-read.table(paste0("./data/UCI HAR Dataset/train/",file))
        train<-cbind(train, temp_dataset)
        rm(temp_dataset)
    }
}

# Q1. Merge the test and train data frames
merged <- rbind(test,train)

# change the column names
names(merged)[1] <- "activity"
names(merged)[2] <- "subject"

# get the names of the observations
features <- read.table(file = "data/UCI HAR Dataset/features.txt", stringsAsFactors = FALSE)
featuretitles <- features[,2]
#names(merged)[3:length(names(merged))] <-  features[,2]
#names(merged)

# Q2. Extract the mean and standard deviation for each measurement
tokeepmean <- which(sapply(featuretitles,grepl,pattern="mean"))
tokeepstd <- which(sapply(featuretitles,grepl,pattern="std"))

tokeep <- c(1,2,tokeepmean+2 ,tokeepstd+2)
tokeep <- tokeep[order(tokeep)]

df <- select(merged,tokeep)
head(df)

# Q3. Using descriptive activity names in dataset
