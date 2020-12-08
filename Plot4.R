library(dplyr)
library(ggplot2)

# Download source files from URL, unzip and read RDS files on 1st run only.
if (!"NEI" %in% ls() & !"SCC" %in% ls()) {
  download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip","./download/FNEI_data.zip")
  unzip("./download/FNEI_data.zip")
  NEI <- readRDS("summarySCC_PM25.rds")
  SCC <- readRDS("Source_Classification_Code.rds")
}

# Extract coal sources from SCC and sum corresponding emissions from NEI
coal_src <- as.character(SCC[grep("- Coal",SCC$EI.Sector),"SCC"])
coal_NEI <-  NEI %>%
  filter(SCC %in% coal_src) %>%
  group_by(year) %>%
  summarise(Sum_Emissions = sum(Emissions)/1e+3)  %>%
  print

# Plot and copy to png
plot(coal_NEI, type = "b", pch = 19, col = 2, xlab = "Year",
     main = expression('Total PM'[2.5]*" Emissions Coal combustion-related sources (1999 - 2008)"),
     ylab = expression('Total PM'[2.5]*" Emission (Thousand tons)"))

dev.copy(png,file = "plot4.png", width = 480, height = 480, units = "px")
dev.off()