#Proper Noun Extractor
def pn_extractor2(text):
	import nltk
	output = []
#	tokens = nltk.sent_tokenize(text) #The sentence distinction appears unnecessary 
	tokens = nltk.word_tokenize(text)
	tagged = nltk.pos_tag(tokens)
	for i in range(0,len(tagged)):
		if tagged[i][1] == "NNP":
			temp = tagged[i][0]	
			output.append(temp)
	return output


#Testing for Debug

#test1 = "Vladimir Putin had a telephone conversation with Federal Chancellor of Germany Angela Merkel, President of the French Republic Francois Hollande and President of Ukraine Petro Poroshenko. This was where Vladimir lived."
#print pn_extractor2(test1)

#Verb Extractor
def vb_extractor(text):
	import nltk
	output = []
#	tokens = nltk.sent_tokenize(text) #The sentence distinction appears unnecessary 
	tokens = nltk.word_tokenize(text)
	tagged = nltk.pos_tag(tokens)
	for i in range(0,len(tagged)):
		if tagged[i][1] == "VBD" or tagged[i][1] == "NN":
			temp = tagged[i][0]	
			output.append(temp)
	return output

#Test
#test1 = "Vladimir Putin had a telephone conversation with Federal Chancellor of Germany Angela Merkel, President of the French Republic Francois Hollande and President of Ukraine Petro Poroshenko. This was where Vladimir lived."	
#print vb_extractor(test1)


