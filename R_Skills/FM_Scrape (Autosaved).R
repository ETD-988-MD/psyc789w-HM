---
title: "Foreign Minister Scrape"
output: html_document
---
### Quick take aways

* `try(.,silent=T)` function allows you to process an error, return nothing, and then go on with the loop. But it will still give you back the error results if assigned to an object. 

-----

Preliminary scan on the site material that Michael is looking to extract from Foreign Ministry sites. 

## Resources 

* CIA's "Chiefs of State and Cabinet Members of Foreign Governments" -- list can be found [here]("https://www.cia.gov/library/publications/world-leaders-1/index.html"). 
    + Note: the html cycle works off a two letter country code. html is straightforward. 
* colfor.com for the FIBS country.codes (in order to make the HTML loop work) can be found [here](""http://www.cloford.com/resources/codes/index.htm"")


----

### Chief of State and Cabinet Scraper

First, to build the simple version just focusing on Afghanistan. 
```{r}
require(rvest)
require(dplyr)
require(stringr)
require(lubridate)
url <- "https://www.cia.gov/library/publications/world-leaders-1/"
request <- paste0(url,"AF",".html")
raw.data <- html(request)
title <- html_nodes(raw.data,".title span") %>% html_text
leaders <- html_nodes(raw.data,".cos_name span") %>% html_text
leader.data <- data.frame("Country"="AF","Office"=title,"office.holder"=leaders)
head(leader.data)
```

Now, to mechanize it, but first, we need to find the correct coding procedure that matches up to the site's url. 
```{r}
#website using FIPS codeing - need to extract this code structure
fibs.raw <- html("http://www.cloford.com/resources/codes/index.htm")
countries <- html_nodes(fibs.raw,".outlinetable td:nth-child(3)") %>% html_text
fibs <- html_nodes(fibs.raw,"p+ .outlinetable td:nth-child(5)") %>% html_text
fibs <- data.frame(country.name=countries[1:232],CCode=fibs)
head(fibs)
```

Now the application -- loop approach
```{r, eval=F}
temp.data <- data.frame(country=NA,country.code=NA,office=NA,office.holder=NA,date.last.updated=NA,date.retrieved=NA)
leader.data <- data.frame(country=NULL,country.code=NULL,office=NULL,office.holder=NULL,date.last.updated=NULL,date.retrieved=NULL)
url <- "https://www.cia.gov/library/publications/world-leaders-1/"
for(i in 1:nrow(fibs)){
  request <- paste0(url,fibs[i,2],".html")
  if(!inherits(try(html(request),silent=T), 'try-error')){
    raw.data <- html(request)
    title <- html_nodes(raw.data,".title span") %>% html_text
    leaders <- html_nodes(raw.data,".cos_name span") %>% html_text
    date <- html_node(raw.data,"#lastUpdateDate") %>% html_text %>% str_trim
    #Storage
    temp.data[1:length(title),"country"] <- fibs[i,1] %>% as.character
    temp.data[1:length(title),"country.code"] <- fibs[i,2] %>% as.character
    temp.data[1:length(title),"office"] <- title
    temp.data[1:length(title),"office.holder"] <- leaders
    temp.data[1:length(title),"date.last.updated"] <- format(dmy(date),"%m-%d-%Y")
    temp.data[1:length(title),"date.retrieved"] <- format(Sys.Date(),"%m-%d-%Y")
    leader.data <- rbind(leader.data,temp.data)
    temp.data <- data.frame(country=NA,office=NA,office.holder=NA,date.retrieved=NA)
    } else{next}
  }    
leader.data %>% nrow #5647 obs
leader.data %>% select(country) %>% unique %>% nrow #191 countries
head(leader.data)
tail(leader.data)
```

The loop retrieved a consistent and reliable list of Chiefs of State and their respective cabinets with appropriate date metadata and retrieval time stamps. Thus completing part 1 of the exercise.

```{r, eval=F}
#Saving time stamped version of the data 
write.csv(leader.data,paste0("Data/CIA_World_Leaders_Data_",format(Sys.Date(),"%m.%d.%y"),".csv"))
```

### Drawing from the Foreign Ministry sites.

Michael directed me to a Foreign Ministry site of analytical interest. 

* [Iran]("http://en.mfa.ir/index.aspx?fkeyid=&siteid=3&pageid=1997")
* Russia
    + [Russian President]("http://eng.kremlin.ru/by-keyword/82?page=1") -- Specifically the foreign policy part of the page.
    + [Russian Foreign Minister]("http://www.mid.ru/brp_4.nsf/main_eng")
    + [Twitter]("https://twitter.com/governmentrf")

Starting with Russia - first the president
```{r}
require(rvest)
require(stringr)
require(lubridate)
require(tm)
require(magrittr)
#regular expression to easily retrive dates from noisy strings
    regexp <- "([[:digit:]]+) ([[:alpha:]]+) ([[:digit:]]{4})"

#Russian Presidents Foreign Policy Pate
output.data <- NULL
for(j in 1:130){ #No. of site pages == 130
  url <- paste0("http://eng.kremlin.ru/by-keyword/82?page=",j)
  raw.data <- html(url)
  title.info <- html_nodes(raw.data,"h4 a") %>% html_text
  briefs <- html_nodes(raw.data,".hentry-related") %>% html_node("div") %>% html_text(.,trim=T)
        #The second node trims the list so that non-entries appear as NA
  date <- html_nodes(raw.data,".entry-meta") %>% html_text() %>% str_extract(.,regexp) %>% dmy() 
  story.link <- html_nodes(raw.data,"h4 a") %>% html_attr("href") %>% paste0("http://eng.kremlin.ru",.)
  temp <- data.frame(title.info,date,briefs,story.link)
  output.data <- rbind(output.data,temp)
}
#reformatting scraped data
output.data$title.info <- as.character(output.data$title.info)
output.data$briefs <- as.character(output.data$briefs)
output.data$story.link <- as.character(output.data$story.link)

#resolving minor issues with the recorded links
for(i in 1:nrow(output.data)){
  if(str_detect(output.data$story.link[i],"http://eng.state.kremlin.ru")){
    output.data$story.link[i] <- gsub("http://eng.kremlin.ruhttp://eng.state.kremlin.ru","http://eng.state.kremlin.ru",output.data$story.link[i])
  }
}

#Save Data as .CSV
write.csv(output.data,paste0("Data/Rus.Pres.Meeting.Data.v.",format(Sys.Date(),"%m.%d.%y"),".csv")) 

#Pulling the specific storys and transforming them to a corpus file time for easy storage
#of the actual content of the news brief.
story.data <- html(output.data$story.link[1])
story.body <- html_nodes(story.data,"#selectable-content > p") %>% html_text %>% str_trim
test <- as.String(story.body) %>% VectorSource(.) %>% VCorpus
#Assigning meta data
test[[1]]$meta$date.published <- output.data$date[1]
test[[1]]$meta$heading <- output.data$title.info[1]
test[[1]]$meta$description <- output.data$briefs[1]
test[[1]]$meta$origin <- output.data$story.link[1]
test[[1]]$meta$author <- "President of Russia - Official Site"
test[[1]]$meta$id <- paste0("ID_",1)

#Now processing into a loop
#Can only combine corpuses, need first iteration to be used as a base for the loop. 
corpus <- test
for(i in 261:nrow(output.data)){
  #For some reason, you can only retrieve ~64 articles at a time.
      #Method 1: we get a timeout
        #story.data <- html(output.data$story.link[i])
      #Method 2: we simulate the browser so that there is no timeout
      story.data <- html_session(output.data$story.link[i])
      story.body <- html_nodes(story.data,"#selectable-content > p") %>% html_text %>% str_trim
      test <- as.String(story.body) %>% VectorSource(.) %>% VCorpus
   test[[1]]$meta$date.published <- output.data$date[i]
   test[[1]]$meta$heading <- output.data$title.info[i]
   test[[1]]$meta$description <- output.data$briefs[i]
   test[[1]]$meta$origin <- output.data$story.link[i]
   test[[1]]$meta$author <- "President of Russia - Official Site"
   test[[1]]$meta$id <- paste0("ID_",i)
   corpus <- c(corpus,test) 
   test <- NULL
   }
#Examples
corpus[[170]]$meta
corpus[[2222]]$meta
#all the meta data and contet is retrievable
corpus[[2222]]$meta[4] 
corpus[[170]]$content

##Save Corpus Object
save(corpus,file=paste0("RU_Pres_corpus_",format(Sys.Date(),"%m.%d.%y"),"_total.no:",length(corpus),".Rdata"))
```


### Processing the data 
Here we need to synthesize the raw scape materials into a working (and statistically utilizable) dataframe. There are two ways to proceed w/r/t processing the raw corpus into the type of dyadic data frame that we need to run the network analysis: The NLP approach or the dictionary approach (which involves creating a dictionary of leader names and position in order extract the names and populated it with the leaders relative status).

#### Natural Language Processing Approach
```{r, eval=F}
#Here we NL processing programs 
require(rJava)
require(NLP)
require(openNLP)
require(openNLPmodels.en) #English dictionary
# Corpus object meta data
corpus[[170]]$meta

#Using languae processing to extract key information from corpus text
story <- as.String(corpus[[1]]$content) #body text
brief <- as.String(corpus[[1]]$meta[2]) # brief

#annotators
word_ann <- Maxent_Word_Token_Annotator()
sent_ann <- Maxent_Sent_Token_Annotator()
person_ann <- Maxent_Entity_Annotator(kind = "person")
location_ann <- Maxent_Entity_Annotator(kind = "location")
organization_ann <- Maxent_Entity_Annotator(kind = "organization")

#streamline the annotators
pipeline <- list(sent_ann,
                 word_ann,
                 person_ann,
                 location_ann,
                 organization_ann)

#Two "paths":
  #story content
      story_annotations <- annotate(story,pipeline)
      story_doc <- AnnotatedPlainTextDocument(story, story_annotations)
  #brief content
      brief_annotations <- annotate(brief,pipeline)
      brief_doc <- AnnotatedPlainTextDocument(brief, story_annotations)

# Extract entities from Annotation
# Use this borrowed function
entities <- function(doc, kind) {
  s <- doc$content
  a <- annotations(doc)[[1]]
  if(hasArg(kind)) {
    k <- sapply(a$features, `[[`, "kind")
    s[a[k == kind]]
  } else {
    s[a[a$type == "entity"]]
  }
}
#We can in theory extract the relavent names.
#from story
  entities(story_doc,kind = "person") %>% unique #failed
  entities(story_doc,kind = "location") %>% unique #success
  entities(story_doc,kind = "organization") %>% unique #success
#from brief
  entities(brief_doc,kind = "person") %>% unique #failed
  entities(brief_doc,kind = "location") %>% unique #failed
  entities(brief_doc,kind = "organization") %>% unique #failed
````
The natural language processing is still limited in the types of information that it can extract. Primarily, the issue with with non-English names and locations (i.e. any name that doesn't come from a Anglo-traditional work from appears to be missed). This presents real problems for processing information about world leaders (many of which do not have English-based names).

#### Dictionary Approach
```{r}
#Pulling out leader names
#Using the world leader dictionary created above
leader.data <- read.csv('Data/CIA_World_Leaders_Data_01.28.15.csv')
head(leader.data) 

#lowercasing the leader names
leader.data$office.holder <- tolower(leader.data$office.holder)

#Subset of Target country leaders
  rus.leaders <- leader.data %>% filter(country=="Russia")
  rus.leaders$office.holder <- str_trim(rus.leaders$office.holder)
#Subet of all non-target country leaders
  other.leaders <- leader.data %>% filter(!country=="Russia")
  other.leaders$office.holder <- str_trim(other.leaders$office.holder)

#extraction will occur along two paths: the brief and the story content.
#here I will do the briefs since it is more straight forward however 
#the code can be easily manipulated to utilize the larger content of the story
  descr <- corpus[[1]]$meta[3] %>% as.character #brief
  descr <- tolower(descr)
#extracting corpus content; to character
  #content <- tm_map(corpus, content_transformer(tolower)) %>%  .[1] %>% inspect
  #content <- s[[1]]$content %>% as.character #actual content of the story

#placeholder object
s <- descr

#Breakup names
  #Target country
  for(i in 1:nrow(rus.leaders)) {
    if(length(strsplit(rus.leaders$office.holder[i]," ")[[1]])==3){
      rus.leaders$last.name[i] <- strsplit(rus.leaders$office.holder[i]," ")[[1]][3]
      rus.leaders$middle.name[i] <- strsplit(rus.leaders$office.holder[i]," ")[[1]][2]
      rus.leaders$first.name[i] <- strsplit(rus.leaders$office.holder[i]," ")[[1]][1]
      }}
  #non-target countries
for(i in 1:nrow(other.leaders)){
  if(length(strsplit(other.leaders$office.holder[i]," ")[[1]])==8){
    other.leaders$last.name[i] <- strsplit(other.leaders$office.holder[i]," ")[[1]][8]
    other.leaders$first.name[i] <- strsplit(other.leaders$office.holder[i]," ")[[1]][1]
    other.leaders$middle.name[i] <- paste(strsplit(other.leaders$office.holder[i]," ")[[1]][2],
                                          strsplit(other.leaders$office.holder[i]," ")[[1]][3],
                                          strsplit(other.leaders$office.holder[i]," ")[[1]][4],
                                          strsplit(other.leaders$office.holder[i]," ")[[1]][5],
                                          strsplit(other.leaders$office.holder[i]," ")[[1]][6],
                                          strsplit(other.leaders$office.holder[i]," ")[[1]][7])
    } else{
      if(length(strsplit(other.leaders$office.holder[i]," ")[[1]])==7){
        other.leaders$last.name[i] <- strsplit(other.leaders$office.holder[i]," ")[[1]][7]
        other.leaders$first.name[i] <- strsplit(other.leaders$office.holder[i]," ")[[1]][1]
        other.leaders$middle.name[i] <- paste(strsplit(other.leaders$office.holder[i]," ")[[1]][2],
                                              strsplit(other.leaders$office.holder[i]," ")[[1]][3],
                                              strsplit(other.leaders$office.holder[i]," ")[[1]][4],
                                              strsplit(other.leaders$office.holder[i]," ")[[1]][5],
                                              strsplit(other.leaders$office.holder[i]," ")[[1]][6])
        } else{
          if(length(strsplit(other.leaders$office.holder[i]," ")[[1]])==6){
            other.leaders$last.name[i] <- strsplit(other.leaders$office.holder[i]," ")[[1]][6]
            other.leaders$first.name[i] <- strsplit(other.leaders$office.holder[i]," ")[[1]][1]
            other.leaders$middle.name[i] <- paste(strsplit(other.leaders$office.holder[i]," ")[[1]][2],
                                                  strsplit(other.leaders$office.holder[i]," ")[[1]][3],
                                                  strsplit(other.leaders$office.holder[i]," ")[[1]][4],
                                                  strsplit(other.leaders$office.holder[i]," ")[[1]][5])
            } else{
              if(length(strsplit(other.leaders$office.holder[i]," ")[[1]])==5){
                other.leaders$last.name[i] <- strsplit(other.leaders$office.holder[i]," ")[[1]][5]
                other.leaders$first.name[i] <- strsplit(other.leaders$office.holder[i]," ")[[1]][1]
                other.leaders$middle.name[i] <- paste(strsplit(other.leaders$office.holder[i]," ")[[1]][2],
                                                      strsplit(other.leaders$office.holder[i]," ")[[1]][3],
                                                      strsplit(other.leaders$office.holder[i]," ")[[1]][4])
                } else{
                  if(length(strsplit(other.leaders$office.holder[i]," ")[[1]])==4){
                    other.leaders$last.name[i] <- strsplit(other.leaders$office.holder[i]," ")[[1]][4]
                    other.leaders$first.name[i] <- strsplit(other.leaders$office.holder[i]," ")[[1]][1]
                    other.leaders$middle.name[i] <- paste(strsplit(other.leaders$office.holder[i]," ")[[1]][2],
                                                          strsplit(other.leaders$office.holder[i]," ")[[1]][3])
                    } else{
                      if(length(strsplit(other.leaders$office.holder[i]," ")[[1]])==3){
                        other.leaders$last.name[i] <- strsplit(other.leaders$office.holder[i]," ")[[1]][3] 
                        other.leaders$first.name[i] <- strsplit(other.leaders$office.holder[i]," ")[[1]][1]
                        other.leaders$middle.name[i] <- strsplit(other.leaders$office.holder[i]," ")[[1]][2]
                        } else{ 
                          if(length(strsplit(other.leaders$office.holder[i]," ")[[1]])==2){
                            other.leaders$last.name[i] <- strsplit(other.leaders$office.holder[i]," ")[[1]][2]
                            other.leaders$first.name[i] <- strsplit(other.leaders$office.holder[i]," ")[[1]][1]
                            other.leaders$middle.name[i] <- NA  
                            } else{ 
                          if(length(strsplit(other.leaders$office.holder[i]," ")[[1]])==0){
                            other.leaders$last.name[i] <- NA
                            other.leaders$first.name[i] <- NA
                            other.leaders$middle.name[i] <- NA  
                            }
                          }}}}}}}}
    
#isolate sideA actors
identified.leaders <- NULL
for(j in 1:nrow(rus.leaders)){
  if(str_detect(s,rus.leaders$last.name[j])){
    tagged.leaders <- filter(rus.leaders,rus.leaders$office.holder==as.character(rus.leaders$office.holder[j]))} else{next}
  identified.leaders <- rbind(identified.leaders,tagged.leaders)
  }
#couple sideA with relevant data
sideA.actor <- NULL
sideA.country <- NULL
sideA.actor.title <- NULL
for(i in 1:nrow(identified.leaders)){
  sideA.actor[i] <- as.character(identified.leaders$office.holder[i])
  sideA.country[i] <- as.character(identified.leaders$country[i])
  sideA.actor.title[i] <- as.character(identified.leaders$office[i])
  }

#isolate sideB actors #LEFT OFF HERE!!!
identified.leaders2 <- NULL
for(j in 1:nrow(other.leaders)){
  
  if(str_detect(s,as.character(other.leaders$country[j]))){
    
    temp.sub.other.leaders <- other.leaders %>% filter(country==country[j])
    
    for(p in 1:nrow(temp.sub.other.leaders)){
      
      if(str_detect(s,temp.sub.other.leaders$last.name[p]) | str_detect(s,temp.sub.other.leaders$first.name[p])){
        tagged.leaders <- temp.sub.other.leaders %>% filter(as.character(temp.sub.other.leaders$office.holder)==as.character(temp.sub.other.leaders$office.holder[p])) 
        identified.leaders2 <- rbind(identified.leaders2,tagged.leaders)
        } else{next}
      
}  
} 
temp.sub.other.leaders <- NULL }

!is.na(str_detect(s,as.character(temp.sub.other.leaders$last.name[p]))) & 


#couple with relevant data re sideB actors
for(i in 1:nrow(identified.leaders2)){
  sideB.actor[i] <- as.character(identified.leaders2$office.holder[i])
  sideb.country[i] <- as.character(identified.leaders2$country[i])
  sideB.actor.title[i] <- as.character(identified.leaders2$office[i])
  }

#Data frame for this iteration
temp.data <- data.frame(sideA.actortitle=title,sideA.actor=sideA.actor,sideA.country=sideA.country)

```






-----

## The Scrape
First, there are preliminary analytically tools that need to be studied further. 

### Web_Scraping (Building a More Efficient Scraper)

The following code is from [here]("http://stackoverflow.com/questions/24576962/how-write-code-to-web-crawling-and-scraping-in-r")...see the answer

```{r}
library(XML)
library(httr)
url <- "http://www.wikiart.org/en/claude-monet/mode/all-paintings-by-alphabet/"
hrefs <- list()
for (i in 1:23) {
  response <- GET(paste0(url,i))
  doc      <- content(response,type="text/html")
  hrefs    <- c(hrefs,doc["//p[@class='pb5']/a/@href"])
}
url      <- "http://www.wikiart.org"
xPath    <- c(pictureName = "//h1[@itemprop='name']",
              date        = "//span[@itemprop='dateCreated']",
              author      = "//a[@itemprop='author']",
              style       = "//span[@itemprop='style']",
              genre       = "//span[@itemprop='genre']")
get.picture <- function(href) {
  response <- GET(paste0(url,href))
  doc      <- content(response,type="text/html")
  info     <- sapply(xPath,function(xp)ifelse(length(doc[xp])==0,NA,xmlValue(doc[xp][[1]])))
}
pictures <- do.call(rbind,lapply(hrefs,get.picture))
head(pictures)
```



### Scraping with Python
First, [this]("http://docs.python-guide.org/en/latest/scenarios/scrape/") and [this]("http://learnpythonthehardway.org/book/ex5.html") for starters. 

### Text Mining
See [this]("http://cran.r-project.org/web/packages/tm/tm.pdf")


