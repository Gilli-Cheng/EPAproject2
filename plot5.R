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

table(grepl("[Mm]otor [Vv]ehicle|Motorcycles",SCC$Short.Name))
grep("[Mm]otor [Vv]ehicle|Motorcycles",SCC$Short.Name,value = TRUE)
motorvehicle <- SCC[grepl("[Mm]otor [Vv]ehicle|Motorcycles",SCC$Short.Name),]
SCCcode <- unique(motorvehicle$SCC)

NEIbal <- NEI[NEI$fips == "24510",]
NEIbalsub <- subset(NEIbal,NEIbal$SCC %in% SCCcode)

library("data.table")
head(NEIbalsub)
summary(NEIbalsub$Emissions)
x0sub <- as.data.frame(with(NEIbalsub,tapply(Emissions,year,sum)))
x0sub <- setDT(x0sub,keep.rownames = TRUE)
names(x0sub) <- c("year","emissions")

dev.cur()
windows(480,480)
g <- ggplot(x0sub,aes(year,emissions,group = 1))
g + geom_point(size = 4, col = "pink") + theme_light() + 
        labs(y = "motor vehicle related emissions in Baltimore",
             title = "Emissions from Motor Vehicle Sources in Baltimore City") +
        coord_cartesian(ylim = c(0,15)) + 
        geom_line(col = "pink",lwd = 1)
dev.copy(png,"./plot5.png",units = "px")
dev.off()
