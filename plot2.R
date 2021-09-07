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
years <- unique(NEI$year)

NEIsub <- NEI[NEI$fips == "24510",]
yearsumsub <- with(NEIsub,tapply(Emissions,year,sum))

range(yearsumsub)

dev.cur()
windows(480,480)
plot(years,yearsumsub,pch = 19,
     xlim = c(1997,2010),
     ylim = c(1500,4000),
     ylab = "Emissions sum (tons)",
     col = "steel blue",
     type = "b",
     cex = 2,lwd = 2) +
        title(main = "Total Emissions from PM2.5 in the Baltimore City")
dev.copy(png, file = "./plot2.png",width = 480,height = 480,units = "px")
dev.off()
