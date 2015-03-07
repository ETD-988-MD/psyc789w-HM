#### Fuzz Word Detection ####
#----------------------------
#Download module `pip install fuzzywuzzy` and `pip install python-Levenshtein`
def fuzzy(text1,text2):
	from fuzzywuzzy import fuzz
	return fuzz.ratio(text1,text2)
	

#Here is another way to manage matching
def pat_extract(quiery, choices):
	from fuzzywuzzy import process
	return process.extractOne(quiery, choices)
	
#Debug
#choices = ["Atlanta Falcons", "New York Jets", "New York Giants", "Dallas Cowboys"]
#print pat_extract("Atl",choices)