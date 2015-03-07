#### Trial Proper Noun Extractor 
pn_extractor <- function(x){
  require(rPython)
  python.load("R_Skills/NLP/py_approach/Applications/pn_extractor2.py")
  output = python.call("pn_extractor2",x)
  return(output)
}

#Debugging...
test <- "While on an official visit to India, 
Vladimir Putin met with President of India Pranab Mukherjee."
test1 <- corpus[[5]]$content
pn_extractor(test)

