Data and scripts for
Remote sensing and GIS practical

Presentations:

Part A in R
[Presentation](http://low-decarie.github.io/Remote-sensing-and-GIS-practical/Part_A_map_difference.html)

Part A in Qgis
[Instruction](https://github.com/low-decarie/Remote-sensing-and-GIS-practical/blob/master/Part_A_instructions%20using%20QGIS.md)


Part B
[Presentation](http://low-decarie.github.io/Remote-sensing-and-GIS-practical/Part_B_time_anomaly.html)

To download:
https://github.com/low-decarie/Remote-sensing-and-GIS-practical/archive/master.zip
(or Click on green "Download or clone" and Click on "download zip”)
Right click on downloaded file and extract/uncompress file
(though you can navigate in the compress file on Windows, the files will not function correctly).


# BS707 Remote sensing data manipulation exercise: Exploring remotely sensed
ocean temperature data for the prediction of coral bleaching
## Summary

Our abilities to sample sufficiently over space and time have been revolutionized with
the availability of remotely sensed ocean colour and development of algorithms that
link ocean colour to environmental (and biological) variables of interest. Coral
bleaching is a growing global concern. It is now generally well understood that coral
bleaching can vary in intensity and frequency as a result of temperature, high and low
light, nutrient availability, eutrophication and pollution (Baker, Glynn, & Riegl, 2008;
Pandolfi, 2003). In part, this increase in knowledge has come from studies that have
integrated broad scale remotely sensed environmental data with “on the ground”
observations (Donner, 2011; Maina, McClanahan, Venus, Ateweberhan, & Madin,
2011; Maina, Venus, McClanahan, & Ateweberhan, 2008)

## Skills

This exercise will introduce you to remote sensing data and how this can be extracted
from the web and applied to address biological questions. Specifically, you will
develop skills and be assessed on your ability to present remotely-sensed spatial data
in a map. You will also develop skills and be assessed on your ability to manipulate
and summarize large temporal datasets. Lastly, you will develop and be assessed on
your time management skills, as the assignment is due at the end of class. Whilst the
integration of statistical tests is not a requirement, statistics will substantially support
any claims of the existence or absence of a trend or difference.

## Tool (software)

This exercise can be done in the software of your choice (“software agnostic”),
however, R scripts are provided on Moodle to facilitate your progression. Part A can
be performed in any GIS software (ArcGis, GRASS, QGIS). Part B can be preformed
in any spreadsheet (Excel, Open/Libre Office) or statistical package (SPSS).

## Assessment

A single “Data Analysis and Interpretation” (DAI) document that contains your
individual response to the questions and tasks denoted below in DAI sections must be
submitted for assessment on FASER. You can work in groups, but you must each
individually submit an independent and original piece of written coursework. The
document you submit must be presented in a neat and logical manner addressing each
of the components of the exercises below. You must state on your assessed document
the source of the data, in line with “Acknowledgement Policy” for the website(s).

## SETUP

1. Download the project folder from Moodle/github
The folder contains all the scripts and example data files. Do not use these example
data files to complete your assignement.
PART A: Spatial trends in sea surface temperature anomalies as it relates to a
mass bleaching event
Maps can be powerful visual tools for the interpretation of spatial data. Mapping
environmental conditions that can lead to bleaching can allow targeted monitoring
and management responses (Liu et al., 2014). Mapping predicted environmental
conditions can lead to the identifications of locations that can act as refugia for corals
(Hooidonk, Maynard, & Planes, 2013) or that are made particularly vulnerable to
bleaching and disease by future conditions (Maynard et al., 2015).
Objectives:
• Identify a mass-bleaching event (location and a year) from the literature.
• For the year of the mass-bleaching event, create a world map of the mean
temperature deviation from long-term climactic averages.
• Observe if temperature was particularly high or low in locations that
experienced mass.
• Identify potential local coral refugia.
Steps for data retrieval:
1. Download a climatic average map
a. Go to https://giovanni.sci.gsfc.nasa.gov/giovanni/
b. Select Time averaged under Maps
c. Constrain the map to the tropics by entering the appropriate latitudes and
time
i. Enter coordinates in Select Region as “West, South,
East, North”. Whole world is “-180, -90, 180, 90”. You can verify
your selection using show map. You may need to constrain this
area to a smaller area than the tropics based on memory available
on your computer.
ii. Enter date range in Select Date Range. Note the
available dates for your variable. Pay attention to the temporal 
range of the data (Begin date and End date, including
considerations of seasonality)
d. Select a “variable” of your choice
i. Note: Lower spatial resolution data will allow you to download for
a larger coverage area. You will need to justify your selection of
remotely sensed parameter in the methods section of you DOI and
the spatial resolution of the data (Spat.Res.). Hint: Look up what
parameters are used by NOAA Coral Reef Watch.
e. Click on the “Plot Data” button at the bottom of the page. It will take up to
5-10 minutes to generate/retrieve the data set but once complete it will
automatically move to a “Data Visualization” tab.
f. Click on Downloads in the left hand list. Choose the NetCDF format.
2. Download	a	map	of	mean	temperature	for	the	year or	month	of	the	massbleaching
event
1. Proceed as for the climatic average; however, select a date range relevant
to year or month of the mass-bleaching event.
i. Note: You will need to justify your selection of date range
(calendar year, year centred on bleaching event, month, etc.).
3. Load both maps into your software of choice (a partial R script is provided on
Moodle, but you are free to use the GIS software of your choice).
4. Calculate the difference between the climatic average and the mean temperature
for the year of the mass-bleaching event.
5. Explore your data. What is the range of temperature anomalies? Note the data
contains freshwater systems that can have a far larger temperature anomaly than
marine system. If needed, select the relevant data.
6. Plot (map) the resulting difference, highlighting the location of the massbleaching
event(s).
With positive and negative cell values in a map, a two colour gradient can better
highlight differences than a single colour gradient covering the whole range. This is
often encoded as blue for negative and red for positive.
Steps for data analysis are provided in the “Part_A_map_difference.R” R script file.
Additional challenges (not assessed):
• Add	to	the	map	the	distribution	of	coral	reefs.
• Add to the map the location and severity of bleaching events reported by
http://www.reefbase.org.
• Create a map of an alternative metric (eg. NOAA Coral Reef Watch Coral
Bleaching Thermal Stress HotSpot, or anomalies for only the hottest month,…) 

# Part A DAI: (300 words)

Produce and present a map of temperature deviations from the long-term
average with appropriate caption, which includes the key findings and
interpretation of the figure.
Discuss why the location of the mass-bleaching event can or cannot be identified
on a map of temperature deviations from the long-term average. This discussion
should include reference to the biological process of thermally induced coral
bleaching, the calculation process (temporal resolution, comparison to integrated
anomaly calculations, averaging across years by month) and limitation of remote
sensing. Discuss the presence of potential local temperature refugia. This
discussion should integrate oceanography concepts, including local predominant
currents.


# PART B: Spatial and temporal trends in sea surface temperature anomalies as it
relates to a mass bleaching event.

Coral-bleaching susceptibility linked to the variability of the system (Donner 2011,
Oliver & Palumbi 2011) and degree of exposure to environmental anomalies (Maina
et al. 2008, 2011, Donner 2011).
Objectives:
• Identify three mass-bleaching sites and three associated (not bleached)
reference sites.
• Calculate yearly temperature anomalies for these sites
• Compare sites based on these anomalies
• Observe temporal trends in these anomalies.
Steps for data retrieval:
1. Based on your observations in part A and in reference to the literature, select
three locations that have experienced a mass bleaching event or a large
temperature anomaly and to which you pair a nearby coral reef location for
which mass bleaching is not reported or little to no temperature anomaly was
observed (reference site).
2. Note their longitude and latitude.
3. Download 3 pairs of time series data for these 3 sites (3 bleaching datasets and
3 reference datasets)
a. Go to http://giovanni.sci.gsfc.nasa.gov/giovanni
b. In Select Plot, choose: Time Series: Area Averaged
c. Select your variable
i. Note: the smaller area can allow you or may require you to
select a higher spatial resolution.
d. Select the beginning and end date so as to capture the longest time
series available.
e. Constrain the map to a 0.5 degree longitude and 0.5 degree latitude
area centred on your first selected location (Caution: does a 1 degree
by 1 degree cell cover the same area everywhere on the planet?)
f. Click “Plot Data”
g. Select the Donwload tab and download the CSV file (you may need to
right click and “Save file as…”)
h. Open the csv file and add a column with the header “Site” and to
which you add the name of the 3 sites to all cells in the column. Add a
second column with the header “Bleached” and to which you the
values of TRUE or FALSE.
i. Repeat this process until you have the data you need for all 6
timeseries.

> HINT: You can open a window for each site to simultaneously download all the data.

> HINT: Do a sanity check to make sure your data set does not include impossible
values. For example, apply the function “summary” to your data.
Calculation of annualized anomalies
Commands for the calculation of annualized anomalies are provided in
“Part_B_time_anomaly.R”.
A “monthly anomaly” can be calculated as the value for any particular month (for any
particular year) minus the typical average for all years. Firstly calculate the average
value for each month across all years, i.e. xi2004−2014 , where i is the month January,
February etc.
Once you have done this, you can calculate the anomaly for each month throughout
your data set.
Monthly anomaly= xi − xi2004−2014 [2]
> Hint: In excel, use the $ to fix a cell or a column in an equation.
Note that this will give you a means to examine the variability within years (i.e. the
typical seasonal variability). In order to further examine across years, you want to
calculate the total anomalous conditions (both positive and negative) that have
accumulated over each year:
Annual integrated anomaly = (xi − xi2004−2014 )
i=January
i=December
∑ [3]
However, you will have “negative” anomalies, i.e. values that are “lower than usual”.
This can be equally as harmful to corals as “higher than usual” temperatures (e.g.
Weeks et al. 2008). Furthermore, using the above calculations, unusually cold months
would cancel out the anomaly of unusually hot months of a year. Thus the absolute
value of the monthly anomaly must be taken.
Monthly absolute anomaly= (xi − xi2004−2014 )
2 = xi − xi2004−2014 [4]
Which can be used in the calculation of the annual integrated absolute anomaly:
Annual integrated absolute anomaly = xi − xi2004−2014
i=January
i=December
∑ [5]

## Additional challenges (not assessed):

• Calculate alternative metric based on SST (eg. NOAA Coral Reef Watch Coral
Bleaching Thermal Stress HotSpot, or anomalies for only the hottest month,…)
• Calculate alternative metric which integrates other variables (eg. Irradiance).
Part B DAI:
(300 words)
Is the variance in temperature different between sites (this can be based on
annual temperature range or other measures of temperature variability within
site)? Current work suggests that variability promotes stress tolerance (e.g.
Oliver & Palumbi 2011). At which site would corals be expected to be more
tolerant to temperature extremes? Discuss a management strategy that could
harness this information.
(300 words)
Discuss why years of mass bleaching can or cannot be detected in temperature
anomaly time series. This discussion should include limitations of the calculation
approach used, reference to alternative methods of detecting temperature
conditions likely to cause bleaching and the possibility of including other
remotely sensed variables in the calculation of bleaching risk. Discuss the cause
of temporal trends in sea-surface temperature anomalies at your observed sites,
why these trends are or are not consistent across sites, or why no trend can be
detected. This discussion should include reference to global climatic events and
global change.
This section of the DAI should be supported by three visual elements (tables
and/or figures), each accompanied by a complete caption including key results
and interpretation. One of the visual elements should introduce the selected sites.
All statistical statements should include a measure of the difference or trend with
relevant units in addition to standard reporting of statistical test.

## Acknowledgements:

This practical is based on a practical initially developed by David Suggett.

## References
Baker, A. C., Glynn, P. W., & Riegl, B. (2008). Climate change and coral reef
bleaching: An ecological assessment of long-term impacts, recovery trends and
future outlook. Estuarine, Coastal and Shelf Science, 80(4), 435–471.
doi:10.1016/j.ecss.2008.09.003
Donner, S. D. (2011). An evaluation of the effect of recent temperature variability on
the prediction of coral bleaching events. Ecological Applications, 21(5), 1718–
1730. doi:10.1890/10-0107.1
Hooidonk, R. Van, Maynard, J. A., & Planes, S. (2013). Temporary refugia for coral
reefs in a warming world. Nature Climate Change, 3(5), 508–511.
doi:10.1038/nclimate1829
Liu, G., Heron, S., Eakin, C., Muller-Karger, F., Vega-Rodriguez, M., Guild, L., …
Lynds, S. (2014). Reef-Scale Thermal Stress Monitoring of Coral Ecosystems:
New 5-km Global Products from NOAA Coral Reef Watch. Remote Sensing,
6(11), 11579–11606. doi:10.3390/rs61111579
Maina, J., McClanahan, T. R., Venus, V., Ateweberhan, M., & Madin, J. (2011).
Global Gradients of Coral Exposure to Environmental Stresses and Implications
for Local Management. PLoS ONE, 6(8), e23064.
doi:10.1371/journal.pone.0023064
Maina, J., Venus, V., McClanahan, T. R., & Ateweberhan, M. (2008). Modelling
susceptibility of coral reefs to environmental stress using remote sensing data
and GIS models. Ecological Modelling, 212(3-4), 180–199.
doi:10.1016/j.ecolmodel.2007.10.033
Maynard, J., van Hooidonk, R., Eakin, C. M., Puotinen, M., Garren, M., Williams, G.,
… Harvell, C. D. (2015). Projections of climate conditions that increase coral
disease susceptibility and pathogen abundance and virulence. Nature Climate
Change, 5(7), 688–694. doi:10.1038/nclimate2625
Pandolfi, J. M. (2003). Global Trajectories of the Long-Term Decline of Coral Reef
Ecosystems. Science, 301(5635), 955–958. doi:10.1126/science.1085706
