#Housekeeping ####
rm(list=ls()) #Clear memory

#Load required packages
#install missing packages using : "install.packages("package_name")
#install.packages(c("dplyr","ggplot2", "tidyr", "scales", "RNetCDF", "maps"))
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
  names(giovanni_map_dataframe) <- giovanni_map_data[["lat"]]  #This was edited to reflect selecting by name rather than by index because of the addition of lat_bnds and lon_bnds to some data files
  giovanni_map_dataframe$lon <- giovanni_map_data[["lon"]]
  
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
climatic_average <- read_giovanni_nc_map("./Data/g4.timeAvgMap.MODISA_L3m_SST_2014_sst4.20070101-20161231.180W_23S_180E_23N.nc")
climatic_average <- rename(climatic_average, climatic_temperature=temperature)

#Plot climatic average as check
#qplot(data=climatic_average, x=as.numeric(lon), y=as.numeric(lat), fill=climatic_temperature, geom="raster")


# Single year/month data ####
#Apply the function to single year/month data
single_year <- read_giovanni_nc_map("./Data/g4.timeAvgMap.MODISA_L3m_SST_2014_sst4.20150101-20151231.180W_23S_180E_23N.nc")
single_year <- rename(single_year,year_temperature=temperature)

#Plot single year as check
#qplot(data=single_year, x=as.numeric(lon), y=as.numeric(lat), fill=year_temperature, geom="raster")

# Merge the data  ####
anomaly <- single_year
anomaly$climatic_temperature <- climatic_average$climatic_temperature



# Calculate the anomalies ####
anomaly$difference <- with(anomaly, year_temperature-climatic_temperature)

#Remove missing values
anomaly <- na.omit(anomaly)

#Constrain the data to sensible values ####
#Should be uncommented (# removed) and edited
# anomaly <- anomaly[anomaly$difference<10 & anomaly$difference>-10,]

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
  #must be uncommented (remove #) and edited for the tropics
  # scale_x_continuous("Axis title", limits=c(-87.0117,27.5977))+ 
  # scale_y_continuous("Axis title", limits=c(38.6719,63.9844))+
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
