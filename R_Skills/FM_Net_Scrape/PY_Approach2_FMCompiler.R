require(tm)
require(lubridate)
require(dplyr)
require(stringr)

#Loading RU_Pres corpus
load("RU_Pres_corpus_02.17.15_total.no:2600.Rdata")

# Leader Data
leader.data <- read.csv('Data/CIA_World_Leaders_Data_01.28.15.csv')
#Need to manually add the US President at the moment 
leader.data$X <- NULL
leader.data <- rbind(leader.data,data.frame(country="United States of America",
                                            country.code="US",office="Pres.",
                                            office.holder="Barack Obama",
                                            date.last.updated="NA",
                                            date.retrieved="NA"))
#Python Parsers
source("R_Skills/FM_Net_Scrape/py_parsers.R")

#Leaders Dictionary Data
for(i in 1:nrow(leader.data)){
  leader.data$first.last.name[i] <- paste(nameparser(as.character(leader.data$office.holder[i]))[1],
                                          nameparser(as.character(leader.data$office.holder[i]))[3])
  leader.data$last.name[i] <- nameparser(as.character(leader.data$office.holder[i]))[3]
}

#Simplifying the capitalization structure
simpleCap <- function(x) {
  s <- strsplit(x, " ")[[1]]
  paste(toupper(substring(s, 1,1)), substring(s, 2),
        sep="", collapse=" ")
}
leader.data$first.last.name <- sapply(tolower(leader.data$first.last.name),simpleCap)

#RM the Andorra Francose Hollande 
leader.data[leader.data$country=="Andorra",][1,] 
leader.data <- leader.data[-100,]

#==============
# Compiling
#==============

#Russian Actor Dictionary
russians <- leader.data %>% filter(country == "Russia")
temp.data <- leader.data %>% filter(!country == "Russia")
output.data <- NULL
    for(k in 1:100){
#       text <- paste0(corpus[[k]]$meta[3],corpus[[k]]$content,corpus[[k]]$meta[4]) 
#       text <- str_split(text,pattern ="[,.]")        
#       text <- paste(text[[1]][sample(length(text[[1]]))],sep=" filler ",collapse=" filler ")  %>% 
#         removePunctuation(.,preserve_intra_word_dashes = T) %>% str_trim() 
#       loc <- try(loc_parser(text),silent=T) %>% unique # Locations mentioned
#       for(i in 1:length(loc)){
#         text <- gsub(loc[i], "", text)  
#       }
#       names <- try(person_parser(text),silent=T)
      
      repeat{
        text <- paste(corpus[[k]]$meta[3],corpus[[k]]$content,corpus[[k]]$meta[4],sep="   ")
        text <- str_split(text,pattern ="[,.]")    
        text <- paste(text[[1]][sample(length(text[[1]]))],sep="   ",collapse="   ")  %>% 
          removePunctuation(.,preserve_intra_word_dashes = T) %>% str_trim() 
        names <- try(person_parser(text),silent=T) %>% unique
        if(!names[1]=="Error in python.exec(python.command) : list index out of range\n"){break}
      }
      
      #Cleaning residual issues
      for(f in 1:length(names)){
        if(str_detect(names[f],"Director")){names[f] <- gsub("Director","",names[f]) %>% str_trim()}
        if(str_detect(names[f],"Mr")){names[f] <- gsub("Mr","",names[f]) %>% str_trim()}
      }
      last.names <- sapply(names,last.name.parser <- function(x){temp <- tolower(nameparser(x)[3])}) %>% unique
      if(length(which(last.names==""))>=1){last.names[-which(last.names=="")]}
      
      #Need both the first.last and last name captures due to inconsistencies in spelling of first names
      side.A.output <- russians[russians$first.last.name %in% names,]
      side.B.output <- temp.data[temp.data$first.last.name %in% names,] %>% unique 
      if(nrow(side.B.output)==0 | nrow(side.A.output)==0){
        print(paste(k));next
      }
      sideA.data <- data.frame(sideA.actor.title=rep(as.character(side.A.output$office),nrow(side.B.output)),
                               sideA.actor=rep(as.character(side.A.output$office.holder),nrow(side.B.output)),
                               sideA.country=rep(as.character(side.A.output$country),nrow(side.B.output)))
      sideB.data <- data.frame(sideB.actor.title=as.character(side.B.output$office),
                               sideB.actor=as.character(side.B.output$office.holder),
                               sideB.country=as.character(side.B.output$country))
      comb.data <- cbind(sideA.data,sideB.data)
      
      #============
      ## Added Vars
      #============
      #Mullateral v. bilateral
      no.B.states <- as.character(comb.data$sideB.country) %>% unique()
      comb.data$meeting.type <- ifelse(length(no.B.states)>=2,"Multilateral","Bilateral")
      #Meeting type
      if(str_detect(text,"telephone conversation")){
        comb.data$type.of.meeting <- "Telephone"
      } else{
        if(str_detect(text,"meeting")){
          comb.data$type.of.meeting <- "In-Person Meeting"
        } else{comb.data$type.of.meeting <- NA}
      } 
      #Date
      comb.data$date <- corpus[[k]]$meta[[8]] %>% as.Date %>% format(.,"%m-%d-%Y")
      #Origin
      comb.data$origin <- corpus[[k]]$meta[[7]]
      #Source
      comb.data$origin.source <- corpus[[k]]$meta[[1]]
      #Corpus Location
      comb.data$corpus.location <- corpus[[k]]$meta[[5]]
      #Reference Description
      comb.data$heading <- corpus[[k]]$meta[[3]]
    
      #Data
      output.data <- rbind(output.data,comb.data)
      comb.data <- NULL
      sideA.data <- NULL
      sideB.data <- NULL
      side.A.output <- NULL
      side.B.output <- NULL
    }



