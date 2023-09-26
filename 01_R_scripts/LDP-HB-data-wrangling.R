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

#libraries for my data wrangling
install.packages("tidyverse")
install.packages("lubridate")
install.packages("stringdist")

#library for when I make preregistration 
#install.packages("prereg") 
#library(prereg) #load 

#library for when I make the manuscript 
#install.packages("grateful")
#library("grateful") #load

#load packages for data wrangling 
library(tidyverse)
library(lubridate)
library(stringdist)

#check working directory 
getwd()

#mine is incorrect so I need to set the working directory 
setwd("C:\\Users\\laura\\Documents\\GitHub\\LDP-mini-proj-Healthy-Beaches")

#import file
healthy_beaches <- read.csv(
  "C:\\Users\\laura\\Documents\\GitHub\\LDP-mini-proj-Healthy-Beaches\\00_raw_data\\Healthy_beaches_raw_data2019-23.csv")

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

#and then create a month-day column for later visualization 
beaches_clean$month_day <-paste(beaches_clean$Month, beaches_clean$Day, sep = "-")

#view changes to make sure the previous code worked as intended 
str(beaches_clean)

#convert year, month, day, and ec columns to numeric datatype 
beaches_clean$Year <- as.numeric(beaches_clean$Year)
beaches_clean$Month <- as.numeric(beaches_clean$Month)
beaches_clean$Day <- as.numeric(beaches_clean$Day)
beaches_clean$Ec_per100mL <- as.numeric(beaches_clean$Ec_per100mL)

#and then make the location a factor 
beaches_clean$Location <- as.factor(beaches_clean$Location)
beaches_clean$Rec_area <- as.factor(beaches_clean$Rec_area)

#View
str(beaches_clean)

#remove any potential extraneous spaces that might exist in the data
#for location and rec area
beaches_clean <- beaches_clean %>% 
     mutate(Location = str_trim(Location, side = "both")) %>% 
     mutate(Rec_area = str_trim(Rec_area, side = "both"))

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

#and now create a data subset that looks at just the most sampled lake to start
#which is last mountain lake 
#this requires us to convert to a dataframe: 
beaches_clean <- data.frame(beaches_clean)

beaches_lml <- beaches_clean %>% 
  subset(sample_count >= 70)
str(beaches_lml)

#for some reason, some of our values returned to character datatypes 
beaches_lml$Year <- as.numeric(beaches_lml$Year)
beaches_lml$Ec_per100mL <- as.numeric(beaches_lml$Ec_per100mL)
beaches_lml$Mc_ugL <- as.numeric(beaches_lml$Mc_ugL)

str(beaches_lml)

#Since this is still a lot of information, let's see what the sample number per 
#rec area looks like 
beaches_lml %>% 
  count(Rec_area) %>% 
  arrange(n)

#Let's select rec areas that have been sampled 5 or more times 
beaches_lml_subset <- beaches_lml %>%  
  group_by(Rec_area) %>% 
  mutate(Rec_visit_count = n()) %>% 
  subset(Rec_visit_count >= 6)
head(beaches_lml_subset)

#count to make sure that worked 
beaches_lml_subset %>% 
  count(Rec_area) %>% 
  arrange(n)

#That looks much more manageable for data visualization 

#Data visualization------------------------------------------------------------

#set ggplot theme
theme_set(theme_bw())

#Let's take a look at the E. coli levels over the four years of data we have
#for each rec area
ggplot(data = beaches_lml_subset, 
       mapping = aes(x = Month, y = Ec_per100mL)) +
  geom_point() + 
  facet_grid(Year ~ Rec_area) + 
  labs(y = "E. coli amount (CFU/100mL)")

#It looks like E. coli levels regularly increase in August at Regina Beach and 
#Rowan's Ravine Provincial Park beach 
#Let's look closer at them: 
beaches_lml_subset %>%  
  subset(Rec_visit_count >= 15) %>% 
  ggplot(mapping = aes(x = month_day, y = Ec_per100mL)) + 
  geom_point() + 
  facet_grid(Year ~ Rec_area) + 
  labs(x = "Sampling month and day", y = "E. coli amount (CFU/100mL)") + 
  theme(axis.text.x = element_text(angle = 45, vjust = 0.5))

#We will stop here for this project further work includes visualizing this type of data for other lakes 
#and microcystin data as well

#Export our clean data 
write.csv(beaches_clean, "C:\\Users\\laura\\Documents\\GitHub\\LDP-mini-proj-Healthy-Beaches\\02_clean_data\\Healthy_beaches_clean_data2019-23.csv")

#I used the built in RStudio gui to save figures into the appropriate folder