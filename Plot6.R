library(dplyr)
library(ggplot2)

# Download source files from URL, unzip and read RDS files on 1st run only.
if (!"NEI" %in% ls() & !"SCC" %in% ls()) {
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip","./download/FNEI_data.zip")
  unzip("./download/FNEI_data.zip")
  NEI <- readRDS("summarySCC_PM25.rds")
  SCC <- readRDS("Source_Classification_Code.rds")
}

# Extract road emissions from NEI and sum emissions for Baltimore and Los Angeles
road_Balt_vs_LA <- NEI %>%
  filter (fips == "24510"| fips == "06037") %>%
  filter(type == "ON-ROAD") %>%
  group_by(year,fips) %>%
  summarise(Sum_Emissions = sum(Emissions))  %>%
  print

# Plot and copy to png
chart <- ggplot(road_Balt_vs_LA, aes(year, Sum_Emissions))
chart <- chart + geom_col(aes(fill=fips), position = "dodge")
chart <- chart + labs(title = expression('Total PM'[2.5]*" Emissions Baltimore vs. LA (1999 to 2008)"),
                      x = "Year", y = expression('Total PM'[2.5]*" Emission (tons)"))
chart <- chart + scale_fill_discrete (name="County",labels= c("LA","Baltimore"))
print(chart)

dev.copy(png,file = "plot6.png", width = 480, height = 480, units = "px")
dev.off()