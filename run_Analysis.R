
library(dplyr)
library(tidyr)
download.file(url = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip",
              destfile = "data/wearabledata.zip",
              method = "curl")

unzip("data/wearabledata.zip", exdir = "./data/")

# get the text files to read
file_list_test <- list.files("./data/UCI HAR Dataset/test/", pattern = "*.txt", recursive = TRUE)
file_list_train <- list.files("./data/UCI HAR Dataset/train/", pattern = "*.txt", recursive = TRUE)

# inverse the order of the files
file_list_test <- file_list_test[order(desc(file_list_test))]
file_list_train <- file_list_train[order(desc(file_list_train))]

# create test data frame
rm(test)
for (file in file_list_test){
    # if the merged dataset doesn't exist, create it
    if (!exists("test")){
        test <- read.table(paste0("./data/UCI HAR Dataset/test/",file))
    }
    
    # if the merged dataset does exist, append to it
    if (exists("test")){
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
    }
    
    # if the merged dataset does exist, append to it
    if (exists("train")){
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
names(merged)[3:length(names(merged))] <-  sapply(1:(length(names(merged))-2),function(x) {paste0("obs",x)})

# Q2. Extract the mean and standard deviation for each measurement
obs <- select(merged,obs1:obs1714)
meas.mean <- summarize(obs, mean)
