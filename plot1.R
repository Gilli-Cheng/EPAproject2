url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
filename <- "peerreview.zip"
origin <- getwd()

if(!file.exists("data")){
        dir.create("data")
        setwd("./data")
        download.file(url = url,
                      destfile = filename,
                      method = "curl")
        unzip(zipfile = filename)
        setwd(origin)
}
NEI <- readRDS(file = "./data/summarySCC_PM25.rds")
SCC <- readRDS("./data/Source_Classification_Code.rds")


yearsum <- tapply(NEI$Emissions,NEI$year,sum)
yearsum[1:4] <- 0.000001*yearsum[1:4]
years <- unique(NEI$year)
range(yearsum)

data <- data.frame(year = years,value = yearsum)
rownames(data) <- NULL

par(mar = c(4,4,1,1))

dev.cur()
windows(480,480)
plot(years, yearsum,
     xlim = c(1997,2010),
     ylim = c(2,8),
     pch = 19,cex = 2,
     col = "steel blue",
     xlab = "",ylab = "",type = "b",lwd = 2) + 
        title(main =  "Total Emissions from PM2.5 in the U.S. from 1999 to 2008",
              ylab = "Sum of PM2.5  (10^6 tons)",
              xlab = "Year")
dev.copy(png, file = "./plot1.png",width = 480, height = 480,units = "px")
dev.off()
