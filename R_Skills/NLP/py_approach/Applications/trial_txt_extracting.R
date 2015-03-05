#This is an extractor for pdfs
#The code was compiled in Python
require(rPython)
python.load("R_Skills/NLP/py_approach/Applications/txt_extractor.py")
txt_ex <- function(x){
  output = python.call("txt_extractor",x)
  return(output)
}

pdf <- "/Users/Ericdunford/Desktop/psyc789w-HM/test.pdf" 
txt_ex(pdf) 
# Still needs some processing, but it works!
