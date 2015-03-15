# Stanford NER Python Wrappers for Language Processing
require(dplyr)
require(tm)
### Defining Functions
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

org_parser <- function(text){
  if(is.character(text)){
    require(rPython)
    python.load("R_Skills/NLP/py_approach/Applications/stanford_nlp_extractors.py")
    output = python.call("stanford_org_extractor",text)
    return(output) #Using a matching correlation, it extracts a correlated term.
  } else {
    warning("This is not a character. Fix that!")
  }
}

loc_parser <- function(text){
  if(is.character(text)){
    require(rPython)
    python.load("R_Skills/NLP/py_approach/Applications/stanford_nlp_extractors.py")
    output = python.call("stanford_loc_extractor",text)
    return(output) #Using a matching correlation, it extracts a correlated term.
  } else {
    warning("This is not a character. Fix that!")
  }
}


#Test 
k <- 100
text <- paste(corpus[[k]]$meta[3],corpus[[k]]$meta[4],corpus[[k]]$content,"") %>% removePunctuation(.,preserve_intra_word_dashes = T)

text <- "The Woman's Rights Movement was a strong 
contender and an interest group that had to be dealt with. 
Barack Obama and his cabinet cheif, Jerry Walters, both saw the potential 
in utilizing this voting group. Upon returning from Israel, 
they went to the caucus in Iowa. Ez-E says fuck the police."
text <- text %>% removePunctuation(.,preserve_intra_word_dashes = T)

person_parser(text) %>% unique
loc_parser(text) %>% unique
try(org_parser(text),silent=T) %>% unique #Try offers some leverage if the function breaks...which happens. 


#Python Parse 

#Nexis Lexis tm.plugin.lexisnexis
#clip...computational linguistics workshop at UMD.




