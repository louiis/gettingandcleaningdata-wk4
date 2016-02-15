

gdp2 <- read.csv("data/gdp.csv")
edu2 <- read.csv("data/edu.csv")

names(gdp2) <- tolower(names(gdp2))
names(edu2) <- tolower(names(edu2))

gdp<-rename(gdp2,countrycode = x, country = x.2, val = x.3, gdprank = gross.domestic.product.2012)
gdp <- select(gdp,countrycode,val, country,gdprank)
gdp <- gdp[-(195:330),]
gdp <- gdp[-(1:4),]

edu <- edu2

# convert factor to numeric
# as.numeric(levels(f))[f] 
numericgdp <- as.numeric(gsub(",","",gsub(" ", "",levels(gdp$val))[gdp$val]))
gdp$val <- numericgdp
numericgdprank <- as.numeric(levels(gdp$gdprank))[gdp$gdprank]
gdp$gdprank <- numericgdprank
     
mm <- match(gdp$countrycode,edu$countrycode)
sum(!is.na(mm))

merged <- merge(gdp,edu)

sorted<- arrange(merged,desc(gdprank))

sorted$quartile <-with(sorted,cut(gdprank,breaks = quantile(gdprank,probs = seq(0,1,by=0.25),
                                                            labels=c("Q1","Q2","Q3","Q4"),na.rm = TRUE),
                                                            include.lower = TRUE))

summarize(group_by(merged,income.group),mean(gdprank))



