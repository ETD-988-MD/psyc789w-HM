#### Parsers for FM Compiler #####

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

person_parser <- function(text){
  if(is.character(text)){
    require(rPython)
    python.load("R_Skills/NLP/py_approach/Applications/stanford_nlp_extractors.py")
    output = python.call("stanford_person_extractor",text)
    return(output) 
  } else {
    warning("This is not a character. Fix that!")
  }
}

org_parser <- function(text){
  if(is.character(text)){
    require(rPython)
    python.load("R_Skills/NLP/py_approach/Applications/stanford_nlp_extractors.py")
    output = python.call("stanford_org_extractor",text)
    return(output) 
  } else {
    warning("This is not a character. Fix that!")
  }
}

loc_parser <- function(text){
  if(is.character(text)){
    require(rPython)
    python.load("R_Skills/NLP/py_approach/Applications/stanford_nlp_extractors.py")
    output = python.call("stanford_loc_extractor",text)
    return(output) 
  } else {
    warning("This is not a character. Fix that!")
  }
}
