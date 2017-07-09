setwd("~/Desktop/Coursera/Project_20170709")
rm(list=ls())
temp <- tempfile()
download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip",temp)
header <- read.table(unzip(temp, "household_power_consumption.txt"),
                     nrows = 1,
                     header = FALSE,
                     sep = ";",
                     stringsAsFactors = FALSE)
power <- read.table(unzip(temp, "household_power_consumption.txt"),
                    skip = grep("1/2/2007", readLines("household_power_consumption.txt")),
                    sep = ";", 
                    na.strings = "?", 
                    nrows = 2879)
colnames(power) <- unlist(header)
rm(temp)

power$newDate <- strptime(as.character(power$Date), "%d/%m/%Y")
format(power$newDate, "%Y-%m-%d")
power$Date <- power$newDate
power$newDate <- NULL
names(power)[3:9] <- c("Global.Active.Power", 
                       "Global.Reactive.Power", 
                       "Voltage", 
                       "Global.Intensity", 
                       "Sub.Metering.1", 
                       "Sub.Metering.2", 
                       "Sub.Metering.3")

png("plot1.png")
hist(power$Global.Active.Power, 
     col="red",
     main = "Global Active Power",
     xlab = "Global Active Power (kilowatts)")
dev.off()