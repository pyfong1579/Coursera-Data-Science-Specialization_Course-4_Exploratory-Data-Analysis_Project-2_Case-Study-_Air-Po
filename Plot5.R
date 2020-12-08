library(dplyr)
library(ggplot2)

# Download source files from URL, unzip and read RDS files on 1st run only.
if (!"NEI" %in% ls() & !"SCC" %in% ls()) {
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip","./download/FNEI_data.zip")
  unzip("./download/FNEI_data.zip")
  NEI <- readRDS("summarySCC_PM25.rds")
  SCC <- readRDS("Source_Classification_Code.rds")
}

# Extract ON-ROAD emissions from NEI and sum emissions for Baltimore
road_Balt <- NEI %>%
  filter (fips == "24510") %>%
  filter(type == "ON-ROAD") %>%
  group_by(year) %>%
  summarise(Sum_Emissions = sum(Emissions))  %>%
  print

# Plot and copy to png
plot(road_Balt, type = "b", pch = 19, col = 5, xlab = "Year",
     main = expression('Total PM'[2.5]*" Emissions Baltimore Onroad sources (1999 - 2008)"),
     ylab = expression('Total PM'[2.5]*" Emission (Thousand tons)"))

dev.copy(png,file = "plot5.png", width = 480, height = 480, units = "px")
dev.off()