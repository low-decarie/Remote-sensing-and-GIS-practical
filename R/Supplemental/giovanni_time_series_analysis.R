#Housekeeping ####
rm(list=ls())
require(dplyr)
require(ggplot2)
require(reshape)
require(gridExtra)
require(lubridate)
theme_set(theme_bw())
require(tidyr)
require(scales)

pdf("./assignement plots.pdf",width=7,height=7)

op <- options(contrasts = c("contr.helmert", "contr.poly"))


#Load data ####

#Function to load giovanni data
load_giovanni_time <- function(path){
  load_file <- function(selected_file){
    variable <- substr(selected_file, 6,9)
    path_file <- paste0(path,selected_file)
    file_data <- read.table(path_file, skip=8, col.names = c("Date", variable))
    file_data$Date <- as.Date(paste(01,file_data$Date), format="%d %b%Y")
    return(file_data)
  }
  
  file.list <- list.files(path)
  for(i in 1:length(file.list)){
    if(i==1){
      all_data <- load_file(file.list[i])}
    else{all_data <- merge(all_data, load_file(file.list[i]))}
  }
  return(all_data)
}


Abrolhos_Brazil <- load_giovanni_time("./Data/for_practical/Abrolhos_Brazil/")
Mahe_Seychelles <- load_giovanni_time("./Data/for_practical/Mahe_Seychelles/")
WMNP <- load_giovanni_time("./Data/for_practical/Wakatobi_Marine_National_Park_Indonesia/")

Abrolhos_Brazil$Site <- "Abrolhos_Brazil"
Mahe_Seychelles$Site <- "Mahe_Seychelles"
WMNP$Site <- "WMNP"
all_data <- rbind(Abrolhos_Brazil,Mahe_Seychelles)
all_data <- rbind(all_data,WMNP)

#Extract month and year
all_data$Year <- year(all_data$Date)
all_data$month <- month(all_data$Date)

#Sanity check and error removal ####
summary(all_data)
plot(all_data)

#Remove months that have negative attenuation coefficients
all_data <- all_data[all_data$K490>0,]

summary(all_data)
plot(all_data)

p <- qplot(data=all_data,
           x=Date,
           y=SST4,
           colour=Site,
           geom="line")
print(p)

p <- qplot(data=all_data,
           x=as.factor(Year),
           y=SST4,
           colour=Site,
           geom="boxplot")
print(p)

write.csv(all_data, "./Data/for_practical/Giovanni_merged_data.csv")

# PART A: Correlation between environmental variables at three different coral reef Sites. ####

#Co-variance of light and temperature (A1)
p <- qplot(data=all_data,
           x=PAR_,
           xlab="Photosynthetically Available Radiation 4km [Einstein/m^2/Day]"
           y=SST4,
           ylab="Sea Surface Temperature (4 micron night) [C]"
           colour=Site)+
  geom_smooth(method="lm", se=F)

print(p+scale_x_continuous(breaks= pretty_breaks()))

fit <- lm(data=all_data,
          SST4~Site*PAR_)
require(car)
Anova(fit)
par(mfrow = c(2,2))
plot(fit)

#PAR at depth (A2)
all_data$PAR_5m <- with(all_data, exp(log(PAR_)-(K490*5)))

p <- qplot(data=all_data,
           x=PAR_5m,
           xlab="Photosynthetically Available Radiation at 5m [Einstein/m^2/Day]"
           y=SST4,
           ylab="Sea Surface Temperature (4 micron night) [C]"
           colour=Site)+
  geom_smooth(method="lm", se=F)

print(p+scale_x_continuous(breaks= pretty_breaks()))

fit <- lm(data=all_data,
          SST4~Site*PAR_5m)
require(car)
Anova(fit)
par(mfrow = c(2,2))
plot(fit)



#Co-variance of attenuation and chlorophyll A3
p <- qplot(data=all_data,
           x=K490,
           xlab="Diffuse Attenuation Coefficient at 490 nm 4km [1/m]"
           y=CHLO,
           ylab="Chlorophyll (mg/m^3)",
           colour=Site)+
  geom_smooth(method="lm", se=F)

print(p+scale_x_continuous(breaks= pretty_breaks()))


fit <- lm(data=all_data,
          CHLO~Site*PAR_)
require(car)
Anova(fit)
par(mfrow = c(2,2))
plot(fit)

#Co-variance of Chlorophyll and temperature A4
p <- qplot(data=all_data,
           x=SST4,
           xlab="Sea Surface Temperature (4 micron night) 4km [C]",
           y=CHLO,
           ylab="Chlorophyll a concentration (mg/m^3)",
           colour=Site)+
  geom_smooth(method="lm", se=F)

print(p+scale_x_continuous(breaks= pretty_breaks()))

fit <- lm(data=all_data,
          CHLO~Site*SST4)
require(car)
Anova(fit)
par(mfrow = c(2,2))
plot(fit)


# PART B: How variable is the environments at these Sites (ranges and anomalies)?  ####



# Inherent extent of variability  B1.
#Variability can include seasonality:
#Extract variance
all_var <- group_by(all_data, Site)
all_var <- summarise(all_var,
                     var_CHLO=var(CHLO),
                     var_K490=var(K490),
                     var_PAR_5m=var(PAR_5m),
                     var_SST4=var(SST4))

all_var <- melt(as.data.frame(all_var), id.vars="Site")

p <- qplot(data=all_var,
           y=value,
           x=Site,
           fill=Site,
           geom="bar",
           stat="identity",
           position="dodge")+
  facet_grid(variable~., scale="free")

print(p+scale_x_continuous(breaks= pretty_breaks()))


#Calculate monthly anomaly
monthly_anomaly <- group_by(all_data, month, Site)
monthly_anomaly <- mutate(monthly_anomaly,
                          mm_CHLO=mean(CHLO),
                          ma_CHLO=CHLO-mean(CHLO),
                          ma_K490=K490-mean(K490),
                          ma_PAR_5m=PAR_5m-mean(PAR_5m),
                          ma_SST4=SST4-mean(SST4),
                          mm_SST4=mean(SST4))


p <- qplot(data=monthly_anomaly,
           x=month,
           y=mm_SST4,
           colour=as.factor(Year),
           facets=Site~.,
           geom="line")
print(p)

p <- qplot(data=monthly_anomaly,
           x=month,
           y=ma_SST4,
           colour=as.factor(Year),
           facets=Site~.,
           geom="line")
print(p)

p <- qplot(data=monthly_anomaly,
           x=as.factor(Year),
           y=ma_SST4,
           colour=Site,
           geom="boxplot")
print(p)


#Calcualte yearly anomaly

aia <- function(absolute=T){
  #Not absolute
  if(absolute==F){
    annual_integrated_anomaly <- group_by(monthly_anomaly, Year, Site)
    annual_integrated_anomaly <- summarise(annual_integrated_anomaly,
                                           aia_CHLO=sum(ma_CHLO),
                                           aia_K490=sum(ma_K490),
                                           aia_PAR_5m=sum(ma_PAR_5m),
                                           aia_SST4=sum(ma_SST4),
                                           max_Temp=max(SST4))
    main="Based on montly anomaly"
  }
  
  if(absolute==T){
    annual_integrated_anomaly <- group_by(monthly_anomaly, Year, Site)
    annual_integrated_anomaly <- summarise(annual_integrated_anomaly,
                                           aia_CHLO=sum(abs(ma_CHLO)),
                                           aia_K490=sum(abs(ma_K490)),
                                           aia_PAR_5m=sum(abs(ma_PAR_5m)),
                                           aia_SST4=sum(abs(ma_SST4)),
                                           max_Temp=max(SST4))
    main="Based on absolute montly anomaly"
  }
  
  #Mean monthly maximum
  mean_monthly_maximum <-   group_by(annual_integrated_anomaly,Site)
  mean_monthly_maximum <- summarise(mean_monthly_maximum,
                                    mean_monthly_maximum=mean(max_Temp))
  mean_monthly_maximum <- merge(all_data,
                                mean_monthly_maximum)
  mean_monthly_maximum$deviation_mmm <- with(mean_monthly_maximum,
                                             SST4-mean_monthly_maximum)  
  
  #Anomalies through time and space (B2)
  aia_CHLO_p <- qplot(data=annual_integrated_anomaly,
                      x=Year,
                      y=aia_CHLO,
                      ylab="Annual integrated annomaly in \nChlorophyll a concentration (mg/m^3)",
                      colour=Site)+
    geom_smooth(se=F)
  
  aia_SST4_p <- qplot(data=annual_integrated_anomaly,
                      x=Year,
                      y=aia_SST4,
                      ylab="Annual integrated annomaly in\n Sea Surface Temperature (4 micron night) 4km [C]",
                      colour=Site)+
    geom_smooth(se=F)
  
  aia_PAR_5m_p <- qplot(data=annual_integrated_anomaly,
                        x=Year,
                        y=aia_PAR_5m,
                        ylab="Annual integrated annomaly in\n Photosynthetically Available Radiation at 5m [Einstein/m^2/Day]",
                        colour=Site)+
    geom_smooth(se=F)
  
  aia_K490_p <- qplot(data=annual_integrated_anomaly,
                      x=Year,
                      y=aia_K490,
                      ylab="Annual integrated annomaly in\n Diffuse Attenuation Coefficient at 490 nm 4km [1/m]",
                      colour=Site)+
    geom_smooth(se=F)
  
  grid.arrange(main=main,
               aia_CHLO_p+scale_x_continuous(breaks= pretty_breaks()),
               aia_K490_p+scale_x_continuous(breaks= pretty_breaks()),
               aia_PAR_5m_p+scale_x_continuous(breaks= pretty_breaks()),
               aia_SST4_p+scale_x_continuous(breaks= pretty_breaks()))
  
  annual_integrated_anomaly <- as.data.frame(annual_integrated_anomaly)
  fit <- with(annual_integrated_anomaly,
              manova(cbind(aia_CHLO, aia_K490, aia_PAR_5m, aia_SST4)~Year*Site))
  summary(fit)
  
  summary.aov(fit)
  
  return(annual_integrated_anomaly)
  
}

annual_integrated_anomaly <- aia(F)
annual_integrated_anomaly <- aia(T)



#PART C: Relating environmental variance to coral bleaching occurrences ####
bleaching_data <- read.csv("Data/for_practical/Bleaching data.csv")

p <- qplot(data=bleaching_data,
           x=Year,
           y=Mean,
           ylab="Bleaching response index",
           ymax=Mean+SE,
           ymin=Mean-SE,
           geom=c("pointrange"),
           colour=Site)

print(p+scale_x_continuous(breaks= pretty_breaks()))


anomaly_bleaching <- merge(bleaching_data, annual_integrated_anomaly)

molten_anomaly_bleaching <- melt(anomaly_bleaching, id.vars = c("Year", "Site","Mean", "SE"))

p <- qplot(data=molten_anomaly_bleaching,
           x=value,
           y=Mean,
           ylab="Bleaching response index",
           ymax=Mean+SE,
           ymin=Mean-SE,
           geom=c("pointrange"),
           colour=Site)+
  geom_smooth(method="lm", se=F)+
  facet_grid(.~variable, scale="free")

print(p)

p <- qplot(data=anomaly_bleaching,
           x=aia_SST4,
           y=Mean,
           ylab="Bleaching response index",
           ymax=Mean+SE,
           ymin=Mean-SE,
           geom=c("pointrange"),
           colour=Site)+
  geom_smooth(method="lm", se=F)

print(p+scale_x_continuous(breaks= pretty_breaks()))

fit <- lm(data=anomaly_bleaching,
          Mean~aia_SST4*Site,
          weights=1/SE)

summary(fit)

p <- qplot(data=anomaly_bleaching,
           x=aia_SST4*aia_PAR_5m,
           y=log(Mean),
           ylab="Bleaching response index",
           #ymax=Mean+SE,
           #ymin=Mean-SE,
           #geom=c("pointrange"),
           colour=Site)+
  geom_smooth(method="lm", se=F)

print(p)

year_summary <- group_by(all_data, Year, Site)
year_summary <- summarise(year_summary,
                          max_temp = max(SST4))

all_bleaching <- merge(year_summary, bleaching_data)
p <- qplot(data=all_bleaching,
           x=max_temp,
           y=Mean,
           ylab="Bleaching response index",
           ymax=Mean+SE,
           ymin=Mean-SE,
           geom=c("pointrange"),
           colour=Site)+
  geom_smooth(method="lm", se=F)

print(p)


year_summary <- group_by(mean_monthly_maximum, Year, Site)
year_summary <- summarise(year_summary,
                          month_over_max = sum(deviation_mmm[deviation_mmm>0]))

all_bleaching <- merge(year_summary, bleaching_data)
p <- qplot(data=all_bleaching,
           x=month_over_max,
           y=Mean,
           ylab="Bleaching response index",
           ymax=Mean+SE,
           ymin=Mean-SE,
           geom=c("pointrange"),
           colour=Site)+
  geom_smooth(method="lm", se=F)

print(p)
graphics.off()