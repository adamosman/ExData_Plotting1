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
power$Date <- power$newDate
power$newDate <- NULL

power$DateTime <- format(strptime(power$Time, format='%H:%M:%S'), '%r')
power$DateTime <- as.POSIXct(paste(power$Date, power$DateTime), format="%Y-%m-%d %r")


names(power)[3:9] <- c("Global.Active.Power", 
                       "Global.Reactive.Power", 
                       "Voltage", 
                       "Global.Intensity", 
                       "Sub.Metering.1", 
                       "Sub.Metering.2", 
                       "Sub.Metering.3")

png("plot4.png")
par(mfrow = c(2,2))
with(power, plot(DateTime,
                 Global.Active.Power,
                 type = "l",
                 ylab = "Global Active Power",
                 xlab = ""))
with(power, plot(DateTime,Voltage,
                 type = "l",
                 xlab = "datetime", 
                 ylab = "Voltage"))
with(power, plot(DateTime,Sub.Metering.1, 
                 xlab = "", 
                 ylab = "Energy sub metering",
                 type = "n"))
with(power, lines(DateTime,
                  Sub.Metering.1,
                  col = "black"))
with(power, lines(DateTime,
                  Sub.Metering.2,
                  col = "red"))
with(power, lines(DateTime,
                  Sub.Metering.3,
                  col = "blue"))
legend("topright",
       legend = c("Sub_metering_1","Sub_metering_2", "Sub_metering_3"),
       col=c("black","red","blue"),
       lty=c(1,1,1),
       bty = "n")
with(power, plot(DateTime,
                 Global.Reactive.Power, 
                 type = "l",
                 xlab = "datetime", 
                 ylab = "Global_reactive_power"))
dev.off()