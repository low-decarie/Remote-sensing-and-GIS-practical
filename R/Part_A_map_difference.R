#Housekeeping ####
rm(list=ls()) #Clear memory

#Load required packages
#install missing packages using : "install.packages("package_name")
require(dplyr)
require(ggplot2)
require(tidyr)
require(scales)
require(RNetCDF)
require(maps)

#Set the theme for the plots
theme_set(theme_bw())
  # see http://docs.ggplot2.org/dev/vignettes/themes.html for other options


#Function to load giovani files  ####
read_giovanni_nc_map <- function(giovanni_nc_map_file){
  #Load the NetCDF file
  giovanni_map_data <- open.nc(giovanni_nc_map_file)
  
  #Extract its content
  giovanni_map_data <- read.nc(giovanni_map_data)
  
  #Convert its content to a data frame
  giovanni_map_dataframe <- as.data.frame(giovanni_map_data[1])
  names(giovanni_map_dataframe) <- giovanni_map_data[[2]]
  giovanni_map_dataframe$lon <- giovanni_map_data[[3]]
  
  #Switch from a wide matrix format
  #in which values for longitude are given across columns
  #to a long format, with a single temperature measurement per row
  giovanni_map_data <- gather(giovanni_map_dataframe,
                              "lat","temperature",
                              -length(names(giovanni_map_dataframe)))
  
  return(giovanni_map_data)
}

# Climatic averaged data ####
# Apply the function to climatic averaged data
climatic_average <- read_giovanni_nc_map("./Data/climatic_average_sea.nc")
climatic_average <- rename(climatic_average, climatic_temperature=temperature)

# Single year/month data ####
#Apply the function to single year/month data
single_year <- read_giovanni_nc_map("./Data/single_year_sea.nc")
single_year <- rename(single_year,year_temperature=temperature)

# Merge the data  ####
anomaly <- single_year
anomaly$climatic_temperature <- climatic_average$climatic_temperature

# Calculate the anomalies ####
anomaly$difference <- with(anomaly, year_temperature-climatic_temperature)

#Remove missing values
anomaly <- na.omit(anomaly)

#Constrain the data to sensible values ####
anomaly <- anomaly[anomaly$difference<10 & anomaly$difference>-10,]

#Plot the anomaly on a map  ####
p <- ggplot()+
  geom_raster(data=anomaly,aes(
           x=as.numeric(lon),
           y=as.numeric(lat),
           fill=as.numeric(difference)))+
    borders("world",
            colour="gray50",
            fill="gray50")

# Edit plot details ####
p <- p+
  scale_x_continuous("Axis title", limits=c(-87.0117,27.5977))+
  scale_y_continuous("Axis title", limits=c(38.6719,63.9844))+
  scale_fill_gradientn("Title of legend",
                       colours=c("blue","white","red"))+
  coord_equal()+
  theme(axis.ticks=element_line(colour="red"),
        axis.text=element_text(colour="green"))

#Save the plot to a PDF file  ####
pdf("./Plots/file.pdf",width=7,height=7)
print(p)
graphics.off()

# Load the plot to screen
#print(p)

# Save the data as a csv for analysis in other software
write.csv(anomaly,
          file="./Output/anomaly_for_map.csv")
