**Date created:** 2023-9-24
**Created by:** Laura Schnell
**Date updated:** 2023-9-25
**Updated by:** Laura Schnell

**Description of the data:**

Data collected from the Healthy Beaches program results archive hosted by the Saskatchewan government was quality checked and cleaned by Laura Schnell (full details found in 01_R_scripts/LDP-HB-data-wrangling.R). 

*Data cleaning:* 

* raw data was brought into the R project
* extraneous spaces were removed from before and after input values
* the date column was changed from a character datatype to a DATE format using lubridate package
* and name of the 'date' column was changed to 'visit_date' to make it more specific
* a separate column was added for Year, Month, and Day data as well as month-day
* a column to track sample counts (how many times a lake had been sampled over the four years of the project from any recreational site) was included to determine the most-sampled lake. 

*Data subsetting:* to make it easier to visualize differences in E. coli measurements over summer, data was subset in the script to look at only the most sampled lakes. It was then further subset to visualize the two most-sampled recreational areas at that lake. These was not exported into the clean_data folder. 

**Variable descriptions:**

   * *Rec_area:* Recreational area lists the beach or public water access point sampled.

   * *Location:* The lake sampled is listed in the location column.

   * *Visit_date:* Sampling/visit date is given in year, month, day format.
     
   * *Year:* The year sampling was performed
     
   * *Month:* The month sampling was performed
     
   * *Day:* The day of the month that sampling occured
     
   * *Ec_per100mL:* E. coli levels were recorded in colony forming units (CFU) per 100 mL of water. Water was cultured by the Roy Romanow Provincial Lab. E. coli is abbreviated to ec.

  *  *Mc_ugL:* Microcystin levels are recorded in micrograms per litre and measured by enzyme-linked immunosorbent assays (ELISAs) performed by the Roy Romanow Provincial Lab. Microcystin is abbreviated to Mc.
    
  *  *month-day:* The month and day that sampling occured. Made to make data visualization easier
    
  *  *sample_count:* The number of times a lake was sampled over the four years of data collected. 

