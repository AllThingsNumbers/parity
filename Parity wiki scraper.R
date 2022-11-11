#activate packages needed to scrape data
library(tidyverse)
library(rvest)


# define seasons to be scraped (spring-autumn and autumn-spring separately)

seasons_spraut <- c(2001:2021)
seasons_autspr <- c("2000-01","2001-02","2002-03","2003-04","2004-05","2005-06","2006-07","2007-08","2008-09","2009-10","2010-11","2011-12","2012-13","2013-14","2014-15","2015-16","2016-17","2017-18","2018-19","2019-20","2020-21")

# define list of countries to be analysed
# we also add a "helper" vector, to tell us which country to scrape next
countries <- list("Albania","Andorra","Armenia","Austria","Azerbaijan","Belarus","Belgium","Bosnia and Herzegovina","Bulgaria","Croatia","Cyprus","Czech Republic","Denmark","England","Estonia","Faroe Islands","Finland","France","Georgia","Germany","Greece","Hungary","Iceland","Israel","Italy","Kazakhstan","Latvia","Lithuania","Luxembourg","Macedonia","Malta","Moldova","Netherlands","Northern Ireland","Norway","Poland","Portugal","Ireland","Romania","Russia","San Marino","Scotland","Serbia","Montenegro","Slovakia","Slovenia","Spain","Sweden","Switzerland","Turkey","Ukraine","Wales","Kosovo")
countries_remaining <- countries



# declare the URL of the website to be scraped - this will be used to "initiate" our .csv file
url = "https://en.wikipedia.org/wiki/2004_Belarusian_Premier_League"



# function used to turn URL into an "analysable" HTML object: read_html(url)

# general form of listing all tables on the website: html_nodes(css="table", read_html(url))


# I identified the table that I am looking for on the Wiki page thanks to its "unique" formatting.
# Now I am putting it in a data frame:
league_table <- data.frame(html_table(html_elements(read_html(url), xpath="//table[@class='wikitable' and @style='text-align:center;']")))







### Code to extract league details on country level ###




## ONLY RUN THIS FOR THE FIRST COUNTRY ON THE LIST (otherwise all your data will be erased)

# to begin, we create and initiate a blank .csv file for our input
final_tables_csv <- "~\\All final tables.csv"
write.csv(t(colnames(league_table)),final_tables_csv, row.names = FALSE)


# we specify the xpath expression used to select the final league table in the Wikipedia article
# luckily, the formatting of this table seems to be consistent in all articles, allowing us to use it
# some leagues have more tables of this type (general season, championship round, relegation round) - for these, we only use the general season table, hence the [1] indexation at the end


xpath_expr <- "(//table[@class='wikitable' and @style='text-align:center;'])[1]"

## FOR 2ND AND EVERY NEXT COUNTRY, run the code starting from here

# declare the country and league name manually
# sadly, no smarter way to do this, unless you manually create a table mapping country name to league name 

# below elements need to be supplied manually for each country to be scraped:

country_name <- as.character(countries_remaining[1])
league_name <- "_Liga_I"
first_season <- "2000-01"
                          # this variable defines the first "season ID", for which data can be found on Wiki for the league names 
                          # (important because for some countries, leagues have changed name and/or structure)
if(nchar(first_season) > 4){
is_league_autspr <- T  # this defines whether a league (or specific seasons of the league) are played in autumn-spring schedule
                          # it is set automatically, based on the length of the season ID (4 characters for SPR-AUT, 7 for AUT-SPR)
} else {
  is_league_autspr <- F
}

# run below loop for leagues playing in AUTUMN-SPRING schedule

if(is_league_autspr == TRUE){
  

for(i in which(seasons_autspr == first_season)[1]:length(seasons_autspr)){
  current_season <- seasons_autspr[i]
  current_season_url <- paste("https://en.wikipedia.org/wiki/", current_season, league_name, sep="")
  final_league_table <- data.frame(html_table(html_elements(read_html(current_season_url), xpath = xpath_expr)))
  final_league_table <- cbind(rep(current_season, nrow(final_league_table)), final_league_table)
  final_league_table <- cbind(rep(country_name, nrow(final_league_table)), final_league_table)
  colnames(final_league_table)[1]="Country"
  colnames(final_league_table)[2]="Season"
  write.table(final_league_table, file = final_tables_csv, append = TRUE, col.names = FALSE, sep = ",")
}
  
  # your little helper to tell you which country to run next
  
  countries_remaining[1] <- NULL
  print(paste("Next country to scrape will be:", countries_remaining[1]))
  
} else
{
# run below loop for leagues playing in SPRING-AUTUMN schedule

 
  

for(i in which(seasons_spraut == first_season)[1]:length(seasons_spraut)){
  current_season <- seasons_spraut[i]
  current_season_url <- paste("https://en.wikipedia.org/wiki/", current_season, league_name, sep="")
  final_league_table <- data.frame(html_table(html_elements(read_html(current_season_url), xpath = xpath_expr)))
  final_league_table <- cbind(rep(current_season, nrow(final_league_table)), final_league_table)
  final_league_table <- cbind(rep(country_name, nrow(final_league_table)), final_league_table)
  colnames(final_league_table)[1]="Country"
  colnames(final_league_table)[2]="Season"
  write.table(final_league_table, file = final_tables_csv, append = TRUE, col.names = FALSE, sep = ",")
}
  
  # your little helper to tell you which country to run next
  
  countries_remaining[1] <- NULL
  print(paste("Next country to scrape will be:", countries_remaining[1]))
  
 
}

### END OF Code to extract league details on country level ###



