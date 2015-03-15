### Stanford NLP ####
#See: http://www.nltk.org/api/nltk.tag.html#module-nltk.tag.stanford


from nltk.tag.stanford import NERTagger
#Here you need to have some software running in the background
st = NERTagger('/Users/Ericdunford/Desktop/psyc789w-HM/R_Skills/NLP/stanford-ner-2014-06-16/classifiers/english.all.3class.distsim.crf.ser.gz','/Users/Ericdunford/Desktop/psyc789w-HM/R_Skills/NLP/stanford-ner-2014-06-16/stanford-ner.jar')

test1 = "Vladimir Putin had a telephone conversation with Federal Chancellor of Germany Angela Merkel, President of the French Republic Francois Hollande and President of Ukraine Petro Poroshenko. This was where Vladimir lived."

output = st.tag(test1.split())
print output
#Partialling out individual persons
for i in range(0,len(output)):
	if output[i][1] == "PERSON" and output[i+1][1] == "PERSON":
		print output[i][0] + " " + output[i+1][0]


test2 = "The participants discussed in detail implementation of the Minsk Agreements aimed at settling the conflict in southeast Ukraine, taking into account the Normandy format telephone contacts and new consultations scheduled to take place soon."
#output = st.tag(test2.split())
#
##Partialling out individual locations
#for i in range(0,len(output)):
#	if output[i][1] == "LOCATION":
#		print output[i][0]
		

