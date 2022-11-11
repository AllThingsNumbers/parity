library(dplyr) # activate dplyr to more easily filter data
library(modelr)
library(tibble)


sort(filter(fin_pos_data, Pos==1, Country == "Poland")$Team, decreasing = T)[1]

# first, let's establish most common champions for each country, as well as their championship percentage

top_champions <- add_column(top_champions, "FirstSeasonMeasured" = rep("",nrow(top_champions)), .after = "Country")

#filter(fin_pos_data, Pos==1, Country == "Croatia")$Team
#mode(filter(fin_pos_data, Pos==1, Country == "Albania")$Team)

#typical(filter(fin_pos_data, Pos==1, Country == "Poland")$Team)

#top_champions <- data.frame(cbind(countries, rep("", 52), rep("", 52), rep("", 52)))
#colnames(top_champions) <- c("Country", "NoOfDiffChamps", "MostFreqChamp", "%ofChampionshipsWon")


#n_distinct(filter(fin_pos_data, Pos==1, Country == "Poland")$Team)

for(i in 1:length(countries)){
  top_champions[i,"NoOfDiffChamps"] <- n_distinct(filter(fin_pos_data, Pos==1, Country == countries[i])$Team)
  top_champions[i,"FirstSeasonMeasured"] <- (filter(fin_pos_data, Country == countries[i])$Season)[1]
  if(length(typical(filter(fin_pos_data, Pos==1, Country == countries[i])$Team)) > 1){
    top_champions[i,"MostFreqChamp"] <- paste(length(typical(filter(fin_pos_data, Pos==1, Country == countries[i])$Team)),
                                                     "most frequent champions:",
                                                     toString(typical(filter(fin_pos_data, Pos==1, Country == countries[i])$Team)))
    
  }
  else {
    top_champions[i,"MostFreqChamp"] <- typical(filter(fin_pos_data, Pos==1, Country == countries[i])$Team)
  }
  top_champions[i, "%ofChampionshipsWon"] <- 0
  NoOfChampsWon <- 0 # technical value to memorise how many championship the currently analyzed champion has won
  for(j in length(typical(filter(fin_pos_data, Pos==1, Country == countries[i])$Team))){
    NoOfChampsWon <- NoOfChampsWon + 
      length(which(filter(fin_pos_data, Pos==1, Country == countries[i])$Team == typical(filter(fin_pos_data, Pos==1, Country == countries[i])$Team)[j]))
  }
  top_champions[i, "%ofChampionshipsWon"] <- NoOfChampsWon / length(filter(fin_pos_data, Pos==1, Country == countries[i]))
}

filter(fin_pos_data, Pos==1, Country == "Poland")$Team


