
side.A.actor <- NULL
side.B.actor <- NULL
side.A.output <- NULL

for(h in 1:length(names)){
  for(j in 1:nrow(russians)){
    if(str_detect(as.character(tolower(russians$last.name[j])),tolower(nameparser(names[h])[3]))){
      side.A.actor <- russians[j,] 
      side.A.output <- rbind(side.A.output,side.A.actor)
    }
  }  
  if(!is.null(side.A.actor)){
    print(h)
  }
  side.A.actor <- NULL
} 
test <- names[-h]

side.B.output <- NULL
side.B.temp <- NULL
for(p in 1:length(names)){
  side.B.temp <- temp.data[tolower(temp.data$last.name) %in% tolower(nameparser(names[p])[3]),] 
  side.B.output <- rbind(side.B.output,side.B.temp)
}



 
####========================

for(h in 1:length(last.names)){
  for(j in 1:nrow(russians)){
    if(str_detect(as.character(tolower(russians$last.name[j])),last.names[h])){
      side.A.actor <- russians[j,]
      side.A.output <- rbind(side.A.output,side.A.actor)
      leftovers <- last.names[-h]
      side.B.actor <- cbind(side.B.actor,leftovers)
      side.B.actor <- unique(side.B.actor)
    }
  }  
} 







side.A.actor <- NULL
side.B.actor <- NULL
side.A.output <- NULL
for(h in 1:length(last.names)){
  for(j in 1:nrow(russians)){
    if(str_detect(as.character(tolower(russians$last.name[j])),last.names[h])){
      side.A.actor <- russians[j,]
      side.A.output <- rbind(side.A.output,side.A.actor)
      leftovers <- last.names[-h]
      side.B.actor <- cbind(side.B.actor,leftovers)
      side.B.actor <- unique(side.B.actor)
    }
  }  
} 

\n xxxxx xxxxx xxxxx \n


test <- floor(runif(10,1,2600))
for(q in 1:length(test)){
  #k <- test[q]
  #print(k)
  repeat{
    text <- paste(corpus[[k]]$meta[3],corpus[[k]]$content,corpus[[k]]$meta[4],sep="   ")
    text <- str_split(text,pattern ="[,.]")    
    text <- paste(text[[1]][sample(length(text[[1]]))],sep="   ",collapse="   ")  %>% 
      removePunctuation(.,preserve_intra_word_dashes = T) %>% str_trim() 
    names <- try(person_parser(text),silent=T) %>% unique
    if(!names[1]=="Error in python.exec(python.command) : list index out of range\n"){break}
  }
  print(q)
  print(names)
}

k = 400

## ==== no parser approach
yy <- paste(corpus[[k]]$meta[3],corpus[[k]]$content,corpus[[k]]$meta[4],sep=" ") %>%removePunctuation(.,preserve_intra_word_dashes = T) %>% str_trim() 
yy <- str_split(yy,pattern =" ")
yy <- unique(yy)

russians$last.name <- sapply(tolower(russians$last.name),simpleCap)
temp.data$last.name <- sapply(tolower(temp.data$last.name),simpleCap)

goods <-NULL;goods2 <-NULL
temp <- NULL;temp2 <- NULL
for(g in 1:length(yy[[1]])){
  temp <- russians[russians$first.last.name %in% paste(yy[[1]][g],yy[[1]][g+1],sep=" "),]
  goods <- rbind(goods,temp)
}
for(g in 1:length(yy[[1]])){
  temp2 <- temp.data[temp.data$first.last.name %in% paste(yy[[1]][g],yy[[1]][g+1],sep=" "),]
  temp3 <- temp.data[temp.data$last.name %in% yy[[1]][g],]
  goods2 <- rbind(goods2,temp2,temp3)
}
unique(goods)
unique(goods2)

russians[yy %in% russians$last.name,]


###=====subset by location?

#Setting the caps
russians$last.name <- sapply(tolower(russians$last.name),simpleCap)
temp.data$last.name <- sapply(tolower(temp.data$last.name),simpleCap)

      text <- paste(corpus[[k]]$meta[3],corpus[[k]]$content,corpus[[k]]$meta[4],sep="   ")
      text <- str_split(text,pattern ="[,.]")    
      text <- paste(text[[1]][sample(length(text[[1]]))],sep="   ",collapse="   ")  %>% 
        removePunctuation(.,preserve_intra_word_dashes = T) %>% str_trim() 
      loc <- try(loc_parser(text),silent=T) %>% unique # Locations mentioned

yy <- paste(corpus[[k]]$meta[3],corpus[[k]]$content,corpus[[k]]$meta[4],sep=" ") %>%removePunctuation(.,preserve_intra_word_dashes = T) %>% str_trim() 
yy <- str_split(yy,pattern =" ")
yy <- unique(yy)

      all.As <-russians[russians$last.name %in% yy[[1]],]
      all.Bs <- NULL
      for(q in 1:length(loc)){
        loc.sub <- temp.data %>% dplyr::filter(country==loc[q]) 
        B <- loc.sub[loc.sub$last.name %in% yy[[1]],]
        all.Bs <- rbind(all.Bs,B)
      } # Nope....

#How about....

k = 600 #Putin Christmas card???
k=300 #Signing an agreement...but not "meeting" with any one
k = 2 
k = 10
k=707
yy <- paste(corpus[[k]]$meta[3],corpus[[k]]$content,corpus[[k]]$meta[4],sep=" ") %>%
  removePunctuation(.,preserve_intra_word_dashes = T) %>% str_trim() 
yy <- str_split(yy,pattern =" ")
yy <- unique(yy)

loc2 <- temp.data$country %>% unique %>% as.character 
loc3 <- loc2[loc2 %in% yy[[1]]]
if("French" %in% yy[[1]]){loc3 <- c(loc3,"France")}

all.As <-russians[russians$last.name %in% yy[[1]],]
all.Bs <- NULL
for(q in 1:length(loc3)){
  loc.sub <- temp.data %>% dplyr::filter(country==loc3[q]) 
  B <- loc.sub[loc.sub$last.name %in% yy[[1]],]
  all.Bs <- rbind(all.Bs,B)
}

#Redundant names???
first.names <- sapply(all.Bs$first.last.name,function(x){g = nameparser(x);g[1]})

loc.sub[first.names %in% yy[[1]],] #nope


#===============================================
##### ----- compressed-pathways compiler
#Data Sources
russians <- leader.data %>% filter(country == "Russia")
    missedA <- c("Valentina Matviyenko","Sergei Ivanov","Sergei Shoigu","Sergei Naryshkin","Rashid Nurgaliyev")
    missedAlast <- c("Matviyenko","Ivanov","Shoigu","Naryshkin","Nurgaliyev")
    russians <- rbind(russians,data.frame(country="Russia",country.code="RS",office=NA,office.holder=missedA,
                         date.last.updated=NA,date.retrieved=NA,first.last.name=missedA,last.name=missedAlast))
temp.data <- leader.data %>% filter(!country == "Russia")
temp.data <- rbind(temp.data,data.frame(country="United States of America",country.code="US",office="Pres.",
                                            office.holder="Barack Obama",date.last.updated="NA",date.retrieved="NA",first.last.name="Barack Obama",last.name="Obama"))
#Removing the Duds (Vacant office positions)
temp.data <- temp.data[-(temp.data$last.name %in% ""),]

length(corpus)

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
  if("Hungarian" %in% text){loc2 <- c(loc2,"Hungary")}
  if("Greek" %in% text){loc2 <- c(loc2,"Greece")}
  
  #If there are no locations
  if(length(loc2)==0){
    print(paste0(k," - Issue: No Specified Country Location"))
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
    print(paste0(k," - Issue: No Side A or B"))
    placeholder <- data.frame(content=corpus[[k]]$meta[3],location=corpus[[k]]$meta[[5]],Issue.Status="No Side A or B")
    issue.list <- rbind(issue.list,placeholder)
    next()
  }
  if(nrow(side.B.output)==0){
    hh <- paste(text,sep="   ",collapse=" ") %>% str_trim()
    hh <- paste0(hh,".")
    names <- try(person_parser(hh),silent=T) %>% unique
    if(length(names)>0){
      for(f in 1:length(names)){
        if(str_detect(names[f],"Director")){names[f] <- gsub("Director","",names[f]) %>% str_trim()}
        if(str_detect(names[f],"Mr")){names[f] <- gsub("Mr","",names[f]) %>% str_trim()}
        if(str_detect(names[f],"Speaker")){names[f] <- gsub("Speaker","",names[f]) %>% str_trim()}
      }}
    B2 <- names[!names %in% russians$first.last.name]
    B3 <- last.names <- sapply(names,last.name.parser <- function(x){temp <- nameparser(x)[3]}) %>% unique
    B3 <- names[!last.names %in% russians$last.name]
    if(length(B2)>0 & length(B3)>0){
      side.B.output <- data.frame(country=NA,country.code=NA,office=NA,office.holder=B3,
                                  date.last.updated=NA,data.retrieved=NA,first.last.name=B3,last.name=NA)
    }
    if(length(B2)==0 | length(B3)==0){
      print(paste0(k," - Issue: No Side B"))
      placeholder <- data.frame(content=corpus[[k]]$meta[3],location=corpus[[k]]$meta[[5]],Issue.Status="No Side B")
      issue.list <- rbind(issue.list,placeholder)
      next()
    }
  }
  if(nrow(side.A.output)==0){
    side.A.output <- russians[russians$last.name %in% "Putin",]  
  }
  
  print(paste0(k,"*"))
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

#=================================
# Cleaning the Data 
WD <- output.data

#given the coding procedure, I picked up a few things I don't want: 
    #1. Ol' Vlady as a side.b actor -- get rid of that
        WD <- WD[!WD$sideB.actor %in% "Vladimir Putin",]
        WD <- WD[!WD$sideB.actor %in% "VLADIMIR PUTIN",]

    #2. Parsing mistakes that broke up names, and then grabbed only pieces of names
        WD <- WD[str_detect(WD$sideB.actor," "),]

    #3. Filling in the titles for entries that went unmatched. 
        WD[is.na(WD$sideB.actor.title),] %>% View #Need to think about ways of resolving this...
        
    #4. Overcome systemic misses
        View(issue.list)

data.compiled <- WD
# save(data.compiled,issue.list,file="Data/FM_Scrape_Compiled_Data_4.26.2015.Rdata")
