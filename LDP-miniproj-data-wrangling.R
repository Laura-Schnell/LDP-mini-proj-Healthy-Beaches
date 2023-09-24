###############################################################################
###############################################################################
##                                                                           ##
##                               Script Title:                               ##
##                      Assignment title: Mini-project                       ##    
##    Class: Productivity and Reproducibility in Ecology and Evolution       ##
##                           Author: Laura Schnell                           ##
##                                  Date:                                    ##
##                                                                           ##
###############################################################################
###############################################################################

#Introduction: 

#Set up------------------------------------------------------------------------

#load packages
library(tidyverse)
library(lubridate)
library(stringdist)

#check working directory 
getwd()

#import file
healthy_beaches <- read.csv(
  "C:\\Users\\laura\\Documents\\GitHub\\LDP-mini-proj-Healthy-Beaches\\Healthy_beaches_19-23.csv")

#view 
str(healthy_beaches)

#Data quality checks and formatting---------------------------------------------

#this data has not yet been cleaned so let's make a duplicate and then do some 
#checks 
beaches_clean <- healthy_beaches

#use the lubridate package to change the date from a character datatype 
beaches_clean$Date <- lubridate::as_date(beaches_clean$Date)
str(beaches_clean) #check that data type changed from character to date

#rename to make the date clearer DPLYR::RENAME function
beaches_clean <- beaches_clean %>%
  dplyr::rename(visit_date = Date)

#make separate columns for year, month, day 
#with TIDYR package, 'separate' function
beaches_clean <- separate(data = beaches_clean, col = visit_date,
                         into = c("Year", "Month", "Day"),
                         sep = "-", remove = FALSE)

#view changes to make sure the previous code worked as intended 
str(beaches_clean)

#convert year, month, day, and ec columns to numeric datatype 
beaches_clean$Year <- as.numeric(beaches_clean$Year)
beaches_clean$Month <- as.numeric(beaches_clean$Month)
beaches_clean$Day <- as.numeric(beaches_clean$Day)
beaches_clean$Ec_per100mL <- as.numeric(beaches_clean$Ec_per100mL)

#and then make the location a factor 
beaches_clean$Location <- as.factor(beaches_clean$Location) 

#View
str(beaches_clean)

#remove any potential extraneous spaces that might exist in the data
#for location
beaches_clean <- beaches_clean %>% 
     mutate(Location = str_trim(Location, side = "both"))

#for microcystin per microgram per litre
beaches_clean <- beaches_clean %>% 
  mutate(Mc_ugL = str_trim(Mc_ugL, side = "both"))

#for year 
beaches_clean <- beaches_clean %>% 
  mutate(Year = str_trim(Year, side = "both"))

#for E. coli per 100 mL 
beaches_clean <- beaches_clean %>% 
  mutate(Ec_per100mL = str_trim(Ec_per100mL, side = "both"))

#since the Healthy Beaches program went to a lot of lakes (some for few visits) 
#lets summarize the locations column to see what the top locations are 
beaches_clean %>% 
  count(Location) %>% 
  arrange(n)

#this list also shows naming inconsistencies that we need to fix 
beaches_clean$Location <- tolower(beaches_clean$Location)

#try to count again and see if that fixed it: 
beaches_clean %>% 
  count(Location) %>% 
  arrange(n)

#let's make a column for that information so we can use it to create a subset 
beaches_clean <- beaches_clean %>%  
  group_by(Location) %>% 
  mutate(sample_count = n())
head(beaches_clean)

#and now create a data subset that looks at just the top eight lakes sampled
#this requires us to convert to a dataframe: 
beaches_clean <- data.frame(beaches_clean)

beaches_subset <- beaches_clean %>% 
  subset(sample_count >= 9)
str(beaches_subset)

#for some reason, some of our values returned to character datatypes 
beaches_subset$Year <- as.numeric(beaches_subset$Year)
beaches_subset$Ec_per100mL <- as.numeric(beaches_subset$Ec_per100mL)
beaches_subset$Mc_ugL <- as.numeric(beaches_subset$Mc_ugL)

#Data visualization------------------------------------------------------------

#Let's mean the E. coli per year and then visualize that by Location 
#first, we need to see how many visits happened per location per year and add
#that as a column 
beaches_subset %>%
  group_by(Location, Year) %>% 
  mutate(yearly_sample_tally = n())

#now we can mean 
ggplot(data = beaches_subset, 
       mapping = aes(x = Year, y = Ec_per100mL, color = Rec_area)) +
  geom_line() + 
  facet_wrap(beaches_subset$Location)

