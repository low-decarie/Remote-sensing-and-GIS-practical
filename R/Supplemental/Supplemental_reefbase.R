#Housekeeping ####
rm(list=ls())
require(dplyr)
require(ggplot2)
require(reshape)
theme_set(theme_bw())
library(ggmap)
library(maptools)


#Coral bleaching data from ReefBase http://www.reefbase.org
coord <- read.csv("./Data/reefbase/CoralBleaching.csv")


#Sanity check on coordinates
lat_lon_check <- function(lat, lon){
  lat_check <- sapply(lat, FUN=function(x){all(x<=90,
                                               x>=-90)})
  lon_check <- sapply(lon, FUN=function(x){all(x<=180,
                                               x>=-180)})
  check <- lat_check+lon_check==2
  return(check)
}

coord <- coord[!lat_lon_check(coord)]

coord <- coord[coord$BLEACHING_SEVERITY %in% c("Low","Medium","HIGH"),]
coord$BLEACHING_SEVERITY <- factor(coord$BLEACHING_SEVERITY, levels=levels(coord$BLEACHING_SEVERITY)[c(2,3,1)])


map <- ggplot()+borders("world", colour="gray50", fill="gray50")
map <- map+geom_point(data=coord,aes(x=LON,
           y=LAT,
           colour=BLEACHING_SEVERITY),
           alpha=0.5)+
  scale_colour_manual(values = c("Low"="yellow",
                                 "Medium"="orange",
                                 "HIGH"="red"))+
  guides(colour = guide_legend(override.aes = list(alpha = 1)))+
  facet_grid(YEAR~.)

print(map)

pdf("./Plots/reefbase.pdf",width=7,height=48)
print(map)
graphics.off()
           
