#----------------------------------------------------
#### Processing and Analyzing Lexisnexis content ####
#----------------------------------------------------

#Packages
  require(tm)
  require(httr)
  install.packages("tm.plugin.lexisnexis") #installing pluggin
  require(tm.plugin.lexisnexis)

#References
  #See this site for details.
  BROWSE("http://www.inside-r.org/node/234883") #inside R

#Drew a query of news stories regarding the anti-milosevic movement (1999-2000)
file <- system.file("R_Skills/LexisNexis/lnquery_anti-milosevic_2015-03-15_14-33.HTML",package = "tm.plugin.lexisnexis")
material <- Corpus(LexisNexisSource(file, encoding = "UTF-8"))

source <- LexisNexisSource("R_Skills/LexisNexis/lnquery_anti-milosevic_2015-03-15_14-33.HTML")
str(source)
corpus1 <- Corpus(source, readerControl = list(language = NA))

headlines <- xml("R_Skills/LexisNexis/lnquery_anti-milosevic_2015-03-15_14-33.HTML") %>%xml_nodes("p") %>% xml_text()
headlines
source <- LexisNexisSource(headlines)
