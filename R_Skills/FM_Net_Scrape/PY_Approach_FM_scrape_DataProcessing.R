######################################
####### Scrape Data Processing #######
    ####### Python Approach #######
######################################
require(tm)
require(lubridate)
require(dplyr)
require(stringr)

#Loading RU_Pres corpus
load("RU_Pres_corpus_02.17.15_total.no:2600.Rdata")

#----------------------------------
## Processing World Leader Data ##
#----------------------------------

leader.data <- read.csv('Data/CIA_World_Leaders_Data_01.28.15.csv')
#Need to manually add the US President at the moment 
leader.data$X <- NULL
leader.data <- rbind(leader.data,data.frame(country="United States of America",
                                            country.code="US",office="Pres.",
                                            office.holder="Barack Obama",
                                            date.last.updated="NA",
                                            date.retrieved="NA"))
#Python Name Parser
nameparser <- function(x){
  if(is.character(x)){
    require(rPython)
    suppressWarnings(python.load("R_Skills/NLP/py_approach/Applications/name_parser.py"))
    output = python.call("name_parser",x)
    return(output)
  } else{
    warning("This is not a character. Fix that!")
  }
}

for(i in 1:nrow(leader.data)){
  leader.data$first.last.name[i] <- paste(nameparser(as.character(leader.data$office.holder[i]))[1],
                                   nameparser(as.character(leader.data$office.holder[i]))[3])
  leader.data$last.name[i] <- nameparser(as.character(leader.data$office.holder[i]))[3]
}

#---------------------------------
## Processing Scrape
#---------------------------------

descr <- corpus[[4]]$meta[[3]] %>% as.character

#### Specifying Python Wrappers ####

# Py Proper Noun Extractor
    pn_extractor <- function(x){
      if(is.character(x)){
        require(rPython)
        python.load("R_Skills/NLP/py_approach/Applications/pn_extractor2.py")
        output = python.call("pn_extractor2",x)
        return(output)
      } else {
        warning("This is not a character. Fix that!")
      }
    }

# Py Verb And Noun Extractor
    vb_extractor <- function(x){
      if(is.character(x)){
        require(rPython)
        python.load("R_Skills/NLP/py_approach/Applications/pn_extractor2.py")
        output = python.call("vb_extractor",x)
        return(output)
      } else {
        warning("This is not a character. Fix that!")
      }
    }

# Stanford Algorithm NL processors
person_parser <- function(text){
  if(is.character(text)){
    require(rPython)
    python.load("R_Skills/NLP/py_approach/Applications/stanford_nlp_extractors.py")
    output = python.call("stanford_person_extractor",text)
    return(output) #Using a matching correlation, it extracts a correlated term.
  } else {
    warning("This is not a character. Fix that!")
  }
}

# Py Fuzzy Character Matching
fuzzy <- function(text1,text2){
  if(is.character(text1) & is.character(text2)){
    require(rPython)
    python.load("R_Skills/NLP/py_approach/Applications/Fuzzy_Character_Matching.py")
    output = python.call("fuzzy",text1,text2)
    return(output) #Provides a matching correlation measure
  } else {
    warning("This is not a character. Fix that!")
  }
}

# Pattern Extraction from character string -- This isn't really useful
# pat_extract <- function(text,choices){
#   if(is.character(text) & is.character(choices)){
#     require(rPython)
#     python.load("R_Skills/NLP/py_approach/Applications/Fuzzy_Character_Matching.py")
#     output = python.call("pat_extract",text,choices)
#     return(output) #Using a matching correlation, it extracts a correlated term.
#   } else {
#     warning("This is not a character. Fix that!")
#   }
# }

#removing the the other Hollande, not of France but of Andorra...
#I will figure out a better solution to this later.
leader.data[leader.data$country=="Andorra",][1,] 
leader.data <- leader.data[-100,]

#--------------------------------------
############ PROCESSOR ################
### Identifying the relavant actors ###
#--------------------------------------

length(corpus)
# For testing
k = 2
h = 1
j= 1

output.data <- NULL
for(k in 1:3){
#   if(is.na(corpus[[k]]$meta[[3]])){
#     text1 <- corpus[[k]]$content %>% as.character #Content material
#   } else{
#     text2 <- corpus[[k]]$meta[[3]] %>% as.character #Description
#   }
  text <- paste(corpus[[k]]$meta[3],corpus[[k]]$content,"") %>% 
    removePunctuation(.,preserve_intra_word_dashes = T) %>% str_trim()#Smash all information points together
  s <- try(person_parser(text),silent=T) %>% unique #Name Extractor
        #Cleaning residual issues
        for(f in 1:length(s)){
          if(str_detect(s[f],"Director")){s[f] <- gsub("Director","",s[f]) %>% str_trim()}
        }
  loc <- try(loc_parser(text),silent=T) %>% unique # Locations mentioned
  org <- try(org_parser(text),silent=T) %>% unique # organizations mentioned
  vn <- try(vb_extractor(text),silent=T) %>% unique # Verbs and Nouns
  identified.leaders.sideA <- NULL
  temp.data <- leader.data %>% filter(country == "Russia")
  for(h in 1:length(s)){
    for(j in 1:nrow(temp.data)){
      if(try(fuzzy(tolower(nameparser(s[h])[3]),as.character(tolower(temp.data$last.name[j]))),silent=T)==100){
        tagged.leaders <- filter(temp.data,temp.data$office.holder==temp.data$office.holder[j])
      } else{next}
      identified.leaders.sideA <- rbind(identified.leaders.sideA,tagged.leaders) %>% unique
    }
  }
  identified.leaders.sideB <- NULL
  temp.data <- leader.data %>% filter(!country == "Russia")
  for(h in 1:length(s)){
    for(j in 1:nrow(temp.data)){
      if(try(fuzzy(tolower(nameparser(s[h])[3]),as.character(tolower(temp.data$last.name[j]))),silent=T)==100){
        tagged.leaders <- filter(temp.data,temp.data$office.holder==as.character(temp.data$office.holder[j]))
      } else{next}
      identified.leaders.sideB <- rbind(identified.leaders.sideB,tagged.leaders)
    }
  }
  
  #couple sideA with relevant data
  sideA.actor <- NULL
  sideA.country <- NULL
  sideA.actor.title <- NULL
  if(length(identified.leaders.sideA)>=1){
    for(i in 1:nrow(identified.leaders.sideA)){
      sideA.actor[i] <- as.character(identified.leaders.sideA$office.holder[i])
      sideA.country[i] <- as.character(identified.leaders.sideA$country[i])
      sideA.actor.title[i] <- as.character(identified.leaders.sideA$office[i])
    }} else{
      sideA.actor <- NA
      sideA.country <- NA
      sideA.actor.title <- NA
    }
  
  #couple sideB with relevant data
  sideB.actor <- NULL
  sideB.country <- NULL
  sideB.actor.title <- NULL
  if(length(identified.leaders.sideB)>=1){
    for(i in 1:nrow(identified.leaders.sideB)){
      sideB.actor[i] <- as.character(identified.leaders.sideB$office.holder[i])
      sideB.country[i] <- as.character(identified.leaders.sideB$country[i])
      sideB.actor.title[i] <- as.character(identified.leaders.sideB$office[i])
    } } else{
      sideB.actor <- NA
      sideB.country <- NA
      sideB.actor.title <- NA
    }
  
  #Data frame for this iteration
  sideB.data <- data.frame(sideB.actor.title,sideB.actor,sideB.country)
  sideA.data <- data.frame(sideA.actor.title=rep(sideA.actor.title,nrow(sideB.data)),sideA.actor=rep(sideA.actor,nrow(sideB.data)),sideA.country=rep(sideA.country,nrow(sideB.data)))
  temp.data <- cbind(sideA.data,sideB.data)
  temp.data$meeting.type <- ifelse(nrow(sideB.data)>=2,"Multilateral","Bilateral")
  temp.data$type.of.meeting <- ifelse(str_detect(corpus[[k]]$meta[[4]] %>% tolower,"telephone"),"Telephone",ifelse(str_detect(corpus[[k]]$meta[[4]] %>% tolower,"meeting"),"Meeting",NA))
  temp.data$date <- corpus[[k]]$meta[[8]] %>% as.Date %>% format(.,"%m-%d-%Y")
  temp.data$origin <- corpus[[k]]$meta[[7]]
  temp.data$origin.source <- corpus[[k]]$meta[[1]]
  temp.data$corpus.location <- corpus[[k]]$meta[[5]]
  temp.data$heading <- corpus[[k]]$meta[[4]]
  output.data <- rbind(output.data,temp.data)
  temp.data <- NULL
}

