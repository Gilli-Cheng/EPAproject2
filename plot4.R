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

table(grepl("[Cc]oal",SCC$Short.Name))
grep("[Cc]oal",SCC$Short.Name,value = TRUE)
coal <- SCC[grepl("[Cc]oal",SCC$Short.Name),]
SCCcode <- unique(coal$SCC)

NEIsub <- subset(NEI,NEI$SCC %in% SCCcode)

library("data.table")
NEIsubsum <- as.data.frame(with(NEIsub,tapply(Emissions,year,sum)))
NEIsubsum <- setDT(NEIsubsum,keep.rownames = TRUE)
NEIsubsum[,2] <- NEIsubsum[,2]*0.0001
names(NEIsubsum) <- c("year","emissions")

library("ggplot2")

head(NEIsubsum)

dev.cur()
windows(480,480)
g <- ggplot(NEIsubsum,aes(year,emissions,group = 1))
g + geom_point(col = "steel blue",size = 4,alpha = 1/2) + 
        geom_line(col = "steel blue",lwd = 1,alpha = 1/2) + 
        theme_light() + 
        labs(x = "Year", y = "Emissions  tons(10^4)",
             title = "Emissions from Coal Combustion-related Sources in the U.S.") + 
        coord_cartesian(ylim = c(30,70))
dev.copy(png,"./plot4.png",units = "px")
dev.off()
