ompare emissions from motor vehicle sources 
in Baltimore City with emissions from motor vehicle sources 
in Los Angeles County, California
(\color{red}{\verb|fips == "06037"|}fips == "06037"). 
Which city has seen greater changes over time in motor vehicle emissions?
        
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
NEIlos <- NEI[NEI$fips == "06037",]
NEIbalsub <- subset(NEIbal,NEIbal$SCC %in% SCCcode)
NEIlossub <- subset(NEIlos,NEIlos$SCC %in% SCCcode)

library("data.table")
head(NEIbalsub);head(NEIlossub)
balsub <- as.data.frame(with(NEIbalsub,tapply(Emissions,year,sum)))
balsub <- setDT(balsub,keep.rownames = TRUE)
balsub$place <- rep("Baltimore",4)
names(balsub) <- c("year","emissions","place")

lossub <- as.data.frame(with(NEIlossub,tapply(Emissions,year,sum)))
lossub <- setDT(lossub,keep.rownames = TRUE)
lossub$place <- rep("Los Angeles",4)
names(lossub) <- c("year","emissions","place")

head(balsub);head(lossub)
mrg <- rbind(balsub,lossub)

dev.cur() 
windows(480,480)
g <- ggplot(mrg,aes(year,emissions, group = place,col = place,))
g + geom_point(size = 4) + theme_light() + 
        geom_line(lwd = 1) + 
        labs(y = "Emissions (tons)")+
        ggtitle("Baltimore and LA in motor vehicle emission by year") + 
        coord_cartesian(ylim = c(0,100))
dev.copy(png,"./plot6.png",units = "px")
dev.off()
