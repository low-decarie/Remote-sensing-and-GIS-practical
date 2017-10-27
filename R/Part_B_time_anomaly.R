#Housekeeping ####
rm(list=ls())
require(dplyr)
require(ggplot2)
require(reshape)
require(gridExtra)
require(lubridate)
require(tidyr)
require(scales)

#install.packages(c("dplyr","ggplot2", "gridExtra","lubridate","tidyr","scales"))


theme_set(theme_bw())

# Save all future plots in this PDF
pdf("./Plots/file.pdf",width=7,height=7)

## Function for loading Giovanni time series data
load_giovanni_time <- function(path){
  file_data <- read.csv(path, 
                          skip=6,
                          col.names = c("Date",
                                        "Temperature",
                                        "NA",
                                        "Site",
                                        "Bleached"))
  file_data$Date <- parse_date_time(file_data$Date, orders="ymdHMS")
  return(file_data)
}

## Creat a list of files
file.list <- list.files("./Data/timeseries/")
file.list <- as.list(paste0("./Data/timeseries/", file.list))

# for(i in file.list){
#   load_giovanni_time(i)
# }

#Load all the files
all_data <- lapply(X=file.list,
                         FUN=load_giovanni_time)
all_data <- as.data.frame(do.call(rbind, all_data))


## Inspect the data with a plot
p <- qplot(data=all_data,
           x=Date,
           y=Temperature,
           colour=Site,
           linetype=Bleached,
           geom="line")
print(p)

#Extract month and year
all_data$Year <- year(all_data$Date)
all_data$month <- month(all_data$Date)

#Sanity check and error removal ####
summary(all_data)


## Calculate monthly anomaly
monthly_anomaly <- group_by(all_data,
                            month,
                            Site,
                            Bleached) %>%
  mutate(mm_Temperature=mean(Temperature),
         ma_Temperature=Temperature-mean(Temperature))

## Calcualte yearly anomaly
annual_integrated_anomaly <- group_by(monthly_anomaly,
                                      Year,
                                      Site,
                                      Bleached) %>%
  summarise(aia_Temperature=sum(abs(ma_Temperature)))

## Inspect the data with a plot
p <- qplot(data=annual_integrated_anomaly,
           x=Site,
           xlab="x axis label",
           y=aia_Temperature,
           ylab="y axis label",
           colour=Bleached,
           geom="boxplot")+
  scale_x_discrete(labels=c("site_1" = "Renamed site 1", "site_2" = "Rename site 2",
                            "site_3" = "Rename site 3"))
print(p)


#Close the PDF
graphics.off()


## Save file
#for plotting or analysis in other software
write.csv(annual_integrated_anomaly,
     file="./Output/annual_integrated_anomaly.csv")

## Next steps
#Plotting and statistical analysis to determine if bleaching years are different from years in which no bleaching is reported and if site where bleaching is reported are different from sites were bleaching is not reported