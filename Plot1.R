library(dplyr)
library(ggplot2)

# Download source files from URL, unzip and read RDS files on 1st run only.
if (!"NEI" %in% ls() & !"SCC" %in% ls()) {
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip","./download/FNEI_data.zip")
  unzip("./download/FNEI_data.zip")
  NEI <- readRDS("summarySCC_PM25.rds")
  SCC <- readRDS("Source_Classification_Code.rds")
}

# Total emissions by year   
tot_Emissions <- NEI  %>%
                    group_by(year) %>%
                    summarise(sum(Emissions)/1e+06) %>%
                  print

#plot and copy to png
plot(tot_Emissions, type = "b", pch = 19, col = 1, xlab = "Year",
     main = expression('Total PM'[2.5]*" Emissions U.S.A (1999 - 2008)"),
     ylab = expression('Total PM'[2.5]*" Emission (million tons)"))

dev.copy(png,file = "plot1.png", width = 480, height = 480, units = "px")
dev.off()