#-----------------------------------------------------------
####### Stanford NLP base functions for R wrappers ########
#-----------------------------------------------------------

#Person Extractor
def stanford_person_extractor(text):
	from nltk.tag.stanford import NERTagger
	#Here you need to have some software running in the background
	st = NERTagger('/Users/Ericdunford/Desktop/psyc789w-HM/R_Skills/NLP/stanford-ner-2014-06-16/classifiers/english.all.3class.distsim.crf.ser.gz','/Users/Ericdunford/Desktop/psyc789w-HM/R_Skills/NLP/stanford-ner-2014-06-16/stanford-ner.jar')
	tagged = st.tag(text.split())
	output = []
	#Partialling out individuals
	for i in range(0,len(tagged)):
		if tagged[i][1] == "PERSON" and tagged[i+1][1] == "PERSON" and tagged[i+2][1] == "PERSON":
			output.append(tagged[i][0] + " " + tagged[i+1][0] + " " + tagged[i+2][0])
		if tagged[i][1] == "PERSON" and tagged[i+1][1] == "PERSON":
			output.append(tagged[i][0] + " " + tagged[i+1][0])
		if tagged[i-1][1] != "PERSON" and tagged[i][1] == "PERSON"  and tagged[i+1][1] != "PERSON":
			output.append(tagged[i][0])
	return output

#-----------------------------------------------------------
#Organization Extractor			
def stanford_org_extractor(text):
	from nltk.tag.stanford import NERTagger
	#Here you need to have some software running in the background
	st = NERTagger('/Users/Ericdunford/Desktop/psyc789w-HM/R_Skills/NLP/stanford-ner-2014-06-16/classifiers/english.all.3class.distsim.crf.ser.gz','/Users/Ericdunford/Desktop/psyc789w-HM/R_Skills/NLP/stanford-ner-2014-06-16/stanford-ner.jar')
	tagged = st.tag(text.split())
	output = []
	#Partialling out locations
	for i in range(0,len(tagged)):
		if tagged[i][1] == "ORGANIZATION" and tagged[i+1][1] == "ORGANIZATION" and tagged[i+2][1] == "ORGANIZATION" and tagged[i+3][1] == "ORGANIZATION":
			output.append(tagged[i][0] + " " + tagged[i+1][0] + " " + tagged[i+2] + " " + tagged[i+3][0])
		if tagged[i][1] == "ORGANIZATION" and tagged[i+1][1] == "ORGANIZATION" and tagged[i+2][1] == "ORGANIZATION":
			output.append(tagged[i][0] + " " + tagged[i+1][0] + " " + tagged[i+2][0])
		if tagged[i][1] == "ORGANIZATION" and tagged[i+1][1] == "ORGANIZATION":
			output.append(tagged[i][0] + " " + tagged[i+1][0])
		if tagged[i-1][1] != "ORGANIZATION" and tagged[i][1] == "ORGANIZATION" and tagged[i+1][1] != "ORGANIZATION":
			output.append(tagged[i][0])
	return output

#----------------------------------------------------------
#Location Extractor
def stanford_loc_extractor(text):
	from nltk.tag.stanford import NERTagger
	#Here you need to have some software running in the background
	st = NERTagger('/Users/Ericdunford/Desktop/psyc789w-HM/R_Skills/NLP/stanford-ner-2014-06-16/classifiers/english.all.3class.distsim.crf.ser.gz','/Users/Ericdunford/Desktop/psyc789w-HM/R_Skills/NLP/stanford-ner-2014-06-16/stanford-ner.jar')
	tagged = st.tag(text.split())
	output = []
	#Partialling out locations
	for i in range(0,len(tagged)):
		if tagged[i][1] == "LOCATION" and tagged[i+1][1] == "LOCATION" and tagged[i+2][1] == "LOCATION":
			output.append(tagged[i][0] + " " + tagged[i+1][0] + " " + tagged[i+2][0])
		if tagged[i][1] == "LOCATION" and tagged[i+1][1] == "LOCATION":
			output.append(tagged[i][0] + " " + tagged[i+1][0])
		if tagged[i-1][1] != "LOCATION" and tagged[i][1] == "LOCATION" and tagged[i+1][1] != "LOCATION":
			output.append(tagged[i][0])
	return output

#Test for Debugging
test1 = "Taking part in the meeting were Prime Minister Dmitry Medvedev, Federation Council Speaker Valentina Matviyenko, Chief of Staff of the Presidential Executive Office Sergei Ivanov Secretary of the Security Council Nikolai Patrushev, Foreign Minister Sergei Lavrov, Interior Minister Vladimir Kolokoltsev, Director of the Federal Security Service Alexander Bortnikov, Deputy Secretary of the Security Council Rashid Nurgaliyev, Director of the Foreign Intelligence Service Mikhail Fradkov and permanent member of the Security Council."
test2 = "When we were in France and Jack had come home from Germany, we knew that we'd live here forever But then ISIS came and killed everyone."
print stanford_person_extractor(test2)
print stanford_org_extractor(test2)
print stanford_loc_extractor(test2)

#NOTES:
#This appears to only work on sentences so you need to build in a sentence parser
