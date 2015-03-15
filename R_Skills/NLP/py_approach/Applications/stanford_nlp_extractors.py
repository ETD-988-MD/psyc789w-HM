#-----------------------------------------------------------
####### Stanford NLP base functions for R wrappers ########
#-----------------------------------------------------------

#Person Extractor
def stanford_person_extractor(text):
	from nltk.tag.stanford import NERTagger
	#Specifying the java path
	import os
	java_path = "/usr/bin/java"
	os.environ['JAVAHOME'] = java_path
	#Here you need to have some software running in the background
	st = NERTagger('/Users/Ericdunford/Desktop/psyc789w-HM/R_Skills/NLP/stanford-ner-2014-06-16/classifiers/english.all.3class.distsim.crf.ser.gz','/Users/Ericdunford/Desktop/psyc789w-HM/R_Skills/NLP/stanford-ner-2014-06-16/stanford-ner.jar')
	tagged = st.tag(text.split())
	output = []
	#Partialling out individuals
	for i in range(0,len(tagged)):
		if tagged[i-1][1] != "PERSON" and tagged[i][1] == "PERSON" and tagged[i+1][1] == "PERSON" and tagged[i+2][1] == "PERSON":
			output.append(tagged[i][0] + " " + tagged[i+1][0] + " " + tagged[i+2][0])
		if tagged[i-1][1] != "PERSON" and tagged[i][1] == "PERSON" and tagged[i+1][1] == "PERSON":
			output.append(tagged[i][0] + " " + tagged[i+1][0])
		if tagged[i-1][1] != "PERSON" and tagged[i][1] == "PERSON"  and tagged[i+1][1] != "PERSON":
			output.append(tagged[i][0])
	return output

#-----------------------------------------------------------
#Organization Extractor			
def stanford_org_extractor(text):
	from nltk.tag.stanford import NERTagger
	#Specifying the java path
	import os
	java_path = "/usr/bin/java"
	os.environ['JAVAHOME'] = java_path
	#Here you need to have some software running in the background
	st = NERTagger('/Users/Ericdunford/Desktop/psyc789w-HM/R_Skills/NLP/stanford-ner-2014-06-16/classifiers/english.all.3class.distsim.crf.ser.gz','/Users/Ericdunford/Desktop/psyc789w-HM/R_Skills/NLP/stanford-ner-2014-06-16/stanford-ner.jar')
	tagged = st.tag(text.split())
	output = []
	#Partialling out locations
	for i in range(0,len(tagged)):
#		if tagged[i-1][1] != "ORGANIZATION" and tagged[i][1] == "ORGANIZATION" and tagged[i+1][1] == "ORGANIZATION" and tagged[i+2][1] == "ORGANIZATION" and tagged[i+3][1] == "ORGANIZATION":
#			output.append(tagged[i][0] + " " + tagged[i+1][0] + " " + tagged[i+2] + " " + tagged[i+3][0])
		if tagged[i-1][1] != "ORGANIZATION" and tagged[i][1] == "ORGANIZATION" and tagged[i+1][1] == "ORGANIZATION" and tagged[i+2][1] == "ORGANIZATION" and tagged[i+3][1] != "ORGANIZATION":
			output.append(tagged[i][0] + " " + tagged[i+1][0] + " " + tagged[i+2][0])
		if tagged[i-1][1] != "ORGANIZATION" and tagged[i][1] == "ORGANIZATION" and tagged[i+1][1] == "ORGANIZATION" and tagged[i+2][1] != "ORGANIZATION":
			output.append(tagged[i][0] + " " + tagged[i+1][0])
		if tagged[i-1][1] != "ORGANIZATION" and tagged[i][1] == "ORGANIZATION" and tagged[i+1][1] != "ORGANIZATION":
			output.append(tagged[i][0])
	return output

#----------------------------------------------------------
#Location Extractor
def stanford_loc_extractor(text):
	from nltk.tag.stanford import NERTagger
	#Specifying the java path
	import os
	java_path = "/usr/bin/java"
	os.environ['JAVAHOME'] = java_path
	#Here you need to have some software running in the background
	st = NERTagger('/Users/Ericdunford/Desktop/psyc789w-HM/R_Skills/NLP/stanford-ner-2014-06-16/classifiers/english.all.3class.distsim.crf.ser.gz','/Users/Ericdunford/Desktop/psyc789w-HM/R_Skills/NLP/stanford-ner-2014-06-16/stanford-ner.jar')
	tagged = st.tag(text.split())
	output = []
	#Partialling out locations
	for i in range(0,len(tagged)):
		if tagged[i-1][1] != "LOCATION" and tagged[i][1] == "LOCATION" and tagged[i+1][1] == "LOCATION" and tagged[i+2][1] == "LOCATION":
			output.append(tagged[i][0] + " " + tagged[i+1][0] + " " + tagged[i+2][0])
		if tagged[i-1][1] != "LOCATION" and tagged[i][1] == "LOCATION" and tagged[i+1][1] == "LOCATION":
			output.append(tagged[i][0] + " " + tagged[i+1][0])
		if tagged[i-1][1] != "LOCATION" and tagged[i][1] == "LOCATION" and tagged[i+1][1] != "LOCATION":
			output.append(tagged[i][0])
	return output

#Test for Debugging

#test1 = "Taking part in the meeting were Prime Minister Dmitry Medvedev, Federation Council Speaker Valentina Matviyenko, Chief of Staff of the Presidential Executive Office Sergei Ivanov Secretary of the Security Council Nikolai Patrushev, Foreign Minister Sergei Lavrov, Interior Minister Vladimir Kolokoltsev, Director of the Federal Security Service Alexander Bortnikov, Deputy Secretary of the Security Council Rashid Nurgaliyev, Director of the Foreign Intelligence Service Mikhail Fradkov and permanent member of the Security Council."
#test2 = "When we were in France and Jack had come home from Germany, we knew that we'd live here forever But then ISIS came and killed everyone."
#test3 = "Russia will continue to support the Middle East peace process and the formation of a Palestinian state Mr Medvedev said at the meeting Dmitry Medvedev held talks with President of the Palestinian National Authority Mahmoud Abbas Also on the agenda were preparations for the upcoming Moscow conference on the Middle East an initiative proposed by Russia and supported by Palestine in particular Mr Medvedev thanked Mr Abbas for Palestines efforts to bolster Russias participation in inter-faith dialogue and for giving Russia property rights to a number of sites In particular Russia received property rights to four plots of land in Bethlehem and Jericho last year  PRESIDENT OF RUSSIA DMITRY MEDVEDEV Mr President dear guests It is my pleasure to welcome you once more to Russia Not so much time has passed since our last meeting back in December but unfortunately dramatic events have taken place since then events that we will certainly discuss today We will also discuss our future work including on settling the situation in the Middle East in general and in Palestine in particular There are several recent major international events that I would like to discuss with you It would be good therefore to exchange information and outline our future plans Once again I wish you a warm welcome PRESIDENT OF THE PALESTINIAN NATIONAL AUTHORITY MAHMOUD ABBAS as translated into Russian Thank you very much Your Excellency It is a great pleasure for us to be here in Moscow and be received by you As you just said this is our second meeting Many events have indeed taken place in the short time since we last met including the dramatic events that we will discuss today We consider it very important overall to coordinate with Russia all the issues concerning the situation in the region and we intend to continue this practice We have indeed lived through some very difficult circumstances I am referring to the Israeli aggression against the Gaza Strip which lasted 22 days causing many victims much destruction and resulting in great suffering for the people in this part of the Palestinian territory A number of other important events have also taken place over this time including the League of Arab States summit in Doha the Arab states economic summit in Kuwait and the summit of Arab and Latin American countries I want to take this opportunity to note our satisfaction with the close and friendly ties that we have and to thank the Russian Federation for its help to the Palestinian people Our people see this help and are aware of it We are confident that our close relations will only grow stronger including through expanding and bolstering Russias presence in the Holy Land and developing the sites to be registered as Russian property We are sure that these kinds of steps will reaffirm the historically close and friendly relations that bind us DMITRY MEDVEDEV Mr President We do indeed have friendship with the Palestinian people and no matter what the great difficulties your people face we will continue to support the Middle East peace process and the formation of the Palestinian state I hope too to discuss with you upcoming prospects including the Moscow conference on the Middle East this initiative that Russia proposed and that I know you support This is perhaps the step closest to hand the next step towards settlement I also want to say a separate word of thanks to you for your efforts to bolster Russias participation in inter-faith dialogue and for granting the Russian Federation property rights to a number of sites We value these relations and are grateful to you for this"
#print stanford_person_extractor(test1)
#print stanford_org_extractor(test3)
#print stanford_loc_extractor(test2)

#NOTES:
#This appears to only work on sentences so you need to build in a sentence parser
