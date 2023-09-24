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

#check working directory 
getwd()

#import file
healthy_beaches <- read.csv(
  "C:\\Users\\laura\\Documents\\GitHub\\LDP-mini-proj-luq-streamchem\\LDP-mini-proj-Healthy-Beaches\\Healthy_beaches_19-23.csv")

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
#View
str(beaches_clean)

## (5.4) use a cluster diagram to visualize typos

dist.matrix <- stringdistmatrix(penguins$speciesL, penguins$speciesL, 
                                method = 'jw', p = 0.1)
row.names(dist.matrix) <- penguins$speciesL
names(dist.matrix) <- penguins$speciesL
dist.matrix <- as.dist(dist.matrix)
clusters <- hclust(dist.matrix, method = "ward.D2")
plot(clusters)


## (5.5) Use stringr::str_trim() to remove extra white spaces 

## we don't have an example of this sort of error in the dataset, but
## let's pretend one speciesL cell contains " antarcticus " (with white 
## spaces both before and after the word)

## you could use the following to strip/trim the white space out:
# penguins <- penguins %>% 
#   mutate(speciesL = str_trim(speciesL, side = "both"))



#Data visualization------------------------------------------------------------