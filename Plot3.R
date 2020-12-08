library(dplyr)
library(ggplot2)

# Download source files from URL, unzip and read RDS files on 1st run only.
if (!"NEI" %in% ls() & !"SCC" %in% ls()) {
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip","./download/FNEI_data.zip")
  unzip("./download/FNEI_data.zip")
  NEI <- readRDS("summarySCC_PM25.rds")
  SCC <- readRDS("Source_Classification_Code.rds")
}

# Extract and total Baltimore Emissions
Balt_type <-  NEI %>%
  filter(fips == "24510") %>%
  group_by(year,type) %>%
  summarise(Sum_Emissions = sum(Emissions))  %>%
print

# Plot and copy to png
chart <- ggplot(Balt_type, aes(year, Sum_Emissions, colour = type))
chart <- chart + geom_line() + geom_point()
chart <- chart + labs(title = expression('Total PM'[2.5]*" Emissions Baltimore by Type (1999 to 2008)"),
         x = "Year", y = expression('Total PM'[2.5]*" Emission (tons)"))
print(chart)

dev.copy(png,file = "plot3.png", width = 480, height = 480, units = "px")
dev.off()