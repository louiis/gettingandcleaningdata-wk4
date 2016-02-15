
if dir.exists("./data") {
    dir.create("data")
}


## Q1
download.file(url="https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv",destfile = "./data/ACSdata.csv",method = "curl")
acs <- read.csv(file="./data/ACSdata.csv")

splitnames <- strsplit(names(acs),"wgtp")
splitnames[123]


## Q2
download.file(url="https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv",destfile = "./data/GDPdata.csv",method = "curl")
gdp<- read.csv(file="./data/GDPdata.csv",stringsAsFactors = FALSE)

g1 <- gdp["X.3"]
g2 <- g1[5:194,]
g3 <- gsub(",","",g2)
g4 <- gsub(" ","",g3)
g5 <- as.numeric(as.character(g4))
gdpmean <- mean(g5)
gdpmean


## Q3
countryNames <- gdp["X.2"]
#countryNames <- gsub(" ","",countryNames)
sum(sapply(countryNames,grepl, pattern = "^United"))


## Q4
library(dplyr)
gdp<- read.csv(file="./data/GDPdata.csv",stringsAsFactors = FALSE)
edu <- read.csv("data/edu.csv",stringsAsFactors = FALSE)
names(edu) <- tolower(names(edu))
names(gdp) <- tolower(names(gdp))

gdp <- rename(gdp,countrycode = x)
names(gdp)

merged <- merge(gdp, edu)
head(merged)
gdp

library(stringr)
fiscal <- edu$special.notes

regexpr <- "Fiscal year end: ([[:alpha:]]+) [[:digit:]]{2}"

fiscal2 <- sapply(fiscal, grepl, pattern = "Fiscal year end:")
fiscal3 <- fiscal[fiscal2]
fiscal3

fiscal4 <- sapply(fiscal,grepl,pattern = regexpr)
fiscal5 <- str_extract(fiscal,pattern = regexpr)

regexpr2 <- "([[:alpha:]]+) [[:digit:]]{2}"
fiscal6 <- str_extract(fiscal5,pattern = regexpr2)
fiscal6

library(lubridate)

fiscal7 <- grepl(fiscal6,pattern = "June")
sum(fiscal7)
fiscal7

## Q5
library(quantmod)
amzn = getSymbols("AMZN",auto.assign=FALSE)
sampleTimes = index(amzn)

head(sampleTimes)
stime <- lapply(sampleTimes,ymd)
head(stime,15)

y <- lapply(stime,year)
sum(y == "2012")

stime2012 <- stime[y == "2012"]
head(stime2012,15)

wd <- lapply(stime2012,wday,label = FALSE)

sum(wd == 2)
