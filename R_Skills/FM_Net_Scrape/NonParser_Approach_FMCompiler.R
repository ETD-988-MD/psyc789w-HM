#=====================================
## "Non-Parser" Dataframe Compiler ##
#=====================================

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
#=========
# Set Up #
#=========

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
leader.data$last.name <- sapply(tolower(leader.data$last.name),simpleCap)

#===========================
# Machine Coding Procedure #
#===========================

#Data Sources
russians <- leader.data %>% filter(country == "Russia")
temp.data <- leader.data %>% filter(!country == "Russia")
  #Removing the Duds (Vacant office positions)
  temp.data <- temp.data[-(temp.data$last.name %in% ""),]

#Containers
output.data <- NULL
comb.data <- NULL
issue.list <- NULL

for(k in 1:length(corpus)){
  #Iterative Containers
  comb.data <- NULL
  sideA.data <- NULL
  sideB.data <- NULL
  side.A.output <- NULL
  side.B.output <- NULL 
  
  #Drawing Text
  text.raw <- paste(corpus[[k]]$meta[3],corpus[[k]]$content,corpus[[k]]$meta[4],sep=" ")
  text.raw <- gsub("(['])|[[:punct:]]"," ",text.raw) %>%
    removePunctuation(.,preserve_intra_word_dashes = T) %>% str_trim() 
  text <- str_split(text.raw,pattern =" ")
  text <- unique(text)
  text <- text[[1]][!text[[1]] %in% ""]
  
  loc <- temp.data$country %>% unique %>% as.character 
  loc2 <- loc[loc %in% text]
  
  #Correcting for Nuanced Naming Conventions in the data
  if("French" %in% text){loc2 <- c(loc2,"France")}
  if("Italian" %in% text){loc2 <- c(loc2,"Italy")}
  if("Indian" %in% text){loc2 <- c(loc2,"India")}
  if("Syrian" %in% text){loc2 <- c(loc2,"Syria")}
  if("Greek" %in% text){loc2 <- c(loc2,"Greece")}
  
  #If there are no locations
  if(length(loc2)==0){
    print(k)
    placeholder <- data.frame(content=corpus[[k]]$meta[3],location=corpus[[k]]$meta[[5]],Issue.Status="No Specified Country Location")
    issue.list <- rbind(issue.list,placeholder)
    next()
  }
  
  side.A.output <- russians[russians$last.name %in% text,]
  side.B.output <- NULL
  for(q in 1:length(loc2)){
    loc.sub <- temp.data %>% dplyr::filter(country==loc2[q]) 
    B <- loc.sub[loc.sub$last.name %in% text,]
    side.B.output <- rbind(side.B.output,B)
    B <- NULL
  }
  
  # When any side comes up empty comes up empty - we need to know it
  if(nrow(side.B.output)==0 & nrow(side.A.output)==0){
    print(k)
    placeholder <- data.frame(content=corpus[[k]]$meta[3],location=corpus[[k]]$meta[[5]],Issue.Status="No Side A or B")
    issue.list <- rbind(issue.list,placeholder)
    next()
  }
  if(nrow(side.B.output)==0){
    print(k)
    placeholder <- data.frame(content=corpus[[k]]$meta[3],location=corpus[[k]]$meta[[5]],Issue.Status="No Side B")
    issue.list <- rbind(issue.list,placeholder)
    next()
  }
  if(nrow(side.A.output)==0){
    side.A.output <- russians[russians$last.name %in% "Putin",]  
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
  if(str_detect(text.raw,"telephone conversation")){
    comb.data$type.of.meeting <- "Telephone"
  } else{
    if(str_detect(text.raw,"meeting")){
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
}









